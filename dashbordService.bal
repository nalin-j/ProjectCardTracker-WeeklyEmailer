
import ballerina.net.http;
import ballerina.config;
import src;



service<http> githubProjectCardTracker {

    @Description {value:"set all the data required for dashboard table"}
    resource dashboard (http:Connection conn, http:InRequest req) {
        http:OutResponse res = {};
        json dataToUI=src:dataToDashboard();
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