import 'dart:convert';

import 'package:amana_foods_hr/classes/companies.dart';
import 'package:amana_foods_hr/classes/leav_types.dart';
import 'package:amana_foods_hr/classes/leave.dart';
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
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddLeave extends StatefulWidget {
  @override
  _AddLeaveState createState() => _AddLeaveState();
}

class _AddLeaveState extends State<AddLeave> {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  FToast fToast;

  DateTime selecteFromdDate = DateTime.now();
  DateTime selecteTodDate = DateTime.now();
  String leave_type;
  static bool show = false;
  static bool err = false;
  static String msg = "";
  DB_Class db= new DB_Class();


  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();
  final empComController = TextEditingController();

  final appIDController = TextEditingController();
  @override
  void initState() {
    fromDateController.text = DateFormat('dd/MM/yyyy HH:mm:ss')
        .format(Utilities.roundupDateTime(DateTime.parse("${selecteFromdDate.toLocal()}")));
    toDateController.text = DateFormat('dd/MM/yyyy HH:mm:ss')
        .format(Utilities.roundupDateTime(DateTime.parse("${selecteTodDate.toLocal()}")));
    appIDController.text=Utilities.generatAppID("Lea", LoadSettings.getUserID());
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
                padding: EdgeInsets.fromLTRB(8.sp,0,8.sp,0),
                child: IconButton(
              icon: Icon( Icons.save_outlined,size: ScreenUtils.GetBarIconSize()),
              onPressed: () {
                saveNewLeave();
              },
            )),

          ],
          leading:  Padding(
              padding: EdgeInsets.fromLTRB(8.sp,0,8.sp,0),
              child: IconButton(

            icon: Icon(Icons.arrow_back, color: Colors.white,size:ScreenUtils.GetBarIconSize()),
            onPressed: () => Navigator.of(context).pushNamed('leaves'),
          )),
          title: Text("leave_desc".tr, style: ScreenUtils.geHeaderextstyle()),
          centerTitle: true,
         // backgroundColor:  ScreenUtils.getAppColor(),
        ),
        //drawer: MyDrawer(),
        body: Center(
          child: Container(
              width: ScreenUtils.GetAddPageContainerScreenWidth(),
              child: ListView(
                children: [
                  //Utilities.errmsg(msg.tr, show, err),
                  Container(
                    // width: ScreenUtils.GetAddPageContainerScreenWidth(),
                    //  height: screenHeight / 5,
                    alignment: (LoadSettings.getLang() == 'en'
                        ? Alignment.centerLeft
                        : Alignment.centerRight),
                    //padding: ScreenUtils.GetAddPageEdgeinsests(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [ //emp_ID
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text("leave_type".tr,
                              style: ScreenUtils.getItemsDetailsTextstyle()),
                        ), //type
                        Container(
                          // width: (screenWidth * 0.95),
                          // padding: ScreenUtils.GetAddPageEdgeinsests(),
                          //margin: ScreenUtils.GetAddPageMargins(),
                          padding: EdgeInsets.fromLTRB(10, 15.sp, 10, 15.sp),
                          margin: ScreenUtils.GetAddPageMargins(),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: DropdownButtonFormField(
                           // value:"Select",
                            decoration: InputDecoration.collapsed(hintText: ""),
                            style: ScreenUtils.getItemsDetailsTextstyle(),

                            items: LoadSettings.getLeaveTypesList()
                                .map((LeaveTypes item) => DropdownMenuItem<String>(
                                child: Text(item.decision),
                                value: item.type_id))
                                .toList(),
                            onChanged: (value) {
                              leave_type = value;
                            },
                          ),
                        ), // type drop down
                        Container(
                          margin: ScreenUtils.GetAddPageMargins(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("leave_date_from".tr,
                                  // textAlign: (LoadSettings.getLang() == 'ar' ? TextAlign.right : TextAlign.left),
                                  style: ScreenUtils.getItemsDetailsTextstyle()
                              ),
                              TextField(
                                //"${selectedDate.toLocal()}".substring(0, 19),
                                controller: fromDateController,

                                keyboardType: TextInputType.datetime,
                              //selectedDate.timeZoneOffset.inHours.toString(),
                              style: ScreenUtils.getItemsDetailsTextstyle()
                              ),
                            ],
                          ),
                        ), //from_date_time
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("leave_date_to".tr,
                                  // textAlign: (LoadSettings.getLang() == 'ar' ? TextAlign.right : TextAlign.left),
                                  style: ScreenUtils.getItemsDetailsTextstyle()),
                              TextField(
                                //"${selectedDate.toLocal()}".substring(0, 19),
                                controller: toDateController,

                                  keyboardType: TextInputType.datetime,
                                  //selectedDate.timeZoneOffset.inHours.toString(),
                                  style: ScreenUtils.getItemsDetailsTextstyle()
                              ),
                            ],
                          ),
                        ), //to_date_time
                        Container(
                          // width: (screenWidth * 0.95),
                          margin: ScreenUtils.GetAddPageMargins(),
                          child: TextField(
                            controller: empComController,
                            keyboardType: TextInputType.text,
                            maxLines: 3,
                            style: ScreenUtils.getItemsDetailsTextstyle(),
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: 'emp_comment'.tr),
                          ),
                        ), //emp comments
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
                        ),*/ //application ID
                      ],
                    ),
                  ),
                ],
              )),
        )

    );
  }

  void saveNewLeave() async {


    if(fromDateController.text=="" ||toDateController.text==""||leave_type=="")
    {
      Utilities.showToast(true, "fillFields".tr,fToast);
    }
    else if(DateFormat('dd/MM/yyyy HH:mm:ss').parse(toDateController.text).isBefore(DateFormat('dd/MM/yyyy HH:mm:ss').parse(fromDateController.text))||
        DateFormat('dd/MM/yyyy HH:mm:ss').parse(toDateController.text).isAtSameMomentAs(DateFormat('dd/MM/yyyy HH:mm:ss').parse(fromDateController.text))||
        DateFormat('dd/MM/yyyy HH:mm:ss').parse(fromDateController.text).isBefore(DateTime.now()))
      {

        Utilities.showToast(true, "dateConflict".tr,fToast);

      }
    else
      {
//DateFormat('dd/MM/yyyy  HH:mm:ss').format(DateTime.parse(toDateController.text))
    String json = "'FromDateTime':'" + fromDateController.text  + "',"
        "'ToDateTime': '" + toDateController.text + "',"
        "'EmployeeId': '"+LoadSettings.getUserID()+"',"
        "'EmployeeComments':'" + empComController.text + "',"
        "'ApplicationId':'" + appIDController.text + "',"
        "'LeaveTypeId': '" + leave_type + "'";
    print("{'Data':[{" + json + "}]}");
    // 'json': "{'Data':[{'Damage': '','EmployeeId': '000105','CreatedByEmployeeId': '000105','Explanation': '', 'ViolationDate': '30/06/2021','ViolationDateTime': '30/06/2021 18:00:23','ApplicationId': 'App14','ViolationType': 'Mentorship'}]}",
    //{'Data':[{'Damage':'dddsss','EmployeeId': '000105','CreatedByEmployeeId': '000105','Explanation':'www','ViolationDate':'29/07/2021','ViolationDateTime':'29/07/2021  03:43:33', 'ApplicationId':'App16','ViolationType': 'Mentorship'}]}


    Utilities.saveNewObject(LoadSettings.getCompanyName(),json, "createLeaveRequest").then((body) async {
      var dbHelper = DB_Class();
      if (body == "timeout") {

        Leave newleave = Leave(
          employee_name: LoadSettings.getUserName(),
          employee_id: LoadSettings.getUserID(),
          employee_comments: empComController.text ,
          from_date_time: fromDateController.text,
          to_date_time: toDateController.text,
          status: "",
          app_id: appIDController.text,
          leave_type_id:leave_type,
          direct_manager_comments: "",
          direct_manager_decision: "",
          job_title: "",
          leave_id: "",
          editFlage: "no",
        );

        dbHelper.insertLeaves(newleave, "leaves_local");
        Utilities.showToast(err, body.tr, fToast);

      }else{
      var responseBody = jsonDecode(body);
      responseBody =
          responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);
      setState(() {
        show = true;
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
        Utilities.showToast(err, msg,fToast);

      });

      if (!err) {
        await dbHelper.getAllLeaves("leaves");
        LoadSettings.setLeavesList(await dbHelper.leaves("leaves"));
        Future.delayed(Duration(seconds: 5)).then((value) =>
        {
          setState(() {
            Navigator.of(context).pushNamed('leaves');

          })
        });

      }

    }



    });}

//{\"Data\":\"Insert record successfully # Vio-000000045\"}
    //{\"Data\":[{\"id\":\"Error\",\"text\":\"Application Id hhhh already exist.\"}]}
  }

}
