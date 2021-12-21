import 'dart:async';

import 'package:amana_foods_hr/classes/companies.dart';
import 'package:amana_foods_hr/classes/various_lists.dart';
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

import 'disciplinary_info.dart';

class EditDisciplinaries extends StatefulWidget {
  @override
  _EditDisciplinariesState createState() => _EditDisciplinariesState();
  final String discip_id;
  EditDisciplinaries(this.discip_id);
}

class _EditDisciplinariesState extends State<EditDisciplinaries> {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  FToast fToast;
  List<Disciplinary> disciplinaries;

  DateTime selectedDate = DateTime.now();
  String violation_type;
  //static bool show = false;
  static bool err = false;
  static String msg = "";
  DB_Class db= new DB_Class();

  final vioIDController = TextEditingController();
  final commentController = TextEditingController();
  final decisionController = TextEditingController();
  final empIDController = TextEditingController();
  final creatEmpIDController = TextEditingController();
  final rejectController = TextEditingController();
  final dateController = TextEditingController();
  final statusController = TextEditingController();
  final damageController = TextEditingController();
  final explainController = TextEditingController();
  final appIDController = TextEditingController();
  final typeController = TextEditingController();


  @override
  void initState() {
    disciplinaries = (
        AppConstants.MANAGER_VIEW =="no"?
        LoadSettings.getDiscpList().where((i) => i.violation_id==widget.discip_id).toList()
            :LoadSettings.getDiscpManagerList().where((i) => i.violation_id==widget.discip_id).toList()
    );

    vioIDController.text = disciplinaries[0].violation_id;
    commentController.text = disciplinaries[0].employee_comments;
    decisionController.text = disciplinaries[0].decision;
    empIDController.text = disciplinaries[0].employee_id;
    creatEmpIDController.text = disciplinaries[0].created_by;
    rejectController.text =  (LoadSettings.getVariousList().where((element) => (element.name=="reject"&&element.desc==disciplinaries[0].acceptance))).first.id;
    dateController.text = disciplinaries[0].violation_date_time;
    statusController.text = (LoadSettings.getVariousList().where((element1) => (element1.name=="Violation Status" && element1.desc==disciplinaries[0].status))).first.id.toString();
    damageController.text = disciplinaries[0].damage_;
    explainController.text = disciplinaries[0].explanation;
    appIDController.text = disciplinaries[0].app_id;
    typeController.text=disciplinaries[0].violation_name;
    violation_type=disciplinaries[0].violation_name;
    super.initState();
    err=true;
    msg="";
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
                padding: EdgeInsets.fromLTRB(8.sp,0,8.sp,0),
                child: IconButton(
              icon: Icon(Icons.save_outlined,size: ScreenUtils.GetBarIconSize()),
              onPressed: () {
                saveNewViolation();
              },
            )),
          ],
          leading:  Padding(
              padding: EdgeInsets.fromLTRB(8.sp,0,8.sp,0),
              child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white,size: ScreenUtils.GetBarIconSize(),),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisciplinaryInfo(widget.discip_id),
              ),
            ),
          )),
          title: Text("edit_punishment".tr, style: ScreenUtils.geHeaderextstyle()),
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
                        Container(
                          //   width: (screenWidth * 0.95),
                          margin: ScreenUtils.GetAddPageMargins(),
                          child: TextField(
                            enabled: false,
                            controller: vioIDController,
                            style: ScreenUtils.getItemsDetailsTextstyle(),
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: 'ID'.tr),
                          ),
                        ),//vio_id
                        Container(
                          //   width: (screenWidth * 0.95),
                          margin: ScreenUtils.GetAddPageMargins(),
                          child: TextField(
                            enabled: false,
                            controller: empIDController,
                            style: ScreenUtils.getItemsDetailsTextstyle(),
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: 'emp_id'.tr),
                          ),
                        ), //emp_ID
                        /*Text("violation_type".tr,
                            style: ScreenUtils.getItemsDetailsTextstyle()
                        ), //type
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
                            value: violation_type,

                            style: ScreenUtils.getItemsDetailsTextstyle(),

                            items: LoadSettings.getViolationTypesList().map((ViolationType item) => DropdownMenuItem<String>(child: Text(item.desc),value: item.id)).toList(),
                           //  items: LoadSettings.getCompanyiesList().map((Company item) =>DropdownMenuItem<String>(child: Text(item.comp_id), value: item.comp_id)).toList(),

                            onChanged: (value) {
                              violation_type = value;
                            },
                          ),
                        ), */// type drop down
                        Container(
                          //   width: (screenWidth * 0.95),
                          margin: ScreenUtils.GetAddPageMargins(),
                          child: TextField(
                            enabled: false,
                            controller: typeController,
                            style: ScreenUtils.getItemsDetailsTextstyle(),
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: 'violation_type'.tr),
                          ),//violation_type
                        ),//vio_id
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("violation_date".tr,
                                  // textAlign: (LoadSettings.getLang() == 'ar' ? TextAlign.right : TextAlign.left),
                                  style:ScreenUtils.getItemsDetailsTextstyle()),
                              TextField(
                                enabled: false,
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
                            enabled: false,
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
                            enabled: false,
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

                        Container(
                          // width: (screenWidth * 0.95),
                          margin: ScreenUtils.GetAddPageMargins(),
                          child: TextField(
                            enabled: false,
                            controller: decisionController,
                            keyboardType: TextInputType.text,
                            maxLines: 3,
                            style: ScreenUtils.getItemsDetailsTextstyle(),
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: 'discpl_board_decision'.tr),
                          ),
                        ),//decision
                        Container(
                          // width: (screenWidth * 0.95),
                          margin: ScreenUtils.GetAddPageMargins(),
                          child: TextField(
                            enabled: false,
                            controller: creatEmpIDController,
                            keyboardType: TextInputType.text,
                            maxLines: 3,
                            style: ScreenUtils.getItemsDetailsTextstyle(),
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: 'created_by'.tr),
                          ),
                        ),//created by
                        Container(
                          // width: (screenWidth * 0.95),
                          margin: ScreenUtils.GetAddPageMargins(),
                          child: TextField(
                            enabled: true,
                            controller: commentController,
                            keyboardType: TextInputType.text,
                            maxLines: 3,
                            style: ScreenUtils.getItemsDetailsTextstyle(),
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: 'comment'.tr),
                          ),
                        ),//Comments
                        Text("acceptance".tr,
                            style: ScreenUtils.getItemsDetailsTextstyle()
                        ), //acceptance
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
                            value: ((rejectController.text!=""&&rejectController.text!=null)?rejectController.text:"Select"),

                            style: ScreenUtils.getItemsDetailsTextstyle(),

                            items:LoadSettings.getVariousList().where((i) => i.name=="reject")
                                .map((VariousLists item) => DropdownMenuItem<String>(
                                child: Text(item.desc),
                                value: item.id.toString()))
                                .toList(),
                            onChanged: (value) {
                              rejectController.text = value;
                            },
                          ),
                        ),//acceptance drop
                        Text("status".tr,
                            style: ScreenUtils.getItemsDetailsTextstyle()
                        ), //status
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
                            value: statusController.text,

                            style: ScreenUtils.getItemsDetailsTextstyle(),

                            items:LoadSettings.getVariousList().where((i) => i.name=="Violation Status")
                                .map((VariousLists item) => DropdownMenuItem<String>(
                                child: Text(item.desc),
                                value: item.id.toString()))
                                .toList(),
                             // onChanged: null,
                            /*onChanged: (value) {
                              statusController.text = value;
                            },*/
                          ),
                        ),//status drop
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
                        ), *///application ID
                      ],
                    ),
                  ),
                ],
              )),
        )
    );
  }


  void saveNewViolation() async {

    if(empIDController.text=="" ||violation_type==""||violation_type=="Select")
      {
        Utilities.showToast(true,"fillFields".tr,fToast);
      }else
        {
          String json = "'Damage':'" +
              damageController.text +
              "','EmployeeId': '" +
              empIDController.text +
              "','CreatedByEmployeeId': '" +
              LoadSettings.getUserID() +
              "','Explanation':'" +
              explainController.text +
              "','ViolationDate':'" +
              dateController.text.substring(0, 10)+
              "','ViolationDateTime':'" +
              dateController.text.substring(0, 19) +
              "','ViolationID':'" +
              vioIDController.text +
              "','Comments':'" +
              commentController.text +
              "','ViolationStatus':'" +
              statusController.text +
              "','CommitteeDecision':'" +
              decisionController.text +
              "','Reject':'" +
              rejectController.text +
              "', 'ApplicationId':'" +
              appIDController.text +
              "','ViolationType': '"+
              typeController.text+"'";

          print("{'Data':[{" + json + "}]}");
          // 'json': "{'Data':[{'Damage': '','EmployeeId': '000105','CreatedByEmployeeId': '000105','Explanation': '', 'ViolationDate': '30/06/2021','ViolationDateTime': '30/06/2021 18:00:23','ApplicationId': 'App14','ViolationType': 'Mentorship'}]}",
          //{'Data':[{'Damage':'dddsss','EmployeeId': '000105','CreatedByEmployeeId': '000105','Explanation':'www','ViolationDate':'29/07/2021','ViolationDateTime':'29/07/2021  03:43:33', 'ApplicationId':'App16','ViolationType': 'Mentorship'}]}

//String comp=LoadSettings.getAllWorkersList().where((element) => element.id==empIDController.text).toList()[0].def_company;
          Utilities.saveNewObject(LoadSettings.getCompanyName(),json, "updateViolation").then((body) async {
            var dbHelper = DB_Class();
            if (body == "timeout") {
              Disciplinary disp = Disciplinary(
                employee_name: "",
                employee_id: empIDController.text,
                created_by: LoadSettings.getUserID(),
                violation_id: vioIDController.text,
                violation_name: violation_type,
                violation_date_time: dateController.text.substring(0, 19) ,
                violation_date: dateController.text.substring(0, 10),
                explanation: explainController.text,
                damage_: damageController.text,
                acceptance: rejectController.text,
                employee_comments: commentController.text ,
                decision:  decisionController.text,
                status: statusController.text,
                app_id: appIDController.text,
                editFlage: "yes",
                employee_company: LoadSettings.getCompanyName(),
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
                await dbHelper.getAllDiscp("disciplinary");
                LoadSettings.setDiscpManagerList(await dbHelper.discps("disciplinary_manager"));
                LoadSettings.setDiscpList(await dbHelper.discps("disciplinary"));

              }
            }
            Future.delayed(Duration(seconds: 5)).then((value) => {
              setState(() {
                Navigator.of(context).pushNamed('discplinaries');
              })
            });
          }
          );

        }



//{\"Data\":\"Insert record successfully # Vio-000000045\"}
    //{\"Data\":[{\"id\":\"Error\",\"text\":\"Application Id hhhh already exist.\"}]}
  }

}
