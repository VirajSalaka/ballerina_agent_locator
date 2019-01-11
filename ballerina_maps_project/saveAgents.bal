import ballerina/http;
import ballerina/log;
import ballerina/io;

//to read the csv file
function saveAgentRecords(string filename){
    string srcFileName = filename;

    io:ReadableCSVChannel rCsvChannel = io:openReadableCsvFile(srcFileName);
    io:println("Start processing the CSV file from ", srcFileName);
    var processedResult = process(rCsvChannel);
    if (processedResult is error) {
        log:printError("An error occurred while processing the records: ",
                        err = processedResult);
    }
    io:println("Processing completed.");

    closeReadableCSVChannel(rCsvChannel);
}

//add entries to the databases after reading the csv
function process(io:ReadableCSVChannel csvChannel) returns error? {

    string[] notEnteredAddresses = [];

    while (csvChannel.hasNext()) {
        var records = check csvChannel.getNext();
        if (records is string[]) {
            string address = makeUntaintedString(records[3]);

            //fetch the location details for the provided address in the csv file
            string[] locationDetails = locationFetch(address);

            //insert records to the database
            if(locationDetails.length() > 0){
                if(locationDetails.length()==1){
                    notEnteredAddresses[notEnteredAddresses.length()] = locationDetails[0];
                }
                else{
                    addEntryToTable(locationDetails);
                }
            }
        }
    }
    io:println("    --------------   ");

    io:println("following addresses are not added");

    int count = 1;
    foreach var item in notEnteredAddresses {
        io:println(count + " : " + item);
        count = count + 1;
    }
    return;
}

//close the csv file
function closeReadableCSVChannel(io:ReadableCSVChannel csvChannel) {
    var result = csvChannel.close();
    if (result is error) {
        log:printError("Error occured while closing the channel: ",
                        err = result);
    }
}

//to make the string untainted
function makeUntaintedString(string _string) returns @untainted string{
    return _string;
}
