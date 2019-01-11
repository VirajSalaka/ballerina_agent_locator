import ballerina/math;
import ballerina/io;

//compute the distance between two locations provided using latlang details using harvesine formula
//returns in meters
function computetwoAgentDistance(float lat1, float lng1, float lat2, float lng2) returns (float){

    float R = 6378.137;
    float dLat = lat2 * math:PI / 180 - lat1 * math:PI / 180;
    float dLng = lng2 * math:PI / 180 - lng1 * math:PI / 180;
    float a = math:sin(dLat / 2) * math:sin(dLat / 2) + math:cos(lat1 * math:PI / 180) * 
                math:cos(lat2 * math:PI / 180) * math:sin(dLng/2) * math:sin(dLng/2);
    float c = 2 * math:atan2(math:sqrt(a), math:sqrt(1-a));
    float d = R * c;
    return d * 1000;
}