import requests

# Constant strings we may use for errors or other messaging
requestErrorDescription = "Request failed, please try again"
commands = ["d = date time", "u = up time", "m = memory usage", "n = network connections", "p = running processes", "cu = current users"]
inputInstructions = "Command to run\n"
for command in commands:
    inputInstructions = inputInstructions + command + "\n"

# Get the configuration of the server
serverAddress = input("IP Address of Server: ")
serverPort = input("Port of Server: ")
baseURL = f"{serverAddress}:{serverPort}/"

inputKey = input(inputInstructions)

# Example: https://google.api.com/someEndpoint
def fetch(endpoint: str) -> requests.Response | str:
    try:
        return requests.get(baseURL + endpoint)
    except:
        print(requestErrorDescription)
    return requestErrorDescription

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

def getComplexEndpoint(endpoint: str):
    dateTimeResponse = fetch(endpoint)
    if dateTimeResponse == requestErrorDescription: return 
    json = dateTimeResponse.json()
    return json

def printJSON(columns: [str], json):
    for column in columns:
        try:
            print(column + ": " + json[column])
        except:
            print("Column not found")

# Start listening for new input
# TODO: Add the other requests and break up into many methods (one for dateTime, upTime, etc)
while inputKey != "" or inputKey != "q":

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
        printJSON(["tbd"], runningProcesses)
    
    if inputKey == "cu":
        runningProcesses = getComplexEndpoint("currentUsers")
        # TODO: find field values
        printJSON(["tbd"], runningProcesses)

    inputKey = input()