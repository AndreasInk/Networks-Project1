# Here are our imports, these allow us to use functions from other libraries
import time
import os
import subprocess
import socketserver
import http.server
import json 

def date_time():
    return json.dumps({"dateTime": time.time()})

def up_time():
    uptime = subprocess.run(['uptime', '-s'], stdout=subprocess.PIPE, text=True)
    uptime_output = uptime.stdout.strip()
    uptime_fields = uptime_output.split(" ")
    return json.dumps({"upTime": time.time() - int(uptime_fields[1])})

def memory_usage():
    return json.dumps({"memoryUsage": os.cpu_count()})

# Returns network connections 
# TODO: Check for correct fields in the project instructions
def network_connections():
    
    # We use subprocess orginally before researching psutil, psutil or subprocess works
    result = subprocess.run(['netstat'], stdout=subprocess.PIPE, text=True)
    jsonToReturn = []
    # We have to do some parsing to return a json
    for line in result.stdout.split("\n"):
        if len(line.split()) == 8:
            protocol, receiveQueue, sendQueue, localAddress, foreignAddress, _, state, _ = line.split()
            jsonToReturn.append({"proto": protocol, "receiveQueue": receiveQueue, "sendQueue": sendQueue, "localAddress": localAddress, "foreignAddress": foreignAddress, "state": state})
    return json.dumps(jsonToReturn)

# TODO: Check for correct fields in the project instructions
def current_users():
    users = []
    current_users = subprocess.run(['who'], stdout=subprocess.PIPE, text=True)
    for user in current_users:
        users.append({"name": user.name,
                    "host": user.host})
    return json.dumps(users)

# TODO: Check for correct fields in the project instructions
def running_processes():
    processes = []
    current_processes = subprocess.run(['ps'], stdout=subprocess.PIPE, text=True)
    for process in current_processes:
        processes.append(process)
    return json.dumps(processes)

def package_response(self, response):
    self.send_response(200)
    self.send_header("Content-Type", "application/json")
    self.end_headers()
    self.wfile.write(response.encode())
    
class ServerHandler(http.server.BaseHTTPRequestHandler):
    
    def do_GET(self):
        path = self.path

        if path == "/runningProcesses":
            response = running_processes()
            package_response(self, response)

        elif path == "/currentUsers":
            response = current_users()
            package_response(self, response)

        elif path == "/networkConnections":
            response = network_connections()
            package_response(self, response)

        elif path == "/memoryUsage":
            response = memory_usage()
            package_response(self, response)

        elif path == "/upTime":
            response = up_time()
            package_response(self, response)
        
        elif path == "/dateTime":
            response = date_time()
            package_response(self, response)
        else:
            # Return a 404 response for routes unknown
            self.send_response(404)
            self.send_header("Content-type", "text/plain")
            self.end_headers()
            self.wfile.write("Not found".encode())

with socketserver.TCPServer(("", 8305), ServerHandler) as httpd:
    print(f"Serving")
    httpd.serve_forever()