import 'dart:convert';

import 'package:amana_foods_hr/classes/companies.dart';
import 'package:amana_foods_hr/classes/leav_types.dart';
import 'package:amana_foods_hr/classes/leave.dart';
import 'package:amana_foods_hr/classes/various_lists.dart';
import 'package:amana_foods_hr/db/db_class.dart';
import 'package:amana_foods_hr/db/get_data_class.dart';
import 'package:amana_foods_hr/pages/leaves/leave_info.dart';
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

class EditLeave extends StatefulWidget {
  @override
  _EditLeaveState createState() => _EditLeaveState();
  final String leave_id;
  EditLeave(this.leave_id);
}

class _EditLeaveState extends State<EditLeave> {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  FToast fToast;

  List<Leave> leavList;
  DateTime selecteFromdDate = DateTime.now();
  DateTime selecteTodDate = DateTime.now();

  static bool show = false;
  static bool err = false;
  static String msg = "";
  DB_Class db= new DB_Class();


  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();
  final empComController = TextEditingController();
  final leaveReqIDController = TextEditingController();
  final leaveStatusController = TextEditingController();
  final leaveTypeController = TextEditingController();
  final empIDController = TextEditingController();
  final managerDecisionController = TextEditingController();
  final managerComController = TextEditingController();
  final appIDController = TextEditingController();
  @override
  void initState() {

    leavList = (
        AppConstants.MANAGER_VIEW =="no"?
        LoadSettings.getLeavesList().where((i) => i.leave_id==widget.leave_id).toList()
            :LoadSettings.getLeavesManagerList().where((i) => i.leave_id==widget.leave_id).toList()
    );

    fromDateController.text = leavList[0].from_date_time;
    toDateController.text =leavList[0].to_date_time;
    empComController.text= leavList[0].employee_comments;
    leaveReqIDController.text= leavList[0].leave_id;
    leaveStatusController.text=(LoadSettings.getVariousList().where((element1) => (element1.name=="Leave Status" && element1.desc==leavList[0].status))).first.id.toString() ;
    leaveTypeController.text= leavList[0].leave_type_id.toString(); // to be edited with desc
    empIDController.text= leavList[0].employee_id;
    //print (leavList[0].direct_manager_decision);
    managerDecisionController.text= (LoadSettings.getVariousList().where((element1) => (element1.name=="Direct Manager Decision" && element1.desc==leavList[0].direct_manager_decision))).first.id.toString();// to be edited with desc
    managerComController.text= leavList[0].direct_manager_comments;
    appIDController.text=leavList[0].app_id;

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
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LeaveInfo(widget.leave_id),
              ),
            ),
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
                          //   width: (screenWidth * 0.95),
                          margin: ScreenUtils.GetAddPageMargins(),
                          child: TextField(
                            enabled: false,
                            controller: leaveReqIDController,
                            style: ScreenUtils.getItemsDetailsTextstyle(),
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: '_id'.tr),
                          ),//violation_type
                        ), //ID
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
                        Container(
                          //   width: (screenWidth * 0.95),
                          margin: ScreenUtils.GetAddPageMargins(),
                          child: TextField(
                            enabled: false,
                            controller: leaveTypeController,
                            style: ScreenUtils.getItemsDetailsTextstyle(),
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: 'leave_type'.tr),
                          ),//violation_type
                        ), //Type
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
                            enabled: false,
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
                        Text("dir_man_decision".tr,
                            style: ScreenUtils.getItemsDetailsTextstyle()
                        ), //decision
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
                            value: ((managerDecisionController.text!=""&&managerDecisionController.text!=null)?managerDecisionController.text:"Select"),

                            style: ScreenUtils.getItemsDetailsTextstyle(),

                            items:LoadSettings.getVariousList().where((i) => i.name=="Direct Manager Decision")
                                .map((VariousLists item) => DropdownMenuItem<String>(
                                child: Text(item.desc),
                                value: item.id.toString()))
                                .toList(),
                            onChanged: (value) {
                              managerDecisionController.text = value;
                            },
                          ),
                        ),
                        Container(
                          // width: (screenWidth * 0.95),
                          margin: ScreenUtils.GetAddPageMargins(),
                          child: TextField(
                            enabled: true,
                            controller: managerComController,
                            keyboardType: TextInputType.text,
                            maxLines: 3,
                            style: ScreenUtils.getItemsDetailsTextstyle(),
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: 'dir_man_comment'.tr),
                          ),
                        ), //Manager Comments
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
        )

    );
  }

  void saveNewLeave() async {


    if(managerComController.text=="" ||managerDecisionController=="")
    {
      Utilities.showToast(true, "fillFields".tr,fToast);
    }else{

    String json = "'FromDateTime':'" + fromDateController.text.substring(0, 19)   + "',"
        "'ToDateTime': '" + toDateController.text.substring(0, 19)  + "',"
        "'EmployeeId': '"+empIDController.text+"',"
        "'EmployeeComments':'" + empComController.text + "',"
        "'LeaveStatus':'" + leaveStatusController.text + "',"
        "'LeaveRequestID':'" + leaveReqIDController.text + "',"
        "'ManagerComments':'" + managerComController.text + "',"
        "'ManagerDecision':'" + managerDecisionController.text + "',"
        "'ApplicationId':'" + appIDController.text + "',"
        "'LeaveTypeId': '" + leaveTypeController.text + "'";
    print("{'Data':[{" + json + "}]}");


    Utilities.saveNewObject(LoadSettings.getCompanyName(),json, "updateLeaveRequest").then((body) async {
      var dbHelper = DB_Class();
      if (body == "timeout") {
        Leave newleave = Leave(
          employee_name: LoadSettings.getUserName(),
          employee_id: empIDController.text,
          employee_comments: empComController.text ,
          from_date_time: fromDateController.text.substring(0, 19),
          to_date_time: toDateController.text.substring(0, 19) ,
          status: leaveStatusController.text,
          app_id: appIDController.text,
          leave_type_id:leaveTypeController.text,
          direct_manager_comments: managerComController.text,
          direct_manager_decision: managerDecisionController.text,
          job_title: "",
          editFlage: "yes",
          leave_id: leaveReqIDController.text,
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
          await dbHelper.getAllLeaves("leaves_manager");
          LoadSettings.setLeavesList(await dbHelper.leaves("leaves"));
          LoadSettings.setLeavesManagerList(await dbHelper.leaves("leaves_manager"));

        }

      }


      Future.delayed(Duration(seconds: 5)).then((value) =>
      {
        setState(() {
            Navigator.of(context).pushNamed('leaves');

        })
      });

    });}

//{\"Data\":\"Insert record successfully # Vio-000000045\"}
    //{\"Data\":[{\"id\":\"Error\",\"text\":\"Application Id hhhh already exist.\"}]}
  }

}
