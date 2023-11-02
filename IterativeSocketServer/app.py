# Here are our imports, these allow us to use functions from other libraries
import time
import os
import subprocess
import socketserver
import http.server
import json 
import datetime

def date_time():
    return json.dumps({"dateTime": time.time()})

def up_time():
    uptime = subprocess.run(['uptime', '-s'], stdout=subprocess.PIPE)
    uptime_output = uptime.stdout.decode('utf-8').strip()
    uptime_float = datetime.datetime.strptime(uptime_output, '%Y-%m-%d %H:%M:%S').timestamp()
    return json.dumps({"upTime": time.time() - uptime_float})

def memory_usage():
    return json.dumps({"memoryUsage": os.cpu_count()})

# Returns network connections 
# TODO: Check for correct fields in the project instructions
def network_connections():
    
    result = subprocess.run(['netstat'], stdout=subprocess.PIPE).stdout.decode('utf-8')
    jsonToReturn = []
    # We have to do some parsing to return a json
    for line in result.split("\n"):
        print(f"current_users {len(line.split())}")
        if len(line.split()) == 8:
            protocol, receiveQueue, sendQueue, localAddress, foreignAddress, _, state, _ = line.split()
            jsonToReturn.append({"proto": protocol, "receiveQueue": receiveQueue, "sendQueue": sendQueue, "localAddress": localAddress, "foreignAddress": foreignAddress, "state": state})
    return json.dumps(jsonToReturn)

# TODO: Check for correct fields in the project instructions
def current_users():
    users = []
    current_users = subprocess.run(['who'], stdout=subprocess.PIPE).stdout.decode('utf-8')
    for line in current_users.split("\n"):
        print(f"current_users {len(line.split())}")
        if len(line.split()) == 5:
            name, host, _, _, _ = line.split()
            users.append({"name": name,
                    "host": host})
    return json.dumps(users)

# TODO: Check for correct fields in the project instructions
def running_processes():
    processes = []
    current_processes = subprocess.run(['ps'], stdout=subprocess.PIPE).stdout.decode('utf-8')
    for line in current_processes.split("\n"):
        print(f"running processes {len(line.split())}")
        if len(line.split()) == 5:
           user, pid, cpu, mem, _ = line.split()
           processes.append({
                "user": user,
                "pid": pid,
            })
    return json.dumps(processes)

# Bundles our response in a readable way
def package_response(self, response):
    self.send_response(200)
    self.send_header("Content-Type", "application/json")
    self.end_headers()
    self.wfile.write(response.encode())

class ServerHandler(http.server.BaseHTTPRequestHandler):
    
    # Calls when we do a get request
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

# Starts our server
with socketserver.TCPServer(("", 3216), ServerHandler) as httpd:
    print(f"Serving")
    httpd.serve_forever()