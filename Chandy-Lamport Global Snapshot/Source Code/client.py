import random
import sys
import socket
import PySimpleGUI as gui
from time import sleep
import threading
import _thread
from random import randint

addrs = {"A": ("127.0.0.1", 11111), "B": ("127.0.0.1", 22222), "C": ("127.0.0.1", 33333), "D": ("127.0.0.1", 44444),
         "E": ("127.0.0.1", 55555)}
NumberOfClients = 5


class client:
    def __init__(self, name):
        self.name = name
        self.event_number = 0
        # For lamport snapshot algorithm, we need FIFO channel with reliable
        # transmission which is provided by TCP. For this experimental purposes,
        # I used UDP to see when all the processes are in the same machine, is UDP
        # good enough for lamport snapshot or not. It worked well !!!
        self.soc = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.soc.bind(addrs[name])
        self.incoming = {}
        self.outgoing = {}
        self.hasToken = False
        self.tokenLossProb = 0.0
        self.continueThread = True
        self.LocalState = []
        self.seqNumber = 0  # The sequence number for initiating the snapshot
        self.snapShotLog = {}
        self.listeningTo = {}
        self.GlobalState = []

    def init_connections(self):
        '''
        Reads the conf file for each client and puts the incoming and outgoing links
        in the list of client connections. For every connection, there is a pair of
        client name and address(IP and port)
        :return: Null
        '''
        f = open(str(self.name) + ".txt", "r")
        # read the outgoing links
        conf = f.readline().strip().split(",")
        self.outgoing = {}
        for item in conf:
            self.outgoing[item] = addrs[item]
        # read the incoming links
        conf = f.readline().strip().split(",")
        self.incoming = {}
        for item in conf:
            self.incoming[item] = addrs[item]

    def RecordMessages(self, senderChannel, msg):
        '''
        Recording the messages on each incoming channel after before receiving the
        subsequent marker
        :param senderChannel: The channel in which the message is received
        :param msg: The content of message (either marker or token etc)
        :return: Null
        '''
        # For all of the snapshots
        for snapID in self.listeningTo:
            # If we are still listening on the channel where we received
            # the message(on any snapshot), then append that message to the
            # state of the channel for that specific snapshot
            if self.listeningTo[snapID][senderChannel] == True:
                self.snapShotLog[snapID][senderChannel] += [msg]

    def AllMarkersReceived(self, snapshotID):
        '''
        Checks whether markers for all incoming channels has received or not
        :param snapshotID: ID of snapshot we are checking
        :return: Ture or False
        '''
        for channel in self.listeningTo[snapshotID]:
            if self.listeningTo[snapshotID][channel] == True:
                return False
        print("Markers received on all incoming channels")
        return True

    def TerminateSnapshot(self, snapshotID):
        '''
        If it is the end of snapshot, first pop the snapshot from list of snapshots
        we are listening to, then find the initiator and send the state to it.
        :param snapshotID: ID of snapshot to be terminated
        :return: Null
        '''
        print(f"Entered terminate snapshot for {snapshotID}")
        self.listeningTo.pop(snapshotID, "KeyNotFound")
        # The first character is the name of initiator, in case of name.len > 1, use regex to separate
        # Seq number and client name
        # Determine the address of snapshot initiator
        initiator = snapshotID[0]
        initiatorAddress = addrs[initiator]
        # Send the state to the initiator
        data = self.name + "," + "SNAPSHOT" + "," + snapshotID + "," + str(self.snapShotLog[snapshotID])
        self.soc.sendto(data.encode(), initiatorAddress)

    def SaveLocalState(self, snapshotID):
        '''
        Saving local state of the client after receipt of the first marker for a snapshot
        The state is whether the client has token or not
        :param snapshotID:
        :return: Null
        '''
        if self.hasToken:
            currentState = "Has Token"
        else:
            currentState = "NO Token"
        # Creating snapshot log for the snapshot and appending the current
        # local state to it.
        self.snapShotLog[snapshotID] = {self.name: currentState}
        print(f"Local state for snapshot {snapshotID} saved as {currentState}")

    def ListenIncomingChannels(self, snapshotID, sender):
        '''
        Listening to all OTHER incoming channels for this snapshot (except C, which sent the first marker)
        The format is: ListeningTo is a dictionary of snapshotIDs. Each record is a dictionary of all
        incoming channels for that snapshotID, set true or false depending on the situation
        :param snapshotID:
        :param initiator: Snapshot Initiator
        :return: Null
        '''
        # Creating a dictionary for that snapshot
        self.listeningTo[snapshotID] = {}
        # Making the client to listen to all incoming chanels
        # Creating empty log record for every incoming channel
        for key in self.incoming:
            self.listeningTo[snapshotID].update({key: True})
            self.snapShotLog[snapshotID].update({key: []})
        # Making the state of channel C as false and recording that channel as empty
        self.listeningTo[snapshotID][sender] = False
        # Instead of setting it as "Empty", you can just leave it as empty. I did this way for demo purposes
        self.snapShotLog[snapshotID][sender] = ["Empty"]
        print("Listening to the following channels")
        print(self.listeningTo)

    def recv(self):
        '''
        Client would stay in this function infinitely ( in a separate thread)
        and communicate with the rest of distributed system, records the messages,
        send/receive marker, get tokens etc.
        :return: Null
        '''
        while True:
            # Sleep on receipt of every message for demo purposes
            sleep(3)
            # Read the buffer and separate the address from data payload
            data, address = self.soc.recvfrom(1024)
            data = data.decode().split(',')
            print(data)
            if data[1] == "token":
                # Change token status and record this message
                print(f"Token received from client: {data[0]}")
                self.hasToken = True
                self.RecordMessages(data[0], f"Token Received from {data[0]}")

            if data[1] == "MARKER":

                # Marker message format: sender + MARKER + initiatorID + initiator SeqN
                snapshotID = data[2]
                sender = data[0]
                # Record the MARKER message if there is any ongoing snapshot:
                # By searching through the web, I realized that we should not record snapshot messages in the state
                # https://decomposition.al/blog/2019/04/26/an-example-run-of-the-chandy-lamport-snapshot-algorithm/
                # For demo purposes, I also recorded the OTHER marker messages received on the
                # channels we are listening to
                self.RecordMessages(sender, ','.join(data[1:]))

                # If it is the first marker of the snapshot
                if snapshotID not in self.snapShotLog:
                    print(f"First marker received for snapshot {snapshotID} from process {sender}")
                    # Structure: Snapshot log is a dictionary of snapshot IDs.
                    # Each snapshot ID has a dictionary for every incoming channel
                    # For every incoming channel of each snapshot, there is a list of messages
                    # Record the channel as empty --> set the value as empty
                    self.SaveLocalState(snapshotID)
                    # Send marker to all outgoing channels
                    print(f"Broadcasting the snapshot {snapshotID} to all outgoing channels")
                    self.broadcast(','.join(data[1:]))
                    # Start listening to all incoming channels
                    self.ListenIncomingChannels(snapshotID, sender)

                else:
                    # Stop recording the channel after receipt of the subsequent marker
                    self.listeningTo[snapshotID][sender] = False
                    print(f"Subsequent marker for snapshot {snapshotID} received from channel {sender}")
                # If all markers on each incoming channel is received,
                # terminate the snapshot and send snapshot to the initiator
                if self.AllMarkersReceived(snapshotID):
                    self.TerminateSnapshot(snapshotID)
            # In case of receiving snapshot result from other clients:
            if data[1] == "SNAPSHOT":
                # Append the snapshot to the global state list
                # Can have a list of global states if we want to support concurrent
                # snapshots initiated by same client.
                self.GlobalState.append(data)
                # If all the snapshots are received, terminate the snapshot and print it
                if len(self.GlobalState) == NumberOfClients:
                    print("End of the Global snapshot:")
                    print(self.GlobalState)
                    print("######################################################")
                    # Flush the global state list
                    self.GlobalState = []

    def broadcast(self, msg):
        '''
        Brodcasting message to all outgoing links
        '''
        data = str(self.name) + "," + msg
        for client in self.outgoing:
            print(data + " sent to client: " + client)
            self.soc.sendto(data.encode(), self.outgoing[client])

    def initiate_snapshopt(self):
        '''
        Record the local state
        Send marker to all outgoing
        Start recording from all incoming channels
        Set no channel as empty
        '''

        # Create unique snapshot ID and save local state
        self.seqNumber += 1
        ID = self.name + str(self.seqNumber)
        self.SaveLocalState(ID)

        # Send markers to all outgoing links
        message = "MARKER," + ID
        self.broadcast(message)
        print(f"MARKER for snapshot {ID} broadcasted to outgoing links.")

        # Start listening to all incoming channels
        self.listeningTo[ID] = {}
        for key in self.incoming:
            self.listeningTo[ID].update({key: True})
            self.snapShotLog[ID].update({key: []})
        print("Listening to the following channels:")
        print(self.listeningTo)

    def sendToken(self):
        '''
        This function is called through thread every 1 second
        If it does not have the token, just return from the function
        If the client has a token, send it to the next one
        :return: Null, calls itself in a thread again
        '''

        if self.hasToken:
            # Nullifying the token before sending it
            self.hasToken = False
            # Find the random token receiver from outgoing channels
            tokenReceiver = random.choice(list(self.outgoing.keys()))
            # Consider the random loss of the token and if no loss, send it to the recipient
            if random.random() >= self.tokenLossProb:
                data = self.name + "," + "token"
                self.soc.sendto(data.encode(), addrs[tokenReceiver])
                print(f"Token sent to client: {tokenReceiver}")

        # Start this thread again after one second
        if self.continueThread:
            t = threading.Timer(1, self.sendToken)
            t.start()

    def startGUI(self):
        # Choosing the theme
        gui.theme('DarkGreen3')
        # All the stuff inside the window.
        layout = [[gui.Button('Take Snapshot'), gui.Button('Generate New Token')],
                  [gui.Text('Prob losing token: %'), gui.InputText(do_not_clear=False, size=10), gui.Button('Submit')]
                  ]

        # Create the Window
        window = gui.Window(f'Client {self.name}', layout)
        # Event Loop to process "events" and get the "values" of the inputs
        while True:
            event, values = window.read()
            if event == gui.WIN_CLOSED:
                self.continueThread = False
                print("Terminating the program ...")
                sys.exit("Good bye!")
            if event == 'Take Snapshot':
                print("Snapshot initiated")
                self.initiate_snapshopt()

            if event == 'Generate New Token':
                self.hasToken = True
                print("New token Generated")

            if event == 'Submit':
                # Changing the token loss probability
                self.tokenLossProb = float(values[0]) / 100
                print(f"The token loss probability is: {self.tokenLossProb}")

        window.close()

    def starter(self):
        '''
        Starting the client:
        initiating all the connections, starting the sendToken thread by calling
        its self-calling function, starting the thread for recv function and running
        the GUI for the program
        :return: Null
        '''
        self.init_connections()
        self.sendToken()
        _thread.start_new_thread(self.recv, ())
        self.startGUI()


if __name__ == "__main__":

    if len(sys.argv) < 2 or sys.argv[1] not in "ABCDE":
        print("Invalid client name for this project. Valid clients are: A, B, C, D, E")
        sys.exit(1)
    cl = client(sys.argv[1])
    cl.starter()
