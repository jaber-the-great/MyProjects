import httplib
import json
# This code creates different MPLS flows with different quality of service level 
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

# Creating different flows and defining different MPLS label for each hop
#########
# Creating MPLS flow from h10 to h3 ---> s10s9s8s5s3
# For realtime traffic in queue numner 1 --> q1
h10_h3_s10_q = {
        'switch':"00:00:00:00:00:00:00:0a",
        "name":"h10_h3_s10_flowq",
        "cookie":"0",
        "priority":"32768",
        "in_port":"1",
        "ipv4_src":"10.0.0.10",
        "ipv4_dst":"10.0.0.3",
        "eth_type":"0x0800",
        "ip_tos":"0x05",
        "active":"true",
        "actions":"push_mpls=0x8847,set_field=mpls_label->8,set_queue=1,output=3"
        }

h10_h3_s9_q = {
        'switch':"00:00:00:00:00:00:00:09",
        "name":"h10_h3_s9_flowq",
        "cookie":"0",
        "priority":"32768",
        "in_port":"4",
        "eth_type":"0x08847",
        "active":"true",
        "mpls_label":"8",
        "actions":"set_field=mpls_label->13,set_queue=1,output=3"
        }

h10_h3_s8_q = {
        'switch':"00:00:00:00:00:00:00:08",
        "name":"h10_h3_s8_flowq",
        "cookie":"0",
        "priority":"32768",
        "in_port":"5",
        "eth_type":"0x8847",
        "active":"true",
        "mpls_label":"13",
        "actions":"set_field=mpls_label->19,set_queue=1,output=3"
        }

h10_h3_s5_q = {
        'switch':"00:00:00:00:00:00:00:05",
        "name":"h10_h3_s5_flowq",
        "cookie":"0",
        "priority":"32768",
        "in_port":"3",
        "eth_type":"0x8847",
        "active":"true",
        "mpls_label":"19",
        "actions":"set_field=mpls_label->25,set_queue=1,output=2"
        }

h10_h3_s3_q = {
        'switch':"00:00:00:00:00:00:00:03",
        "name":"h10_h3_s3_flowq",
        "cookie":"0",
        "priority":"32768",
        "in_port":"3",
        "eth_type":"0x8847",
        "active":"true",
        "mpls_label":"25",
        "actions":"pop_mpls=0x800,set_queue=1,output=1"
        }


##########################
#Creating flow from h10 to h3 --> s10s9s8s5s3
## For NON realtime traffic in queue numner 2 --> q2
h10_h3_s10 = {
        'switch':"00:00:00:00:00:00:00:0a",
        "name":"h10_h3_s10_flow",
        "cookie":"0",
        "priority":"32768",
        "in_port":"1",
        "ipv4_src":"10.0.0.10",
        "ipv4_dst":"10.0.0.3",
        "eth_type":"0x0800",
        "ip_tos":"0x0a",
        "active":"true",
        "actions":"push_mpls=0x8847,set_field=mpls_label->7,set_queue=2,output=3"
        }

h10_h3_s9 = {
        'switch':"00:00:00:00:00:00:00:09",
        "name":"h10_h3_s9_flow",
        "cookie":"0",
        "priority":"32768",
        "in_port":"4",
        "eth_type":"0x08847",
        "active":"true",
        "mpls_label":"7",
        "actions":"set_field=mpls_label->14,set_queue=2,output=3"
        }

h10_h3_s8 = {
        'switch':"00:00:00:00:00:00:00:08",
        "name":"h10_h3_s8_flow",
        "cookie":"0",
        "priority":"32768",
        "in_port":"5",
        "eth_type":"0x8847",
        "active":"true",
        "mpls_label":"14",
        "actions":"set_field=mpls_label->21,set_queue=2,output=3"
        }

h10_h3_s5 = {
        'switch':"00:00:00:00:00:00:00:05",
        "name":"h10_h3_s5_flow",
        "cookie":"0",
        "priority":"32768",
        "in_port":"3",
        "eth_type":"0x8847",
        "active":"true",
        "mpls_label":"21",
        "actions":"set_field=mpls_label->28,set_queue=2,output=2"
        }

