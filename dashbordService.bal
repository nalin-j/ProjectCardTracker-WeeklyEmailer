
import ballerina.net.http;
import ballerina.config;
import ballerina.io;
import src;



service<http> githubProjectCardTracker {

    @Description {value:"set all the data required for dashboard table"}
    resource dashboard (http:Connection conn, http:InRequest req) {
        http:OutResponse res = {};
        json dataToUI;
        var params = req.getQueryParams();
        var project,_ = (string)params["pRojEct"];
        if(project.length()>4 && project.subString(0,4)=="http"){
            dataToUI=src:dataToDashboard();
        }
        else{
            dataToUI=src:dataToDashboardFiltered(project);
        }

        res.addHeader("Access-Control-Allow-Origin","*");
        res.setJsonPayload(dataToUI);
        _ = conn.respond(res);
    }

    @Description {value:"set all the data required for dashboard header"}
    resource Head (http:Connection conn, http:InRequest req) {
        http:OutResponse res = {};
        var threshold,_= <int>config:getGlobalValue("conf_threshold");
        json dataHead={"count":lengthof src:dataToDashboard(),"threshold":threshold};
        res.addHeader("Access-Control-Allow-Origin","*");
        res.setJsonPayload(dataHead);
        _ = conn.respond(res);
    }

}