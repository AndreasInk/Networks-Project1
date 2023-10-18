# Here are our imports, these allow us to use functions from other libraries
from flask import Flask, jsonify
import time
import os
import subprocess
import psutil

# Initailizes the server
app = Flask(__name__)

@app.route("/dateTime")
def date_time():
    return jsonify({"dateTime": time.time()})

@app.route("/upTime")
def up_time():
    return jsonify({"upTime": time.time() - psutil.boot_time()})

@app.route("/memoryUsage")
def memory_usage():
    return jsonify({"memoryUsage": os.cpu_count()})

# Returns network connections 
# TODO: Check for correct fields in the project instructions
@app.route("/networkConnections")
def network_connections():
    
    # We use subprocess orginally before researching psutil, psutil or subprocess works
    result = subprocess.run(['netstat', '-tuln'], stdout=subprocess.PIPE, text=True)
    jsonToReturn = []
    # We have to do some parsing to return a json
    for line in result.stdout.split("\n"):
        print(len(line.split()))
        if len(line.split()) == 8:
            protocol, receiveQueue, sendQueue, localAddress, foreignAddress, _, state, _ = line.split()
            jsonToReturn.append({"proto": protocol, "receiveQueue": receiveQueue, "sendQueue": sendQueue, "localAddress": localAddress, "foreignAddress": foreignAddress, "state": state})
    return jsonify(jsonToReturn)

# TODO: Check for correct fields in the project instructions
@app.route("/currentUsers")
def current_users():
    users = []
    for user in psutil.users():
        users.append({"name": user.name,
                      "host": user.host})
    return jsonify(users)

# TODO: Check for correct fields in the project instructions
@app.route("/runningProcesses")
def running_processes():
    processes = []
    for process in psutil.process_iter(attrs=["pid", "name"]):
        processes.append(process)
    return jsonify(processes)

# Starts the server
app.run(threaded=False)
