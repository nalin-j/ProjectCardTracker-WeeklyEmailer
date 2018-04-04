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

import ballerina.net.http;
import ballerina.config;
import src;
import ballerina.log;
import logFile;
import ballerina.runtime;


@http:configuration {port:9094}
service<http> githubProjectCardTracker {
    @Description {value:"set all the data required for dashboard table"}

    resource dashboard (http:Connection conn, http:InRequest req) {
        http:OutResponse res = {};
        var threshold, _ = <int>config:getGlobalValue("conf_threshold");
        json dataToUI;
        var params = req.getQueryParams();
        int count;
        var project, _ = (string)params["project"];
        error err;
        if (project == "null" || project == null) {

            dataToUI,err = src:dataToDashboard();
            if(err!=null){
                logFile:logError(err.message,runtime:getCallStack()[1].packageName);
                return;
            }
            count = (lengthof dataToUI);
        }
        else {
            dataToUI,err = src:dataToDashboardFiltered(project);
            count = (lengthof dataToUI);
        }
        json result = {"table":dataToUI, "count":count, "threshold":threshold};
        res.addHeader("Access-Control-Allow-Origin", "*");
        res.setJsonPayload(result);
        _ = conn.respond(res);
    }
}
