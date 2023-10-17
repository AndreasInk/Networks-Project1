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

def fetch(endpoint: str) -> requests.Response:
    try:
        requests.get(baseURL + endpoint)
    except:
        print(requestErrorDescription)

def getDateTime():
    dateTimeResponse = fetch("dateTime")
    json = dateTimeResponse.json()
    return json["dateTime"]

def getUpTime():
    dateTimeResponse = fetch("upTime")
    json = dateTimeResponse.json()
    return json["upTime"]

# Start listening for new input
# TODO: Add the other requests and break up into many methods (one for dateTime, upTime, etc)
while inputKey != "":

    if inputKey == "d":
        getDateTime()

    if inputKey == "u":
        getUpTime()

    inputKey = input()