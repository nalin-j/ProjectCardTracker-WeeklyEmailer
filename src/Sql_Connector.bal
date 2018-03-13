package src;

import ballerina.data.sql;
import ballerina.log;
import ballerina.config;
import ballerina.io;

struct MailList{
    string USER;
    string TASK;
    int DELAY;
    string URL;
    string CREATED;
    string UPDATED;
    string PROJECT;
}


@Description {value:"Update database with filtered cards"}
@Param {value:"filtered project card details"}
public function updateDB(sql:Parameter[][] batch){
    endpoint<sql:ClientConnector> projectCardsDB {
        create sql:ClientConnector(sql:DB.MYSQL, config:getGlobalValue("Conf_SqlServer"),
                                   PORT, CERTIFICATE_CHECK, config:getGlobalValue("Conf_sqlUser"),
                                   config:getGlobalValue("Conf_SqlPassword"), {maximumPoolSize:POOL_SIZE });
    }
    int retFlag;
    int[] retFlagArr;
    table dt = projectCardsDB.select(CHECK_FILTEREDCARDS, null, null);
    var check,_ = <json>dt;
    if(check.toString()=="[]"){
        retFlag = projectCardsDB.update(CREATE_FILTEREDCARDS, null);
        log:printInfo("Created filteredCards table in projectCardsDB");
    }
    else {
        retFlag = projectCardsDB.update(DELETE_FILTEREDCARDS,null);
    }

    retFlagArr = projectCardsDB.batchUpdate(UPDATE_FILTEREDCARDS, batch);
    log:printInfo("Updated filteredCards table in projectCardsDB");
    projectCardsDB.close();

}

@Description {value:"query details of the cards which should be notified with in today"}
@Param {value:"Threshold delay"}
@Return {value:"card details"}
public function todayMailList(sql:Parameter[] threshold)(json){
    endpoint<sql:ClientConnector> projectCardsDB {
        create sql:ClientConnector(sql:DB.MYSQL, config:getGlobalValue("Conf_SqlServer"),
                                   PORT, CERTIFICATE_CHECK, config:getGlobalValue("Conf_sqlUser"),
                                   config:getGlobalValue("Conf_SqlPassword"), {maximumPoolSize:POOL_SIZE });
    }
    table dataTable = projectCardsDB.select(QUERY_TODAY, threshold, typeof MailList);
    var jsonRes, _ = <json>dataTable;
    return jsonRes;
}

@Description {value:"query all the project card details for PMC Email"}
@Return {value:"all project card details which are not updated recently"}
public function allCardList()(json){
    endpoint<sql:ClientConnector> projectCardsDB {
        create sql:ClientConnector(sql:DB.MYSQL, config:getGlobalValue("Conf_SqlServer"),
                                   PORT, CERTIFICATE_CHECK, config:getGlobalValue("Conf_sqlUser"),
                                   config:getGlobalValue("Conf_SqlPassword"), {maximumPoolSize:POOL_SIZE });
    }
    table dataTable = projectCardsDB.select(QUERY_LIST, null, typeof MailList);
    var jsonRes, _ = <json>dataTable;
    return jsonRes;
}

@Description {value:"query all the project card details for Dashboard"}
@Return {value:"all project card details which are not updated recently"}
public function dataToDashboard()(json){
    endpoint<sql:ClientConnector> projectCardsDB {
        create sql:ClientConnector(sql:DB.MYSQL, config:getGlobalValue("Conf_SqlServer"),
                                   PORT, CERTIFICATE_CHECK, config:getGlobalValue("Conf_sqlUser"),
                                   config:getGlobalValue("Conf_SqlPassword"), {maximumPoolSize:POOL_SIZE });
    }
    table dt = projectCardsDB.select(QUERY_DASHBOARD, null, null);
    var jsonRes, _ = <json>dt;
    return jsonRes;
}

public function mapEmailAddress (sql:Parameter[] githubID) (json ) {
    endpoint<sql:ClientConnector> projectCardsDB {
        create sql:ClientConnector(sql:DB.MYSQL, config:getGlobalValue("Conf_SqlServer"),
                                   PORT, CERTIFICATE_CHECK, config:getGlobalValue("Conf_sqlUser"),
                                   config:getGlobalValue("Conf_SqlPassword"), {maximumPoolSize:POOL_SIZE });
    }
    table dt = projectCardsDB.select("SELECT WSO2MAIL FROM mailTable WHERE GITID = ?", githubID, null);
    var jsonRes, _ = <json>dt;
    return jsonRes;
}