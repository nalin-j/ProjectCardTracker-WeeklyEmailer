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

public const string CHECK_FILTEREDCARDS = "SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='filteredCards' AND TABLE_SCHEMA='projectCardsDB'";
public const string CREATE_FILTEREDCARDS = "CREATE TABLE filteredCards(ID INT AUTO_INCREMENT,PROJECT VARCHAR(255),STATE VARCHAR(255),TASK VARCHAR(255),
                                           CREATED VARCHAR(255),UPDATED VARCHAR(255),DELAY INT,USER VARCHAR(255),CARD_ID VARCHAR(255),URL VARCHAR(255),PRIMARY KEY (ID))";
public const string DELETE_FILTEREDCARDS = "DELETE FROM filteredCards";
public const string UPDATE_FILTEREDCARDS = "INSERT INTO filteredCards (PROJECT,STATE,TASK,CREATED,UPDATED,DELAY,USER,CARD_ID,URL) VALUES (?,?,?,?,?,?,?,?,?)";
public const string QUERY_LIST = "SELECT USER,TASK,DELAY,URL,CREATED,UPDATED,PROJECT FROM filteredCards ORDER BY PROJECT ASC,DELAY DESC";
public const string QUERY_TODAY = "SELECT USER,TASK,DELAY,URL,CREATED,UPDATED,PROJECT FROM filteredCards WHERE (MOD(DELAY,?)=0)";
public const string QUERY_DASHBOARD = "SELECT PROJECT,STATE,TASK,CREATED,UPDATED,DELAY,USER,URL from filteredCards ORDER by PROJECT ASC,DELAY DESC ";
public const string QUERY_SUMMARY = "SELECT PROJECT, COUNT(*) AS COUNT FROM filteredCards GROUP BY PROJECT";
public const string QUERY_DASHBOARD_FILTERED = "SELECT PROJECT,STATE,TASK,CREATED,UPDATED,DELAY,USER,URL from filteredCards WHERE PROJECT= ? ORDER by PROJECT ASC,DELAY DESC ";