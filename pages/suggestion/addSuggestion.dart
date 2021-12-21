import 'dart:convert';

import 'package:amana_foods_hr/classes/suggestion.dart';
import 'package:amana_foods_hr/classes/user.dart';
import 'package:amana_foods_hr/classes/various_lists.dart';
import 'package:amana_foods_hr/db/db_class.dart';
import 'package:amana_foods_hr/db/get_data_class.dart';
import 'package:amana_foods_hr/pages/load_settings.dart';
import 'package:amana_foods_hr/util/ScreenUtil.dart';
import 'package:amana_foods_hr/util/Settings.dart';
import 'package:amana_foods_hr/util/app_constants.dart';
import 'package:amana_foods_hr/util/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class AddSuggestion extends StatefulWidget {
  @override
  _AddSuggestionState createState() => _AddSuggestionState();
}

class _AddSuggestionState extends State<AddSuggestion> {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  FToast fToast;

  //static bool show = false;
  static bool err = false;
  static bool suggestionFlag = true,againstPersonFlag=true;
  static String msg = "";
  DB_Class db = new DB_Class();
  static String type = "1";
  static String category = "0";
  static bool alertPerson=false;
  static bool alertManager=false;
  static String complainAbout = '1';

  final empIDController = TextEditingController();

  final explainController = TextEditingController();
  final appIDController = TextEditingController();
  @override
  void initState() {
    suggestionFlag = true;
    complainAbout = '1';
    type='1';
    category='0';
    alertPerson=false;
    alertManager=false;
     empIDController.text="";

    //List<User> test=LoadSettings.getAllWorkersList().where((element) => element.def_company.toLowerCase()==LoadSettings.getCompanyName().toLowerCase()).toList();
    appIDController.text =
        Utilities.generatAppID("CS", LoadSettings.getUserID());
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    // print ("screenWidth:");print (screenWidth);
    screenHeight = _mediaQueryData.size.height;
    // print ("screenHeight:");print (screenHeight);

    ScreenUtils.setWidth(screenWidth);

    ScreenUtils.setHeight(screenHeight);
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: ScreenUtils.GetAppBarHeight(),
          actions: [
            // action button
            Padding(
                padding: EdgeInsets.fromLTRB(8.sp, 0, 8.sp, 0),
                child: IconButton(
                  icon: Icon(Icons.save_outlined,
                      size: ScreenUtils.GetBarIconSize()),
                  onPressed: () {
                    saveNewComplain();
                  },
                )),
          ],
          leading: Padding(
              padding: EdgeInsets.fromLTRB(8.sp, 0, 8.sp, 0),
              child: IconButton(
                icon: Icon(Icons.arrow_back,
                    color: Colors.white, size: ScreenUtils.GetBarIconSize()),
                onPressed: () => Navigator.of(context).pushNamed('suggestions'),
              )),
          title: Text("sug_comp_des".tr, style: ScreenUtils.geHeaderextstyle()),
          centerTitle: true,
          // backgroundColor:  ScreenUtils.getAppColor(),
        ),
        //drawer: MyDrawer(),
        body: Center(
          child: Container(
              width: ScreenUtils.GetAddPageContainerScreenWidth(),
              child: ListView(children: [
                // Utilities.errmsg(msg.tr, show, err),
                Container(
                    alignment: (LoadSettings.getLang() == 'en'
                        ? Alignment.centerLeft
                        : Alignment.centerRight),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("category".tr,
                              // textAlign: (LoadSettings.getLang() == 'ar' ? TextAlign.right : TextAlign.left),
                              style:
                              ScreenUtils.getItemsDetailsTextstyle()),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 15.sp, 10, 15.sp),
                            margin: ScreenUtils.GetAddPageMargins(),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              border: Border.all(color: Colors.grey, width: 1),
                            ),
                            child: DropdownButtonFormField(
                              decoration:
                              InputDecoration.collapsed(hintText: ""),
                              value: "1",
                              style: ScreenUtils.getItemsDetailsTextstyle(),
                              items: LoadSettings.getVariousList()
                                  .where((i) => i.name == "Feedback Category")
                                  .map((VariousLists item) =>
                                  DropdownMenuItem<String>(
                                      child: Text(item.desc),
                                      value: item.id.toString()))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {

                                  category = value;
                                });
                              },
                            ),
                          ),
                          Text("type".tr,
                              // textAlign: (LoadSettings.getLang() == 'ar' ? TextAlign.right : TextAlign.left),
                              style:
                              ScreenUtils.getItemsDetailsTextstyle()),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 15.sp, 10, 15.sp),
                            margin: ScreenUtils.GetAddPageMargins(),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              border: Border.all(color: Colors.grey, width: 1),
                            ),
                            child: DropdownButtonFormField(
                              decoration:
                                  InputDecoration.collapsed(hintText: ""),
                              value: "1",
                              style: ScreenUtils.getItemsDetailsTextstyle(),
                              items: LoadSettings.getVariousList()
                                  .where((i) => i.name == "Feedback Type")
                                  .map((VariousLists item) =>
                                      DropdownMenuItem<String>(
                                          child: Text(item.desc),
                                          value: item.id.toString()))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  suggestionFlag =
                                      (value == "0" ? false : true);
                                  //againstPersonFlag=true;
                                  type = value;
                                });
                              },
                            ),
                          ), //Type
                          complianceFields(!suggestionFlag),

                          Container(
                            // width: (screenWidth * 0.95),
                            margin: ScreenUtils.GetAddPageMargins(),
                            child: TextField(
                              controller: explainController,
                              keyboardType: TextInputType.text,
                              maxLines: 3,
                              style: ScreenUtils.getItemsDetailsTextstyle(),
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  labelText: 'explanation'.tr),
                            ),
                          ), //explanation
                          CheckboxListTile(
                            title: Text("alert_manager".tr),
                            value: alertManager,
                            onChanged: (newValue) {
                              setState(() {
                                alertManager = newValue;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                          )
                         /* Container(
                            //width: (screenWidth * 0.95),
                            margin: ScreenUtils.GetAddPageMargins(),
                            // padding: ScreenUtils.GetAddPageEdgeinsests(),
                            child: TextField(
                              enabled: false,
                              controller: appIDController,
                              style: ScreenUtils.getItemsDetailsTextstyle(),
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  labelText: 'application_id'.tr),
                            ),
                          ),*/

                        ]))
              ])),
        ));
  }

  void saveNewComplain() async {
    if (suggestionFlag = false && type == "") {

      Utilities.showToast(true, "fillFields".tr, fToast);
    } else {
      String json = "'EmployeeId_ComplaintAgainst': '" +
          empIDController.text +
          "'"
              ",'EmployeeId_CreatedBy':'" +
          LoadSettings.getUserID() +
          "'"
              ",'ComplimentType':'" +
          type +
          "'"
              ",'FeedbackCategory':'" +
          category +
          "'"
              ",'ComplimentAbout':'" +
          complainAbout +
          "'"
              ",'Explanation':'" +
          explainController.text +
          "'"
              ",'AlertDirectManager':'" +
          (alertManager?"1":"0") +
          "'"
              ",'AlertPerson':'" +
          (!suggestionFlag?(alertPerson?"1":"0"):"")+
          "'"
              ",'ApplicationId':'" +
          appIDController.text +
          "'";
      print("{'Data':[{" + json + "}]}");
      Utilities.saveNewObject(LoadSettings.getCompanyName(),json, "createCompliment").then((body) async {
        var dbHelper = DB_Class();
        if (body == "timeout") {
          SuggestionCompliance newSugg = SuggestionCompliance(
            employee_name: LoadSettings.getUserName(),
            employee_id: LoadSettings.getUserID(),
            compliant_against_name: empIDController.text ,
            complain_suggestion: type,
            compliant_about: complainAbout,
            explanation: explainController.text,
            compliant_id: "",
            date_time: "",
            status: "",
            alert_direct_manager: (alertManager?"1":"0"),
            alert_person: (alertPerson?"1":"0") ,
            app_id: appIDController.text,
            job_title: "",

          );

          dbHelper.insertSuggestionCompliance(newSugg, "suggestions_local");
          Utilities.showToast(err, body.tr, fToast);

        } else {
          var responseBody = jsonDecode(body);
          responseBody =
              responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);


            if (body.contains("successfully")) {
              print("Done:");
              print(responseBody);
              msg = responseBody;
              err = false;
            } else {
              print("ID:");
              print(responseBody[0]["id"]);
              print("text");
              print(responseBody[0]["text"]);
              msg = responseBody[0]["text"];
              err = true;
            }

            Utilities.showToast(err, msg, fToast);




          if (!err) {
            await dbHelper.getAllsuggestions("suggestions");
            LoadSettings.setSuggestList(await dbHelper.suggestions("suggestions"));
          }
        }
        Future.delayed(Duration(seconds: 5)).then((value) => {
          setState(() {

            if (!err) {
              Navigator.of(context).pushNamed('suggestions');
            }
          })
        });
      });
    }

