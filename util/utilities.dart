import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:amana_foods_hr/exceptions/app_exception.dart';
import 'package:amana_foods_hr/pages/load_settings.dart';
import 'package:amana_foods_hr/util/ScreenUtil.dart';
import 'package:amana_foods_hr/util/app_constants.dart';
import 'package:amana_foods_hr/util/preferences_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utilities {
  static T castDynamic<T>(dynamic object, {T data}) {
    try {
      return object as T;
    } on TypeError catch (e) {
      print("couldn't cast");
    }
  }

  static Widget buildExpandedText(String data, {bool bold, Color textColor, int maxLines}) {
    return Expanded(
      child: Text(
        (data!=null?data:""),
        maxLines: maxLines != null ? maxLines : 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: textColor != null ? textColor : Colors.black54,
          fontSize: 14.sp,
          fontWeight: bold != null ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
  static Widget buildViewExpandedText(String data, int maxLines) {
    return Expanded(
      child: Text(
        data,
        maxLines: maxLines != null ? maxLines : 1,
        overflow: TextOverflow.ellipsis,
        style: ScreenUtils.getItemsDetailsTextstyle(),
      ),
    );
  }

  static Widget buildTableText(String data, {int maxLines, Color textColor, bool bold}) {
    return Text(
      data,
      maxLines: maxLines != null ? maxLines : 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: textColor != null ? textColor : Colors.black, fontSize: 15, fontWeight: bold != null ? FontWeight.bold : FontWeight.normal),
    );
  }

  static Padding buildRow(String label, String data) {
    return Padding(
      padding: EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "$label",
            style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          TextField(
            readOnly: true,
            controller: TextEditingController(
              text: data,
            ),
          ),
        ],
      ),
    );
  }


  static Padding buildViewRow(String label, String data) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5,10,5,10),
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10.sp),
            child: Text(
              "$label",
              style: ScreenUtils.getCardItemsTitleTextstyle(),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10.sp),
            child: Text(
              (data==null?"":data),
              style: ScreenUtils.getCardItemsDetailsTextstyle(),
            ),
          ),
          Divider(
            color: Color.fromRGBO(130, 130, 130,1),
            height: 1,
          ),
         // Utilities.buildExpandedText(data),

        ],
      ),
    );
  }

  static Padding buildViewCol(String label, String data) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5,10,5,10),
      child: Row(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              "$label",
              style: ScreenUtils.getCardItemsTitleTextstyle(),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              data,
              style: ScreenUtils.getCardItemsDetailsTextstyle(),
            ),
          ),

          // Utilities.buildExpandedText(data),

        ],
      ),
    );
  }

  static dynamic returnHttpResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        {
          var jsonResponse;
          try {
            jsonResponse = json.decode(response.body.toString());
          } on FormatException catch (e) {
            throw UnAuthorizedException(response.body.toString());
          }
          return jsonResponse;
        }
      case 400:
        {
          throw BadRequestException(response.body.toString());
        }
      case 401:
      case 403:
        {
          throw UnAuthorizedException(response.body.toString());
        }
      case 500:
        throw UnAuthorizedException("An error occurred while calling server");
    }
  }

  static void showSnackBar(BuildContext context, String message, int duration) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: new Duration(seconds: duration),
    ));
  }

  static void showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  static String generatAppID(String doc,String user)
  {
    return  doc+user+"_"+DateTime.now().year.toString()+DateTime.now().month.toString()+DateTime.now().day.toString()+DateTime.now().hour.toString()+DateTime.now().minute.toString()+DateTime.now().second.toString();

  }
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.black54,

                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(
                          color: ScreenUtils.GetMainColor(),
                        ),
                        SizedBox(height: 10,),
                        Text('load_msg'.tr,style: TextStyle(color: ScreenUtils.GetPrimaryColor()),)
                      ]),
                    )
                  ]));
        });
  }

  static void logout(BuildContext context) {
    PreferencesManager.setString(AppConstants.USER_ID_KEY, null);
    Navigator.of(context).pushReplacementNamed("/home");
  }
