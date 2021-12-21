import 'dart:async';

import 'package:amana_foods_hr/classes/companies.dart';
import 'package:amana_foods_hr/classes/user.dart';
import 'package:amana_foods_hr/classes/violationTypes.dart';
import 'package:amana_foods_hr/classes/discipilinary.dart';
import 'package:amana_foods_hr/db/db_class.dart';
import 'package:amana_foods_hr/db/get_data_class.dart';
import 'package:amana_foods_hr/pages/load_settings.dart';
import 'package:amana_foods_hr/util/ScreenUtil.dart';
import 'package:amana_foods_hr/util/Settings.dart';
import 'package:amana_foods_hr/util/app_constants.dart';
import 'package:amana_foods_hr/util/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class AddDisciplinaries extends StatefulWidget {
  @override
  _AddDisciplinariesState createState() => _AddDisciplinariesState();
}

class _AddDisciplinariesState extends State<AddDisciplinaries> {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  FToast fToast;

  DateTime selectedDate = DateTime.now();

  String violation_type, empID = "",againstUserCompany="";
  //static bool show = false;
  static bool err = false;
  static String msg = "";

  DB_Class db = new DB_Class();

  final empIDController = TextEditingController();
  final dateController = TextEditingController();
  final damageController = TextEditingController();
  final explainController = TextEditingController();
  final appIDController = TextEditingController();

