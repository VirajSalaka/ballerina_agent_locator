import ballerina/http;
import ballerina/log;
import ballerina/io;
import ballerina/mysql;
import ballerina/config;


string dbHost = config:getAsString("DB_SERVER");
string name = config:getAsString("DB_NAME");
string username = config:getAsString("DB_USERNAME");
string password = config:getAsString("DB_PASSWORD");

mysql:Client testDB = new({
        host: dbHost,
        name: name,
        username: username,
        password: password
    });

//create table
function createTable(){
    var ret = testDB->update("DROP TABLE AGENT");
    ret = testDB->update("CREATE TABLE agent(id INT AUTO_INCREMENT,
                          place_id VARCHAR(255), address VARCHAR(255), lat VARCHAR(255), 
                          lng VARCHAR(255), PRIMARY KEY (id))");
    handleUpdate(ret, "Agent table is created successfully");
}

//add entry to the table
//locationDetails array [(place_id),(address),(lat),(lng)]
function addEntryToTable(string[] locationDetails){

    string sqlString = "INSERT INTO agent(place_id, address, lat, lng) values (";
    
    sqlString = sqlString + "'" + locationDetails[0] + "'" + "," ;
    sqlString = sqlString + "'" + locationDetails[1] + "'" + "," ;
    sqlString = sqlString + "'" + locationDetails[2] + "'" + "," ;
    sqlString = sqlString + "'" + locationDetails[3] + "'" + ")" ;
    
    var ret = testDB->update(sqlString);
    handleUpdate(ret, locationDetails[1]);
}

//to retrieve all the entries
function retrieveAllEntries() returns (json){
    var selectRet = testDB->select("SELECT * FROM agent", ());

    if (selectRet is table<record {}>) {
        io:println("\nConvert the table into json");
        var jsonConversionRet = json.convert(selectRet);
        if (jsonConversionRet is json) {
            return jsonConversionRet;
        } else {
            io:println("Error in table to json conversion");
        }
    } else {
        io:println("Select data from student table failed: "
                + <string>selectRet.detail().message);
    }

    return null;
}
//to check the status of the database operation
function handleUpdate(int|error returned, string message) {
    if (returned is int) {
        io:println(message + " status: " + returned);
    } else {
        io:println(message + " failed: " + <string>returned.detail().message);
    }
}