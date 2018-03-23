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
import ballerina.time;
import ballerina.log;
import ballerina.config;
import ballerina.io;
import ballerina.file;

@Description {value:"Map Email address and body requared for Individual Emails"}
@Param {value:"project card details"}
@Return {value:"Email address and Email body"}
public function createUserEmail (mailList[] users) (json) {
    json returnList = [];
    int userCounter = 0;
    foreach user in users {
        sql:Parameter[] params = [];
        sql:Parameter param = {sqlType:sql:Type.VARCHAR, value:user.USER};
        params = [param];
        companyMail mapped = null;
        error sqlError = {message:null};
        mapped, sqlError = mapEmailAddress(params);
        if (mapped == null) {
            log:printError("No WSO2 Email address found for user : " + user.USER);
            next;
        }
        else {
            string task;
            if (user.TASK == null) {
                task = null;
            }
            else {
                task = user.TASK;
            }
            returnList[userCounter] = {addr:mapped.WSO2MAIL, body:individualMailBody(user)};//"hi "+user.USER.toString()+"!  this is to notify your project card :" +task+ ",
            userCounter = userCounter + 1;
        }
    }
    return (returnList);
}

@Description {value:"Design the mail content required for the user Email"}
@Param {value:"project card details"}
@Return {value:"HTML body as a string"}
public function individualMailBody (mailList user) (string) {
    string Body;
    string project = user.PROJECT;
    string task = user.TASK;
    string creator = user.USER;
    string created = user.CREATED;
    string updated = user.UPDATED;
    string url = user.URL;
    int delay = user.DELAY;
    Body = "<div class=\"email-container\" style=\"max-width: 680px; margin: auto;\">" +
           "<table class=\"email-container\" style=\"max-width: 680px;\" role=\"presentation\" border=\"0\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\"><!-- HEADER : BEGIN -->" +
           "<tbody>" +
           "<tr style=\"height: 110px;\">" +
           "<td style=\"height: 110px;\" bgcolor=\"#ff\">" +
           "<table role=\"presentation\" border=\"0\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\">" +
           "<tbody>" +
           "<tr>" +
           "<td style=\"padding: 20px 40px 20px 40px; text-align: center;\"><img style=\"height: auto; font-family: sans-serif; font-size: 15px; line-height: 20px; color: #555555;\" src=\"http://digit.lk/wp-content/uploads/2013/07/wso2.jpg\" alt=\"alt_text\" width=\"150\" height=\"13\" border=\"0\" />" +
           "<h1 style=\"margin: 0; font-family: 'Montserrat', sans-serif; font-size: 30px; line-height: 36px; color: #ffffff; font-weight: bold;\">GitHub Project Card Tracker</h1>" +
           "</td>" +
           "</tr>" +
           "</tbody>" +
           "</table>" +
           "</td>" +
           "</tr>" +
           "<tr style=\"height: 77px;\">" +
           "<td style=\"text-align: center; background-position: center center !important; background-size: cover !important; height: 77px;\" align=\"center\" valign=\"top\" bgcolor=\"#333333\"><!-- [if gte mso 9]>" +
           "<v:rect xmlns:v=\"urn:schemas-microsoft-com:vml\" fill=\"true\" stroke=\"false\" style=\"width:680px; height:380px; background-position: center center !important;\">" +
           "<v:fill type=\"tile\" src=\"background.png\" color=\"#222222\" />" +
           "<v:textbox inset=\"0,0,0,0\">" +
           "<![endif]-->" +
           "<div><!-- [if mso]>" +
           "<table role=\"presentation\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\" width=\"500\">" +
           "<tr>" +
           "<td align=\"center\" valign=\"middle\" width=\"500\">" +
           "<![endif]-->" +
           "<table style=\"max-width: 500px; margin: auto; height: 398px; width: 92.457%;\" role=\"presentation\" border=\"0\" width=\"466\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\">" +
           "<tbody>" +
           "<tr>" +
           "<td style=\"height: 249.6px;\" align=\"center\" valign=\"middle\">" +
           "<table style=\"height: 97px;\" width=\"500\">" +
           "<tbody>" +
           "<tr>" +
           "<td style=\"text-align: center; padding: 0px; height: 13px; width: 499px;\" valign=\"top\"><img style=\"height: auto; font-family: sans-serif; font-size: 15px; line-height: 20px; color: #555555;\" src=\"https://tctechcrunch2011.files.wordpress.com/2010/07/github-logo.png?w=400\" alt=\"alt_text\" width=\"150\" height=\"13\" border=\"0\" /></td>" +
           "</tr>" +
           "<tr>" +
           "<td style=\"text-align: center; padding: 10px 20px 0px; font-family: sans-serif; font-size: 15px; line-height: 20px; color: #757575; height: 66px; width: 499px;\" valign=\"top\">" +
           "<p style=\"margin: 0;\">This is to notify your following project card has not been updated recently. Please look forward for the issue</p>" +
           "</td>" +
           "</tr>" +
           "<tr style=\"height: 28px;\">" +
           "<td style=\"margin: 0px; font-family: 'Montserrat', sans-serif; font-size: 25px; line-height: 36px; color: #ffffff; font-weight: bold; text-align: center; height: 28px; width: 499px;\">" + task + "</td>" +
           "</tr>" +
           "<tr style=\"height: 28px;\">" +
           "<td style=\"margin: 0px; font-family: 'Montserrat', sans-serif; font-size: 25px; line-height: 36px; color: #ffffff; text-align: center; height: 28px; width: 499px;\">DELAY : " + delay + " Days</td>" +
           "</tr>" +
           "<tr>" +
           "<td style=\"text-align: center; padding: 0px 60px; height: 43.7px; width: 499px;\" align=\"center\" valign=\"top\"><!-- Button : BEGIN --><center>" +
           "<table class=\"center-on-narrow\" style=\"text-align: center;\" role=\"presentation\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\">" +
           "<tbody>" +
           "<tr>" +
           "<td class=\"button-td\" style=\"border-radius: 50px; background: #26a4d3; text-align: center;\"><a class=\"button-a\" style=\"background: #26a4d3; border: 15px solid #26a4d3; font-family: 'Montserrat', sans-serif; font-size: 14px; line-height: 1.1; text-align: center; text-decoration: none; display: block; border-radius: 50px; font-weight: bold;\" href=\"" + url + "\"> <span class=\"button-link\" style=\"color: #ffffff;\">&nbsp;&nbsp;&nbsp;&nbsp;GO TO PROJECT CARD&nbsp;&nbsp;&nbsp;&nbsp;</span> </a></td>" +
           "</tr>" +
           "</tbody>" +
           "</table>" +
           "</center><!-- Button : END --></td>" +
           "</tr>" +
           "<tr style=\"height: 28px;\">" +
           "<td style=\"margin: 0px;\">&nbsp;</td>" +
           "</tr>" +
           "</tbody>" +
           "</table>" +
           "</td>" +
           "</tr>" +
           "</tbody>" +
           "</table>" +
           "</div>" +
           "</td>" +
           "</tr>" +
           "<!-- HERO : END --> <!-- INTRO : BEGIN -->" +
           "<tr>" +
           "<td style= bgcolor=\"#ffffff\">" +
           "<table style=\"height: 45px;\" role=\"presentation\" border=\"0\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\">" +
           "<tbody>" +
           "<tr style=\"height: px;\">" +
           "<td style=\"padding: 0px 40px; text-align: left; height: 10px; width: 100%;\">" +
           "<h1 style=\"margin: 0; font-family: 'Montserrat', sans-serif; font-size: 20px; line-height: 26px; color: #333333; font-weight: bold; text-align: center;\">Project Card Details</h1>" +
           "</td>" +
           "</tr>" +
           "<tr>" +
           "<td>" +
           "<table style=\"width: 676px;\" width=\"640\">" +
           "<tbody>" +
           "<tr>" +
           "<td style=\"padding: 0px 30px; text-align: left; width: 138px; font-size: 18px; border: 1px solid black;\">Project</td>" +
           "<td style=\"padding: 0px 30px; width: 540px; font-size: 18px; border: 1px solid black;\">" + project + "</td>" +
           "</tr>" +
           "<tr>" +
           "<td style=\"padding: 0px 30px; text-align: left; width: 138px; font-size: 18px; border: 1px solid black;\">Creator</td>" +
           "<td style=\"padding: 0px 30px; width: 540px; font-size: 18px; border: 1px solid black;\">" + creator + "</td>" +
           "</tr>" +
           "<tr>" +
           "<td style=\"padding: 0px 30px; text-align: left; width: 138px; font-size: 18px; border: 1px solid black;\">Created</td>" +
           "<td style=\"padding: 0px 30px; width: 540px; font-size: 18px; border: 1px solid black;\">" + created + "</td>" +
           "</tr>" +
           "<tr>" +
           "<td style=\"padding: 0px 30px; text-align: left; width: 138px; font-size: 18px; border: 1px solid black;\">Updated</td>" +
           "<td style=\"padding: 0px 30px; width: 540px; font-size: 18px; border: 1px solid black;\">" + updated + "</td>" +
           "</tr>" +
           "</tbody>" +
           "</table>" +
           "</td>" +
           "</tr>" +
           "</tbody>" +
           "</table>" +
           "</td>" +
           "</tr>" +
           "<!-- INTRO : END --> <!-- CTA : BEGIN -->" +
           "<tr style=\"height: 87px;\">" +
           "<td style=\"height: 87px;\" bgcolor=\"#26a4d3\">" +
           "<table style=\"height: 71px;\" role=\"presentation\" border=\"0\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\">" +
           "<tbody>" +
           "<tr style=\"height: 50px;\">" +
           "<td style=\"padding: 0px 0px 0px; font-family: sans-serif; font-size: 17px; line-height: 23px; color: #aad4ea; text-align: center; font-weight: normal; height: px;\">" +
           "<p style=\"margin: 0;\">&nbsp;</p>" +
           "<p style=\"margin: 0;\">This is an Auto Generated E-mail</p>" +
           "<p style=\"margin: 0;\">WSO2 Lanka (Pvt) Ltd</p>" +
           "</td>" +
           "</tr>" +
           "<tr style=\"height: 10px;\">" +
           "<td style=\"text-align: center; padding: 0px 20px 40px; height: 10px;\" align=\"center\" valign=\"middle\"><!-- Button : BEGIN --> <!-- Button : END --></td>" +
           "</tr>" +
           "</tbody>" +
           "</table>" +
           "</td>" +
           "</tr>" +
           "<!-- CTA : END --> <!-- SOCIAL : BEGIN --></tbody>" +
           "</table>" +
           "</div>";

    return (Body);

}



