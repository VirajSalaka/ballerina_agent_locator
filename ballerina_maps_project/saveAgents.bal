import ballerina/http;
import ballerina/log;
import ballerina/io;

function saveAgentRecords(){
    string srcFileName = "./files/sample.csv";

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

function process(io:ReadableCSVChannel csvChannel) returns error? {
    while (csvChannel.hasNext()) {
        var records = check csvChannel.getNext();
        if (records is string[]) {
            string address = makeUntaintedString(records[3]);
            string[] locationDetails = locationFetch(address);

            if(locationDetails.length() > 0){
                addEntryToTable(locationDetails);
            }
        
        }
    }
    return;
}

function closeReadableCSVChannel(io:ReadableCSVChannel csvChannel) {
    var result = csvChannel.close();
    if (result is error) {
        log:printError("Error occured while closing the channel: ",
                        err = result);
    }
}

function makeUntaintedString(string _string) returns @untainted string{
    return _string;
}
