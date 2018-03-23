//
// Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
//

package src;

import ballerina.net.http;
import ballerina.config;
import ballerina.log;



@Description {value:"query project list and then cards by project id"}
@Return {value:"json object which contain all card details"}
public function getData () (json,error) {
    endpoint<http:HttpClient> httpEndpoint {
        create http:HttpClient(graphql, {});
    }

    http:OutRequest request = {};
    http:InResponse response = {};
    http:HttpConnectorError err = null;
    json functionReturn = [];
    int cardNo = 0;
    json jsonPayLoad = {query:PROJECTS};

    request.addHeader("Authorization", "Bearer " + config:getGlobalValue("Conf_Githubtoken"));
    request.setJsonPayload(jsonPayLoad);
    response, err = httpEndpoint.post("", request);
    if(err!=null){
        return null,err;
    }
    log:printInfo("POST projects request");
    json projectList = response.getJsonPayload();

    if (projectList.data == null) {
        log:printError("some thing went wrong in projects query");
    }
    else {
        foreach project in projectList.data.organization.projects.nodes {
            request = {};
            response = {};
            request.addHeader("Authorization", "Bearer " + config:getGlobalValue("Conf_Githubtoken"));
            jsonPayLoad = {query:CARDS.replace("project_number", project.number.toString())};
            request.setJsonPayload(jsonPayLoad);
            response, err = httpEndpoint.post("", request);
            if(err!=null){
                return null,err;
            }
            json projectCards = response.getJsonPayload();
            functionReturn[cardNo] = projectCards.data.organization.project;
            cardNo = cardNo + 1;
        }
    }
    return functionReturn,err;
}

