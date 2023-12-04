import requests
import datetime
from statistics import mean
import threading

# Constant strings we may use for errors or other messaging
requestErrorDescription = "Request failed, please try again"
commands = ["d = date time", "u = up time", "m = memory usage", "n = network connections", "p = running processes", "cu = current users"]
inputInstructions = "Command to run\n"
iterationInstructions = "How many times should the command run?\n"
for command in commands:
    inputInstructions = inputInstructions + command + "\n"

# Get the configuration of the server
serverAddress = input("IP Address of Server (http://localhost): ")
if serverAddress == "":
    serverAddress = "http://localhost"

serverPort = input("Port of Server (8080): ")
if serverPort == "":
    serverPort = "3216"
    
baseURL = f"{serverAddress}:{serverPort}/"

inputKey = input(inputInstructions)
iterations = int(input(iterationInstructions))

averageTimes = []

# Example: https://google.api.com/someEndpoint
def fetch(endpoint: str):
    try:
        return requests.get(baseURL + endpoint)
    except:
        print(requestErrorDescription)
    return requestErrorDescription

# For basic endpoints that just return a number
def getBasicEndpoint(endpoint: str, iterationStartDate: float):
    response = fetch(endpoint)
    
    if response == requestErrorDescription: 
        print(requestErrorDescription) 
        return 
    try:
        json = response.json()
        print(json[endpoint])
        averageTimes.append(datetime.datetime.now().timestamp() - iterationStartDate)
        return json[endpoint]
    except:
        print(requestErrorDescription)
        return

# For complex endpoints that return a few componets
def getComplexEndpoint(endpoint: str, columnNames: list, iterationStartDate: float):
    
    response = fetch(endpoint)
    if response == requestErrorDescription: return 
    json = response.json()
    averageTimes.append(datetime.datetime.now().timestamp() - iterationStartDate)
    printJSON(columnNames, json)
    return json

# Given columns, this method prints the column and value
def printJSON(columns: [str], json):
    for value in json:
        for column in columns:
            try:
                print(column + ": " + value[column])
            except:
                print("Column not found")

threads = []

def startThread(type: str, columnNames: list = None):
    thread = threading.Thread()
    iterationStartDate = datetime.datetime.now().timestamp()
    if columnNames == None:
        thread = threading.Thread(target=getBasicEndpoint, args=(type,iterationStartDate,))
    else:
         thread = threading.Thread(target=getComplexEndpoint, args=(type,columnNames,iterationStartDate,))
    thread.start()
    threads.append(thread)
# Start listening for new input
while inputKey != "" or inputKey != "q":
    
    for iteration in range(0, iterations):
        
        if inputKey == "d":
            startThread("dateTime")
             
        if inputKey == "u":
            startThread("upTime")

        if inputKey == "m":
            startThread("memoryUsage")

        if inputKey == "n":
            startThread("networkConnections", columnNames=["proto", "receiveQueue", "sendQueue", "localAddress", "foreignAddress"])
        
        if inputKey == "p":
            startThread("runningProcesses", ["user", "pid"])
        
        if inputKey == "cu":
            startThread("currentUsers", ["name", "host"])
    
    # Wait for all threads to complete
    for thread in threads:
        thread.join()
        
    print(f"Requests over time: {averageTimes}")
    print(f"Average time per request: {mean(averageTimes)}")
    for time in averageTimes:
        print(f"{time}, ")
        
    averageTimes = []

    inputKey = input(inputInstructions)
    iterations = int(input(iterationInstructions))

    
    