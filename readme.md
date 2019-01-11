# Nearby Agent Locator using Ballerina
Background :
    Imagine a scenerio where a user needs to find out the agents (belongs to organization)
    who are located within a certain predefined distance 'x'. When the agent addresses are
    provided, the user can find the nearby agents using this application. In this implemntation,
    we are using ballerina, mysql  and google geocoding API.

![Overview](component_diagram.png)

### Getting started

* Clone the repository by running the following command
```shell
git clone https://github.com/VirajSalaka/ballerina_agent_locator.git
```

* Initialize the ballerina project.
```shell
ballerina init
```
* Create a file called `ballerina.conf` and include the following cofigurations
```shell
DB_SERVER="localhost"
DB_NAME="myproject"
DB_USERNAME="root"
DB_PASSWORD="root"
MAPS_API_KEY="<your api key>"
```
 
### SAVE ADDRESS FILE
* save the csv file inside "files" folder , which you need to add to the database.
* The csv file should be in following format,

    "ID" , "Agent Name" , "Agent email" , "Agent Address" 
    

###Instructions
* Go to project directory,
* Run the ballerina program
```shell
ballerina run ballerina_maps_project
```
* follow the instructions provided in the terminal and provide the valid inputs.
* finally you will end up with the agents located within the radius you have mentioned.
    
    
