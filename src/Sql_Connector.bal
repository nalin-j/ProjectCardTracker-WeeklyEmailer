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

import ballerina.data.sql;
import ballerina.log;
import ballerina.config;
import ballerina.io;


public struct mailList {
    string USER;
    string TASK;
    int DELAY;
    string URL;
    string CREATED;
    string UPDATED;
    string PROJECT;
}
public struct projectCount {
    string PROJECT;
    int COUNT;
}
struct companyMail {
    string WSO2MAIL;
}


@Description {value:"Update database with filtered cards"}
@Param {value:"filtered project card details"}
public function updateDB (sql:Parameter[][] batch)(error) {
    endpoint<sql:ClientConnector> projectCardsDB {
        create sql:ClientConnector(sql:DB.MYSQL, config:getGlobalValue("Conf_SqlServer"),
                                   PORT, CERTIFICATE_CHECK, config:getGlobalValue("Conf_sqlUser"),
                                   config:getGlobalValue("Conf_SqlPassword"), {maximumPoolSize:POOL_SIZE});
    }
    int retFlag;
    int[] retFlagArr;
    error conversionError = null;
    try{
        table dt = projectCardsDB.select(CHECK_FILTEREDCARDS, null, null);
        var check, conversionError = <json>dt;
        if (conversionError != null) {
            projectCardsDB.close();
            return conversionError;
        }
        if (check.toString() == "[]") {
            retFlag = projectCardsDB.update(CREATE_FILTEREDCARDS, null);
            log:printInfo("Created filteredCards table in projectCardsDB");
        }
        else {
            retFlag = projectCardsDB.update(DELETE_FILTEREDCARDS, null);
        }

        retFlagArr = projectCardsDB.batchUpdate(UPDATE_FILTEREDCARDS, batch);
        log:printInfo("Updated filteredCards table in projectCardsDB");
    }
    catch(error e){
        projectCardsDB.close();
        return e;
    }
    finally{
        projectCardsDB.close();
    }
    return conversionError;
}

@Description {value:"query details of the cards which should be notified with in today"}
@Param {value:"Threshold delay"}
@Return {value:"card details"}
public function todayMailList (sql:Parameter[] threshold) (mailList[], error) {
    endpoint<sql:ClientConnector> projectCardsDB {
        create sql:ClientConnector(sql:DB.MYSQL, config:getGlobalValue("Conf_SqlServer"),
                                   PORT, CERTIFICATE_CHECK, config:getGlobalValue("Conf_sqlUser"),
                                   config:getGlobalValue("Conf_SqlPassword"), {maximumPoolSize:POOL_SIZE});
    }
    mailList[] outRes = [];
    error conversionError = null;
    try {
        table dataTable = projectCardsDB.select(QUERY_TODAY, threshold, typeof mailList);
        var jsonRes, conversionError = <json>dataTable;
        if (conversionError != null) {
            projectCardsDB.close();
            return null, conversionError;
        }
        int counter = 0;
        foreach card in jsonRes {
            var structRes, conversionError = <mailList>card;
            if (conversionError != null) {
                projectCardsDB.close();
                return null, conversionError;
            }
            outRes[counter] = structRes;
            counter = counter + 1;
        }
    }
    catch (error e) {
        return null, e;
    }
    finally {
        projectCardsDB.close();
    }
    return outRes, conversionError;
}

public function projectSummery () (projectCount[], error) {
    endpoint<sql:ClientConnector> projectCardsDB {
        create sql:ClientConnector(sql:DB.MYSQL, config:getGlobalValue("Conf_SqlServer"),
                                   PORT, CERTIFICATE_CHECK, config:getGlobalValue("Conf_sqlUser"),
                                   config:getGlobalValue("Conf_SqlPassword"), {maximumPoolSize:POOL_SIZE});
    }
    projectCount[] outRes = [];
    error conversionError = null;
    try {
        table dataTable = projectCardsDB.select(QUERY_SUMMARY, null, null);
        var jsonRes, conversionError = <json>dataTable;
        int counter = 0;

        foreach project in jsonRes {
            var structRes, conversionError = <projectCount>project;
            if (conversionError != null) {
                projectCardsDB.close();
                return null, conversionError;

            }
            outRes[counter] = structRes;
            counter = counter + 1;
        }
    }
    catch (error e) {
        return null, e;
    }
    finally {
        projectCardsDB.close();
    }
    return outRes, conversionError;
}

