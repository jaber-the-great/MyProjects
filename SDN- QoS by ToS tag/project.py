from mininet.topo import Topo
class MyTopo (Topo):
        "simple topology example"
        def __init__(self):
                Topo.__init__(self)
                switches=[]
                hosts = []
                # Creating 10 hosts and 10 switches
                for i in range(1,11):
                        NewSwitch= self.addSwitch('s%s' %i)
                        NewHost=self.addHost('h%s' %i)
                        # Connecting each host to a swithc with the same number
                        self.addLink(NewSwitch,NewHost)
                        switches.append(NewSwitch)
                        hosts.append(NewHost)
                # Connecting switches together
                self.addLink(switches[0],switches[2])
                self.addLink(switches[0],switches[3])
                self.addLink(switches[0],switches[1])
                self.addLink(switches[1],switches[3])
                self.addLink(switches[2],switches[4])
                self.addLink(switches[3],switches[6])
                self.addLink(switches[3],switches[7])
                self.addLink(switches[4],switches[7])
                self.addLink(switches[5],switches[9])
                self.addLink(switches[5],switches[6])
                self.addLink(switches[6],switches[8])
                self.addLink(switches[6],switches[7])
                self.addLink(switches[7],switches[8])
                self.addLink(switches[8],switches[9])


topos = {'mytopo': (lambda: MyTopo())}
