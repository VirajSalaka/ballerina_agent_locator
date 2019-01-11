import ballerina/http;
import ballerina/log;
import ballerina/io;
import ballerina/mysql;
import ballerina/math;


public function main() {
    
    string addFileFlag = io:readln("do you need to add the agent location csv file?(yes or no): ");

    if (addFileFlag.equalsIgnoreCase("yes") || addFileFlag.equalsIgnoreCase("y")) {
            string filename = io:readln("please mention the file name");
            createTable();
            saveAgentRecords("./files/" + filename);
    }else if (addFileFlag.equalsIgnoreCase("no") || addFileFlag.equalsIgnoreCase("n")) {

    }
    else{
        while(!(addFileFlag.equalsIgnoreCase("yes") || addFileFlag.equalsIgnoreCase("y") || 
            addFileFlag.equalsIgnoreCase("no") || addFileFlag.equalsIgnoreCase("n"))){
            if (addFileFlag.equalsIgnoreCase("yes") || addFileFlag.equalsIgnoreCase("y")) {
                string filename = io:readln("please mention the file name");
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

    var addressInput = io:readln("enter your address here: ");
    string currentAddress = string.convert(addressInput);

    string[] currentLocationDetails = locationFetch(currentAddress);

    string place_id = currentLocationDetails[0];
    string address = currentLocationDetails[1];
    float|error latitude = float.convert(currentLocationDetails[2]);
    float|error longitude = float.convert(currentLocationDetails[3]);

    io:println(place_id);

    json addressList = retrieveAllEntries();

    int i = 0;
    int l = addressList.length();

    string[] addressArray = [];

    var rawDistance = io:readln("enter the radius of area you need to calculate (in meters) ");

    float|error radius = float.convert(rawDistance);

    while (radius is error){
        var secondRawDistance = io:readln("entered value is not valid. please enter a valid number in meters ");
        float|error secondRadius = float.convert(secondRawDistance);

        if(secondRadius is float){
            radius = secondRadius;
        }

    }
    if(radius is float){
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
                float distance = computetwoAgentDistance(latitude, longitude, agentLatitude, agentLongitude);
                if(distance < radius){
                    if(agentAddress is string){
                        addressArray[addressArray.length()] = agentAddress;
                    }
                }
            }

            i = i+1;
        }
    }
    
    
}


