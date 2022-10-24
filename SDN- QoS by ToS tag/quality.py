import httplib
import json

# This code provides different classes of quality of service for different flows
# It does it by defining different values for ip_tos
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


#Providing quality of service for h10 to h3 flow
#h10 to h3 --> s10s9s8s5s3
q1_h10_h3_s10 = {
        'switch':"00:00:00:00:00:00:00:0a",
        "name":"q1_h10_h3_s10_flow",
        "cookie":"0",
        "priority":"32768",
        "in_port":"1",
        "ipv4_src":"10.0.0.10",
        "ipv4_dst":"10.0.0.3",
        "eth_type":"0x0800",
        "active":"true",
        "ip_tos":"0x05",
        #"ip_dscp":"0x00",
        "actions":"output=3,set_queue=1"
        }

q2_h10_h3_s10 = {
        'switch':"00:00:00:00:00:00:00:0a",
        "name":"q2_h10_h3_s10_flow",
        "cookie":"0",
        "priority":"32768",
        "in_port":"1",
        "ipv4_src":"10.0.0.10",
        "ipv4_dst":"10.0.0.3",
        "eth_type":"0x0800",
        "active":"true",
        "ip_tos":"0x0a",
        #"ip_dscp":"0x04",
        "actions":"output=3,set_queue=2"
        }
q3_h10_h3_s10 = {
        'switch':"00:00:00:00:00:00:00:0a",
        "name":"q3_h10_h3_s10_flow",
        "cookie":"0",
        "priority":"32768",
        "in_port":"1",
        "ipv4_src":"10.0.0.10",
        "ipv4_dst":"10.0.0.3",
        "eth_type":"0x0800",
        "active":"true",
        "ip_tos":"0x15",
        #"ip_dscp":"0x08",
        "actions":"output=3,set_queue=3"
        }
########



q1_h10_h3_s9 = {
        'switch':"00:00:00:00:00:00:00:09",
        "name":"q1_h10_h3_s9_flow",
        "cookie":"0",
        "priority":"32768",
        "in_port":"4",
        "ipv4_src":"10.0.0.10",
        "ipv4_dst":"10.0.0.3",
        "eth_type":"0x0800",
        "active":"true",
        "ip_tos":"0x05",
        #"ip_dscp":"0x00",
        "actions":"output=3,set_queue=1"
        }

q2_h10_h3_s9 = {
        'switch':"00:00:00:00:00:00:00:09",
        "name":"q2_h10_h3_s9_flow",
        "cookie":"0",
        "priority":"32768",
        "in_port":"4",
        "ipv4_src":"10.0.0.10",
        "ipv4_dst":"10.0.0.3",
        "eth_type":"0x0800",
        "active":"true",
        "ip_tos":"0x0a",
        #"ip_dscp":"0x04",
        "actions":"output=3,set_queue=2"
        }

q3_h10_h3_s9 = {
        'switch':"00:00:00:00:00:00:00:09",
        "name":"q3_h10_h3_s9_flow",
        "cookie":"0",
        "priority":"32768",
        "in_port":"4",
        "ipv4_src":"10.0.0.10",
        "ipv4_dst":"10.0.0.3",
        "eth_type":"0x0800",
        "active":"true",
        "ip_tos":"0x15",
        #"ip_dscp":"0x08",
        "actions":"output=3,set_queue=3"
        }


##########


q1_h10_h3_s8 = {
        'switch':"00:00:00:00:00:00:00:08",
        "name":"q1_h10_h3_s8_flow",
        "cookie":"0",
        "priority":"32768",
        "in_port":"5",
        "ipv4_src":"10.0.0.10",
        "ipv4_dst":"10.0.0.3",
        "eth_type":"0x0800",
        "active":"true",
        "ip_tos":"0x05",
        #"ip_dscp":"0x00",
        "actions":"output=3,set_queue=1"
        }

q2_h10_h3_s8 = {
        'switch':"00:00:00:00:00:00:00:08",
        "name":"q2_h10_h3_s8_flow",
        "cookie":"0",
        "priority":"32768",
        "in_port":"5",
        "ipv4_src":"10.0.0.10",
        "ipv4_dst":"10.0.0.3",
        "eth_type":"0x0800",
        "active":"true",
        "ip_tos":"0x0a",
        #"ip_dscp":"0x04",
        "actions":"output=3,set_queue=2"
        }