public function createSummeryEmail (projectCount[] projectList) (json) {
    int counter = 1;
    int totalCards = 0;
    string colour;
    time:Time time = time:currentTime();
    int year = time.year();
    int month = time.month();
    int day = time.day();
    string date = year + ":" + month + ":" + day;
    string body = "<html>" +
                  "<head>" +
                  "<title></title>" +
                  "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />" +
                  "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">" +
                  "<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\" />" +
                  "<style type=\"text/css\">" +
                  "/* CLIENT-SPECIFIC STYLES */" +
                  "body, table, td, a { -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; }" +
                  "table, td { mso-table-lspace: 0pt; mso-table-rspace: 0pt; }" +
                  "img { -ms-interpolation-mode: bicubic; }" +
                  "/* RESET STYLES */" +
                  "img { border: 0; height: auto; line-height: 100%; outline: none; text-decoration: none; }" +
                  "table { border-collapse: collapse !important; }" +
                  "body { height: 100% !important; margin: 0 !important; padding: 0 !important; width: 100% !important; }" +
                  "/* iOS BLUE LINKS */" +
                  "a[x-apple-data-detectors] {" +
                  "    color: inherit !important;" +
                  "    text-decoration: none !important;" +
                  "    font-size: inherit !important;" +
                  "    font-family: inherit !important;" +
                  "    font-weight: inherit !important;" +
                  "    line-height: inherit !important;" +
                  "}" +
                  "/* MEDIA QUERIES */" +
                  "@media screen and (max-width: 480px) {" +
                  "    .mobile-hide {" +
                  "        display: none !important;" +
                  "    }" +
                  "    .mobile-center {" +
                  "        text-align: center !important;" +
                  "    }" +
                  "}" +
                  "/* ANDROID CENTER FIX */" +
                  "div[style*=\"margin: 16px 0;\"] { margin: 0 !important; }" +
                  "</style>" +
                  "<body style=\"margin: 0 !important; padding: 0 !important; background-color: #eeeeee;\" bgcolor=\"#eeeeee\">" +
                  "<!-- HIDDEN PREHEADER TEXT -->" +
                  "<div style=\"display: none; font-size: 1px; color: #fefefe; line-height: 1px; font-family: Open Sans, Helvetica, Arial, sans-serif; max-height: 0px; max-width: 0px; opacity: 0; overflow: hidden;\">" +
                  "</div>" +
                  "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">" +
                  "    <tr>" +
                  "        <td align=\"center\" style=\"background-color: #eeeeee;\" bgcolor=\"#eeeeee\">" +
                  "        <!--[if (gte mso 9)|(IE)]>" +
                  "        <table align=\"center\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"600\">" +
                  "        <tr>" +
                  "        <td align=\"center\" valign=\"top\" width=\"600\">" +
                  "        <![endif]-->" +
                  "        <table align=\"center\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">" +
                  "            <tr>" +
                  "                <td align=\"center\" valign=\"top\" style=\"font-size:0; padding: 35px;\" bgcolor=\"#044767\">" +
                  "                <!--[if (gte mso 9)|(IE)]>" +
                  "                <table align=\"center\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"600\">" +
                  "                <tr>" +
                  "                <td align=\"left\" valign=\"top\" width=\"300\">" +
                  "                <![endif]-->" +
                  "                <div style=\"display:inline-block; max-width:50%; min-width:100px; vertical-align:top; width:100%;\">" +
                  "                    <table align=\"left\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">" +
                  "                        <tr>" +
                  "                            <td align=\"left\" valign=\"top\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 36px; font-weight: 800; line-height: 48px;\" class=\"mobile-center\">" +
                  "                                <h1 style=\"font-size: 36px; font-weight: 800; margin: 0; color: #ffffff;\">GitHub Project Card Tracker</h1>" +
                  "                            </td>" +
                  "                        </tr>" +
                  "                    </table>" +
                  "                </div>" +
                  "                <!--[if (gte mso 9)|(IE)]>" +
                  "                </td>" +
                  "                <td align=\"right\" width=\"300\">" +
                  "                <![endif]-->" +
                  "                <div style=\"display:inline-block; max-width:50%; min-width:100px; vertical-align:top; width:100%;\" class=\"mobile-hide\">" +
                  "                    <table align=\"right\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"max-width:30px;\">" +
                  "                        <tr>" +
                  "                            <td valign=\"top\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 48px; font-weight: 400; line-height: 48px;\">" +
                  "                                 <a target=\"_blank\" style=\"color: #ffffff; text-decoration: none;\"><img src=\"https://cdn-images-1.medium.com/max/1600/1*Hp_mwS4K0msofoCyc0m33g.png\" width=\"140\" style=\"display: block; border: 0px;\"/></a>" +
                  "                            </td>" +
                  "                        </tr>" +
                  "                    </table>" +
                  "                </div>" +
                  "                <!--[if (gte mso 9)|(IE)]>" +
                  "                </td>" +
                  "                </tr>" +
                  "                </table>" +
                  "                <![endif]-->" +
                  "                </td>" +
                  "            </tr>" +
                  "            <tr>" +
                  "                <td align=\"center\" style=\"padding: 35px 35px 20px 35px; background-color: #ffffff;\" bgcolor=\"#ffffff\">" +
                  "                <!--[if (gte mso 9)|(IE)]>" +
                  "                <table align=\"center\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"600\">" +
                  "                <tr>" +
                  "                <td align=\"center\" valign=\"top\" width=\"600\">" +
                  "                <![endif]-->" +
                  "                <table align=\"center\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"60%\" style=\"max-width:100%;\">" +
                  "                    <tr>" +
                  "                        <td align=\"center\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 16px; font-weight: 400; line-height: 24px; padding-top: 25px;\">" +
                  "                            " +
                  "                            <h2 style=\"font-size: 30px; font-weight: 800; line-height: 36px; color: #333333; margin: 0;\">" +
                  "                                GitHub Project Card Summary" +
                  "                            <h1 style=\"font-size: 20px; font-weight: 200; line-height: 20px; color: #333333; margin: 0;\">" +
                  date +
                  "                            <h1 style=\"font-size: 20px; font-weight: 200; line-height: 20px; color: #999999; margin: 10;\">" +
                  "                                Threshold : " + config:getGlobalValue("conf_threshold") +
                  "                    </tr>" +
                  "                    <tr>" +
                  "                        <td align=\"left\" style=\"padding-top: 20px;\">" +
                  "			" +
                  "                            <table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" margin-left=\"100px\" align=\"center\" >" +
                  "                                <tr>" +
                  "                                    " +
                  "                                    <td  width=\"20%\"align=\"left\" bgcolor=\"#cccccc\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 16px; font-weight: 800; line-height: 24px; padding: 10px;\">" +
                  "                                        Project" +
                  "                                    </td>" +
                  "									<td width=\"15%\"align=\"left\" bgcolor=\"#cccccc\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 16px; font-weight: 800; line-height: 24px; padding: 10px;\">" +
                  "                                        Number of non moving cards" +
                  "                                    </td>" +
                  "									<td  width=\"10%\"align=\"center\" bgcolor=\"#cccccc\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 16px; font-weight: 800; line-height: 24px; padding: 10px;\">" +
                  "                                        Go to Dashboard" +
                  "                                    </td>" +
                  "									" +
                  "                                </tr>";
    foreach project in projectList {
        int numberOfCards = project.COUNT;
        totalCards = totalCards + numberOfCards;
        if (counter % 2 == 0) {
            colour = "#eeeeee";
        }
        else {
            colour = "#ffffff";
        }

        body = body + "                                <tr>" +
               "                                    <td width=\"20%\" align=\"left\" bgcolor=\"" + colour + "\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 16px; font-weight: 600; line-height: 24px; padding: 5px 10px 5px 10px;\">" +
               project.PROJECT +
               "                                    </td>" +
               "                                    <td width=\"15%\" align=\"left\" bgcolor=\"" + colour + "\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 16px; font-weight: 600; line-height: 24px; padding: 5px 10px 5px 10px;\">" +
               numberOfCards +
               "                                    </td>" +
               "									<td width=\"10%\" align=\"center\" bgcolor=\"" + colour + "\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 16px; font-weight: 400; line-height: 24px; padding: 5px 10px 5px 10px;\"><!-- Button : BEGIN --><center>" +
               "<table role=\"presentation\" class=\"center-on-narrow\" style=\"text-align: center;\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" align=\"center\">" +
               "<tbody>" +
               "<tr>" +
               "<td style=\"border-radius: 10px; background: #26a4d3; text-align: center;\" class=\"button-td\"><a href=\"" + DASHBOARD_URL + "?project=" + project.PROJECT + "\" style=\"background: #26a4d3; border: 10px solid #26a4d3; font-family: 'Montserrat', sans-serif; font-size: 14px; line-height: 1.1; text-align: center; text-decoration: none; display: block; border-radius: 50px; font-weight: bold;\" class=\"button-a\"> <span style=\"color: #ffffff;\" class=\"button-link\">&nbsp;&nbsp;&nbsp;&nbsp;More Info..&nbsp;&nbsp;&nbsp;&nbsp;</span> </a></td>" +
               "</tr>" +
               "</tbody>" +
               "</table>" +
               "										</center><!-- Button : END --></td>" +
               "                                </tr>";
        counter = counter + 1;
    }
    body = body + "                                <tr>" +
           "                                    <td width=\"20%\" align=\"left\" bgcolor=\"#cccccc\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 16px; font-weight: 600; line-height: 24px; padding: 5px 10px 5px 10px;\">" +
           "Total Number of Non Moving Cards" +
           "                                    </td>" +
           "                                    <td width=\"15%\" align=\"left\" bgcolor=\"#cccccc\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 16px; font-weight: 600; line-height: 24px; padding: 5px 10px 5px 10px;\">" +
           totalCards +
           "                                    </td>" +
           "									<td width=\"10%\" align=\"center\" bgcolor=\"#cccccc\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 16px; font-weight: 400; line-height: 24px; padding: 5px 10px 5px 10px;\"><!-- Button : BEGIN --><center>" +
           "<table role=\"presentation\" class=\"center-on-narrow\" style=\"text-align: center;\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" align=\"center\">" +
           "<tbody>" +
           "<tr>" +
           "<td style=\"border-radius: 10px; background: #26a4d3; text-align: center;\" class=\"button-td\"><a href=\"" + DASHBOARD_URL + "\" style=\"background: #26a4d3; border: 10px solid #26a4d3; font-family: 'Montserrat', sans-serif; font-size: 14px; line-height: 1.1; text-align: center; text-decoration: none; display: block; border-radius: 50px; font-weight: bold;\" class=\"button-a\"> <span style=\"color: #ffffff;\" class=\"button-link\">&nbsp;&nbsp;&nbsp;&nbsp;DashBoard&nbsp;&nbsp;&nbsp;&nbsp;</span> </a></td>" +
           "</tr>" +
           "</tbody>" +
           "</table>" +
           "										</center><!-- Button : END --></td>" +
           "                                </tr>";
    body = body + "                                " +
           "                            </table>" +
           "                        </td>" +
           "                    </tr>" +
           "                   " +
           "                </table>" +
           "                <!--[if (gte mso 9)|(IE)]>" +
           "                </td>" +
           "                </tr>" +
           "                </table>" +
           "                <![endif]-->" +
           "                </td>" +
           "            </tr>" +
           "             <tr>" +
           "                <td align=\"center\" height=\"100%\" valign=\"top\" width=\"100%\" style=\"padding: 0 35px 35px 35px; background-color: #ffffff;\" bgcolor=\"#ffffff\">" +
           "                </td>" +
           "            </tr>" +
           "            <tr>" +
           "                <td align=\"center\" style=\" padding: 35px; background-color: #1b9ba3;\" bgcolor=\"#1b9ba3\">" +
           "                <!--[if (gte mso 9)|(IE)]>" +
           "                <table align=\"center\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"600\">" +
           "                <tr>" +
           "                <td align=\"center\" valign=\"top\" width=\"600\">" +
           "                <![endif]-->" +
           "                <table align=\"center\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"max-width:600px;\">" +
           "                    <tr>" +
           "                        <td align=\"center\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 16px; font-weight: 400; line-height: 24px; padding-top: 25px;\">" +
           "                            <h2 style=\"font-size: 24px; font-weight: 800; line-height: 30px; color: #ffffff; margin: 0;\">" +
           "                                All the above GitHub project cards have not been updated recently." +
           "                            </h2>" +
           "                        </td>" +
           "                    </tr>" +
           "                    " +
           "                </table>" +
           "                <!--[if (gte mso 9)|(IE)]>" +
           "                </td>" +
           "                </tr>" +
           "                </table>" +
           "                <![endif]-->" +
           "                </td>" +
           "            </tr>" +
           "        </table>" +
           "        <!--[if (gte mso 9)|(IE)]>" +
           "        </td>" +
           "        </tr>" +
           "        </table>" +
           "        <![endif]-->" +
           "        </td>" +
           "    </tr>" +
           "</table>" +
           "    " +
           "</body>" +
           "</html>";
    json mail = {addr:"nalin.j@outlook.com", body:body};
    return (mail);
}


function readFile ()(string){
    file:File src = {path:"/home/njay/Desktop/summeryEmail.html"};
    io:ByteChannel channel = src.openChannel("r");
    var characterChannel,_ = channel.readAllBytes();
    return characterChannel.toString("UTF-8");
}