@Description {value:"query all the project card details for Dashboard"}
@Return {value:"all project card details which are not updated recently"}
public function dataToDashboard () (json, error) {
    endpoint<sql:ClientConnector> projectCardsDB {
        create sql:ClientConnector(sql:DB.MYSQL, config:getGlobalValue("Conf_SqlServer"),
                                   PORT, CERTIFICATE_CHECK, config:getGlobalValue("Conf_sqlUser"),
                                   config:getGlobalValue("Conf_SqlPassword"), {maximumPoolSize:POOL_SIZE});
    }
    error conversionError = null;
    json jsonRes;
    try{
        table dt = projectCardsDB.select(QUERY_DASHBOARD, null, null);
        jsonRes, conversionError = <json>dt;
        if (conversionError != null) {
            projectCardsDB.close();
            return null, conversionError;

        }
        if (jsonRes[0].PROJECT != null) {
            log:printInfo("Data sent to Dashboard Sucsessfully");
        }
    }
    catch(error e){
        projectCardsDB.close();
        return null,e;
    }
    projectCardsDB.close();
    return jsonRes,conversionError;
}

public function dataToDashboardFiltered (string project) (json,error) {
    endpoint<sql:ClientConnector> projectCardsDB {
        create sql:ClientConnector(sql:DB.MYSQL, config:getGlobalValue("Conf_SqlServer"),
                                   PORT, CERTIFICATE_CHECK, config:getGlobalValue("Conf_sqlUser"),
                                   config:getGlobalValue("Conf_SqlPassword"), {maximumPoolSize:POOL_SIZE});
    }
    error conversionError = null;
    sql:Parameter[] params = [];
    sql:Parameter param = {sqlType:sql:Type.VARCHAR, value:project};
    params = [param];
    json jsonRes;
    try{
    table dt = projectCardsDB.select(QUERY_DASHBOARD_FILTERED, params, null);
    jsonRes, conversionError = <json>dt;
    if (conversionError != null) {
        projectCardsDB.close();
        return null, conversionError;

    }
        if (jsonRes[0].PROJECT != null) {
            log:printInfo("Filterd Data sent to Dashboard Sucsessfully");
        }
    }
    catch (error e) {
        conversionError=e;
    }
    projectCardsDB.close();
    return jsonRes,conversionError;
}

public function mapEmailAddress (sql:Parameter[] githubID) (companyMail, error) {
    endpoint<sql:ClientConnector> projectCardsDB {
        create sql:ClientConnector(sql:DB.MYSQL, config:getGlobalValue("Conf_SqlServer"),
                                   PORT, CERTIFICATE_CHECK, config:getGlobalValue("Conf_sqlUser"),
                                   config:getGlobalValue("Conf_SqlPassword"), {maximumPoolSize:POOL_SIZE});
    }
    companyMail outRes = null;
    error conversionError = {message:null};
    try {
        table dt = projectCardsDB.select("SELECT WSO2MAIL FROM mailTable WHERE GITID = ?", githubID, null);
        var jsonRes, conversionError = <json>dt;
        if (conversionError != null) {
            projectCardsDB.close();
            log:printError("can't convert table to json");
            conversionError = {message:"can't convert table to json"};
            return null, conversionError;
        }
        if (lengthof jsonRes != 0) {
            outRes, _ = <companyMail>jsonRes[0];
        }
    }
    catch (error e) {
        conversionError = e;
    }
    finally {
        projectCardsDB.close();
    }
    return outRes, conversionError;
}

