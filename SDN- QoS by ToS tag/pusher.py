import httplib
import json

# This code creats different flows and pushes them into floodlight controller.
class StaticEntryPusher(object):

    def __init__(self, server):
        self.server = server

    def get(self, data):
        ret = self.rest_call({}, 'GET')
        return json.loads(ret[2])

    def set(self, data):
        ret = self.rest_call(data, 'POST')
        return ret[0] == 200

    def remove(self, objtype, data):
        ret = self.rest_call(data, 'DELETE')
        return ret[0] == 200

    def rest_call(self, data, action):
        path = '/wm/staticentrypusher/json'
        headers = {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            }
        body = json.dumps(data)
        conn = httplib.HTTPConnection(self.server, 8080)
        conn.request(action, path, body, headers)
        response = conn.getresponse()
        ret = (response.status, response.reason, response.read())
        print ret
        conn.close()
        return ret

pusher = StaticEntryPusher('127.0.0.1')

#Creating flow from host h10 to  host h3
#Creating flow from host h6 to  host h1
#Creating flow from host h9 to  host h1
#Creating flow from host h10 to  host h2
#Creating flow from host h3 to  host h7
#Creating flow from host h4 to  host h10

##########################1
#h10 to h3 --> s10s9s8s5s3
h10_h3_s10 = {
        'switch':"00:00:00:00:00:00:00:0a",
        "name":"h10_h3_s10_flow",
        "cookie":"0",
        "priority":"32768",
        "in_port":"1",
        "ipv4_src":"10.0.0.10",
        "ipv4_dst":"10.0.0.3",
        "eth_type":"0x0800",
        "active":"true",
        "actions":"output=3"
        }

h10_h3_s9 = {
        'switch':"00:00:00:00:00:00:00:09",
        "name":"h10_h3_s9_flow",
        "cookie":"0",
        "priority":"32768",
        "in_port":"4",
        "ipv4_src":"10.0.0.10",
        "ipv4_dst":"10.0.0.3",
        "eth_type":"0x0800",
        "active":"true",
        "actions":"output=3"
        }

h10_h3_s8 = {
        'switch':"00:00:00:00:00:00:00:08",
        "name":"h10_h3_s8_flow",
        "cookie":"0",
        "priority":"32768",
        "in_port":"5",
        "ipv4_src":"10.0.0.10",
        "ipv4_dst":"10.0.0.3",
        "eth_type":"0x0800",
        "active":"true",
        "actions":"output=3"
        }

h10_h3_s5 = {
        'switch':"00:00:00:00:00:00:00:05",
        "name":"h10_h3_s5_flow",
        "cookie":"0",
        "priority":"32768",
        "in_port":"3",
        "ipv4_src":"10.0.0.10",
        "ipv4_dst":"10.0.0.3",
        "eth_type":"0x0800",
        "active":"true",
        "actions":"output=2"
        }

h10_h3_s3 = {
        'switch':"00:00:00:00:00:00:00:03",
        "name":"h10_h3_s3_flow",
        "cookie":"0",
        "priority":"32768",
        "in_port":"3",
        "ipv4_src":"10.0.0.10",
        "ipv4_dst":"10.0.0.3",
        "eth_type":"0x0800",
        "active":"true",
        "actions":"output=1"
        }

########################2
#h6 to h1 ----> s6s7s4s1

h6_h1_s6 = {
            'switch':"00:00:00:00:00:00:00:06",
            "name":"h6_h1_s6_flow",
            "cookie":"0",
            "priority":"32768",
            "in_port":"1",
            "ipv4_src":"10.0.0.6",
            "ipv4_dst":"10.0.0.1",
            "eth_type":"0x0800",
            "active":"true",
            "actions":"output=3"
            }



h6_h1_s7 = {
            'switch':"00:00:00:00:00:00:00:07",
            "name":"h6_h1_s7_flow",
            "cookie":"0",
            "priority":"32768",
            "in_port":"3",
            "ipv4_src":"10.0.0.6",
            "ipv4_dst":"10.0.0.1",
            "eth_type":"0x0800",
            "active":"true",
            "actions":"output=2"
            }


h6_h1_s4 = {
            'switch':"00:00:00:00:00:00:00:04",
            "name":"h6_h1_s4_flow",
            "cookie":"0",
            "priority":"32768",
            "in_port":"4",
            "ipv4_src":"10.0.0.6",
            "ipv4_dst":"10.0.0.1",
            "eth_type":"0x0800",
            "active":"true",
            "actions":"output=2"
            }


h6_h1_s1 = {
            'switch':"00:00:00:00:00:00:00:01",
            "name":"h6_h1_s1_flow",
            "cookie":"0",
            "priority":"32768",
            "in_port":"3",
            "ipv4_src":"10.0.0.6",
            "ipv4_dst":"10.0.0.1",
            "eth_type":"0x0800",
            "active":"true",
            "actions":"output=1"
            }


#######################3
#h9 to h1 --->s9s7s8s4s2s1

