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

# Start listening for new input
while inputKey != "":
    if inputKey == "d":
        try:
            requests.get(baseURL + "dateTime")
        except:
            print(requestErrorDescription)
    inputKey = input()