  @override
  void initState() {
    String Job = DateTime.now().year.toString() +
        DateTime.now().month.toString() +
        DateTime.now().day.toString() +
        DateTime.now().hour.toString() +
        DateTime.now().minute.toString() +
        DateTime.now().second.toString();
    print("job:");
    print(Job);
    dateController.text = DateFormat('dd/MM/yyyy hh:mm:ss')
        .format(DateTime.parse("${selectedDate.toLocal()}"));
    appIDController.text =
        Utilities.generatAppID("Vio", LoadSettings.getUserID());
    super.initState();
    err = true;
    msg = "";
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
                    saveNewViolation();
                  },
                )),
          ],
          leading: Padding(
              padding: EdgeInsets.fromLTRB(8.sp, 0, 8.sp, 0),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: ScreenUtils.GetBarIconSize(),
                ),
                onPressed: () =>
                    Navigator.of(context).pushNamed('discplinaries'),
              )),
          title:
              Text("add_punishment".tr, style: ScreenUtils.geHeaderextstyle()),
          centerTitle: true,
          // backgroundColor:  ScreenUtils.getAppColor(),
        ),
        //drawer: MyDrawer(),
        body: Center(
          child: Container(
              width: ScreenUtils.GetAddPageContainerScreenWidth(),
              child: ListView(
                children: [
                  //  Utilities.errmsg(msg.tr, show, err),
                  Container(
                    // width: ScreenUtils.GetAddPageContainerScreenWidth(),
                    //  height: screenHeight / 5,
                    alignment: (LoadSettings.getLang() == 'en'
                        ? Alignment.centerLeft
                        : Alignment.centerRight),
                    //padding: ScreenUtils.GetAddPageEdgeinsests(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /*  Container(
                          margin: ScreenUtils.GetAddPageMargins(),
                          child: TextField(
                            controller: empIDController,
                            style: ScreenUtils.getItemsDetailsTextstyle(),
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: 'emp_id'.tr),
                          ),
                        ), */ //emp_ID
                        Text("emp_name".tr,
                            // textAlign: (LoadSettings.getLang() == 'ar' ? TextAlign.right : TextAlign.left),
                            style:
                            ScreenUtils.getItemsDetailsTextstyle()),
                        Container(

                            //padding: EdgeInsets.fromLTRB(10, 15.sp, 10, 15.sp),
                            margin: ScreenUtils.GetAddPageMargins(),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              border: Border.all(color: Colors.grey, width: 1),
                            ),
                            child: SearchableDropdown.single(
                              displayClearIcon: false,
                              isExpanded: true,
                              style: ScreenUtils.getItemsDetailsTextstyle(),
                              hint: Text(
                                "Select Employee",
                                style: TextStyle(color: Colors.black),
                              ),
                              disabledHint: Text("Select Employee"),
                              items: LoadSettings.getReportedToWorkersList()
                                  .map((item) => DropdownMenuItem<User>(
                                      child: Text(item.name), value: item))
                                  .toList(),
                              onChanged: (User newValue) {
                                setState(() {
                                  print("new value to set is $newValue");
                                  empID = newValue.id;
                                  againstUserCompany=LoadSettings.getCompanyByWorker(empID).toLowerCase();

                                });
                              },
                            )
                        ),
                        Text("violation_type".tr,
                            style:
                                ScreenUtils.getItemsDetailsTextstyle()), //type
                        Container(
                          // width: (screenWidth * 0.95),
                          padding: EdgeInsets.fromLTRB(10, 15.sp, 10, 15.sp),
                          margin: ScreenUtils.GetAddPageMargins(),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: DropdownButtonFormField(
                            decoration: InputDecoration.collapsed(hintText: ""),
                            // value: "Select",
                            style: ScreenUtils.getItemsDetailsTextstyle(),

                            items: LoadSettings.getViolationTypesList().where((i) => i.company==againstUserCompany).map((ViolationType item) =>DropdownMenuItem<String>(child: Text(item.desc), value: item.id)).toList(),
                            //  items: LoadSettings.getCompanyiesList().map((Company item) =>DropdownMenuItem<String>(child: Text(item.comp_id), value: item.comp_id)).toList(),

                            onChanged: (value) {
                              violation_type = value;
                            },
                          ),
                        ), // type drop down
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("violation_date".tr,
                                  // textAlign: (LoadSettings.getLang() == 'ar' ? TextAlign.right : TextAlign.left),
                                  style:
                                      ScreenUtils.getItemsDetailsTextstyle()),
                              TextField(
                                /* onTap:(){ DatePicker.showDateTimePicker(context,
                                    showTitleActions: true,

                                    locale: LocaleType.en,
                                    minTime: DateTime(2019, 3, 5),
                                    maxTime: DateTime(2035, 6, 7),
                                    theme: DatePickerTheme(

                                        headerColor: Colors.green,
                                        backgroundColor: Colors.white,
                                        itemStyle: TextStyle(
                                            color: Colors.green,
                                            fontWeight:
                                            FontWeight.bold,
                                            fontSize: ScreenUtils
                                                .GetHomePageFontSize()),
                                        doneStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtils
                                                .GetDatePickerFontSize())),
                                    onChanged: (date) {
                                      //print('change $date in time zone ' +
                                      //  date.timeZoneOffset.inHours.toString());
                                    }, onConfirm: (date) {
                                      //   print('confirm $date');
                                      if (date != null &&
                                          date != selectedDate) {
                                        selectedDate = date;
                                        setState(() {});
                                        dateController.text =
                                        "${selectedDate.toLocal()}";
                                      }
                                    }, currentTime: DateTime.now());},*/
                                //"${selectedDate.toLocal()}".substring(0, 19),
                                controller: dateController,
                                keyboardType: TextInputType.datetime,
                                //selectedDate.timeZoneOffset.inHours.toString(),
                                style: ScreenUtils.getItemsDetailsTextstyle(),
                              ),
                            ],
                          ),
                        ), //violation_date_time

                        Container(
                          // width: (screenWidth * 0.95),
                          margin: ScreenUtils.GetAddPageMargins(),
                          child: TextField(
                            controller: damageController,
                            keyboardType: TextInputType.text,
                            maxLines: 3,
                            style: ScreenUtils.getItemsDetailsTextstyle(),
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: 'damage_result'.tr),
                          ),
                        ), //damage_result
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
                        /*Container(
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
                        ),*/ //application ID
                      ],
                    ),
                  ),
                ],
              )),
        ));
  }

  Future<void> _showDatePicker(BuildContext context, bool isTo) async {
    final ThemeData theme = Theme.of(context);
    assert(theme.platform != null);
    switch (theme.platform) {
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
      case TargetPlatform.windows:
      case TargetPlatform.android:
        return buildMaterialDatePicker(context, isTo);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return buildCupertinoDatePicker(context, isTo);
    }
  }

  buildMaterialDatePicker(BuildContext context, bool isTo) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 1),
      lastDate: DateTime(2100),
      initialEntryMode: DatePickerEntryMode.input,
    );
    if (picked != null) {
      selectedDate = picked;
      setState(() {});
      dateController.text = "${selectedDate.toLocal()}";
    }
  }

  buildCupertinoDatePicker(BuildContext context, bool isTo) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (picked) {
                if (picked != null) {
                  selectedDate = picked;
                  setState(() {});
                  dateController.text =
                      "${selectedDate.toLocal()}".split(' ')[0];
                }
              },
              initialDateTime: DateTime.now(),
              minimumYear: 2000,
              maximumYear: 2025,
            ),
          );
        });
  }

  void saveNewViolation() async {
    if (empID == "" || violation_type == "" || violation_type == "Select") {
      Utilities.showToast(true, "fillFields".tr, fToast);
    } else {
      String json = "'Damage':'" +
          damageController.text +
          "','EmployeeId': '" +
          empID +
          "','CreatedByEmployeeId': '" +
          LoadSettings.getUserID() +
          "','Explanation':'" +
          explainController.text +
          "','ViolationDate':'" +
          dateController.text.substring(0, 10) +
          "','ViolationDateTime':'" +
          dateController.text +
          "', 'ApplicationId':'" +
          appIDController.text +
          "','ViolationType': '" +
          violation_type +
          "'";

      print("{'Data':[{" + json + "}]}");
      // 'json': "{'Data':[{'Damage': '','EmployeeId': '000105','CreatedByEmployeeId': '000105','Explanation': '', 'ViolationDate': '30/06/2021','ViolationDateTime': '30/06/2021 18:00:23','ApplicationId': 'App14','ViolationType': 'Mentorship'}]}",
      //{'Data':[{'Damage':'dddsss','EmployeeId': '000105','CreatedByEmployeeId': '000105','Explanation':'www','ViolationDate':'29/07/2021','ViolationDateTime':'29/07/2021  03:43:33', 'ApplicationId':'App16','ViolationType': 'Mentorship'}]}

      Utilities.saveNewObject(againstUserCompany,json, "createViolation").then((body) async {
        var dbHelper = DB_Class();
        if (body == "timeout") {
          Disciplinary disp = Disciplinary(
            employee_name: LoadSettings.getUserName(),
            employee_id: empID,
            created_by: LoadSettings.getUserID(),
            violation_id: "",
            violation_name: violation_type,
            violation_date: dateController.text.substring(0, 10),
            violation_date_time: dateController.text,
            explanation: explainController.text,
            damage_: damageController.text,
            acceptance: "",
            employee_comments: "",
            decision: "",
            status: "",
            app_id: appIDController.text,
            editFlage: "no",
            employee_company: againstUserCompany,
          );

          dbHelper.insertDisciplinaries(disp, "disciplinary_local");
          Utilities.showToast(err, body.tr, fToast);

        } else {
          var responseBody = jsonDecode(body);
          responseBody =
              responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);
          setState(() {

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
          });

          if (!err) {

            await dbHelper.getAllDiscp("disciplinary_manager");
            LoadSettings.setDiscpManagerList(await dbHelper.discps("disciplinary_manager"));


          }
        }
        if (!err)Future.delayed(Duration(seconds: 5)).then((value) => {
          setState(() {
            Navigator.of(context).pushNamed('discplinaries');
          })
        });
      });
    }

//{\"Data\":\"Insert record successfully # Vio-000000045\"}
    //{\"Data\":[{\"id\":\"Error\",\"text\":\"Application Id hhhh already exist.\"}]}
  }
}
