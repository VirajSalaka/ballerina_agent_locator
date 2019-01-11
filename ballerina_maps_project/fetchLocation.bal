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
            else if(r.results.length() > 1){
                io:println("too many results from google for address  : " + address);
                int i = 0;
                int result_count = r.results.length();
                io:println("JSON : ");
                while(i < result_count){
                    io:println(i + ". : "+ r.results[i].toString());
                    i = i + 1;
                }

                var firstInput = io:readln("pick one address from the above, and enter the number");

                int|error resultNumber = int.convert(firstInput);

                if(resultNumber is int){
                    while(true){
                        if(resultNumber < result_count && resultNumber > -1){
                            var lat = r.results[resultNumber].geometry.location.lat;
                            var lng = r.results[resultNumber].geometry.location.lng;
                            var place_id = r.results[resultNumber].place_id;
                            var recievedAddress = r.results[resultNumber].formatted_address;

                            string tempAddress = recievedAddress.toString();

                            if(tempAddress.length()>0){
                                io:println(tempAddress.length()+ " "+address);
                                return [place_id.toString(), recievedAddress.toString(), lat.toString(), lng.toString()];
                            }
                                return [place_id.toString(), address, lat.toString(), lng.toString()];
                        }

                        var secondInput = io:readln("Entered number is not valid, and please enter the number again.");
                        int|error resultNumber2 = int.convert(secondInput);

                        if(resultNumber2 is int){
                            resultNumber = resultNumber2;
                        }
                    }
                }


                return [];
            }else{
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
        }
    } else if(response is error) {
        log:printError("Get request failed", err = response);
    }
    return [];
}

