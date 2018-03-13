package src;

import ballerina.data.sql;
import ballerina.time;
import ballerina.log;

@Description {value:"Map Email address and body requared for Individual Emails"}
@Param {value:"project card details"}
@Return {value:"Email address and Email body"}
public function createUserEmail(json users)(json){
    json returnList=[];
    int userCounter=0;
    foreach user in users  {
        sql:Parameter[] params = [];
        sql:Parameter param = {sqlType:sql:Type.VARCHAR, value:user.USER.toString()};
        params = [param];
        json mapped = mapEmailAddress(params);
        if(lengthof mapped==0){
            log:printError("No WSO2 Email address found for user : "+user.USER.toString());
            next;
        }
        else{
            string task;
            if (user.TASK==null){
                task = null;
            }
            else{
                task = user.TASK.toString();
            }
            returnList[userCounter]={addr:mapped[0].WSO2MAIL,body:individualMailBody(user)};//"hi "+user.USER.toString()+"!  this is to notify your project card :" +task+ ",
            userCounter=userCounter+1;
        }
    }
    return (returnList);
}

@Description {value:"Design the mail content required for the user Email"}
@Param {value:"project card details"}
@Return {value:"HTML body as a string"}
public function individualMailBody(json user)(string){
    string Body;
    string project = user.PROJECT.toString();
    string task = user.TASK.toString();
    string creator = user.USER.toString();
    string created = user.CREATED.toString();
    string updated = user.UPDATED.toString();
    string url = user.URL.toString();
    string delay = user.DELAY.toString();
    Body = "<div style=\"max-width: 680px; margin: auto;\" class=\"email-container\">" +
           "<table role=\"presentation\" style=\"max-width: 680px;\" class=\"email-container\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" align=\"center\"><!-- HEADER : BEGIN -->" +
           "<tbody>" +
           "<tr style=\"height: 10px;\">" +
           "<td style=\"height: 110px;\" bgcolor=\"#ff\">" +
           "<table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\">" +
           "<tbody>" +
           "<tr>" +
           "<td style=\"padding: 20px 40px 20px 40px; text-align: center;\"><img src=\"http://digit.lk/wp-content/uploads/2013/07/wso2.jpg\" alt=\"alt_text\" style=\"height: auto; font-family: sans-serif; font-size: 15px; line-height: 20px; color: #555555;\" width=\"150\" height=\"13\" border=\"0\" /></td>" +
           "</tr>" +
           "</tbody>" +
           "</table>" +
           "</td>" +
           "</tr>" +
           "<!-- HEADER : END --> <!-- HERO : BEGIN -->" +
           "<tr style=\"height: 329px;\"><!-- Bulletproof Background Images c/o https://backgrounds.cm -->" +
           "<td style=\"text-align: center; background-position: center center !important; background-size: cover !important; height: 200px;\" valign=\"top\" bgcolor=\"#333333\" align=\"center\"><!-- [if gte mso 9]>" +
           "                        <v:rect xmlns:v=\"urn:schemas-microsoft-com:vml\" fill=\"true\" stroke=\"false\" style=\"width:680px; height:380px; background-position: center center !important;\">" +
           "                        <v:fill type=\"tile\" src=\"background.png\" color=\"#222222\" />" +
           "                        <v:textbox inset=\"0,0,0,0\">" +
           "                        <![endif]-->" +
           "<div><!-- [if mso]>" +
           "                            <table role=\"presentation\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\" width=\"500\">" +
           "                            <tr>" +
           "                            <td align=\"center\" valign=\"middle\" width=\"500\">" +
           "                            <![endif]-->" +
           "<table role=\"presentation\" style=\"max-width: 500px; margin: auto; height: 398px; width: 92.457%;\" width=\"466\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" align=\"center\">" +
           "<tbody>" +
           "<tr style=\"height: 21px;\">" +
           "<td style=\"font-size: 20px; line-height: 20px; height: 25px;\" height=\"20\">&nbsp;</td>" +
           "</tr>" +
           "<tr style=\"height: 43px;\">" +
           "<td style=\"height: 354px;\" valign=\"middle\" align=\"center\">" +
           "<table style=\"height: 97px;\" width=\"500\">" +
           "<tbody>" +
           "<tr style=\"height: 143px;\">" +
           "<td style=\"text-align: center; padding: 0px; height: 102px; width: 499px;\" valign=\"top\">" +
           "<h1 style=\"margin: 0; font-family: 'Montserrat', sans-serif; font-size: 30px; line-height: 36px; color: #ffffff; font-weight: bold;\"></h1>" +
           "<h1 style=\"margin: 0; font-family: 'Montserrat', sans-serif; font-size: 30px; line-height: 36px; color: #ffffff; font-weight: bold;\">Github Project Card Tracker</h1> <img src=\"https://tctechcrunch2011.files.wordpress.com/2010/07/github-logo.png?w=400\" alt=\"alt_text\" style=\"height: auto; font-family: sans-serif; font-size: 15px; line-height: 20px; color: #555555;\" width=\"150\" height=\"13\" border=\"0\" />" +
           "</td>" +
           "</tr>" +
           "<tr style=\"height: 66px;\">" +
           "<td style=\"text-align: center; padding: 10px 20px 15px; font-family: sans-serif; font-size: 15px; line-height: 20px; color: #757575; height: 66px; width: 499px;\" valign=\"top\">" +
           "<p style=\"margin: 0;\">This is to notify your following project card has not updated recently. Please look forward for the issue</p>" +
           "</td>" +
           "</tr>" +
           "<tr style=\"height: 28px;\">" +
           "<td style=\"margin: 0px; font-family: 'Montserrat', sans-serif; font-size: 25px; line-height: 36px; color: #ffffff; font-weight: bold; text-align: center; height: 28px; width: 499px;\">DELAY : "+delay+" Days" +
           "<p style=\"margin: 0;\"></p>" +
           "</td>" +
           "</tr>" +
           "<tr style=\"height: 100px;\">" +
           "<td style=\"text-align: center; padding: 15px 0px 60px; height: 53px; width: 499px;\" valign=\"top\" align=\"center\"><!-- Button : BEGIN --><center>" +
           "<table role=\"presentation\" class=\"center-on-narrow\" style=\"text-align: center;\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" align=\"center\">" +
           "<tbody>" +
           "<tr>" +
           "<td style=\"border-radius: 50px; background: #26a4d3; text-align: center;\" class=\"button-td\"><a href=\""+url+"\" style=\"background: #26a4d3; border: 15px solid #26a4d3; font-family: 'Montserrat', sans-serif; font-size: 14px; line-height: 1.1; text-align: center; text-decoration: none; display: block; border-radius: 50px; font-weight: bold;\" class=\"button-a\"> <span style=\"color: #ffffff;\" class=\"button-link\">&nbsp;&nbsp;&nbsp;&nbsp;GO TO PROJECT CARD&nbsp;&nbsp;&nbsp;&nbsp;</span> </a></td>" +
           "</tr>" +
           "</tbody>" +
           "</table>" +
           "</center><!-- Button : END --></td>" +
           "</tr>" +
           "</tbody>" +
           "</table>" +
           "</td>" +
           "</tr>" +
           "<tr style=\"height: 10px;\">" +
           "<td style=\"font-size: 20px; line-height: 20px; height: 10px;\" height=\"20\">&nbsp;</td>" +
           "</tr>" +
           "</tbody>" +
           "</table>" +
           "<!-- [if mso]>" +
           "                            </td>" +
           "                            </tr>" +
           "                            </table>" +
           "                            <![endif]--></div>" +
           "<!-- [if gte mso 9]>" +
           "                        </v:textbox>" +
           "                        </v:rect>" +
           "                        <![endif]--></td>" +
           "</tr>" +
           "<!-- HERO : END --> <!-- INTRO : BEGIN -->" +
           "<tr style=\"height: 253px;\">" +
           "<td style=\"height: 237px;\" bgcolor=\"#ffffff\">" +
           "<table role=\"presentation\" style=\"height: 45px;\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\">" +
           "<tbody>" +
           "<tr style=\"height: 87px;\">" +
           "<td style=\"padding: 0px 40px; text-align: left; height: 10px; width: 100%;\">" +
           "<h1 style=\"margin: 0; font-family: 'Montserrat', sans-serif; font-size: 20px; line-height: 26px; color: #333333; font-weight: bold; text-align: center;\">Project Card Details</h1>" +
           "</td>" +
           "</tr>" +
           "<tr style=\"height: 203px;\">" +
           "<td style=\"height: 177px; width: 100%;\">" +
           "<table style=\"width: 676px;\" width=\"640\" height=\"152\">" +
           "<tbody>" +
           "<tr>" +
           "<td style=\"padding: 0px 30px; text-align: left; width: 138px; font-size: 18px; border: 1px solid black;\">Task</td>" +
           "<td style=\"padding: 0px 30px; width: 540px; font-size: 18px; border: 1px solid black;\">"+task+"</td>" +
           "</tr>" +
           "<tr>" +
           "<td style=\"padding: 0px 30px; text-align: left; width: 138px; font-size: 18px; border: 1px solid black;\">Project</td>" +
           "<td style=\"padding: 0px 30px; width: 540px; font-size: 18px; border: 1px solid black;\">"+project+"</td>" +
           "</tr>" +
           "<tr>" +
           "<td style=\"padding: 0px 30px; text-align: left; width: 138px; font-size: 18px; border: 1px solid black;\">Creator</td>" +
           "<td style=\"padding: 0px 30px; width: 540px; font-size: 18px; border: 1px solid black;\">"+creator+"</td>" +
           "</tr>" +
           "<tr>" +
           "<td style=\"padding: 0px 30px; text-align: left; width: 138px; font-size: 18px; border: 1px solid black;\">Created</td>" +
           "<td style=\"padding: 0px 30px; width: 540px; font-size: 18px; border: 1px solid black;\">"+created+"</td>" +
           "</tr>" +
           "<tr>" +
           "<td style=\"padding: 0px 30px; text-align: left; width: 138px; font-size: 18px; border: 1px solid black;\">Updated</td>" +
           "<td style=\"padding: 0px 30px; width: 540px; font-size: 18px; border: 1px solid black;\">"+updated+"</td>" +
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
           "<table role=\"presentation\" style=\"height: 71px;\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\">" +
           "<tbody>" +
           "<tr style=\"height: 50px;\">" +
           "<td style=\"padding: 0px 0px 0px; font-family: sans-serif; font-size: 17px; line-height: 23px; color: #aad4ea; text-align: center; font-weight: normal; height: px;\">" +
           "<p style=\"margin: 0;\"></p>" +
           "<p style=\"margin: 0;\">This is an Auto Generated E-mail</p>" +
           "<p style=\"margin: 0;\">WSO2 Lanka (Pvt) Ltd</p>" +
           "</td>" +
           "</tr>" +
           "<tr style=\"height: 10px;\">" +
           "<td style=\"text-align: center; padding: 0px 0px 0px; height: 10px;\" valign=\"middle\" align=\"center\"><!-- Button : BEGIN -->" +
           "<table role=\"presentation\" class=\"center-on-narrow\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" align=\"center\">" +
           "<tbody>" +
           "<tr></tr>" +
           "</tbody>" +
           "</table>" +
           "<!-- Button : END --></td>" +
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

@Description {value:"Genarate HTML content for PMC group Email"}
@Param {value:"project card details"}
@Return {value:"sender email and HTML body"}
public function pmcEmail(json groupList)(json){
    int counter=1;
    string task;
    string colour;
    time:Time time = time:currentTime();
    int year=time.year();
    int month=time.month();
    int day=time.day();
    string date="Date - " + year + ":" + month + ":" + day;
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
                  "This is a auto genarated E-mail to notify set of pending cards which are not updated more than 7 days" +
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
                  "                <td align=\"center\" valign=\"top\" style=\"font-size:0; padding: 10px;\" bgcolor=\"#044767\">" +
                  "                <!--[if (gte mso 9)|(IE)]>" +
                  "                <table align=\"center\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"600\">" +
                  "                <tr>" +
                  "                <td align=\"left\" valign=\"top\" width=\"300\">" +
                  "                <![endif]-->" +
                  "                <div style=\"display:inline-block; max-width:50%; min-width:100px; vertical-align:top; width:100%;\">" +
                  "                    <table align=\"left\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">" +
                  "                        <tr>" +
                  "                            <td align=\"left\" valign=\"top\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 36px; font-weight: 800; line-height: 48px;\" class=\"mobile-center\">" +
                  "                                <h1 style=\"font-size: 36px; font-weight: 800; margin: 0; color: #ffffff;\">Github Project Card Tracker</h1>" +
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
                  "                <table align=\"center\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"max-width:100%;\">" +
                  "                    <tr>" +
                  "                        <td align=\"center\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 16px; font-weight: 400; line-height: 24px; padding-top: 25px;\">" +
                  "                            " +
                  "                            <h2 style=\"font-size: 30px; font-weight: 800; line-height: 36px; color: #333333; margin: 0;\">" +
                  "                                Project Card Details <br>" +
                  "                            <h2 style=\"font-size: 20px; font-weight: 800; line-height: 36px; color: #333333; margin: 0;\">" +
                  date+
                  "                    </tr>" +
                  "                    <tr>" +
                  "                        <td align=\"left\" style=\"padding-top: 20px;\">" +
                  "			" +
                  "                            <table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" >" +
                  "                                <tr>" +
                  "                                    <td  width=\"15%\"align=\"left\" bgcolor=\"#eeeeee\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 16px; font-weight: 800; line-height: 24px; padding: 10px;\">" +
                  "                                        Project" +
                  "                                    </td>" +
                  "									<td width=\"40%\"align=\"left\" bgcolor=\"#eeeeee\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 16px; font-weight: 800; line-height: 24px; padding: 10px;\">" +
                  "                                        Task" +
                  "                                    </td>" +
                  "									<td  width=\"10%\"align=\"left\" bgcolor=\"#eeeeee\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 16px; font-weight: 800; line-height: 24px; padding: 10px;\">" +
                  "                                        Creator" +
                  "                                    </td>" +
                  "									<td  width=\"15%\"align=\"left\" bgcolor=\"#eeeeee\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 16px; font-weight: 800; line-height: 24px; padding: 10px;\">" +
                  "                                        Created" +
                  "                                    </td>" +
                  "									<td  width=\"15%\"align=\"left\" bgcolor=\"#eeeeee\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 16px; font-weight: 800; line-height: 24px; padding: 10px;\">" +
                  "                                        Updated" +
                  "                                    </td>" +
                  "									<td width=\"10%\" align=\"left\" bgcolor=\"#eeeeee\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 16px; font-weight: 800; line-height: 24px; padding: 10px;\">" +
                  "                                        Delay<br>(Days)" +
                  "                                    </td>" +
                  "									" +
                  "                                </tr>" ;
    foreach card in groupList {
        if (counter%2==0){
            colour="#eeeeee";
        }
        else{
            colour="#ffffff";
        }
        if (card.TASK==null){
            task = null;
        }
        else{
            task = card.TASK.toString();
        }
        body=body+ "                                <tr>" +
             "                                    <td width=\"15%\" align=\"left\"bgcolor=\""+colour+"\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 16px; font-weight: 400; line-height: 24px; padding: 15px 10px 5px 10px;\">" +
             card.PROJECT.toString() +
             "                                    </td>" +
             "									<td  width=\"40%\" align=\"left\"bgcolor=\""+colour+"\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 16px; font-weight: 400; line-height: 24px; padding: 15px 10px 5px 10px;\">" +
             "                                        <a href=\""+card.URL.toString()+"\">"+task+"</a>" +
             "                                    </td>" +
             "									<td width=\"10%\" align=\"left\" bgcolor=\""+colour+"\"style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 16px; font-weight: 400; line-height: 24px; padding: 15px 10px 5px 10px;\">" +
             card.USER.toString() +
             "                                    </td>" +
             "									<td width=\"15%\" align=\"left\"bgcolor=\""+colour+"\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 16px; font-weight: 400; line-height: 24px; padding: 15px 10px 5px 10px;\">" +
             card.CREATED.toString()+
             "                                    </td>" +
             "									<td width=\"15%\" align=\"left\"bgcolor=\""+colour+"\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 16px; font-weight: 400; line-height: 24px; padding: 15px 10px 5px 10px;\">" +
             card.UPDATED.toString() +
             "                                    </td>" +
             "									<td width=\"10%\" align=\"left\"bgcolor=\""+colour+"\" style=\"font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 16px; font-weight: 400; line-height: 24px; padding: 15px 10px 5px 10px;\">" +
             card.DELAY.toString() +
             "                                    </td>" +
             "                                </tr>";
        counter=counter+1;
    }
    body=body+ "                               " +
         "                                " +
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
         "                                All the above Github project cards are not updated recently." +
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
    json mail={addr:"nalin.j@outlook.com",body:body};
    return (mail);
}
