from flask import Flask, jsonify
import time
import os
import subprocess
import psutil

app = Flask(__name__)

@app.route("/dateTime")
def date_time():
    return jsonify({"dateTime": time.time()})
# hello
@app.route("/upTime")
def up_time():
    return jsonify({"upTime": time.time() - psutil.boot_time()})

@app.route("/memoryUsage")
def memory_usage():
    return jsonify({"cpu": os.cpu_count()})

@app.route("/networkConnections")
def network_connections():
    
    result = subprocess.run(['netstat', '-tuln'], stdout=subprocess.PIPE, text=True)
    jsonToReturn = []
    for line in result.stdout.split("\n"):
        print(len(line.split()))
        if len(line.split()) == 8:
            protocol, receiveQueue, sendQueue, localAddress, foreignAddress, _, state, _ = line.split()
            jsonToReturn.append({"proto": protocol, "receiveQueue": receiveQueue, "sendQueue": sendQueue, "localAddress": localAddress, "foreignAddress": foreignAddress, "state": state})
    return jsonify(jsonToReturn)

@app.route("/currentUsers")
def current_users():
    users = []
    for user in psutil.users():
        users.append({"name": user.name,
                      "host": user.host})
    return jsonify(users)

@app.route("/runningProcesses")
def running_processes():
    processes = []
    for process in psutil.process_iter(attrs=["pid", "name"]):
        processes.append(process)
    return jsonify(processes)

app.run(threaded=False)
