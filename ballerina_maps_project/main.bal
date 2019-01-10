import ballerina/http;
import ballerina/log;
import ballerina/io;
import ballerina/mysql;
import ballerina/math;

// http:Client clientEndpoint = new("https://maps.googleapis.com/maps/api/geocode/json?address=");

// mysql:Client testDB = new({
//         host: "remotemysql.com",
//         name: "66tDPdlh6q",
//         username: "66tDPdlh6q",
//         password: "P0bxw66zIp"
//     });


//todo: read list of addresses from a file
//provide an address as a commandline argument
//implement the function to do the calculation
//output print in terminal
//read the addresses from a spreadsheet

//extended
//send it as a message 

//extended
//distance matrix api to find the closest agent

public function main() {
    createTable();
    saveAgentRecords();
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
            if(distance < 10000){
                io:println(agentAddress);
            }
        }

        i = i+1;
    }
    
}


