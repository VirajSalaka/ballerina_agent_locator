import ballerina/http;
import ballerina/log;
import ballerina/io;
import ballerina/config;

http:Client clientEndpoint = new("https://maps.googleapis.com/maps/api/geocode/json?address=");

//todo: fetch place_id
function locationFetch(string address) returns @untainted string[]{

    string formattedAddress = address.replaceAll("/", "%2F");
    formattedAddress = formattedAddress.replaceAll("\\+", "%2B");
    formattedAddress = formattedAddress.replaceAll(" ", "+");
    formattedAddress = formattedAddress.replaceAll("\\-","%2D");
    string url = formattedAddress + "&key=" + config:getAsString("MAPS_API_KEY");
    var response = clientEndpoint->get(url);
    if (response is http:Response) {
        // io:println(response.getJsonPayload());
        var r = response.getJsonPayload();
        if(r is json){
            if(r.results.length() == 0){
                io:println("error -- could not receive the location : " + address);
                return [];
            }
            var lat = r.results[0].geometry.location.lat;
            var lng = r.results[0].geometry.location.lng;
            var place_id = r.results[0].place_id;
            var recievedAddress = r.results[0].formatted_address;

            string tempAddress = recievedAddress.toString();

            if(tempAddress.length()>0){
                io:println(tempAddress.length()+ " "+address);
                return [place_id.toString(), recievedAddress.toString(), lat.toString(), lng.toString()];
            }
            return [place_id.toString(), address, lat.toString(), lng.toString()];
            
        }
    } else if(response is error) {
        log:printError("Get request failed", err = response);
    }
    return [];
}