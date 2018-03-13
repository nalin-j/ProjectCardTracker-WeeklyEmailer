package src;

import ballerina.net.http;
import ballerina.config;
import ballerina.log;

@Description {value:"query project list and then cards by project id"}
@Return {value:"json object which contain all card details"}
public function getData ()(json) {
    endpoint<http:HttpClient> httpEndpoint {
        create http:HttpClient(graphql, {});
    }

    http:OutRequest request = {};
    http:InResponse response = {};
    http:HttpConnectorError err;
    json functionReturn = [];
    int cardNo = 0;
    json jsonPayLoad = {query:PROJECTS};

    request.addHeader("Authorization", "Bearer " + config:getGlobalValue("Conf_Githubtoken"));
    request.setJsonPayload(jsonPayLoad);
    response, err = httpEndpoint.post("", request);
    log:printInfo("POST projects request");
    json projectList = response.getJsonPayload();

    if(projectList.data==null){
        log:printError("some thing went wrong in projects query");
    }
    else{
        foreach project in projectList.data.organization.projects.nodes {
            request = {};
            response = {};
            request.addHeader("Authorization", "Bearer " + config:getGlobalValue("Conf_Githubtoken"));
            jsonPayLoad = {query:CARDS.replace("project_number",project.number.toString())};
            request.setJsonPayload(jsonPayLoad);
            response, err = httpEndpoint.post("", request);
            json projectCards = response.getJsonPayload();
            functionReturn[cardNo]=projectCards.data.organization.project;
            cardNo=cardNo+1;
        }
    }
    return functionReturn;
}