/*
  static dynamic parseJsonResponse(Iterable list, String documentType) {
    switch (documentType) {
      case AppConstants.TYPE_SALES:
        return list.map((e) => SalesOrder.fromJson(e)).toList().first;
      case AppConstants.TYPE_PURCHASE:
        return list.map((e) => PurchaseRequisition.fromJson(e)).toList().first;
      case AppConstants.TYPE_NON_CONFORMANCE:
        return list.map((e) => NonConformance.fromJson(e)).toList().first;
      case AppConstants.TYPE_PRICE_LIST:
        return list.map((e) => PriceList.fromJson(e)).toList().first;
    }
  }*/


  static Future<String> checkonline() async {

    String url= "http://188.247.90.187:81/HRTest/HR/login?workerId=1&password=1";
    try{
      var response = await http.get(
        Uri.parse(url),
        headers: {'Connection': "Keep-Alive"},
      ).timeout(const Duration(seconds: AppConstants.CONNECTION_TIME_OUT_SECONDS));
      return response.body;
    } on TimeoutException catch (_) {
      return "timeout";
    } on SocketException catch (_) {
      return "timeout";
    }

  }
  static Future<String> saveNewObject(String company,String json,String objectType) async {

    String url="";

      url='http://188.247.90.187:81/HRTest/HR/'+objectType;
try{
  final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'company': company,
        'json': "{'Data':[{"+json+"}]}",

      }),
    ).timeout(const Duration(seconds: AppConstants.CONNECTION_TIME_OUT_SECONDS));
  return response.body;
  } on TimeoutException catch (_) {
  return "timeout";
  } on SocketException catch (_) {
  return "timeout";
  }
/*String tst=response.body;
if(tst.contains("successfully"))
  print(tst);*/



  }
  //Set time to next hour with ZERO minutes and seconds
  static   DateTime roundupDateTime(DateTime d) {
     int deltaMinute;
      deltaMinute = 60 - d.minute;

    return d.add(Duration(
        milliseconds: -d.millisecond,
        // reset milliseconds to zero
        microseconds: -d.microsecond,
        // reset microseconds to zero,
        seconds: -d.second,
        // reset seconds to zero
        minutes: deltaMinute));
  }


  static Widget errmsg(String text,bool show,bool err){
    //error message widget.
    if(show == true){
      //if error is true then show error message box
      return Container(
        padding: EdgeInsets.all(10.00),
        margin: EdgeInsets.only(bottom: 10.00),
        width: ScreenUtils.GetAddPageContainerScreenWidth(),
        color: err?Colors.red:Colors.green,
        child: Row(children: [

          Container(
            margin: EdgeInsets.only(right:6.00),
            child: Icon(err?Icons.info:Icons.assignment_turned_in_outlined, color: Colors.white),
          ), // icon for error message

          Text(text, style: TextStyle(color: Colors.white,
              fontSize:ScreenUtils.GetHomePageFontSize())),
          //show error message text
        ]),
      );
    }else{
      return Container();
      //if error is false, return empty container.
    }
  }


 static showToast(bool err,String msg,FToast fToast) {

    fToast.showToast(
      child: Utilities.getToastNotification(err,msg),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 5),
    );
  }
  static showfirebaseNotificationToast(String title,String msg,FToast fToast) {

    fToast.showToast(

      child: Utilities.getFirebaseToastNotification(title,msg),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 10),
    );
  }
  static Widget getToastNotification(bool err,String msg){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: (err?Colors.yellow:Colors.green),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon((err?Icons.info_outline:Icons.check)),
          SizedBox(
            width: 14.0,
          ),
          Utilities.buildViewExpandedText(msg,3),
        ],
      ),
    );
  }

  static Widget getFirebaseToastNotification(String title,String msg){
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.green,
      ),
      child: Column(
      //  mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
              Icons.info_outline),

          Text(

            title,
            style: ScreenUtils.getCardItemsTitleTextstyle(),
          ),
          Utilities.buildViewExpandedText(msg,3),
        ],
      ),
    );
  }
}
