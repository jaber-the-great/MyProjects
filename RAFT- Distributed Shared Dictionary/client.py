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
from collections import deque

addrs = {"A": ("127.0.0.1", 11111), "B": ("127.0.0.1", 22222), "C": ("127.0.0.1", 33333), "D": ("127.0.0.1", 44444),
         "E": ("127.0.0.1", 55555)}
NumberOfClients = 5
clientsList = "ABCDE"

class client:
    def __init__(self, name):
        self.name = name
        self.event_number = 0
        self.soc = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        # We can have a shorter timeout but due to larger intentional delay, I considered this value
        self.soc.settimeout(random.uniform(5,10))
        self.soc.bind(addrs[name])
        self.failedLinksList = []
        self.continueThread = True
        self.LocalState = []
        self.seqNumber = 0  # The sequence number for dictionary ID generation
        self.dictionaries = {} # TODO: or change it to a list
        self.role = "follower"
        self.currentTerm = 0
        self.currentLeader = None
        self.votedFor = None
        self.log = [[0,0,None]]
        self.state= []
        self.listOfKeys = readPublicKeysFromFile()
        self.votesReceived = 0


    def update_current_term(self, term):
        # Do I need to save it in state?
        self.currentTerm = term
        self.saveStateOnDisk()
    def update_voted_for(self, client):
        # DO I need to save it in state?
        self.votedFor = client
        self.saveStateOnDisk()

    def send_heartbeat(self):
        # Can use AppendEnryRPC with empty RPC for this purpose too
        while True:
            sleep(1)
            if self.role == 'leader':
                msg = ["heartbeat" , str(self.currentTerm)]
                msg = ','.join(msg)
                self.broadcast(msg)

    def start_election(self):

        self.update_current_term(self.currentTerm +1)
        self.role = "candidate"
        self.votesReceived = 1
        self.update_voted_for(self.name)

        print(f"Becoming candidate for term: {self.currentTerm}" )
        last_log = self.getLastLog()
        print(f"The last log is: {last_log}")
        lastIndex = last_log[0]
        lastTerm = last_log[1]
        # RequestVoteRPC format: candidateID, term, lastLogIndex, lastLogTerm
        msg = ["RequestVoteRPC" , str(self.currentTerm), str(lastIndex),
               str(lastTerm)]
        msg = ','.join(msg)
        self.broadcast(msg)


    def getLastLog(self):
        # Index, term, command
        last = self.log[0]
        return last
    def vote_or_not(self, vote_request):
        # vote_request: candidate, type, term, lastLogindex, lastlogTerm
        # Grand vote and reset election timeout if: (VotedFor is null or CandidateID) AND
        # candidateLog >= local log,
        candidate = vote_request[0]
        term = int(vote_request[2])
        lastIndexCandidate = int(vote_request[3])
        lastTermCandidate = int(vote_request[4])
        # TODO: Get the last term and index from log file
        last = self.getLastLog()
        lastLogIndex = int(last[0])
        lastLogTerm = int(last[1])
        Log_Complete = False
        if self.votedFor == None:
           Log_Complete = True
        if lastTermCandidate > lastLogTerm or (lastTermCandidate == lastLogTerm and lastIndexCandidate >= lastLogIndex):
            Log_Complete = True
        NewerTerm = False
        # TODO: is this if correct and based on protocl?
        if term > self.currentTerm:
            NewerTerm = True
        elif term == self.currentTerm:
            if self.votedFor == None or self.votedFor == candidate:
                NewerTerm = True
        if Log_Complete and NewerTerm:
            self.currentTerm = term
            self.role = 'follower'
            self.votedFor = candidate
            self.send_message('vote,' + str(self.currentTerm), candidate)
    def Append_entry(self, command):
        prevEntry = self.getLastLog()
        term = self.currentTerm
        index = prevEntry[0] + 1
        # message format: AppendEntries + current term, current index, command(put get etc) , prev<index, term#>
        msg = ["AppendEntries", str(term),str(index), command , str(prevEntry[0]), str(prevEntry[1])]
        # Maybe just to the ones with access to dictionary
        self.broadcast(msg)

    def handleCMD(self, command):
        command = command.split(',')
        type = command[0]
        dictID = command[1]

        if type == "newDict":
            members = command[2]
            if self.name in members:
                self.dictionaries[dictID] = {"Info": command}
            return

        if dictID not in self.dictionaries:
            return None
        key = command[2]
        if type == "get":
            value = self.dictionaries[dictID][key]
            return value
        if type == "put":
            self.dictionaries[dictID][key] = command[3]
            return None


    def saveStateOnDisk(self):
        file = open(self.name + "_state.txt",'w')
        file.write("current term," + str(self.currentTerm) + '\n')

        file.write("voted for," + str(self.votedFor) + '\n')
        file.close()

    def appendToLogOnDisk(self, data):
        file = open("log.txt", 'a')
        file.write(data)
        file.close()

    def readLogFromFile(self):
        file = open("log.txt", 'r')
        data = file.readlines()
        data.reverse()
        self.log = data
    def readStateFromFile(self):
        file = open(self.name + '_state.txt','r')
        value = file.readline().split(',')
        self.currentTerm = int(value[1])
        value = file.readline().split(',')
        if value[1] != None:
            self.votedFor = value[1]
        else:
            self.votedFor = None
    def recv(self):
        # TODO: If follower, respond to the rpcs
        # message format: sender, type, other values
        # print(f"Started to listen at node: {self.name}")
        try:
            while True:
                data, address = self.soc.recvfrom(1024)
                data = data.decode().split(',')
                sender = data[0]
                if sender in self.failedLinksList:
                    continue

                messageType = data[1]
                if messageType != "heartbeat":
                    print(data)
                if messageType == "heartbeat":
                    if self.name== "E":
                        print(data)
                    self.role = "follower"
                    self.currentLeader = sender
                    term = int(data[2])
                    if self.currentTerm > term:
                        # ask to step down
                        msg = ["step" , str(self.currentTerm),str(self.currentLeader)]
                        msg = ','.join(msg)
                        self.send_message(msg,self.currentLeader)
                    self.currentTerm = max(term, self.currentTerm)
                if messageType == "RequestVoteRPC":
                    term = int(data[2])
                    if int(term > self.currentTerm):
                        if self.role == "leader" or self.role == "candidate":
                            self.role = "follower"
                            # TODO: rest of the step down
                    self.vote_or_not(data)
                if messageType == "vote":
                    self.votesReceived +=1
                    # Change condition for partitioning and failures
                    if self.role == "candidate" and self.votesReceived > 2:
                        self.role = 'leader'
                        self.currentLeader = self.name
                        print(f"This node ({self.name}) changed the role to leader")
                        #TODO: change the timeout setting (no leader election)
                        self.soc.settimeout(None)
                if messageType == "data":
                    pass
                    #TODO: store the data
                if messageType == "AppendEntries":
                    if self.role == "candidate":
                        self.role = 'follower'
                    self.handleCMD(data[4])
                    # TODO: sent response to the leader



                if messageType == "put" or messageType == "get" or messageType == "newDict":
                    if self.role == 'leader':
                        cmd = ','.join(data[1:])
                        self.Append_entry(cmd)


                if messageType == "step":
                    if self.role != "follower":
                        self.role = "follower"
                        self.currentTerm = int(data[2])
                        self. currentLeader = data[3]
        except socket.timeout:
            print("Timeout happened here")
            _thread.start_new_thread(self.recv, ())
            self.start_election()
        except:
            print("can non connect")


    def createDictionary(self, generator, members):
        ID = self.createUniqueDictID()
        pub , pri = generateKeyForDictionary()
        # dictPirvateKeys = {}
        # for client in members:
        #     theKey = enc(pri,self.listOfKeys[client])
        #     dictPirvateKeys[client] = theKey
        # print(dictPirvateKeys)
        command = ['newDict', ID, members,str(pub)]
        # for item in dictPirvateKeys:
        #     command.append(str(dictPirvateKeys[item]))
        command = ','.join(command)
        self.send_message(command, self.currentLeader)

    def putKeyValueDict(self,dictID, key, value):
        # TODO: check access to the dictionary first
        # TODO: The client should encrypt an operation with the public key of the dictionary that the operation is for
        # TODO: It should then add the encrypted operation, the dictionary id, and its own client id to the log
        command = ["put", dictID,key, value]
        command = ','.join(command)
        self.send_message(command,self.currentLeader)

    def getValueDict(self, dictID, key):
        command = ["get", dictID, key]
        command = ','.join(command)
        self.send_message(command, self.currentLeader)


    def createUniqueDictID(self):
        '''Use PID + a persistent counter/seq number for creating this'''
        ID = self.name + str(self.seqNumber)
        self.seqNumber +=1
        print(f"The new dictionary ID is: {ID}")
        return ID

    def printDict(self, dictID):
        # print client id for all dictionary members and content of dictionary with dictionary id
        print(f'Dictionary ID:{dictID}')
        info = self.dictionaries[dictID]['Info']
        info = info.split(',')
        members = info[1]
        print(f'Members of dictionary: {members}')
        for item in self.dictionaries[dictID]:
            if item != "Info":
                print(self.dictionaries[dictID][item])

    def printAll(self):
        for item in self.dictionaries:
            print(item)

    def failLink(self, dest):
        # Adds the destination to the list of failed links
        self.failedLinksList.append(dest)

    def fixLink(self, dest):
        # Removes the destination from the list of failed links
        self.failedLinksList.remove(dest)

    def failProcess(self):
        self.role = "follower"
        print("Failing current process")

    def crashRecover(self):
        self.readLogFromFile()
        self.readStateFromFile()
        self.role = 'follower'
        self.currentLeader = None
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
                  [gui.Button('failProcess')]
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

                client_ids = str(inputs[0]).upper()
                client_ids = client_ids.split()
                client_ids.append(self.name)
                client_ids = ''.join(client_ids)
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




    def broadcast(self, msg):
        data = str(self.name) + "," + msg
        # TODO: find the client members of the dictionary or it is all of them?????

        for client in clientsList:
            if client not in self.failedLinksList and client != self.name:
                if "heartbeat" not in data:
                    print(data + " sent to client: " + client)
                try:
                    self.soc.sendto(data.encode(), addrs[client])
                except:
                    print("no connection")


    def send_message(self,msg, receiver):
        data = str(self.name) + "," + msg
        if receiver not in self.failedLinksList:
            print(data + " sent as direct message to client: " + receiver)
            self.soc.sendto(data.encode(), addrs[receiver])

    def starter(self):

        _thread.start_new_thread(self.recv, ())
        _thread.start_new_thread(self.send_heartbeat,())

        self.startGUI()


if __name__ == "__main__":

    if len(sys.argv) < 2 or sys.argv[1] not in "ABCDE":
        print("Invalid client name for this project. Valid clients are: A, B, C, D, E")
        sys.exit(1)
    cl = client(sys.argv[1])
    cl.starter()