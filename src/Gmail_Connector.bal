package src;

import ballerina.net.http;
import ballerina.config;
import ballerina.log;
import ballerina.util;


string refresh_token = config:getGlobalValue("conf_Gmailrefresh_token");
string client_id = config:getGlobalValue("conf_Gmailclient_id");
string client_secret = config:getGlobalValue("conf_Gmailclient_secret");

@Description {value:"Genarate Gmail Access token using Refresh token"}
@Return {value:"New Access token and error"}
public function generateAccessToken () (string, error) {
    endpoint<http:HttpClient> gmailTokenEP {
        create http:HttpClient(ENDPOINT,{});
    }
    http:OutRequest request = {};
    http:InResponse response = {};
    http:HttpConnectorError err;
    error msg;
    string body = string `grant_type=refresh_token&client_id={{client_id}}&client_secret={{client_secret}}&refresh_token={{refresh_token}}`;
    request.setHeader("Content-Type", "application/x-www-form-urlencoded");
    request.setStringPayload(body);
    response, err = gmailTokenEP.post("/token", request);
    json jResponse = response.getJsonPayload();
    string token;
    try {
        if ((error)err == null) {
            token, _ = (string)jResponse.access_token;
            log:printInfo("New access token is generated");
        } else {
            msg = {message:"Error occurred when sending a request to retrieve the access token"};
        }
    } catch (error e) {
        msg = {message:"Error getting the access token"};
    }
    return token, msg;
}

@Description {value:"Send individual emails to users"}
@Param {value:"Email adress and corresponding Mail body"}
@Param {value:"Access token for Gmail"}
public function sendUserEmail(json mailDetails, string token){
    int count=0;
    string sender = "nalin.j@outlook.com";
    foreach user in mailDetails {
        if (count==0){
            sendMail(token,sender,"2njayworks@gmail.com","Individual E-mail", user.body.toString());
            log:printInfo("Notificatiom mail sent to "+sender);
        }
        count=count+1;
        
    }
}

@Description {value:"Send Email to PMC Group"}
@Param {value:"Email address and corresponding Email body"}
@Param {value:"Access token for Gmail"}
public function sendPMCEmail (json mailDetails, string token)  {
    sendMail(token,mailDetails.addr.toString(),"2njayworks@gmail.com","Summary E-mail-test", mailDetails.body.toString());
}

@Description {value:"Send Mail request"}
@Param {value:"Gmail Access token"}
@Param {value:"Recepient"}
@Param {value:"Sender"}
@Param {value:"Subject"}
@Param {value:"Email content"}
public function sendMail(string accessToken, string to,string from,string subject, string message){

    endpoint<http:HttpClient> httpEndpoint {
        create http:HttpClient(GOOGLE_APIS,{});
    }

    http:OutRequest request = {};
    http:InResponse response = {};
    string buildRequest = "";

    buildRequest = buildRequest + "to:" + to+ "\n";
    buildRequest = buildRequest + "subject:" + subject + "\n";
    buildRequest = buildRequest + "from:" + from + "\n";
    buildRequest = buildRequest + "content-type:" + "text/html;charset=iso-8859-1" + "\n";
    buildRequest = buildRequest + "\n" + message + "\n";

    string encodedRequest = util:base64Encode(buildRequest);
    encodedRequest=encodedRequest.replace("+", "-");
    encodedRequest=encodedRequest.replace("/", "_");

    json sendMailRequest = {"raw":encodedRequest};
    string sendMailPath = "/v1/users/me/messages/send";

    request.setHeader("Authorization", "Bearer " + accessToken);
    request.setHeader("Content-Type", "application/json");
    request.setJsonPayload(sendMailRequest);
    http:HttpConnectorError er;
    response,er = httpEndpoint.post(sendMailPath, request);
    json result = response.getJsonPayload();
}