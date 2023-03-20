import random
import sys
import socket
import PySimpleGUI as gui
from time import sleep
import threading
import json
import rsa
import _thread
from random import randint
from encryption import *

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

        self.role = "follower"
        self.currentTerm = 0
        self.currentLeader = None
        self.votedFor = None
        self.log = open(self.name + ".txt", 'a')
        self.state = self.name + "_state.txt"
        self.publicKey , self.privateKey = rsa.newkeys(2048)

        self.listOfKeys = readPublicKeysFromFile()
        self.fail_clients = []
        self.votesReceived = 0

    def update_saved_file(self, filename, recordType, newValue):
        '''
        Supporting persistent disk storage of Raft's state
        :param filename:
        :param recordType:
        :param newValue:
        :return:
        '''
        file = open(filename,'rw')
        prevState = file.readlines()
        if recordType == 'currentTerm':
            pass
        elif recordType == 'votedFor':
            pass
    def update_current_term(self, term):
        self.currentTerm = term

    def update_voted_for(self, client):
        self.votedFor = client

    def send_heartbeat(self):
        while True:
            if self.role == 'leader':
                self.broadcast_to_all(f'heartbeat {self.name} {self.currentTerm}'.encode())
    def start_election(self):
        self.update_current_term(self.name)
        self.role = "candidate"
        self.votesReceived = 1



    def recv(self):

        while True:
            # Sleep on receipt of every message for demo purposes
            sleep(3)
            # Read the buffer and separate the address from data payload
            data, address = self.soc.recvfrom(1024)
            data = data.decode().split(',')
            print(data)
            if data[1] == "token":

                print(f"Token received from client: {data[0]}")
                # self.RecordMessages(sender, ','.join(data[1:]))


    def createDictionary(self, generator, members):
        # TODO: create dict ID
        # TODO: create dictionary log: dic_id, clientIDS, dic pub key, all versions of dic private key
        # TODO: check commited by raft
        pass

    def putKeyValueDict(self,dictID, key, value):
        # TODO: check access to the dictionary first
        # TODO: The client should encrypt an operation with the public key of the dictionary that the operation is for
        # TODO: It should then add the encrypted operation, the dictionary id, and its own client id to the log
        pass
    def getValueDict(self, dictID, key):
        pass


    def createUniqueDictID(self):
        '''Use PID + a persistent counter/seq number for creating this'''
        # TODO: create unique dictionary ID
        ID = 0
        print(f"The new dictionary ID is: {ID}")
        pass

    def printDict(self,dictID):
        # TODO: print client id for all dictionary members and content of dictionary with dictionary id
        pass

    def printAll(self):
        #TODO: print dictionary ids for all dict that the client is a member of
        pass

    def broadcast(self, msg):
        '''
        Brodcasting message to all outgoing links
        '''
        #TODO: put it in try catch cause some links may fail
        data = str(self.name) + "," + msg
        for client in self.outgoing:
            print(data + " sent to client: " + client)
            self.soc.sendto(data.encode(), self.outgoing[client])

    def failLink(self, dest):
        # TODO: keep a list of failed link, check whenever doing broadcast or sening message,
        # or keep a dictionary of active links or a map etc
        pass

    def fixLink(self,dest):
        #TODO: update the list of failed link
        pass

    def failProcess(self):
        pass
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
        layout = [
                  [gui.Button('Create'),gui.Text('Client IDs'), gui.InputText(do_not_clear=False, size=10)],
                  [gui.Button('Put'), gui.Text('Dict_ID Key Value'), gui.InputText(do_not_clear=False, size=10)],
                  [gui.Button('Get'), gui.Text('Dict_ID Key'), gui.InputText(do_not_clear=False, size=10)],
                  [gui.Button('PrintDict'), gui.Text('Dict_ID'), gui.InputText(do_not_clear=False, size=10)],
                  [gui.Button('printAll')],
                  [gui.Button('failLink'), gui.Text('dest'), gui.InputText(do_not_clear=False, size=10)],
                  [gui.Button('fixLink'), gui.Text('dest'), gui.InputText(do_not_clear=False, size=10)],
                  [gui.Button('failProcess')],
                  [gui.Text('Prob losing token: %'), gui.InputText(do_not_clear=False, size=10), gui.Button('Submit')]
                  ]

        # Create the Window
        window = gui.Window(f'Client {self.name}', layout)
        # Event Loop to process "events" and get the "values" of the inputs
        while True:
            event, inputs = window.read()
            if event == gui.WIN_CLOSED:
                self.continueThread = False
                print("Terminating the program ...")
                sys.exit("Good bye!")
            # if event == 'Create':
            #     print("Creating new dictionary")

            if event == 'Create':
                # The client_ids are in inputs[0]
                client_ids = inputs[0].split()
                print(f"Node {self.name} creates dictionary involving {client_ids}")
                self.createDictionary(self.name, client_ids)

            if event == 'Put':
                # The arguments are in inputs[1]
                args = inputs[1].split()
                # TODO: check the type ... maybe need to cast. Make it robust
                dictID = args[0]
                key = args[1]
                value = args[2]
                print(f"Put the key: {key} and value: {value} in dictionary:{dictID}")
                self.putKeyValueDict(dictID,key,value)
            if event == 'Get':
                # The arguments are in inputs[2]
                args = inputs[2].split()
                # TODO: check the type ... maybe need to cast. Make it robust
                dictID = args[0]
                key = args[1]
                print(f"Get the value of key: {key} from dictionary:{dictID}")
                self.getValueDict(dictID,key)

            if event == 'PrintDict':
                # The client_ids are in inputs[3]
                dictID = inputs[3]
                print(f"Print the dictionary: {dictID}")
                self.printDict(dictID)

            if event == 'printAll':
                print(f"Print all the dictionaries that client {self.name} is member of them")
                self.printAll()

            if event == 'failLink':
                # The destination of fail link in input[4
                destination = inputs[4]
                print(f"Failing the link between {self.name} and {destination}")
                self.failLink(destination)

            if event == 'fixLink':
                # The destination of fail link in input[4
                destination = inputs[5]
                print(f"Fixing the link between {self.name} and {destination}")
                self.fixLink(destination)

            if event == 'failProcess':
                print(f"Failing the process at node {self.name}")
                self.failProcess()
        window.close()

    def starter(self):
        # self.sendToken()
        # _thread.start_new_thread(self.recv, ())
        self.startGUI()


if __name__ == "__main__":

    # if len(sys.argv) < 2 or sys.argv[1] not in "ABCDE":
    #     print("Invalid client name for this project. Valid clients are: A, B, C, D, E")
    #     sys.exit(1)
    cl = client(sys.argv[1])
    cl.starter()
    pass