//{\"Data\":\"Insert record successfully # Vio-000000045\"}
    //{\"Data\":[{\"id\":\"Error\",\"text\":\"Application Id hhhh already exist.\"}]}
  }

  Widget complianceFields(bool complaint) {
    if (complaint == true) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("compliance_about".tr,
                style: ScreenUtils.getItemsDetailsTextstyle()), // About
            Container(
              margin: ScreenUtils.GetAddPageMargins(),
              padding: EdgeInsets.fromLTRB(10, 15.sp, 10, 15.sp),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: DropdownButtonFormField(
                decoration: InputDecoration.collapsed(hintText: ""),
                value: '1',
                style: ScreenUtils.getItemsDetailsTextstyle(),
                items: LoadSettings.getVariousList()
                    .where((i) => i.name == "Feedback About")
                    .map((VariousLists item) => DropdownMenuItem<String>(
                        child: Text(item.desc), value: item.id.toString()))
                    .toList(),
                onChanged: (value) {
                  //  this.langVale=value;

                  complainAbout = value;
                  setState(() {
                    againstPersonFlag =
                    (value == "0" ? false : true);
                  });
                },
              ),
            ),
            Visibility(
                visible: againstPersonFlag,
                child:Text("complain_against".tr,
                // textAlign: (LoadSettings.getLang() == 'ar' ? TextAlign.right : TextAlign.left),
                style:
                ScreenUtils.getItemsDetailsTextstyle())),
            Visibility(
              visible: againstPersonFlag,
                child: Container(

              //padding: EdgeInsets.fromLTRB(10, 15.sp, 10, 15.sp),
                margin: ScreenUtils.GetAddPageMargins(),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: SearchableDropdown(
                  displayClearIcon: true,
                  isExpanded: true,
                  style: ScreenUtils.getItemsDetailsTextstyle(),
                  hint: Text(
                    'complain_against'.tr,
                    style: TextStyle(color: Colors.black),
                  ),
                 // isCaseSensitiveSearch: true,
                  disabledHint: Text('complain_against'.tr),
                  items: LoadSettings.getAllWorkersList().where((i) => i.def_company.toLowerCase() == LoadSettings.getCompanyName().toLowerCase() )
                      .map((item) => DropdownMenuItem<User>(
                      child: Text(item.name), value: item))
                      .toList(),
                  onClear:() {
                    setState(() {

                      empIDController.text = "";
                    });
                  },
                  onChanged: (User newValue) {
                    setState(() {
                      print("new value to set is $newValue");
                      if(newValue!=null)
                      empIDController.text = newValue.id;
                      else
                        empIDController.text = "";
                    });
                  },
                )
            )),
           Visibility(
               visible: (againstPersonFlag&&empIDController.text!=""),
               child:  CheckboxListTile(
             title: Text("alert_person".tr),
             value: alertPerson,
             onChanged: (newValue) {
               setState(() {
                 alertPerson = newValue;
               });
             },
             controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
           ))
           /* Container(
              //   width: (screenWidth * 0.95),
              margin: ScreenUtils.GetAddPageMargins(),
              child: TextField(
                controller: empIDController,
                style: ScreenUtils.getItemsDetailsTextstyle(),
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'complain_against'.tr),
              ),
            ),*/ //Compliance about
            // Compliance Name
          ],
        ),
      );
    } else {
      return Container();
      //if error is false, return empty container.
    }
  }


}