h9_h1_s9 = {
            'switch':"00:00:00:00:00:00:00:09",
            "name":"h9_h1_s9_flow",
            "cookie":"0",
            "priority":"32768",
            "in_port":"1",
            "ipv4_src":"10.0.0.9",
            "ipv4_dst":"10.0.0.1",
            "eth_type":"0x0800",
            "active":"true",
            "actions":"output=2"
            }

h9_h1_s7 = {
            'switch':"00:00:00:00:00:00:00:07",
            "name":"h9_h1_s7_flow",
            "cookie":"0",
            "priority":"32768",
            "in_port":"4",
            "ipv4_src":"10.0.0.9",
            "ipv4_dst":"10.0.0.1",
            "eth_type":"0x0800",
            "active":"true",
            "actions":"output=5"
            }

h9_h1_s8 = {
            'switch':"00:00:00:00:00:00:00:08",
            "name":"h9_h1_s8_flow",
            "cookie":"0",
            "priority":"32768",
            "in_port":"4",
            "ipv4_src":"10.0.0.9",
            "ipv4_dst":"10.0.0.1",
            "eth_type":"0x0800",
            "active":"true",
            "actions":"output=2"
            }

h9_h1_s4 = {
            'switch':"00:00:00:00:00:00:00:04",
            "name":"h9_h1_s4_flow",
            "cookie":"0",
            "priority":"32768",
            "in_port":"5",
            "ipv4_src":"10.0.0.9",
            "ipv4_dst":"10.0.0.1",
            "eth_type":"0x0800",
            "active":"true",
            "actions":"output=3"
            }

h9_h1_s2 = {
            'switch':"00:00:00:00:00:00:00:02",
            "name":"h9_h2_s1_flow",
            "cookie":"0",
            "priority":"32768",
            "in_port":"3",
            "ipv4_src":"10.0.0.9",
            "ipv4_dst":"10.0.0.1",
            "eth_type":"0x0800",
            "active":"true",
            "actions":"output=2"
            }

h9_h1_s1 = {
            'switch':"00:00:00:00:00:00:00:01",
            "name":"h9_h1_s1_flow",
            "cookie":"0",
            "priority":"32768",
            "in_port":"4",
            "ipv4_src":"10.0.0.9",
            "ipv4_dst":"10.0.0.1",
            "eth_type":"0x0800",
            "active":"true",
            "actions":"output=1"
            }


#######################4
#h10 to h2 --->s10s6s7s4s2

h10_h2_s10 = {
            'switch':"00:00:00:00:00:00:00:0a",
            "name":"h9_h2_s10_flow",
            "cookie":"0",
            "priority":"32768",
            "in_port":"1",
            "ipv4_src":"10.0.0.10",
            "ipv4_dst":"10.0.0.2",
            "eth_type":"0x0800",
            "active":"true",
            "actions":"output=2"
            }

h10_h2_s6 = {
            'switch':"00:00:00:00:00:00:00:06",
            "name":"h9_h2_s6_flow",
            "cookie":"0",
            "priority":"32768",
            "in_port":"2",
            "ipv4_src":"10.0.0.10",
            "ipv4_dst":"10.0.0.2",
            "eth_type":"0x0800",
            "active":"true",
            "actions":"output=3"
            }
h10_h2_s7 = {
            'switch':"00:00:00:00:00:00:00:07",
            "name":"h9_h2_s7_flow",
            "cookie":"0",
            "priority":"32768",
            "in_port":"3",
            "ipv4_src":"10.0.0.10",
            "ipv4_dst":"10.0.0.2",
            "eth_type":"0x0800",
            "active":"true",
            "actions":"output=2"
            }
h10_h2_s4 = {
            'switch':"00:00:00:00:00:00:00:04",
            "name":"h9_h2_s4_flow",
            "cookie":"0",
            "priority":"32768",
            "in_port":"4",
            "ipv4_src":"10.0.0.10",
            "ipv4_dst":"10.0.0.2",
            "eth_type":"0x0800",
            "active":"true",
            "actions":"output=3"
            }
h10_h2_s2 = {
            'switch':"00:00:00:00:00:00:00:02",
            "name":"h9_h2_s2_flow",
            "cookie":"0",
            "priority":"32768",
            "in_port":"3",
            "ipv4_src":"10.0.0.10",
            "ipv4_dst":"10.0.0.2",
            "eth_type":"0x0800",
            "active":"true",
            "actions":"output=1"
            }


#######################5
#h3 to h7 --->s3s5s8s7

h3_h7_s3 = {
            'switch':"00:00:00:00:00:00:00:03",
            "name":"h3_h7_s3_flow",
            "cookie":"0",
            "priority":"32768",
            "in_port":"1",
            "ipv4_src":"10.0.0.3",
            "ipv4_dst":"10.0.0.7",
            "eth_type":"0x0800",
            "active":"true",
            "actions":"output=3"
            }

