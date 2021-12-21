import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:amana_foods_hr/exceptions/app_exception.dart';
import 'package:amana_foods_hr/pages/load_settings.dart';
import 'package:amana_foods_hr/util/app_constants.dart';
import 'package:amana_foods_hr/util/preferences_manager.dart';
import 'package:amana_foods_hr/util/utilities.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//var baseUrl = PreferencesManager.getStringVal(AppConstants.SERVER_SETTING_KEY);
var baseUrl= LoadSettings.getServer();
class HttpUtils {
  static Future<http.Response> login(String username, String password) {
    var mainURL= LoadSettings.getServer();
    var url = mainURL + "login?workerId=$username&password=$password";
    return http.get(Uri.parse(url)).timeout(const Duration(seconds: AppConstants.CONNECTION_TIME_OUT_SECONDS), onTimeout: () {
      return login(username, password);
    });
  }

  static Future<http.Response> getApprovals({BuildContext context}) {
    String userId = PreferencesManager.getStringVal(AppConstants.USER_ID_KEY);
    var url = baseUrl + "getWorkItemList?userId=$userId&language=${PreferencesManager.getLanguageCode()}";
    return http.get(Uri.parse(url)).timeout(const Duration(seconds: AppConstants.CONNECTION_TIME_OUT_SECONDS), onTimeout: () {
      if (context != null) {
        Utilities.showSnackBar(context, "Couldn't connect to server", 4);
        return getApprovals(context: context);
      }
      return null;
    });
  }

  static Future<http.Response> getApprovalDetails(String userId, String workItem) {
    var url = baseUrl + "getWorkItem?userId=$userId&workItem=$workItem&language=${PreferencesManager.getLanguageCode()}";
    print("getting details for $url");
    return http.get(Uri.parse(url)).timeout(const Duration(seconds: AppConstants.CONNECTION_TIME_OUT_SECONDS), onTimeout: () {
      return getApprovalDetails(userId, workItem);
//      throw new FetchDataException("Couldn't connect to server");
    });
  }

  static Future<http.Response> getDelegateUsers() {
    var url = baseUrl + "/userList";
    return http.get(Uri.parse(url)).timeout(const Duration(seconds: AppConstants.CONNECTION_TIME_OUT_SECONDS), onTimeout: () {
      return getDelegateUsers();
//      throw new FetchDataException("Couldn't connect to server");
    });
  }

  static Future submitAction(String company, String workItem, String comment, String action, String toUserId) {
    String userId = PreferencesManager.getStringVal(AppConstants.USER_ID_KEY);
    comment = Uri.encodeComponent(comment);
    var url;
    if (action == 'Delegate') {
      url = baseUrl + "actionDelegate?company=$company&fromUserId=$userId&toUserId=$toUserId&workItem=$workItem&comment=$comment";
    } else if (action == 'RequestChange') {
      url = baseUrl + "actionChangeRequest?company=$company&fromUserId=$userId&toUserId=$toUserId&workItem=$workItem&comment=$comment";
    } else {
      url = baseUrl + "actionWorkflow?company=$company&userId=$userId&workItem=$workItem&comment=$comment&actionType=$action";
    }
    print("calling the following URL : $url");
    return http.get(url).timeout(const Duration(seconds: AppConstants.CONNECTION_TIME_OUT_SECONDS), onTimeout: () {
      throw new FetchDataException("Couldn't connect to server");
    });
  }

  static Future registerToken(String token) async {
   var url = baseUrl + "register";


   print("register token : $url");

   try{
     final response = await http.post(
       Uri.parse(url),
       headers: <String, String>{
         'Content-Type': 'application/json; charset=UTF-8',
       },
       body: jsonEncode(<String, String>{
         'workerId': LoadSettings.getUserID(),
         'token': token,
         'lamguage':LoadSettings.getLang(),

       }),
     ).timeout(const Duration(seconds: AppConstants.CONNECTION_TIME_OUT_SECONDS));
     return response.body;
   } on TimeoutException catch (_) {
     return "timeout";
   } on SocketException catch (_) {
     return "SocketException";
   }


  }

  static Future changePassword(String oldpass,String newpass) async {
    var url = baseUrl + "changePassword";

    try{
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'workerId': LoadSettings.getUserID(),
          'newPassword': newpass,
          'oldPassword':oldpass,

        }),
      ).timeout(const Duration(seconds: AppConstants.CONNECTION_TIME_OUT_SECONDS));
      return response.body;
    } on TimeoutException catch (_) {
      return "timeout";
    } on SocketException catch (_) {
      return "SocketException";
    }


  }

  static void notificationReceived(String message) {
//    String url = "https://en5uz7wx8b40xs0.m.pipedream.net?message=$message";
//    http.get(url).then((value) => null);
    //TODO:remove this method as it was used for debugging notification after releasing
  }
}
