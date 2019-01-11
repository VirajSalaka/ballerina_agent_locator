import ballerina/http;
import ballerina/log;
import ballerina/io;
import ballerina/mysql;
import ballerina/math;

//main function
public function main() {
    
    //to check whether the user needs to update the database with new data set (csv file)
    string addFileFlag = io:readln("do you need to add the agent location csv file?(yes or no): ");

    if (addFileFlag.equalsIgnoreCase("yes") || addFileFlag.equalsIgnoreCase("y")) {

            //add file name
            string filename = io:readln("please mention the file name : ");

            //create table agent
            createTable();

            //add entries to the agent table
            saveAgentRecords("./files/" + filename);

    //if the user input is no, we can move forward
    }else if (addFileFlag.equalsIgnoreCase("no") || addFileFlag.equalsIgnoreCase("n")) {

    }

    //if user inputs some other string, continue until the system recieves a valid answer
    else{
        //to iterate until the system recieves the correct answer
        while(!(addFileFlag.equalsIgnoreCase("yes") || addFileFlag.equalsIgnoreCase("y") || 
            addFileFlag.equalsIgnoreCase("no") || addFileFlag.equalsIgnoreCase("n"))){

            if (addFileFlag.equalsIgnoreCase("yes") || addFileFlag.equalsIgnoreCase("y")) {
                string filename = io:readln("please mention the file name : ");
                createTable();
                saveAgentRecords("./files/" + filename);
                break;

            }else if (addFileFlag.equalsIgnoreCase("no") || addFileFlag.equalsIgnoreCase("n")) {
                break;

            }else{
                addFileFlag = io:readln("answer is not valid, please say yes or no. : ");
                continue;
            }
        }
    }

    //to take the user input (this should be a business address)
    var addressInput = io:readln("enter your address here: ");

    //to convert the input into a string
    string currentAddress = string.convert(addressInput);

    //to retrieve place_id, formatted address, and latlang using the google API
    string[] currentLocationDetails = locationFetch(currentAddress);

    if(currentLocationDetails.length() == 1 || currentLocationDetails.length() == 0){
        io:println("location cannot be fetched, press ctrl+z");
    }

    //to convert the string values
    string place_id = currentLocationDetails[0];
    string address = currentLocationDetails[1];
    float|error latitude = float.convert(currentLocationDetails[2]);
    float|error longitude = float.convert(currentLocationDetails[3]);

    //to retrieve all the entries in the database
    json addressList = retrieveAllEntries();

    int i = 0;
    int l = addressList.length();

    //keep the addresses which located within the mentioned radius from user location
    string[] addressArray = [];

    //the radius user need to calculate
    var rawDistance = io:readln("enter the radius of area you need to calculate (in meters) ");

    float|error radius = float.convert(rawDistance);

    //to handle input conversion error
    while (radius is error){
        var secondRawDistance = io:readln("entered value is not valid. please enter a valid number in meters ");
        float|error secondRadius = float.convert(secondRawDistance);

        if(secondRadius is float){
            radius = secondRadius;
        }

    }
    //if user provides a valid input
    if(radius is float){

        //iterate through all the entries within the database
        while (i < l){
            json searchResult = addressList[i];

            var jsonPlace_id = searchResult.place_id;
            var jsonAddress = searchResult.address;
            var jsonLatitude = searchResult.lat;
            var jsonLongitude = searchResult.lng;

            string|error agentAddress = string.convert(jsonAddress);
            float|error agentLatitude = float.convert(jsonLatitude);
            float|error agentLongitude = float.convert(jsonLongitude);

            if(latitude is float && longitude is float && agentLatitude is float && agentLongitude is float){

                //compute the distance between agent(from database) and user using harvesine formula
                float distance = computetwoAgentDistance(latitude, longitude, agentLatitude, agentLongitude);

                //check the agents located within the user defined radius
                if(distance < radius){
                    if(agentAddress is string){
                        addressArray[addressArray.length()] = agentAddress;
                    }
                }
            }

            i = i+1;
        }
    }

    //print all the agent addresses located within the radius
    io:println("\nThese are the results");
    foreach var item in addressArray {
        io:println(item);
    }
    io:println();
    io:println("count is : " + addressArray.length());
}


