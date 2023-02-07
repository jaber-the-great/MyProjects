import random
import sys
import socket
import PySimpleGUI as gui
import time
import threading
from random import randint
addrs = {"A":("127.0.0.1",11111), "B":("127.0.0.1",22222), "C": ("127.0.0.1",33333), "D": ("127.0.0.1",44444) , "E": ("127.0.0.1",55555)}

class client:
    def __init__(self, name):
        self.name = name
        self.event_number = 0
        self.soc = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.soc.bind(addrs[name])
        self.incoming = {}
        self.outgoing = {}
        self.hasToken = False
        self.tokenLossProb = 0.0
        self.continueThread = True
        self.LocalState = []
        self.seqNumber = 0 # The sequence number for initiating the snapshot
        self.snapShotLog = {}


    def init_connections(self):
        f = open(str(self.name)+".txt", "r")
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
        print(self.incoming)


    def recv(self):
        while True:
            data , address = self.soc.recvfrom(1024)
            data = data.split(',')
            if data[1] == "token":
                # TODO: record the state of getting token
                self.hasToken = True
            if data[1] == "MARKER":
                # Marker message format: sender + MARKER + initiatorID + initiator SeqN
                snapshotID = data[2] + data[3]
                sender = data[0]
                if snapshotID not in self.snapShotLog:
                    # Record the channel as empty
                    # Put the channel in the list
                    # Start sending MARKER on the outgoing
                    self.snapShotLog[snapshotID]= [sender]
                else:
                    if sender in self.snapShotLog[snapshotID]:
                        # TODO: Stop recording that channel and save the state
                        pass
                    else:
                        # TODO: Record the state of that channel
                        self.snapShotLog[snapshotID] += [sender]

            # Data is state


    def broadcast(self, msg):
        ''' Brodcasting message to all outgoing links'''
        data = str(self.name) + "," + msg
        for client in self.outgoing.values():
            self.soc.sendto(data.encode(),client)

    def initiate_snapshopt(self):
        '''
        Record the local state
        Send marker to all outgoing
        Start recording from all incoming channels
        '''
        self.seqNumber +=1
        ID = self.name + "," + str(self.seqNumber)
        message = "MARKER," + ID
        self.broadcast(message)

    def sendToken(self):
        # This function is called through thread every 1 second
        # If it does not have the token, just return from the function
        # If the client has a token, send it to the next one
        if self.hasToken:
            # Nullifying the token before sending it
            self.hasToken = False
            # Find the random token receiver from outgoing channels
            tokenReceiver = random.choice(list(self.outgoing.keys()))
            # Consider the random loss of the token
            if random.random() >= self.tokenLossProb:
                # TODO: send the token
                print(f"Sending tokens to client: {tokenReceiver}")


        if self.continueThread:
            t = threading.Timer(1, self.sendToken)
            t.start()


    def startGUI(self):
        gui.theme('DarkGreen3')   # Add a touch of color
        # All the stuff inside your window.
        layout = [  [gui.Button('Take Snapshot'),gui.Button('Generate New Token')],
                    [gui.Text('Prob losing token: %'), gui.InputText(do_not_clear=False ,size = 10) ,gui.Button('Submit')]
                    ]


        # Create the Window
        window = gui.Window(f'Client {self.name}', layout)
        # Event Loop to process "events" and get the "values" of the inputs
        while True:
            event, values = window.read()
            if event == gui.WIN_CLOSED:
                # TODO: Maybe terminate the program
                self.continueThread = False
                print("Terminating the program ...")
                sys.exit("Good bye!")
            if event == 'Take Snapshot':
                self.initiate_snapshopt()
                # TODO: finish the snapshot and record it
                print("Snapshot initiated")
            if event == 'Generate New Token':
                # create new token or simple set the token value to true
                self.hasToken = True
                print("New token Generated")

            if event == 'Submit':
                self.tokenLossProb = float(values[0]) / 100
                print(f"The token loss probability is: {self.tokenLossProb}")

        window.close()



if __name__ == "__main__":

    print(len(sys.argv))
    cl = client(sys.argv[1])
    cl.init_connections()
    cl.sendToken()
    cl.startGUI()

    cl.recv()