q3_h10_h3_s8 = {
        'switch':"00:00:00:00:00:00:00:08",
        "name":"q3_h10_h3_s8_flow",
        "cookie":"0",
        "priority":"32768",
        "in_port":"5",
        "ipv4_src":"10.0.0.10",
        "ipv4_dst":"10.0.0.3",
        "eth_type":"0x0800",
        "active":"true",
        "ip_tos":"0x15",
        #"ip_dscp":"0x08",
        "actions":"output=3,set+queue=3"
        }


##########

q1_h10_h3_s5 = {
        'switch':"00:00:00:00:00:00:00:05",
        "name":"q1_h10_h3_s5_flow",
        "cookie":"0",
        "priority":"32768",
        "in_port":"3",
        "ipv4_src":"10.0.0.10",
        "ipv4_dst":"10.0.0.3",
        "eth_type":"0x0800",
        "active":"true",
        "ip_tos":"0x05",
        #"ip_dscp":"0x00",
        "actions":"output=2,set_queue=1"
        }

q2_h10_h3_s5 = {
        'switch':"00:00:00:00:00:00:00:05",
        "name":"q2_h10_h3_s5_flow",
        "cookie":"0",
        "priority":"32768",
        "in_port":"3",
        "ipv4_src":"10.0.0.10",
        "ipv4_dst":"10.0.0.3",
        "eth_type":"0x0800",
        "active":"true",
        "ip_tos":"0x0a",
        #"ip_dscp":"0x04",
        "actions":"output=2,set_queue=2"
        }

q3_h10_h3_s5 = {
        'switch':"00:00:00:00:00:00:00:05",
        "name":"q3_h10_h3_s5_flow",
        "cookie":"0",
        "priority":"32768",
        "in_port":"3",
        "ipv4_src":"10.0.0.10",
        "ipv4_dst":"10.0.0.3",
        "eth_type":"0x0800",
        "active":"true",
        "ip_tos":"0x15",
        #"ip_dscp":"0x08",
        "actions":"output=2,set_queue=3"
        }

#########

q1_h10_h3_s3 = {
        'switch':"00:00:00:00:00:00:00:03",
        "name":"q1_h10_h3_s3_flow",
        "cookie":"0",
        "priority":"32768",
        "in_port":"3",
        "ipv4_src":"10.0.0.10",
        "ipv4_dst":"10.0.0.3",
        "eth_type":"0x0800",
        "active":"true",
        "ip_tos":"0x05",
        #"ip_dscp":"0x00",
        "actions":"output=1,set_queue=1"
        }

q2_h10_h3_s3 = {
        'switch':"00:00:00:00:00:00:00:03",
        "name":"q2_h10_h3_s3_flow",
        "cookie":"0",
        "priority":"32768",
        "in_port":"3",
        "ipv4_src":"10.0.0.10",
        "ipv4_dst":"10.0.0.3",
        "eth_type":"0x0800",
        "active":"true",
        "ip_tos":"0x0a",
        #"ip_dscp":"0x04",
        "actions":"output=1,set_queue=2"
        }

q3_h10_h3_s3 = {
        'switch':"00:00:00:00:00:00:00:03",
        "name":"q3_h10_h3_s3_flow",
        "cookie":"0",
        "priority":"32768",
        "in_port":"3",
        "ipv4_src":"10.0.0.10",
        "ipv4_dst":"10.0.0.3",
        "eth_type":"0x0800",
        "active":"true",
        "ip_tos":"0x15",
        #"ip_dscp":"0x08",
        "actions":"output=1,set_queue=3"
        }

# Pushing the flows and rules to the controller
######1
pusher.set(q1_h10_h3_s10)
pusher.set(q2_h10_h3_s10)
pusher.set(q3_h10_h3_s10)
pusher.set(q1_h10_h3_s9)
pusher.set(q2_h10_h3_s9)
pusher.set(q3_h10_h3_s9)
pusher.set(q1_h10_h3_s8)
pusher.set(q2_h10_h3_s8)
pusher.set(q3_h10_h3_s8)
pusher.set(q1_h10_h3_s5)
pusher.set(q2_h10_h3_s5)
pusher.set(q3_h10_h3_s5)
pusher.set(q1_h10_h3_s3)
pusher.set(q2_h10_h3_s3)
pusher.set(q3_h10_h3_s3)
