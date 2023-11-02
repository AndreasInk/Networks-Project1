import requests
import datetime
from statistics import mean
# Constant strings we may use for errors or other messaging
requestErrorDescription = "Request failed, please try again"
commands = ["d = date time", "u = up time", "m = memory usage", "n = network connections", "p = running processes", "cu = current users"]
inputInstructions = "Command to run\n"
iterationInstructions = "How many times should the command run?\n"
for command in commands:
    inputInstructions = inputInstructions + command + "\n"

# Get the configuration of the server
serverAddress = input("IP Address of Server (http://localhost): ")
serverPort = input("Port of Server (8080): ")
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
def getBasicEndpoint(endpoint: str):
    response = fetch(endpoint)
    if response == requestErrorDescription: 
        print(requestErrorDescription) 
        return 
    try:
        json = response.json()
        return json[endpoint]
    except:
        print(requestErrorDescription)
        return

# For complex endpoints that return a few componets
def getComplexEndpoint(endpoint: str):
    dateTimeResponse = fetch(endpoint)
    if dateTimeResponse == requestErrorDescription: return 
    json = dateTimeResponse.json()
    return json

# Given columns, this method prints the column and value
def printJSON(columns: [str], json):
    for column in columns:
        try:
            print(column + ": " + json[column])
        except:
            print("Column not found")

# Start listening for new input
while inputKey != "" or inputKey != "q":
    for iteration in range(0, iterations):
        iterationStartDate = datetime.datetime.now().timestamp()
        if inputKey == "d":
            print(getBasicEndpoint("dateTime"))
             
        if inputKey == "u":
            print(getBasicEndpoint("upTime"))

        if inputKey == "m":
            print(getBasicEndpoint("memoryUsage"))

        if inputKey == "n":
            networkConnections = getComplexEndpoint("networkConnections")
            printJSON(["proto", "receiveQueue", "sendQueue", "localAddress", "foreignAddress", "state"], networkConnections)
        
        if inputKey == "p":
            runningProcesses = getComplexEndpoint("runningProcesses")
            # TODO: find field values
            printJSON(["tbd", "tbh"], runningProcesses)
        
        if inputKey == "cu":
            runningProcesses = getComplexEndpoint("currentUsers")
            # TODO: find field values
            printJSON(["tbd"], runningProcesses)

        averageTimes.append(datetime.datetime.now().timestamp() - iterationStartDate)

    inputKey = input()

    print(f"Request over time: {averageTimes}")
    print(f"Average time per request: {mean(averageTimes)}")
    