h10_h3_s3 = {
        'switch':"00:00:00:00:00:00:00:03",
        "name":"h10_h3_s3_flow",
        "cookie":"0",
        "priority":"32768",
        "in_port":"3",
        "eth_type":"0x8847",
        "active":"true",
        "mpls_label":"28",
        "actions":"pop_mpls=0x800,set_queue=2,output=1"
        }

###########################
##### Creating flow from h10 to h8    s10s9s8
### # For realtime traffic in queue numner 1 --> q1
h10_h8_s10_q = {
            'switch':"00:00:00:00:00:00:00:0a",
            "name":"flowq1",
            "cookie":"0",
            "priority":"32768",
            "in_port":"1",
            "ipv4_src":"10.0.0.10",
            "ipv4_dst":"10.0.0.8",
            "eth_type":"0x0800",
            "ip_tos":"0x05",
            "active":"true",
            "actions":"push_mpls=0x8847,set_field=mpls_label->4,set_queue=1,output=3"
            }
h10_h8_s9_q = {
            'switch':"00:00:00:00:00:00:00:09",
            "name":"flowq2",
            "cookie":"0",
            "priority":"32768",
            "in_port":"4",
            "eth_type":"0x08847",
            "active":"true",
            "mpls_label":"4",
            "actions":"set_field=mpls_label->5,output=3"
            }

h10_h8_s8_q = {
            'switch':"00:00:00:00:00:00:00:08",
            "name":"flowq3",
            "cookie":"0",
            "priority":"32768",
            "in_port":"5",
            "eth_type":"0x08847",
            "active":"true",
            "mpls_label":"5",
            "actions":"pop_mpls=0x800,set_queue=1,output=1"
            }


#######################
#Creating flow from h10 to h8 --->s10s6s7s8
# # For NON realtime traffic in queue numner 2 --> q2
h10_h8_s10 = {
            'switch':"00:00:00:00:00:00:00:0a",
            "name":"h9_h2_s10_flow",
            "cookie":"0",
            "priority":"32768",
            "in_port":"1",
            "ipv4_src":"10.0.0.10",
            "ipv4_dst":"10.0.0.8",
            "eth_type":"0x0800",
            "active":"true",
            "ip_tos":"0x0a",
            "actions":"push_mpls=0x8847,set_field=mpls_label->3,set_queue=2,output=2"
            }

h10_h8_s6 = {
            'switch':"00:00:00:00:00:00:00:06",
            "name":"h9_h2_s6_flow",
            "cookie":"0",
            "priority":"32768",
            "in_port":"2",
            "eth_type":"0x08847",
            "active":"true",
            "mpls_label":"3",
            "actions":"set_field=mpls_label->9,output=3"
            }
h10_h8_s7 = {
            'switch':"00:00:00:00:00:00:00:07",
            "name":"h9_h2_s7_flow",
            "cookie":"0",
            "priority":"32768",
            "in_port":"3",
            "eth_type":"0x08847",
            "active":"true",
            "mpls_label":"9",
            "actions":"set_field=mpls_label->15,output=5"
            }
h10_h8_s8 = {
            'switch':"00:00:00:00:00:00:00:08",
            "name":"h9_h2_s4_flow",
            "cookie":"0",
            "priority":"32768",
            "in_port":"4",
            "eth_type":"0x8847",
            "active":"true",
            "mpls_label":"15",
            "actions":"pop_mpls=0x800,set_queue=2,output=1"
            }


# Pushing the flows and different rules into the controller
pusher.set(h10_h3_s10)
pusher.set(h10_h3_s9)
pusher.set(h10_h3_s8)
pusher.set(h10_h3_s5)
pusher.set(h10_h3_s3)

pusher.set(h10_h3_s10_q)
pusher.set(h10_h3_s9_q)
pusher.set(h10_h3_s8_q)
pusher.set(h10_h3_s5_q)
pusher.set(h10_h3_s3_q)
#######
pusher.set(h10_h8_s10)
pusher.set(h10_h8_s6)
pusher.set(h10_h8_s7)
pusher.set(h10_h8_s8)

#######
pusher.set(h10_h8_s10_q)
pusher.set(h10_h8_s9_q)
pusher.set(h10_h8_s8_q)
