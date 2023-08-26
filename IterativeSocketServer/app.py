from flask import Flask, jsonify
import datetime
import os
app = Flask(__name__)

@app.route("/dateTime")
def date_time():
    return datetime.timedelta()

@app.route("/upTime")
def up_time():
    return datetime.timedelta()

@app.route("/memoryUsage")
def memory_usage():
    return os.cpu_count()

@app.route("/returnNetworkConnections")
def network_connections():
    return jsonify({"networkConnections": datetime.timedelta()})

@app.route("/currentUsers")
def network_connections():
    return jsonify({"currentUsers": datetime.timedelta()})

@app.route("/runningProcesses")
def running_processes():
    return jsonify({"processes": datetime.timedelta()})

app.run(threaded=False)