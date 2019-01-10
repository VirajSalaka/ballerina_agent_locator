import ballerina/math;
import ballerina/io;

//using harvesine formula
//returns in meters
function computetwoAgentDistance(float lat1, float lng1, float lat2, float lng2) returns (float){
    // var R = 6378.137; // Radius of earth in KM
    // var dLat = lat2 * Math.PI / 180 - lat1 * Math.PI / 180;
    // var dLon = lon2 * Math.PI / 180 - lon1 * Math.PI / 180;
    // var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
    // Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
    // Math.sin(dLon/2) * Math.sin(dLon/2);
    // var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    // var d = R * c;
    // return d * 1000; // meters


    float R = 6378.137;
    float dLat = lat2 * math:PI / 180 - lat1 * math:PI / 180;
    float dLng = lng2 * math:PI / 180 - lng1 * math:PI / 180;
    float a = math:sin(dLat / 2) * math:sin(dLat / 2) + math:cos(lat1 * math:PI / 180) * 
                math:cos(lat2 * math:PI / 180) * math:sin(dLng/2) * math:sin(dLng/2);
    float c = 2 * math:atan2(math:sqrt(a), math:sqrt(1-a));
    float d = R * c;
    //io:println("Distance is "+ d);
    return d * 1000;
}