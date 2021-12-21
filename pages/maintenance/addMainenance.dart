import 'dart:convert';

import 'package:amana_foods_hr/classes/assets.dart';
import 'package:amana_foods_hr/classes/diagnostics.dart';
import 'package:amana_foods_hr/classes/maintenance.dart';
import 'package:amana_foods_hr/classes/objects.dart';
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
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class AddMainenance extends StatefulWidget {
  @override
  _AddMainenanceState createState() => _AddMainenanceState();
}

class _AddMainenanceState extends State<AddMainenance> {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  List<DropdownMenuItem<Assets>> assetsListbyObjectID,empty_assetsListbyObjectID;
  FToast fToast;

  DateTime selectedDate = DateTime.now();
  String priority_type = "", objectid = "", assetid = "", diagid = "";
  static bool show = false;
  static bool err = false;
  static String msg = "";
  DB_Class db = new DB_Class();

  final objIDController = TextEditingController();
  final assetIDController = TextEditingController();
  final diagIDController = TextEditingController();
  final dateController = TextEditingController();
  final damageController = TextEditingController();
  final notesController = TextEditingController();
  final descController = TextEditingController();
  final appIDController = TextEditingController();

  @override
  void initState() {
    dateController.text = DateFormat('dd/MM/yyyy')
        .format(DateTime.parse("${selectedDate.toLocal()}"));
    appIDController.text =
        Utilities.generatAppID("Mai", LoadSettings.getUserID());
    assetsListbyObjectID = [
      DropdownMenuItem(
        child: Text(""),
        value: null,
      ),
    ];
    empty_assetsListbyObjectID = [
      DropdownMenuItem(
        child: Text(""),
        value: null,
      ),
    ];
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
                    saveNewMaintenance();
                  },
                )),
          ],
          leading: Padding(
              padding: EdgeInsets.fromLTRB(8.sp, 0, 8.sp, 0),
              child: IconButton(
                icon: Icon(Icons.arrow_back,
                    color: Colors.white, size: ScreenUtils.GetBarIconSize()),
                onPressed: () => Navigator.of(context).pushNamed('maintenance'),
              )),
          title: Text("maintenance_desc".tr,
              style: ScreenUtils.geHeaderextstyle()),
          centerTitle: true,
          //  backgroundColor:  ScreenUtils.getAppColor(),
        ),
        //drawer: MyDrawer(),
        body: Center(
          child: Container(
              width: ScreenUtils.GetAddPageContainerScreenWidth(),
              child: ListView(
                children: [
                  // Utilities.errmsg(msg.tr, show, err),
                  Container(
                    alignment: (LoadSettings.getLang() == 'en'
                        ? Alignment.centerLeft
                        : Alignment.centerRight),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Select Object".tr,
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
                              isExpanded: true,
                              displayClearIcon: false,

                              //decoration: InputDecoration.collapsed(hintText: ""),
                              style: ScreenUtils.getItemsDetailsTextstyle(),
                            /*  hint: Text(
                                "Select Object",
                                style: TextStyle(color: Colors.black),
                              ),*/
                              disabledHint: Text("Select Object"),

                              onChanged: (Objects newValue) {
                                setState(() {
                                  print("new value to set is $newValue");
                                  objectid = newValue.object_id;
                                  assetsListbyObjectID =
                                      LoadSettings.getAssetsList()
                                          .where((i) => i.object_id == objectid)
                                          .map((item) =>
                                              DropdownMenuItem<Assets>(
                                                  child: Text(item.object_id +
                                                      "(" +
                                                      item.asset_id +
                                                      ")"),
                                                  value: item))
                                          .toList();
                                });
                              },
                              items: LoadSettings.getObjectsList()
                                  .where((i) => i.company.toLowerCase() == LoadSettings.getCompanyName().toLowerCase())
                                  .map(( item) =>
                                      DropdownMenuItem<Objects>(
                                          child: Text(item.object_name),
                                          value: item))
                                  .toList(),
                            )), // object id
                        Text("Select Asset".tr,
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
                            child: SearchableDropdown(
                              displayClearIcon: false,
                              isExpanded: true,
                              //decoration: InputDecoration.collapsed(hintText: ""),
                              style: ScreenUtils.getItemsDetailsTextstyle(),
                              /*hint: Text(
                                "Select Asset",
                                style: TextStyle(color: Colors.black),
                              ),*/
                              disabledHint: Text("Select Asset"),
                              onChanged: (Assets newValue) {
                                setState(() {
                                  print("new value to set is $newValue");
                                  assetid = newValue.asset_id;
                                });
                              },
                              items: (assetsListbyObjectID.length>0?assetsListbyObjectID:empty_assetsListbyObjectID),

                            )), // Asset ID
                        Text("Select Diagnostic".tr,
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
                              isExpanded: true,
                              displayClearIcon: false,

                              //decoration: InputDecoration.collapsed(hintText: ""),
                              style: ScreenUtils.getItemsDetailsTextstyle(),
                              /*hint: Text(
                                "Select Diagnostic",
                                style: TextStyle(color: Colors.black),
                              ),*/
                              disabledHint: Text("Select Diagnostic"),

                              onChanged: (Diagnostics newValue) {
                                setState(() {
                                  print("new value to set is $newValue");
                                  diagid = newValue.diag_id;
                                });
                              },
                              items: LoadSettings.getDiagsList()
                                  .where((i) => i.company.toLowerCase() == LoadSettings.getCompanyName().toLowerCase())
                                  .map(( item) =>
                                      DropdownMenuItem<Diagnostics>(
                                          child: Text(item.diag_name),
                                          value: item))
                                  .toList(),
                            )), // Diagnostic ID
                        Text("priority".tr,
                            style: ScreenUtils
                                .getItemsDetailsTextstyle()), //Priority
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 15.sp, 10, 15.sp),
                          margin: ScreenUtils.GetAddPageMargins(),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: DropdownButtonFormField(
                            decoration: InputDecoration.collapsed(hintText: ""),
                            style: ScreenUtils.getItemsDetailsTextstyle(),
                            items: LoadSettings.getVariousList()
                                .where((i) => i.name == "Priority")
                                .map((VariousLists item) =>
                                    DropdownMenuItem<String>(
                                        child: Text(item.desc),
                                        value: item.id.toString()))
                                .toList(),
                            onChanged: (value) {
                              priority_type = value;
                            },
                          ),
                        ), // Priority drop down
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("_date".tr,
                                  // textAlign: (LoadSettings.getLang() == 'ar' ? TextAlign.right : TextAlign.left),
                                  style:
                                      ScreenUtils.getItemsDetailsTextstyle()),
                              TextField(
                                controller: dateController,
                                keyboardType: TextInputType.datetime,
                                style: ScreenUtils.getItemsDetailsTextstyle(),
                              ),
                            ],
                          ),
                        ), // request date
                        Container(
                          // width: (screenWidth * 0.95),
                          margin: ScreenUtils.GetAddPageMargins(),
                          child: TextField(
                            controller: notesController,
                            keyboardType: TextInputType.text,
                            maxLines: 3,
                            style: ScreenUtils.getItemsDetailsTextstyle(),
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: 'notes'.tr),
                          ),
                        ), //notes
                        Container(
                          // width: (screenWidth * 0.95),
                          margin: ScreenUtils.GetAddPageMargins(),
                          child: TextField(
                            controller: descController,
                            keyboardType: TextInputType.text,
                            maxLines: 3,
                            style: ScreenUtils.getItemsDetailsTextstyle(),
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: 'description'.tr),
                          ),
                        ), //description
                       /* Container(
                          margin: ScreenUtils.GetAddPageMargins(),
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

  void saveNewMaintenance() async {
    if (assetid == "" ||
        objectid == "" ||
        diagid == "" ||
        priority_type == "" ||
        dateController.text == "" ||
        diagIDController == "") {
      Utilities.showToast(true, "fillFields".tr, fToast);
    } else {
      String json = "'AssetId':'" +
          assetid +
          "','ObjectId': '" +
          objectid +
          "','DiagnosticsId': '" +
          diagid +
          "','RequestDescription': '" +
          descController.text +
          "','WorkOrderPriority': '" +
          priority_type +
          "','RequesterId': '" +
          LoadSettings.getUserID() +
          "','Notes':'" +
          notesController.text +
          "','TransDate':'" +
          dateController.text +
          "', 'ApplicationId':'" +
          appIDController.text +
          "'";
      print("{'Data':[{" + json + "}]}");
      // 'json': "{'Data':[{'Damage': '','EmployeeId': '000105','CreatedByEmployeeId': '000105','Explanation': '', 'ViolationDate': '30/06/2021','ViolationDateTime': '30/06/2021 18:00:23','ApplicationId': 'App14','ViolationType': 'Mentorship'}]}",
      //{'Data':[{'Damage':'dddsss','EmployeeId': '000105','CreatedByEmployeeId': '000105','Explanation':'www','ViolationDate':'29/07/2021','ViolationDateTime':'29/07/2021  03:43:33', 'ApplicationId':'App16','ViolationType': 'Mentorship'}]}
      Utilities.saveNewObject(LoadSettings.getCompanyName(),json, "createRequestWorkOrder")
          .then((body) async {
        var dbHelper = DB_Class();
        if (body == "timeout") {
          Maintenance newMaint = Maintenance(
            employee_name: LoadSettings.getUserName(),
            employee_id: LoadSettings.getUserID(),
            asset_id: assetid,
            object_id: objectid,
            asset_name: "",
            object_name: "",
            diagnostic_id: diagid,
            diagnostic_name: "",
            request_id: "",
            description: descController.text,
            notes: notesController.text,
            priority: priority_type,
            request_date: dateController.text,
            work_order: "",
            status: "",
            app_id: appIDController.text,

          );

          dbHelper.insertMaintenances(newMaint, "maintenance_local");
          Utilities.showToast(err, body.tr, fToast);
        } else {
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
            Utilities.showToast(err, msg, fToast);
          });

          if (!err) {
            await dbHelper.getAllMaintenances("maintenance");
            LoadSettings.setMaintenancesList(
                await dbHelper.maintenances("maintenance"));
          }
        }
        Future.delayed(Duration(seconds: 5)).then((value) => {
              setState(() {
                show = false;
                if (!err) {
                  Navigator.of(context).pushNamed('maintenance');
                }
              })
            });
      });
    }
  }
}