h3_h7_s5 = {
            'switch':"00:00:00:00:00:00:00:05",
            "name":"h3_h7_s5_flow",
            "cookie":"0",
            "priority":"32768",
            "in_port":"2",
            "ipv4_src":"10.0.0.3",
            "ipv4_dst":"10.0.0.7",
            "eth_type":"0x0800",
            "active":"true",
            "actions":"output=3"
            }

h3_h7_s8 = {
            'switch':"00:00:00:00:00:00:00:08",
            "name":"h3_h7_s8_flow",
            "cookie":"0",
            "priority":"32768",
            "in_port":"3",
            "ipv4_src":"10.0.0.3",
            "ipv4_dst":"10.0.0.7",
            "eth_type":"0x0800",
            "active":"true",
            "actions":"output=4"
            }

h3_h7_s7 = {
            'switch':"00:00:00:00:00:00:00:07",
            "name":"h3_h7_s7_flow",
            "cookie":"0",
            "priority":"32768",
            "in_port":"5",
            "ipv4_src":"10.0.0.3",
            "ipv4_dst":"10.0.0.7",
            "eth_type":"0x0800",
            "active":"true",
            "actions":"output=1"
            }


#######################6
#h4 to h10 --->s4s8s9s10

h4_h10_s4 = {
            'switch':"00:00:00:00:00:00:00:04",
            "name":"h4_h10_s4_flow",
            "cookie":"0",
            "priority":"32768",
            "in_port":"1",
            "ipv4_src":"10.0.0.4",
            "ipv4_dst":"10.0.0.10",
            "eth_type":"0x0800",
            "active":"true",
            "actions":"output=5"
            }

h4_h10_s8 = {
            'switch':"00:00:00:00:00:00:00:08",
            "name":"h4_h10_s8_flow",
            "cookie":"0",
            "priority":"32768",
            "in_port":"2",
            "ipv4_src":"10.0.0.4",
            "ipv4_dst":"10.0.0.10",
            "eth_type":"0x0800",
            "active":"true",
            "actions":"output=5"
            }

h4_h10_s9 = {
            'switch':"00:00:00:00:00:00:00:09",
            "name":"h4_h10_s9_flow",
            "cookie":"0",
            "priority":"32768",
            "in_port":"3",
            "ipv4_src":"10.0.0.4",
            "ipv4_dst":"10.0.0.10",
            "eth_type":"0x0800",
            "active":"true",
            "actions":"output=4"
            }

h4_h10_s10 = {
            'switch':"00:00:00:00:00:00:00:0a",
            "name":"h4_h10_s10_flow",
            "cookie":"0",
            "priority":"32768",
            "in_port":"3",
            "ipv4_src":"10.0.0.4",
            "ipv4_dst":"10.0.0.10",
            "eth_type":"0x0800",
            "active":"true",
            "actions":"output=1"
            }

########################
flow1 = {
    'switch':"00:00:00:00:00:00:00:01",
    "name":"flow_mod_1",
    "cookie":"0",
    "priority":"32768",
    "in_port":"4",
    "ipv4_src":"10.0.0.2",
    "ipv4_dst":"10.0.0.3",
    "eth_type":"0x0800",
    "active":"true",
    "actions":"output=2"
    }




flow2 = {
    'switch':"00:00:00:00:00:00:00:02",
    "name":"flow_mod_2",
    "cookie":"0",
    "priority":"32768",
    "in_port":"1",
    "ipv4_src":"10.0.0.2",
    "ipv4_dst":"10.0.0.3",
    "eth_type":"0x0800",
    "active":"true",
    "actions":"output=2"
    }

flow3 = {
    'switch':"00:00:00:00:00:00:00:03",
    "name":"flow_mod_3",
    "cookie":"0",
    "priority":"32768",
    "in_port":"2",
    "ipv4_src":"10.0.0.2",
    "ipv4_dst":"10.0.0.3",
    "eth_type":"0x0800",
    "active":"true",
    "actions":"output=1"
    }


# Pushing the created flows to the controller
######1
pusher.set(h10_h3_s10)
pusher.set(h10_h3_s9)
pusher.set(h10_h3_s8)
pusher.set(h10_h3_s5)
pusher.set(h10_h3_s3)
#######2
pusher.set(h6_h1_s6)
pusher.set(h6_h1_s7)
pusher.set(h6_h1_s4)
pusher.set(h6_h1_s1)
#######3
pusher.set(h9_h1_s9)
pusher.set(h9_h1_s7)
pusher.set(h9_h1_s8)
pusher.set(h9_h1_s4)
pusher.set(h9_h1_s2)
pusher.set(h9_h1_s1)
#######4
pusher.set(h10_h2_s10)
pusher.set(h10_h2_s6)
pusher.set(h10_h2_s7)
pusher.set(h10_h2_s4)
pusher.set(h10_h2_s2)
#######5
pusher.set(h3_h7_s3)
pusher.set(h3_h7_s5)
pusher.set(h3_h7_s8)
pusher.set(h3_h7_s7)
#######6
pusher.set(h4_h10_s4)
pusher.set(h4_h10_s8)
pusher.set(h4_h10_s9)
pusher.set(h4_h10_s10)
