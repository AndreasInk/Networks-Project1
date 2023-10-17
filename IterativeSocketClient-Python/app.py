import requests

# Constant strings we may use for errors or other messaging
requestErrorDescription = "Request failed, please try again"

# Get the configuration of the server
serverAddress = input("IP Address of Server: ")
serverPort = input("Port of Server: ")
baseURL = f"{serverAddress}:{serverPort}/"

# Configure setup instructions 
commands = ["d = date time", "u = up time"]
inputInstructions = "Command to run\n"

for command in commands:
    inputInstructions = inputInstructions + command + "\n"

inputKey = input(inputInstructions)

def fetch(endpoint: str) -> requests.Response | str:
    try:
        return requests.get(baseURL + endpoint)
    except:
        print(requestErrorDescription)
    return requestErrorDescription

def getBasicEndpoint(endpoint: str):
    response = fetch(endpoint)
    if response == requestErrorDescription: return 
    json = response.json()
    print(json[endpoint])
    return json[endpoint]

def getComplexEndpoint(endpoint: str):
    dateTimeResponse = fetch(endpoint)
    if dateTimeResponse == requestErrorDescription: return 
    json = dateTimeResponse.json()
    return json

def printJSON(columns: str, json):
    for column in columns:
        print(column + ": " + json[column])

# Start listening for new input
# TODO: Add the other requests and break up into many methods (one for dateTime, upTime, etc)
while inputKey != "" or inputKey != "q":

    if inputKey == "d":
        getBasicEndpoint("dateTime")

    if inputKey == "u":
        getBasicEndpoint("upTime")

    if inputKey == "m":
        getBasicEndpoint("memoryUsage")

    if inputKey == "n":
        networkConnections = getComplexEndpoint("networkConnections")
       

    inputKey = input()