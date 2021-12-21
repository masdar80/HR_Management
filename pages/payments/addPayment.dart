import 'dart:convert';

import 'package:amana_foods_hr/classes/payment.dart';
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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddPayment extends StatefulWidget {
  @override
  _AddPaymentState createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  FToast fToast;

  static bool show = false;
  static bool err = false;
  static String msg = "";
  DB_Class db = new DB_Class();

  final empIDController = TextEditingController();
  final empComment = TextEditingController();
  final reqAmount = TextEditingController();
  final appIDController = TextEditingController();
  @override
  void initState() {
    empIDController.text = LoadSettings.getUserID();
    appIDController.text =
        Utilities.generatAppID("Pay", LoadSettings.getUserID());
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
                    saveNewPayemnt();
                  },
                )),
          ],
          leading: Padding(
              padding: EdgeInsets.fromLTRB(8.sp, 0, 8.sp, 0),
              child: IconButton(
                icon: Icon(Icons.arrow_back,
                    color: Colors.white, size: ScreenUtils.GetBarIconSize()),
                onPressed: () => Navigator.of(context).pushNamed('payments'),
              )),
          title: Text("adv_payment_desc".tr,
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
                          // width: (screenWidth * 0.95),
                          margin: ScreenUtils.GetAddPageMargins(),
                          child: TextField(
                            controller: empComment,
                            keyboardType: TextInputType.text,
                            maxLines: 3,
                            style: ScreenUtils.getItemsDetailsTextstyle(),
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: 'emp_comment'.tr),
                          ),
                        ), //damage_result
                        Container(
                          // width: (screenWidth * 0.95),
                          margin: ScreenUtils.GetAddPageMargins(),
                          child: TextField(
                            controller: reqAmount,
                            keyboardType: TextInputType.number,
                            style: ScreenUtils.getItemsDetailsTextstyle(),
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: '_amount'.tr),
                          ),
                        ), //explanation
                       /* Container(
                          //width: (screenWidth * 0.95),
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

  void saveNewPayemnt() async {
    if (reqAmount.text == "") {
      Utilities.showToast(true, "fillFields".tr, fToast);
    } else {
      String json = "'EmployeeId': '" +
          LoadSettings.getUserID() +
          "','EmployeeComments': '" +
          empComment.text +
          "','RequestedAmount':'" +
          reqAmount.text +
          "','ApplicationId':'" +
          appIDController.text +
          "'";
      print("{'Data':[{" + json + "}]}");
      // 'json': "{'Data':[{'Damage': '','EmployeeId': '000105','CreatedByEmployeeId': '000105','Explanation': '', 'ViolationDate': '30/06/2021','ViolationDateTime': '30/06/2021 18:00:23','ApplicationId': 'App14','ViolationType': 'Mentorship'}]}",
      //{'Data':[{'Damage':'dddsss','EmployeeId': '000105','CreatedByEmployeeId': '000105','Explanation':'www','ViolationDate':'29/07/2021','ViolationDateTime':'29/07/2021  03:43:33', 'ApplicationId':'App16','ViolationType': 'Mentorship'}]}
      Utilities.saveNewObject(LoadSettings.getCompanyName(),json, "createAdvanceOnSalary").then((body) async {
        var dbHelper = DB_Class();
        if (body == "timeout") {
          Payment newPay = Payment(
            employee_name: LoadSettings.getUserName(),
            employee_id: LoadSettings.getUserID(),
            employee_comments: empComment.text,
            req_mount: reqAmount.text,
            accepted_amount: "",
            account_dep_comments: "",
            adv_pay_id: "",
            hr_comments: "",
            hr_decision: "",
            receipted: "",
            status: "",
            app_id: appIDController.text,
            job_title: "",
          );

          dbHelper.insertPayments(newPay, "adv_payment_local");
          Utilities.showToast(err, body.tr, fToast);
          Future.delayed(Duration(seconds: 3)).then((value) => {
                setState(() {
                  show = false;
                  Navigator.of(context).pushNamed('payments');
                })
              });
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
            await dbHelper.getAllPayments("adv_payment");
            LoadSettings.setPaymentstList(await dbHelper.payemtns("adv_payment"));
          }
        }

        Future.delayed(Duration(seconds: 5)).then((value) => {
          setState(() {
            show = false;
            if (!err) {
              Navigator.of(context).pushNamed('payments');
            }
          })
        });
      });
    }

//{\"Data\":\"Insert record successfully # Vio-000000045\"}
    //{\"Data\":[{\"id\":\"Error\",\"text\":\"Application Id hhhh already exist.\"}]}
  }


}
