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
package samples;


import ballerina.config;
import ballerina.data.sql;
import ballerina.time;
import src;
import ballerina.log;
import ballerina.io;
import logFile;
import ballerina.runtime;

public function main (string[] args) {
    var thresholdDays, _ = <int>config:getGlobalValue("conf_threshold");
    sql:Parameter[] params = [];
    sql:Parameter param = {sqlType:sql:Type.INTEGER, value:thresholdDays};
    params = [param];
    //query cards from github
    error err;
    var allCards,err= src:getData();
    if (err!=null){
        logFile:logError(err.message,runtime:getCallStack()[1].packageName);
        return;
    }

    src:mailList[] personalMailList;
    src:projectCount[] summeryToPMC;
    sql:Parameter[][] filteredCards;
    //filter received cards according to the requirement
    filteredCards = filterCards(allCards, thresholdDays);
    //update the database from filtered cards
    error sqlError;
    sqlError=src:updateDB(filteredCards);
    if (sqlError!=null){
        logFile:logError(err.message,runtime:getCallStack()[1].packageName);
        return;
    }

    //card details of user who should acknowledge within today
    personalMailList, sqlError = src:todayMailList(params);
    if (sqlError!=null){
        logFile:logError(err.message,runtime:getCallStack()[1].packageName);
        return;
    }
    //summary of the cards which should forward to PMC group
    summeryToPMC, sqlError = src:projectSummery();
    if (sqlError != null) {
        logFile:logError(err.message,runtime:getCallStack()[1].packageName);
        return;
    }
    //create Email content using summary
    json summeryMail = src:createSummeryEmail(summeryToPMC);
    //create set of user Email bodies mapped with relevant WSO2 Email
    json individualMail = src:createUserEmail(personalMailList);

    string Token;
    error tokenError;
    //generate new access token for Gmail
    Token, tokenError = src:generateAccessToken();
    if (tokenError == null) {
        //send set of user Emails
       // src:sendUserEmail(individualMail, Token);
        //send summary Email to PMC group
        src:sendPMCEmail(summeryMail, Token);
    }
    else {
        logFile:logError("Error in Gmail access token",runtime:getCallStack()[1].packageName);
        return;
    }

}



@Description {value:"filter open project cards which have not been updated for a threshold time period"}
@Param {value:"all github project cards"}
@Param {value:"thresold time period which cards should be filtered"}
@Return {value:"filtered cards"}
function filterCards (json allCards, int threshold) (sql:Parameter[][]) {
    sql:Parameter[][] batchToUpdate = [];
    sql:Parameter[] params = [];
    sql:Parameter projectName;
    sql:Parameter columnName;
    sql:Parameter title;
    sql:Parameter createdAt;
    sql:Parameter updatedAt;
    sql:Parameter delay;
    sql:Parameter user;
    sql:Parameter cardId;
    sql:Parameter url;
    int counter = 0;
    int gap;
    boolean issueOPEN;
    foreach project in allCards {
        if (lengthof project.columns.nodes == 0) {
            next;
        }
        else {
            foreach column in project.columns.nodes {
                if (lengthof column.cards.nodes == 0 || column.name.toString() == "Done") {
                    next;
                }
                else {
                    foreach card in column.cards.nodes {
                        issueOPEN = false;
                        gap = CalculateDelay(card.updatedAt);
                        if (card.content == null || card.content.toString() == "{}") {
                            issueOPEN = false;
                        }
                        else if (card.content.state.toString() == "OPEN") {
                            issueOPEN = true;
                        }
                        if (gap >= threshold && issueOPEN) {
                            params = [];
                            projectName = {sqlType:sql:Type.VARCHAR, value:project.name};
                            columnName = {sqlType:sql:Type.VARCHAR, value:column.name};
                            title = {sqlType:sql:Type.VARCHAR, value:card.content.title.toString().replace("\"", "'").replace("%", "/100")};
                            createdAt = {sqlType:sql:Type.VARCHAR, value:formatDate(card.createdAt)};
                            updatedAt = {sqlType:sql:Type.VARCHAR, value:formatDate(card.updatedAt)};
                            delay = {sqlType:sql:Type.INTEGER, value:gap};
                            user = {sqlType:sql:Type.VARCHAR, value:card.creator.login};
                            cardId = {sqlType:sql:Type.VARCHAR, value:card.id};
                            url = {sqlType:sql:Type.VARCHAR, value:card.content.url};
                            params = [projectName, columnName, title, createdAt, updatedAt, delay, user, cardId, url];
                            batchToUpdate[counter] = params;
                            counter = counter + 1;
                        }
                    }
                }
            }
        }
    }
    return batchToUpdate;
}

@Description {value:"change the format of date"}
@Param {value:"input date fromat"}
@Return {value:"'Date: yyyy:mm:dd' format"}
function formatDate (json inputFormat) (string) {
    int day;
    int month;
    int year;
    time:Time created = time:parse(inputFormat.toString(), "yyyy-MM-dd'T'HH:mm:ss'Z'");
    year, month, day = created.getDate();
    return ("Date: " + year + ":" + month + ":" + day);
}

@Description {value:"calculate number of days from input date to today"}
@Param {value:"date"}
@Return {value:"number of days passed"}
public function CalculateDelay (json date) (int) {
    time:Time currentTime = time:currentTime();
    time:Time lastUpdate = time:parse(date.toString(), "yyyy-MM-dd'T'HH:mm:ss'Z'");
    int currentYear = currentTime.year();
    int currentMonth = currentTime.month();
    int currentDay = currentTime.day();
    int updatedYear = lastUpdate.year();
    int updatedMonth = lastUpdate.month();
    int updatedDay = lastUpdate.day();

    currentMonth = (currentMonth + 9) % 12;
    currentYear = currentYear - currentMonth / 10;

    updatedMonth = (updatedMonth + 9) % 12;
    updatedYear = updatedYear - updatedMonth / 10;

    int currentCount = (365 * currentYear + currentYear / 4 - currentYear / 100 + currentYear / 400 + (currentMonth * 306 + 5) / 10 + (currentDay - 1));
    int updatedCount = (365 * updatedYear + updatedYear / 4 - updatedYear / 100 + updatedYear / 400 + (updatedMonth * 306 + 5) / 10 + (updatedDay - 1));
    return (currentCount - updatedCount);
}

