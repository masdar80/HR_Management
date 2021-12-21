import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:developer';

import 'package:amana_foods_hr/classes/assets.dart';
import 'package:amana_foods_hr/classes/diagnostics.dart';
import 'package:amana_foods_hr/classes/discipilinary.dart';
import 'package:amana_foods_hr/classes/leav_types.dart';
import 'package:amana_foods_hr/classes/leave.dart';
import 'package:amana_foods_hr/classes/maintenance.dart';
import 'package:amana_foods_hr/classes/objects.dart';
import 'package:amana_foods_hr/classes/payment.dart';
import 'package:amana_foods_hr/classes/products.dart';
import 'package:amana_foods_hr/classes/service.dart';
import 'package:amana_foods_hr/classes/suggestion.dart';
import 'package:amana_foods_hr/classes/syncError.dart';
import 'package:amana_foods_hr/classes/user.dart';
import 'package:amana_foods_hr/classes/various_lists.dart';
import 'package:amana_foods_hr/classes/violationTypes.dart';
import 'package:amana_foods_hr/pages/load_settings.dart';
import 'package:amana_foods_hr/util/Settings.dart';
import 'package:amana_foods_hr/util/app_constants.dart';
import 'package:amana_foods_hr/util/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as io;

class DB_Class {
  static Database _db;
  var newuser = false;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    //  io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(await getDatabasesPath(), "hr_db63.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    /*************** Setting Queries****************/

    await db.execute('''CREATE TABLE app_settings (
      serverip TEXT,
      lang TEXT,
      user_id  TEXT,
      lastuserid TEXT,
      username TEXT,
      userpass TEXT,
      islogedin TEXT
      )
    ''');
    await db.execute('''CREATE TABLE sync_errors (
      doc_id TEXT PRIMARY KEY,
      doc_type TEXT,
      error  TEXT,
      isManagerList TEXT,
      processType TEXT)
    ''');

    await db.execute('''CREATE TABLE various_list (
                 id TEXT ,
                 name TEXT,
                 desc TEXT,
                 PRIMARY KEY(id,name))''');

    await db.execute('''CREATE TABLE service_objects (
                 object_id TEXT PRIMARY KEY,
                 object_name TEXT,
                 company TEXT)''');

    await db.execute('''CREATE TABLE service_assets (
                 asset_id TEXT PRIMARY KEY,
                 object_id TEXT ,
                 asset_name TEXT ,
                 company TEXT)''');

    await db.execute('''CREATE TABLE service_diags (
                 diag_id TEXT PRIMARY KEY,
                 diag_name TEXT ,
                 company TEXT)''');

    await db.execute('''CREATE TABLE products (
                 id TEXT PRIMARY KEY,
                 name TEXT ,
                 unit TEXT ,
                 company TEXT)''');

    /******************END Setting Queries****************/

    /****************disciplinary queries*****************************/
    await db.execute('''CREATE TABLE disciplinary (
                 violation_id TEXT PRIMARY KEY,
                 violation_name TEXT,
                 employee_name TEXT,
                 employee_id TEXT,
                 created_by TEXT,
                 violation_date_time datetime,
                 violation_date date,
                 explanation TEXT,
                 damage_ TEXT,
                 acceptance TEXT,
                 appointment_date_time TEXT,
                 employee_comments TEXT,
                 decision TEXT,
                 penaltyType TEXT,
                 penaltyValue TEXT,
                 app_id TEXT,
                 editFlage TEXT,
                 employee_company TEXT,
                 status TEXT)''');
    await db.execute('''CREATE TABLE disciplinary_manager (
                 violation_id TEXT  PRIMARY KEY,
                 violation_name TEXT,
                 employee_name TEXT,
                 employee_id TEXT,
                 created_by TEXT,
                 violation_date_time datetime,
                 violation_date date,
                 explanation TEXT,
                 damage_ TEXT,
                 acceptance TEXT,
                 appointment_date_time TEXT,
                 employee_comments TEXT,
                 decision TEXT,
                 penaltyType TEXT,
                 penaltyValue TEXT,
                 app_id TEXT ,
                 editFlage TEXT,
                 employee_company TEXT,
                 status TEXT)''');

    await db.execute('''CREATE TABLE disciplinary_local (
                 violation_id TEXT ,
                 violation_name TEXT,
                 employee_name TEXT,
                 employee_id TEXT,
                 created_by TEXT,
                 violation_date_time datetime,
                 violation_date date,
                 explanation TEXT,
                 damage_ TEXT,
                 acceptance TEXT,
                 appointment_date_time TEXT,
                 employee_comments TEXT,
                 decision TEXT,
                 penaltyType TEXT,
                 penaltyValue TEXT,
                 app_id TEXT PRIMARY KEY,
                 employee_company TEXT,
                 comp TEXT,
                 status TEXT)''');
    await db.execute('''CREATE TABLE violationType (
                 id TEXT,
                 desc TEXT,
                 company TEXT,
                 allowcommittee TEXT,
                 PRIMARY KEY(id,company))''');

    await db.execute('''CREATE TABLE relatedWorkers (
                 id TEXT  PRIMARY KEY,
                 name TEXT,
                 def_company TEXT)''');

    await db.execute('''CREATE TABLE allWorkers (
                 id TEXT  PRIMARY KEY,
                 name TEXT,
                 def_company TEXT)''');
    /****************End disciplinary queries*****************************/

    /****************Suggestions queries*****************************/
    await db.execute('''
   CREATE TABLE suggestions (
                    compliant_id TEXT PRIMARY KEY,
                     employee_name TEXT,
                     employee_id TEXT,
                     job_title TEXT,
                     date_time datetime,
                     complain_suggestion TEXT,
                     compliant_about TEXT,
                     explanation TEXT,
                     compliant_against_name,
                     app_id TEXT,
                     alert_person TEXT,
                     appointment_date_time TEXT,
                     decision TEXT,
                     penalty_type TEXT,
                     penalty_value TEXT,
                     feedback_category TEXT,
                     alert_direct_manager TEXT,
                     status TEXT)''');
    await db.execute('''
   CREATE TABLE suggestions_local (
                    compliant_id TEXT,
                     employee_name TEXT,
                     employee_id TEXT,
                     job_title TEXT,
                     date_time datetime,
                     complain_suggestion TEXT,
                     compliant_about TEXT,
                     explanation TEXT,
                     compliant_against_name,
                     app_id TEXT PRIMARY KEY,
                     alert_person TEXT,
                     appointment_date_time TEXT,
                     decision TEXT,
                     penalty_type TEXT,
                     feedback_category TEXT,
                     penalty_value TEXT,
                     alert_direct_manager TEXT,
                     status TEXT)''');
    await db.execute('''
   CREATE TABLE suggestions_manager (
                    compliant_id TEXT PRIMARY KEY,
                     employee_name TEXT,
                     employee_id TEXT,
                     job_title TEXT,
                     date_time datetime,
                     complain_suggestion TEXT,
                     compliant_about TEXT,
                     explanation TEXT,
                     compliant_against_name,
                     app_id TEXT,
                     alert_person TEXT,
                     decision TEXT,
                     appointment_date_time TEXT,
                     penalty_type TEXT,
                     penalty_value TEXT,
                     feedback_category TEXT,
                     alert_direct_manager TEXT,
                     status TEXT)''');
    /****************End Suggestions queries*****************************/

    /****************Leave queries*****************************/
    await db.execute('''CREATE TABLE leaves (
                 leave_id TEXT PRIMARY KEY,
                 employee_name TEXT,
                 employee_id TEXT,
                 job_title TEXT,
                 leave_type_id TEXT,
                 from_date_time datetime,
                 to_date_time datetime,
                 employee_comments TEXT,
                 direct_manager_comments TEXT,
                 direct_manager_decision TEXT,
                 app_id TEXT,
                 editFlage TEXT,
                 status TEXT)''');

    await db.execute('''CREATE TABLE leaves_local (
                 leave_id TEXT,
                 employee_name TEXT,
                 employee_id TEXT,
                 job_title TEXT,
                 leave_type_id TEXT,
                 from_date_time datetime,
                 to_date_time datetime,
                 employee_comments TEXT,
                 direct_manager_comments TEXT,
                 direct_manager_decision TEXT,
                 app_id TEXT  PRIMARY KEY,
                 editFlage TEXT,
                 status TEXT)''');

    await db.execute('''CREATE TABLE leaves_manager (
                 leave_id TEXT PRIMARY KEY,
                 employee_name TEXT,
                 employee_id TEXT,
                 job_title TEXT,
                 leave_type_id TEXT,
                 from_date_time datetime,
                 to_date_time datetime,
                 employee_comments TEXT,
                 direct_manager_comments TEXT,
                 direct_manager_decision TEXT,
                 app_id TEXT  ,
                 editFlage TEXT,
                 status TEXT)''');

    await db.execute('''CREATE TABLE leaveTypes (
                 type_id TEXT PRIMARY KEY,
                 decision TEXT,
                 company TEXT)''');

    /****************END Leave queries *****************************/
    /****************Payment queries*****************************/
    await db.execute('''CREATE TABLE adv_payment (
                 adv_pay_id TEXT PRIMARY KEY,
                 employee_name TEXT,
                 employee_id TEXT,
                 job_title TEXT,
                 req_mount real,
                 accepted_amount real,
                 employee_comments TEXT,
                 hr_comments TEXT,
                 hr_decision TEXT,
                 account_dep_comments TEXT,
                 receipted INTEGER,
                 app_id TEXT,
                 status TEXT)''');
    await db.execute('''CREATE TABLE adv_payment_manager (
                 adv_pay_id TEXT PRIMARY KEY,
                 employee_name TEXT,
                 employee_id TEXT,
                 job_title TEXT,
                 req_mount real,
                 accepted_amount real,
                 employee_comments TEXT,
                 hr_comments TEXT,
                 hr_decision TEXT,
                 account_dep_comments TEXT,
                 receipted INTEGER,
                 app_id TEXT,
                 status TEXT)''');
    await db.execute('''CREATE TABLE adv_payment_local (
                 adv_pay_id TEXT ,
                 employee_name TEXT,
                 employee_id TEXT,
                 job_title TEXT,
                 req_mount real,
                 accepted_amount real,
                 employee_comments TEXT,
                 hr_comments TEXT,
                 hr_decision TEXT,
                 account_dep_comments TEXT,
                 receipted INTEGER,
                 app_id TEXT PRIMARY KEY,
                 status TEXT)''');

    /****************END Payment queries*****************************/

    /**************** Maintenance queries*****************************/
    await db.execute('''CREATE TABLE maintenance (
                 request_id TEXT PRIMARY KEY,
                 employee_name TEXT,
                 employee_id TEXT,
                 description TEXT,
                 request_date datetime,
                 object_id TEXT,
                 object_name TEXT,
                 asset_id TEXT,
                 asset_name TEXT,
                 diagnostic_id TEXT,
                 diagnostic_name TEXT,
                 notes TEXT,
                 work_order TEXT,
                 priority TEXT,
                 app_id TEXT,
                 status TEXT)''');
    await db.execute('''CREATE TABLE maintenance_manager (
                 request_id TEXT PRIMARY KEY,
                 employee_name TEXT,
                 employee_id TEXT,
                 description TEXT,
                 request_date datetime,
                 object_id TEXT,
                 object_name TEXT,
                 asset_id TEXT,
                 asset_name TEXT,
                 diagnostic_id TEXT,
                 diagnostic_name TEXT,
                 notes TEXT,
                 work_order TEXT,
                 priority TEXT,
                 app_id TEXT,
                 status TEXT)''');
    await db.execute('''CREATE TABLE maintenance_local (
                 request_id TEXT ,
                 employee_name TEXT,
                 employee_id TEXT,
                 description TEXT,
                 request_date datetime,
                 object_id TEXT,
                 object_name TEXT,
                 asset_id TEXT,
                 asset_name TEXT,
                 diagnostic_id TEXT,
                 diagnostic_name TEXT,
                 notes TEXT,
                 work_order TEXT,
                 priority TEXT,
                 app_id TEXT PRIMARY KEY,
                 status TEXT)''');

    /****************END Maintenance queries*****************************/

    /**************** Service queries*****************************/
    await db.execute('''CREATE TABLE service (
                 request_id TEXT PRIMARY KEY,
                 employee_name TEXT,
                 job_title TEXT,
                 pr_name TEXT,
                 request_date datetime,
                 priority TEXT,
                 service_type TEXT,
                 product_type TEXT,
                 app_id TEXT,
                 status TEXT)''');
    await db.execute('''CREATE TABLE service_manager (
                 request_id TEXT PRIMARY KEY,
                 employee_name TEXT,
                 job_title TEXT,
                 pr_name TEXT,
                 request_date datetime,
                 priority TEXT,
                 service_type TEXT,
                 product_type TEXT,
                 app_id TEXT,
                 status TEXT)''');
    await db.execute('''CREATE TABLE service_local (
                 request_id TEXT ,
                 employee_name TEXT,
                 job_title TEXT,
                 pr_name TEXT,
                 request_date datetime,
                 priority TEXT,
                 service_type TEXT,
                 product_type TEXT,
                 app_id TEXT PRIMARY KEY,
                 status TEXT)''');

    /****************Lines queries*****************************/
    await db.execute('''CREATE TABLE lines (
                 line_id int PRIMARY KEY,
                 request_id TEXT,
                 service_item_id TEXT,
                 service_item_name TEXT,
                 quantity real,
                 unit TEXT,
                 delivery_date TEXT,
                 po_status TEXT)''');
    await db.execute('''CREATE TABLE lines_manager (
                 line_id int PRIMARY KEY,
                 request_id TEXT,
                 service_item_id TEXT,
                 service_item_name TEXT,
                 quantity real,
                 unit TEXT,
                 delivery_date TEXT,
                 po_status TEXT)''');
    await db.execute('''CREATE TABLE lines_local (
                 line_id int ,
                 request_id TEXT,
                 service_item_id TEXT,
                 service_item_name TEXT,
                 quantity real,
                 unit TEXT,
                 delivery_date TEXT,
                 po_status TEXT,
                 PRIMARY KEY(line_id,request_id))''');
    /****************END Lines queries*****************************/

    /****************END Service queries*****************************/
  }

  void UploadData() async {
    UploadLocalSavedDiscp();
    UploadLocalSavedLeave();
    UploadLocalSavedFeeds();
    UploadLocalSavedPaymeny();
    UploadLocalSavedMainte();
    UploadLocalSavedService();
  }

  UploadLocalSavedDiscp() async {
    // Get a reference to the database.
    var dbClient = await db;
    String json = "";
    String process = "";
    String company="";

    final List<Map<String, dynamic>> maps =
        await dbClient.query("disciplinary_local");
    if (maps.length > 0)
      for (var obj in maps) {
        if (obj['editFlage'] == "yes") {
          json = "'Damage':'" +
              obj['damage_'] +
              "','ViolationID':'" +
              obj['violation_id'] +
              "','EmployeeId': '" +
              obj['employee_id'] +
              "','CreatedByEmployeeId': '" +
              obj['created_by'] +
              "','Explanation':'" +
              obj['explanation'] +
              "','ViolationDate':'" +
              obj['violation_date'] +
              "','Comments':'" +
              obj['employee_comments'] +
              "','CommitteeDecision':'" +
              obj['decision'] +
              "','PenaltyType':'" +
              obj['penaltyType'] +
              "','PenaltyValue':'" +
              obj['penaltyValue'] +
              "','Reject':'" +
              obj['acceptance'] +
              "','ViolationDateTime':'" +
              obj['violation_date_time'] +
              "','ViolationStatus':'" +
              obj['status'] +
              "', 'ApplicationId':'" +
              obj['app_id'] +
              "','ViolationType': '" +
              obj['violation_name'] +
              "'";
          process = "updateViolation";
          company=obj['employee_company'];

        } else {
          json = "'Damage':'" +
              obj['damage_'] +
              "','EmployeeId': '" +
              obj['employee_id'] +
              "','CreatedByEmployeeId': '" +
              obj['created_by'] +
              "','Explanation':'" +
              obj['explanation'] +
              "','ViolationDate':'" +
              obj['violation_date'] +
              "','ViolationDateTime':'" +
              obj['violation_date_time'] +
              "', 'ApplicationId':'" +
              obj['app_id'] +
              "','ViolationType': '" +
              obj['violation_name'] +
              "'";
          process = "createViolation";
         // company=LoadSettings.getAllWorkersList().where((i) => i.id==obj['employee_id']) .toList()[0].def_company;
          company=obj['employee_company'];
        }
        Utilities.saveNewObject(company,json, process).then((body) async {
          var responseBody = jsonDecode(body);
          responseBody =
              responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);
          if (body.contains("successfully")) {
            print("Local " + process + " Done");

          } else {
            print("ID:");
            print(responseBody[0]["id"]);
            SyncError newSE = SyncError(
                doc_id: obj['app_id'],
                doc_type: "violation".tr,
                error: responseBody[0]["text"],
                isManagerList: "no",
                processType: process);
            insertSyncErrorRecordInDB(newSE);
          }
          dbClient.delete("disciplinary_local",
              where: 'app_id = ?', whereArgs: [obj['app_id']]);
        });
      }
  }

  UploadLocalSavedLeave() async {
    // Get a reference to the database.
    var dbClient = await db;
    String json = "";
    String process = "";

    final List<Map<String, dynamic>> maps =
        await dbClient.query("leaves_local");
    if (maps.length > 0)
      for (var obj in maps) {
        if (obj['editFlage'] == "yes") {
          json = "'FromDateTime':'" +
              obj['from_date_time'] +
              "',"
                  "'ToDateTime': '" +
              obj['to_date_time'] +
              "',"
                  "'EmployeeId': '" +
              obj['employee_id'] +
              "',"
                  "'EmployeeComments':'" +
              obj['employee_comments'] +
              "',"
                  "'LeaveStatus':'" +
              obj['status'] +
              "',"
                  "'LeaveRequestID':'" +
              obj['leave_id'] +
              "',"
                  "'ManagerComments':'" +
              obj['direct_manager_comments'] +
              "',"
                  "'ManagerDecision':'" +
              obj['direct_manager_decision'] +
              "',"
                  "'ApplicationId':'" +
              obj['app_id'] +
              "',"
                  "'LeaveTypeId': '" +
              obj['leave_type_id'] +
              "'";
          process = "updateLeaveRequest";
        } else {
          json = "'FromDateTime':'" +
              obj['from_date_time'] +
              "',"
                  "'ToDateTime': '" +
              obj['to_date_time'] +
              "',"
                  "'EmployeeId': '" +
              obj['employee_id'] +
              "',"
                  "'EmployeeComments':'" +
              obj['employee_comments'] +
              "',"
                  "'ApplicationId':'" +
              obj['app_id'] +
              "',"
                  "'LeaveTypeId': '" +
              obj['leave_type_id'] +
              "'";
          process = "createLeaveRequest";
        }
        Utilities.saveNewObject(LoadSettings.getCompanyName(),json, process).then((body) async {
          var responseBody = jsonDecode(body);
          responseBody =
              responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);
          if (body.contains("successfully")) {
            print("Local " + process + " Done");

          } else {
            print("ID:");
            print(responseBody[0]["id"]);
            SyncError newSE = SyncError(
                doc_id: obj['app_id'],
                doc_type: "leave".tr,
                error: responseBody[0]["text"],
                isManagerList: obj['editFlage'],
                processType: process);
            insertSyncErrorRecordInDB(newSE);
          }
          dbClient.delete("leaves_local",
              where: 'app_id = ?', whereArgs: [obj['app_id']]);
        });
      }
  }

  UploadLocalSavedFeeds() async {
    // Get a reference to the database.
    var dbClient = await db;
    String json = "";
    String process = "createCompliment";

    final List<Map<String, dynamic>> maps =
        await dbClient.query("suggestions_local");
    if (maps.length > 0)
      for (var obj in maps) {
        json = "'EmployeeId_ComplaintAgainst': '" +
            obj['compliant_against_name'] +
            "'"
                ",'EmployeeId_CreatedBy':'" +
            obj['employee_id'] +
            "'"
                ",'ComplimentType':'" +
            obj['complain_suggestion'] +
            "'"
                ",'ComplimentAbout':'" +
            obj['compliant_about'] +
            "'"
                ",'Explanation':'" +
            obj['explanation'] +
            "'"
                ",'AlertDirectManager':'" +
            obj['alert_direct_manager'] +
            "'"
                ",'AlertPerson':'" +
            obj['alert_person'] +
            "'"
                ",'FeedbackCategory':'" +
            obj['feedback_category'] +
            "'"
                ",'ApplicationId':'" +
            obj['app_id'] +
            "'";

        Utilities.saveNewObject(LoadSettings.getCompanyName(),json, process).then((body) async {
          var responseBody = jsonDecode(body);
          responseBody =
              responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);
          if (body.contains("successfully")) {
            print("Local " + process + " Done");

          } else {
            print("ID:");
            print(responseBody[0]["id"]);
            SyncError newSE = SyncError(
                doc_id: obj['app_id'],
                doc_type: "sug_comp".tr,
                error: responseBody[0]["text"],
                isManagerList: "no",
                processType: process);
            insertSyncErrorRecordInDB(newSE);
          }
          dbClient.delete("suggestions_local",
              where: 'app_id = ?', whereArgs: [obj['app_id']]);
        });
      }
  }

  UploadLocalSavedPaymeny() async {
    // Get a reference to the database.
    var dbClient = await db;
    String json = "";
    String process = "createAdvanceOnSalary";

    final List<Map<String, dynamic>> maps =
        await dbClient.query("adv_payment_local");
    if (maps.length > 0)
      for (var obj in maps) {
        json = "'EmployeeId': '" +
            obj['employee_id'] +
            "','EmployeeComments': '" +
            obj['employee_comments'] +
            "','RequestedAmount':'" +
            obj['req_mount'].toString() +
            "','ApplicationId':'" +
            obj['app_id'] +
            "'";

        Utilities.saveNewObject(LoadSettings.getCompanyName(),json, process).then((body) async {
          var responseBody = jsonDecode(body);
          responseBody =
              responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);
          if (body.contains("successfully")) {
            print("Local " + process + " Done");

          } else {
            print("ID:");
            print(responseBody[0]["id"]);
            SyncError newSE = SyncError(
                doc_id: obj['app_id'],
                doc_type: "adv_payment".tr,
                error: responseBody[0]["text"],
                isManagerList: "no",
                processType: process);
            insertSyncErrorRecordInDB(newSE);
          }
          dbClient.delete("adv_payment_local",
              where: 'app_id = ?', whereArgs: [obj['app_id']]);
        });
      }
  }

  UploadLocalSavedMainte() async {
    // Get a reference to the database.
    var dbClient = await db;
    String json = "";
    String process = "createRequestWorkOrder";

    final List<Map<String, dynamic>> maps =
        await dbClient.query("maintenance_local");
    if (maps.length > 0)
      for (var obj in maps) {
        json = "'AssetId':'" +
            obj['asset_id'] +
            "','ObjectId': '" +
            obj['object_id'] +
            "','DiagnosticsId': '" +
            obj['diagnostic_id'] +
            "','RequestDescription': '" +
            obj['description'] +
            "','WorkOrderPriority': '" +
            obj['priority'] +
            "','RequesterId': '" +
            obj['employee_id'] +
            "','Notes':'" +
            obj['notes'] +
            "','TransDate':'" +
            obj['request_date'] +
            "', 'ApplicationId':'" +
            obj['app_id'] +
            "'";

        Utilities.saveNewObject(LoadSettings.getCompanyName(),json, process).then((body) async {
          var responseBody = jsonDecode(body);
          responseBody =
              responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);
          if (body.contains("successfully")) {
            print("Local " + process + " Done");

          } else {
            print("ID:");
            print(responseBody[0]["id"]);
            SyncError newSE = SyncError(
                doc_id: obj['app_id'],
                doc_type: "maintenance".tr,
                error: responseBody[0]["text"],
                isManagerList: "no",
                processType: process);
            insertSyncErrorRecordInDB(newSE);
          }
          dbClient.delete("maintenance_local",
              where: 'app_id = ?', whereArgs: [obj['app_id']]);
        });
      }
  }

  UploadLocalSavedService() async {
    // Get a reference to the database.
    var dbClient = await db;
    String json = "";
    String process = "createPurchReq";

    final List<Map<String, dynamic>> maps =
        await dbClient.query("service_local");
    if (maps.length > 0)
      for (var obj in maps) {
        /*json = "'PRName':'" +obj['pr_name'] +
            "','PurchasePriority': '" +obj['priority'] +
            "','ProductType': '" +obj['product_type'] +
            "','PurchaseType': '" +obj['service_type'] +
            "','Preparer': '" +obj['employee_name'] +
            "','RequestedDate':'" + obj['request_date'] +
            "', 'ApplicationId':'" +obj['app_id']+""
            "','Lines': [" +await getLocalLinesJson(obj['app_id'])+"]";
*/
        getLocalLinesJson(obj['app_id']).then((value) {
          json = "'PRName':'" +
              obj['pr_name'] +
              "','PurchasePriority': '" +
              obj['priority'] +
              "','ProductType': '" +
              obj['product_type'] +
              "','PurchaseType': '" +
              obj['service_type'] +
              "','Preparer': '" +
              obj['employee_name'] +
              "','RequestedDate':'" +
              obj['request_date'] +
              "', 'ApplicationId':'" +
              obj['app_id'] +
              ""
                  "','Lines': [" +
              value +
              "]";

          Utilities.saveNewObject(LoadSettings.getCompanyName(),json, process).then((body) async {
            var responseBody = jsonDecode(body);
            responseBody =
                responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);
            if (body.contains("successfully")) {
              print("Local " + process + " Done");

            } else {
              print("ID:");
              print(responseBody[0]["id"]);
              SyncError newSE = SyncError(
                  doc_id: obj['app_id'],
                  doc_type: "service".tr,
                  error: responseBody[0]["text"],
                  isManagerList: "no",
                  processType: process);
              insertSyncErrorRecordInDB(newSE);
            }
            dbClient.delete("lines_local",
                where: 'request_id = ?', whereArgs: [obj['app_id']]);
            dbClient.delete("service_local",
                where: 'app_id = ?', whereArgs: [obj['app_id']]);
          });
        });
      }
  }

  Future<String> getLocalLinesJson(String app_id) async {
    var dbClient = await db;
    String linesjson = "";
    int counter = 0;

    final List<Map<String, dynamic>> maps = await dbClient
        .query("lines_local", where: 'request_id = ?', whereArgs: [app_id]);
    if (maps.length > 0)
      for (var singleLine in maps) {
        linesjson += "{'ServiceItemID':'" +
            singleLine['service_item_id'] +
            "','Quantity': '" +
            singleLine['quantity'].toString() +
            "','DeliveryDate': '" +
            singleLine['delivery_date'] +
            "'}";
        counter++;
        if (counter < maps.length) linesjson += ",";
      }

    return linesjson;
  }

  /**********Setting List*******/
  /**********Sync Error*******/
  void insertSyncErrorRecordInDB(SyncError se) async {
    var dbClient = await db;

    await dbClient.insert(
      "sync_errors",
      se.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SyncError>> syncErrors() async {
    var dbClient = await db;
    // Query the table for all The disciplinary.
    final List<Map<String, dynamic>> maps =
        await dbClient.query("sync_errors");
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return SyncError(
          doc_id: maps[i]['doc_id'],
          doc_type: maps[i]['doc_type'],
          error: maps[i]['error'],
          isManagerList: maps[i]['isManagerList'],
          processType: maps[i]['processType']);
    });
  }
  /**********End Sync Error*******/

  /**********Various*******/
  void insertVariousRecordInDB(VariousLists vl) async {
    var dbClient = await db;

    await dbClient.insert(
      "various_list",
      vl.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<VariousLists>> various() async {
    var dbClient = await db;
    // Query the table for all The disciplinary.
    final List<Map<String, dynamic>> maps =
        await dbClient.query("various_list");
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return VariousLists(
        id: maps[i]['id'],
        name: maps[i]['name'],
        desc: maps[i]['desc'],
      );
    });
  }

  Future getVarious() async {
    var url = LoadSettings.getServer() + "lists";

    print("URL 1:" + url);

    var response = await http.get(
      Uri.parse(url),
      headers: {'Connection': "Keep-Alive"},
    );
    var responseBody = jsonDecode(response.body);
    responseBody =
        responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);
/*
    VariousLists objReject = VariousLists(
      name: "reject",
      id: "Select",
      desc: "Select",
    );
    insertVariousRecordInDB(objReject);
*/
    VariousLists objReject = VariousLists(
      name: "reject",
      id: "1",
      desc: "Yes",
    );
    insertVariousRecordInDB(objReject);

    objReject = VariousLists(
      name: "reject",
      id: "0",
      desc: "No",
    );
    insertVariousRecordInDB(objReject);

    for (var singleVarious in responseBody) {
      // Create a Dog and add it to the disciplinary table
      VariousLists obj = VariousLists(
        id: singleVarious["Id"],
        name: singleVarious["ListName"],
        desc: singleVarious["Description"],
      );
      insertVariousRecordInDB(obj);
    }
  }

  /**********Objects*******/
  void insertObjectRecordInDB(Objects obj) async {
    var dbClient = await db;

    await dbClient.insert(
      "service_objects",
      obj.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Objects>> objects() async {
    var dbClient = await db;
    // Query the table for all The disciplinary.
    final List<Map<String, dynamic>> maps =
        await dbClient.query("service_objects");
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Objects(
        object_id: maps[i]['object_id'],
        object_name: maps[i]['object_name'],
        company: maps[i]['company'],
      );
    });
  }

  Future getObjects() async {
    var url = LoadSettings.getServer() +
        "objects?company=" +
        LoadSettings.getCompanyName();

    print("URL 1:" + url);

    var response = await http.get(
      Uri.parse(url),
      headers: {'Connection': "Keep-Alive"},
    );
    var responseBody = jsonDecode(response.body);
    responseBody =
        responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);

    for (var singleObject in responseBody) {
      // Create a Dog and add it to the disciplinary table
      Objects obj = Objects(
        object_id: singleObject["ObjectId"],
        object_name: singleObject["Name"],
        company: singleObject["Company"],
      );
      insertObjectRecordInDB(obj);
    }
  }
  /**********Assets*******/

  void insertAssetRecordInDB(Assets obj) async {
    var dbClient = await db;

    await dbClient.insert(
      "service_assets",
      obj.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Assets>> assets() async {
    var dbClient = await db;
    // Query the table for all The disciplinary.
    final List<Map<String, dynamic>> maps =
        await dbClient.query("service_assets");
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Assets(
        asset_id: maps[i]['asset_id'],
        object_id: maps[i]['object_id'],
        asset_name: maps[i]['asset_name'],
        company: maps[i]['company'],
      );
    });
  }

  Future getAssets() async {
    var url = LoadSettings.getServer() +
        "assets?company=" +
        LoadSettings.getCompanyName();

    print("URL 1:" + url);

    var response = await http.get(
      Uri.parse(url),
      headers: {'Connection': "Keep-Alive"},
    );
    var responseBody = jsonDecode(response.body);
    responseBody =
        responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);

    for (var singleObject in responseBody) {
      // Create a Dog and add it to the disciplinary table
      Assets obj = Assets(
        asset_id: singleObject["AssetId"],
        object_id: singleObject["ObjectId"],
        asset_name: singleObject["AssetName"],
        company: singleObject["Company"],
      );
      insertAssetRecordInDB(obj);
    }
  }

  /**********Diagnostics*******/

  void insertDiagnosticRecordInDB(Diagnostics obj) async {
    var dbClient = await db;

    await dbClient.insert(
      "service_diags",
      obj.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Diagnostics>> diagnostics() async {
    var dbClient = await db;
    // Query the table for all The disciplinary.
    final List<Map<String, dynamic>> maps =
        await dbClient.query("service_diags");
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Diagnostics(
        diag_id: maps[i]['diag_id'],
        diag_name: maps[i]['diag_name'],
        company: maps[i]['company'],
      );
    });
  }

  Future getDiagnostics() async {
    var url = LoadSettings.getServer() +
        "diagnostics?company=" +
        LoadSettings.getCompanyName();

    print("URL 1:" + url);

    var response = await http.get(
      Uri.parse(url),
      headers: {'Connection': "Keep-Alive"},
    );
    var responseBody = jsonDecode(response.body);
    responseBody =
        responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);

    for (var singleObject in responseBody) {
      // Create a Dog and add it to the disciplinary table
      Diagnostics obj = Diagnostics(
        diag_id: singleObject["DiagnosticsId"],
        diag_name: singleObject["Name"],
        company: singleObject["Company"],
      );
      insertDiagnosticRecordInDB(obj);
    }
  }

  /**********Products*******/
  void insertProductRecordInDB(Product obj) async {
    var dbClient = await db;

    await dbClient.insert(
      "products",
      obj.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Product>> products() async {
    var dbClient = await db;
    // Query the table for all The disciplinary.
    final List<Map<String, dynamic>> maps = await dbClient.query("products");
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Product(
        id: maps[i]['id'],
        name: maps[i]['name'],
        unit: maps[i]['unit'],
        company: maps[i]['company'],
      );
    });
  }

  Future getProducs() async {
    var url = LoadSettings.getServer() +
        "product?company=" +
        LoadSettings.getCompanyName();

    print("URL 1:" + url);

    var response = await http.get(
      Uri.parse(url),
      headers: {'Connection': "Keep-Alive"},
    );
    var responseBody = jsonDecode(response.body);
    responseBody =
        responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);

    for (var singleObject in responseBody) {
      // Create a Dog and add it to the disciplinary table
      Product obj = Product(
        id: singleObject["ItemID"],
        name: singleObject["ItemName"],
        unit: singleObject["Unit"],
        company: singleObject["Company"],
      );
      insertProductRecordInDB(obj);
    }
  }

  /***********Leave Typers****************/
  void insertLeaveTypeRecordInDB(LeaveTypes lt) async {
    var dbClient = await db;

    await dbClient.insert(
      "leaveTypes",
      lt.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<LeaveTypes>> leaveTypes() async {
    var dbClient = await db;
    // Query the table for all The disciplinary.
    final List<Map<String, dynamic>> maps = await dbClient.query("leaveTypes");
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return LeaveTypes(
        type_id: maps[i]['type_id'],
        decision: maps[i]['decision'],
        company: maps[i]['company'],
      );
    });
  }

  Future getLeaveTypes() async {
    var url = LoadSettings.getServer() + "leaveType";
    print("URL 1:" + url);

    var response = await http.get(
      Uri.parse(url),
      headers: {'Connection': "Keep-Alive"},
    );
    var responseBody = jsonDecode(response.body);
    responseBody =
        responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);

    for (var singleLeavType in responseBody) {
      LeaveTypes lt = LeaveTypes(
        type_id: singleLeavType["LeaveTypeID"],
        decision: singleLeavType["Description"],
        company: singleLeavType["Company"],
      );
      insertLeaveTypeRecordInDB(lt);
    }
  }

  /***************Violation Types********************/
  void insertViolationTypeRecordInDB(ViolationType vt) async {
    var dbClient = await db;

    await dbClient.insert(
      "violationType",
      vt.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ViolationType>> ViolationTypes() async {
    var dbClient = await db;
    // Query the table for all The disciplinary.
    final List<Map<String, dynamic>> maps =
        await dbClient.query("violationType");
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return ViolationType(
        id: maps[i]['id'],
        desc: maps[i]['desc'],
        company: maps[i]['company'],
        allowcommittee: maps[i]['allowcommittee']
      );
    });
  }

  Future getViolationTypes() async {
    var url = LoadSettings.getServer() + "violationType";
    print("URL 1:" + url);

    var response = await http.get(
      Uri.parse(url),
      headers: {'Connection': "Keep-Alive"},
    );
    var responseBody = jsonDecode(response.body);
    responseBody =
        responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);

    for (var singlevio in responseBody) {
      // Create a Dog and add it to the disciplinary table
     // if (singlevio["Company"] == LoadSettings.getCompanyName()) {
        ViolationType vio = ViolationType(
          id: singlevio["ViolationType"],
          desc: singlevio["ViolationTypeDescription"],
          company: singlevio["Company"],
          allowcommittee: singlevio["AllowCommittee"],
        );
        insertViolationTypeRecordInDB(vio);

    }
  }

  /***************Related Woker********************/
  void insertRelatedWorkersRecordInDB(User vt) async {
    var dbClient = await db;

    await dbClient.insert(
      "relatedWorkers",
      vt.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<User>> workrs() async {
    var dbClient = await db;
    // Query the table for all The disciplinary.
    final List<Map<String, dynamic>> maps =
        await dbClient.query("relatedWorkers");
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        name: maps[i]['name'],
        def_company: maps[i]['def_company'],
      );
    });
  }

  Future getRealtedWorkers() async {
    var url = LoadSettings.getServer() +
        "workers?workerId=" +
        LoadSettings.getUserID();

    print("URL 1:" + url);

    var response = await http.get(
      Uri.parse(url),
      headers: {'Connection': "Keep-Alive"},
    );
    var responseBody = jsonDecode(response.body);
    responseBody =
        responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);

    for (var singleworker in responseBody) {
      // Create a Dog and add it to the disciplinary table
      User obj = User(
        id: singleworker["Id"],
        name: singleworker["Name"],
        def_company: singleworker["DefaultCompany"],
      );
      insertRelatedWorkersRecordInDB(obj);
    }
  }


  /********************All Workers ********************/
  void insertAllWorkersRecordInDB(User vt) async {
    var dbClient = await db;

    await dbClient.insert(
      "allWorkers",
      vt.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<List<User>> allworkers() async {
    var dbClient = await db;
    // Query the table for all The disciplinary.
    final List<Map<String, dynamic>> maps =
    await dbClient.query("allWorkers");
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        name: maps[i]['name'],
        def_company: maps[i]['def_company'],
      );
    });
  }

  Future<List<User>> getAllWorkers() async {
    var url = LoadSettings.getServer() + "allWorkers" ;

    print("URL 1:" + url);

    var response = await http.get(
      Uri.parse(url),
      headers: {'Connection': "Keep-Alive"},
    );
    var responseBody = jsonDecode(response.body);
    responseBody =
        responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);

    for (var singleworker in responseBody) {
      // Create a Dog and add it to the disciplinary table
      User obj = User(
        id: singleworker["Id"],
        name: singleworker["Name"],
        def_company: singleworker["DefaultCompany"],
      );
      insertAllWorkersRecordInDB(obj);
    }
  }
  //
  /**********End Setting List*******/

  /*********   Disciplinary   ***********/
  void insertDisciplinaries(Disciplinary disc, String tableName) async {
    // Get a reference to the database.

    var dbClient = await db;

    // print("save single vio: "+disc.app_id);
    // Insert the Disciplinary into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same Disciplinary is inserted twice.
    //
    // In this case, replace any previous data.
    await dbClient.insert(
      tableName,
      disc.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Disciplinary>> discps(String tableName) async {
    // Get a reference to the database.
    var dbClient = await db;

    // Query the table for all The disciplinary.
    final List<Map<String, dynamic>> maps = await dbClient.query(tableName);

    print("Save Vio List");
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Disciplinary(
        violation_id: maps[i]['violation_id'],
        employee_name: maps[i]['employee_name'],
        violation_name: maps[i]['violation_name'],
        employee_id: maps[i]['employee_id'],
        created_by: maps[i]['created_by'],
        violation_date_time: maps[i]['violation_date_time'],
        explanation: maps[i]['explanation'],
        damage_: maps[i]['damage_'],
        acceptance: maps[i]['acceptance'],
        employee_comments: maps[i]['employee_comments'],
        decision: maps[i]['decision'],
        appointment_date_time:maps[i]['appointment_date_time'],
        penaltyType:  maps[i]['penaltyType'],
        penaltyValue:  maps[i]['penaltyValue'],

        status: maps[i]['status'],
        app_id: maps[i]['app_id'],
        violation_date: maps[i]['violation_date'],
      );
    });
  }

  Future getAllDiscp(String tableName) async {
    //String IP=conf.getServerIP();
    //print("IP:"+IP);
    var url = (tableName == "disciplinary"
        ? LoadSettings.getServer() +
            "violation?workerId=" +
            LoadSettings.getUserID()
        : LoadSettings.getServer() +
            "violation_Manager?workerId=" +
            LoadSettings.getUserID());
    print("URL 1:" + url);
    var response = await http.get(
      Uri.parse(url),
      headers: {'Connection': "Keep-Alive"},
    );
    var responseBody = jsonDecode(response.body);
    responseBody =
        responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);

    //Creating a list to store input data;

    for (var singleDiscp in responseBody) {
      // Create a Disp and add it to the disciplinary table
      Disciplinary disp = Disciplinary(
        employee_name: singleDiscp["EmployeeName"],
        employee_id: singleDiscp["EmployeeId"],
        created_by: singleDiscp["CreatedBy"],
        violation_id: singleDiscp["ViolationID"],
        violation_name: singleDiscp["ViolationType"],
        violation_date_time: singleDiscp["ViolationDateTime"],
        explanation: singleDiscp["Explanation"],
        damage_: singleDiscp["Damage"],
        acceptance: singleDiscp["Reject"],
        employee_comments: singleDiscp["Comments"],
        decision: singleDiscp["CommitteeDecision"],
        penaltyValue: singleDiscp["PenaltyValue"],
        appointment_date_time: singleDiscp["AppointmentDateTime"],
        penaltyType: singleDiscp["PenaltyType"],
        status: singleDiscp["ViolationStatus"],
        editFlage: "",
        employee_company: "",
        app_id: singleDiscp["ApplicationId"],
        violation_date: singleDiscp["ViolationDate"],
      );
      insertDisciplinaries(disp, tableName);
    }
  }

  /*********   Disciplinary   END ***********/

  /*********   SuggestionCompliance   ***********/
  // A method that retrieves all the suggestions from the disciplinary table.
  Future<List<SuggestionCompliance>> suggestions(String tableName) async {
    // Get a reference to the database.
    var dbClient = await db;

    // Query the table for all The suggestions.
    final List<Map<String, dynamic>> maps = await dbClient.query(tableName);

    print("Save Suggest List");
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return SuggestionCompliance(
        compliant_id: maps[i]['compliant_id'],
        employee_name: maps[i]['employee_name'],
        employee_id: maps[i]['employee_id'],
        job_title: maps[i]['job_title'],
        date_time: maps[i]['date_time'],
        complain_suggestion: maps[i]['complain_suggestion'],
        compliant_about: maps[i]['compliant_about'],
        explanation: maps[i]['explanation'],
        compliant_against_name: maps[i]['compliant_against_name'],
        alert_direct_manager: maps[i]['alert_direct_manager'],
        alert_person: maps[i]['alert_person'],
        decision: maps[i]['decision'],
        appointment_date_time:maps[i]['appointment_date_time'],
        penalty_type: maps[i]['penalty_type'],
        penalty_value: maps[i]['penalty_value'],
        status: maps[i]['status'],
        feedback_category: maps[i]['feedback_category'],
        app_id: maps[i]['app_id'],
      );
    });
  }

  // Define a function that inserts SuggestionCompliance into the database
  void insertSuggestionCompliance(
      SuggestionCompliance suggestion, String tableName) async {
    // Get a reference to the database.
    var dbClient = await db;

    // Insert the SuggestionCompliance into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same SuggestionCompliance is inserted twice.
    //
    // In this case, replace any previous data.
    await dbClient.insert(
      tableName,
      suggestion.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future getAllsuggestions(String tableName) async {
    //String IP=conf.getServerIP();
    //print("IP:"+IP);

    var url = (tableName == "suggestions"
        ? LoadSettings.getServer() +
            "compliments?workerId=" +
            LoadSettings.getUserID()
        : LoadSettings.getServer() +
            "compliments_Manager?workerId=" +
            LoadSettings.getUserID());

    print("URL 1:" + url);
    var response = await http.get(
      Uri.parse(url),
      headers: {'Connection': "Keep-Alive"},
    );
    var responseBody = jsonDecode(response.body);
    responseBody =
        responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);

    //Creating a list to store input data;

    for (var singleSuggest in responseBody) {
      // Create a Dog and add it to the disciplinary table
      SuggestionCompliance suggest = SuggestionCompliance(
        employee_name: singleSuggest["EmployeeName"],
        employee_id: singleSuggest["EmployeeId"],
        compliant_id: singleSuggest["ComplimentID"],
        complain_suggestion: singleSuggest["ComplimentType"],
        compliant_about: singleSuggest["ComplimentAbout"],
        date_time: singleSuggest["ComplimentDateTime"],
        explanation: singleSuggest["Explanation"],
        compliant_against_name: singleSuggest["ComplaintAgainstEmployee"],
        job_title: singleSuggest["WorkerPosition"],
        status: singleSuggest["ComplimentStatus"],
        penalty_value:  singleSuggest["PenaltyValue"],
        penalty_type:  singleSuggest["PenaltyType"],
        alert_person:   singleSuggest["AlertPerson"],
        decision:singleSuggest["Desicion"],
        appointment_date_time: singleSuggest["AppointmentDateTime"],
        alert_direct_manager:  singleSuggest["AlertDirectManager"],
        feedback_category: singleSuggest["FeedbackCategory"],
        app_id: singleSuggest["ApplicationId"],
      );
      insertSuggestionCompliance(suggest, tableName);
    }
  }

  /*********   SuggestionCompliance   END ***********/

  /*********   Advanced Payment   ***********/
  // A method that retrieves all the Payments from the Payment table.
  Future<List<Payment>> payemtns(String tableName) async {
    // Get a reference to the database.
    var dbClient = await db;

    // Query the table for all The Payments.
    final List<Map<String, dynamic>> maps = await dbClient.query(tableName);

    print("Save payment List");
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Payment(
        adv_pay_id: maps[i]["adv_pay_id"],
        employee_name: maps[i]["employee_name"],
        employee_id: maps[i]["employee_id"],
        job_title: maps[i]["job_title"],
        employee_comments: maps[i]["employee_comments"],
        status: maps[i]["status"],
        req_mount: maps[i]["req_mount"],
        accepted_amount: maps[i]["accepted_amount"],
        hr_comments: maps[i]["hr_comments"],
        hr_decision: maps[i]["hr_decision"],
        account_dep_comments: maps[i]["account_dep_comments"],
        receipted: (maps[i]["receipted"] == 0 ? "false" : "true"),
        app_id: maps[i]["app_id"],
      );
    });
  }

  // Define a function that inserts Payment into the database
  void insertPayments(Payment payment, String tableName) async {
    // Get a reference to the database.
    var dbClient = await db;

    // Insert the Payment into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same Disciplinary is inserted twice.
    //
    // In this case, replace any previous data.
    await dbClient.insert(
      tableName,
      payment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future getAllPayments(String tableName) async {
    //String IP=conf.getServerIP();
    //print("IP:"+IP);

    var url = (tableName == "adv_payment"
        ? LoadSettings.getServer() +
            "advanceOnSalary?workerId=" +
            LoadSettings.getUserID()
        : LoadSettings.getServer() +
            "advanceOnSalary_Manager?workerId=" +
            LoadSettings.getUserID());
    print("URL 1:" + url);
    var response = await http.get(
      Uri.parse(url),
      headers: {'Connection': "Keep-Alive"},
    );
    var responseBody = jsonDecode(response.body);
    responseBody =
        responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);

    //Creating a list to store input data;

    for (var singlePayment in responseBody) {
      // Create a Dog and add it to the disciplinary table
      Payment payment = Payment(
        adv_pay_id: singlePayment["AdvancedSalaryID"],
        employee_name: singlePayment["EmployeeName"],
        employee_id: singlePayment["EmployeeId"],
        job_title: singlePayment["WorkerPosition"],
        employee_comments: singlePayment["EmployeeComments"],
        status: singlePayment["Status"],
        req_mount: singlePayment["RequestedAmount"],
        accepted_amount: singlePayment["AmountAccepted"],
        hr_comments: singlePayment["HRComments"],
        hr_decision: singlePayment["HRDecision"],
        account_dep_comments: singlePayment["AccountingComments"],
        receipted: singlePayment["Receipted"],
        app_id: singlePayment["ApplicationId"],
      );
      insertPayments(payment, tableName);
    }

    /****************************/
  }
  /*********  Advanced Payment   EN  ***********/

  /*********  Leaves     ***********/
  // A method that retrieves all the disciplinaries from the disciplinary table.
  Future<List<Leave>> leaves(String tableName) async {
    // Get a reference to the database.
    var dbClient = await db;

    // Query the table for all The disciplinary.
    final List<Map<String, dynamic>> maps = await dbClient.query(tableName);

    print("Save Leave List");
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Leave(
        employee_name: maps[i]["employee_name"],
        employee_id: maps[i]["employee_id"],
        leave_id: maps[i]["leave_id"],
        job_title: maps[i]["job_title"],
        from_date_time: maps[i]["from_date_time"],
        to_date_time: maps[i]["to_date_time"],
        direct_manager_comments: maps[i]["direct_manager_comments"],
        direct_manager_decision: maps[i]["direct_manager_decision"],
        employee_comments: maps[i]["employee_comments"],
        status: maps[i]["status"],
        app_id: maps[i]['app_id'],
        leave_type_id: maps[i]['leave_type_id'],
      );
    });
  }

  // Define a function that inserts Disciplinary into the database
  void insertLeaves(Leave leave, String tableName) async {
    // Get a reference to the database.
    final dbClient = await db;
    await dbClient.insert(
      tableName,
      leave.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future getAllLeaves(String tableName) async {
    //String IP=conf.getServerIP();
    //print("IP:"+IP);
    var url = (tableName == "leaves"
        ? LoadSettings.getServer() +
            "leaveRequest?workerId=" +
            LoadSettings.getUserID()
        : LoadSettings.getServer() +
            "leaveRequest_Manager?workerId=" +
            LoadSettings.getUserID());

    print("URL 1:" + url);
    var response = await http.get(
      Uri.parse(url),
      headers: {'Connection': "Keep-Alive"},
    );
    var responseBody = jsonDecode(response.body);
    responseBody =
        responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);

    //Creating a list to store input data;

    for (var singleLeave in responseBody) {
      // Create a Dog and add it to the disciplinary table
      Leave leave = Leave(
        employee_name: singleLeave["EmployeeName"],
        employee_id: singleLeave["EmployeeId"],
        leave_id: singleLeave["LeaveRequestID"],
        leave_type_id: singleLeave["LeaveTypeId"],
        job_title: singleLeave["WorkerPosition"],
        from_date_time: singleLeave["FromDate"],
        to_date_time: singleLeave["ToDate"],
        direct_manager_comments: singleLeave["ManagerComments"],
        direct_manager_decision: singleLeave["ManagerDecision"],
        employee_comments: singleLeave["Employee Comments"],
        status: singleLeave["LeaveStatus"],
        app_id: singleLeave["ApplicationId"],
      );
      insertLeaves(leave, tableName);
    }

    /****************************/
  }

  /*********  Leaves   END  ***********/

  /*********  Maintenance     ***********/
  // A method that retrieves all the disciplinaries from the disciplinary table.
  Future<List<Maintenance>> maintenances(String table) async {
    // Get a reference to the database.
    var dbClient = await db;

    // Query the table for all The disciplinary.
    final List<Map<String, dynamic>> maps = await dbClient.query(table);

    print("Save maint List");
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Maintenance(
        employee_name: maps[i]["employee_name"],
        employee_id: maps[i]["employee_id"],
        request_id: maps[i]["request_id"],
        description: maps[i]["description"],
        request_date: maps[i]["request_date"],
        object_id: maps[i]["object_id"],
        object_name: maps[i]["object_name"],
        asset_id: maps[i]["asset_id"],
        asset_name: maps[i]["asset_name"],
        diagnostic_id: maps[i]["diagnostic_id"],
        diagnostic_name: maps[i]["diagnostic_name"],
        notes: maps[i]["notes"],
        work_order: maps[i]["work_order"],
        priority: maps[i]["priority"],
        status: maps[i]["status"],
        app_id: maps[i]["app_id"],
      );
    });
  }

  // Define a function that inserts Disciplinary into the database
  Future<void> insertMaintenances(Maintenance maintenance, String table) async {
    // Get a reference to the database.
    var dbClient = await db;

    // Insert the Disciplinary into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same Disciplinary is inserted twice.
    //
    // In this case, replace any previous data.
    await dbClient.insert(
      table,
      maintenance.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future getAllMaintenances(String table) async {
    var url = (table == "maintenance"
        ? LoadSettings.getServer() +
            "maintenanceRequest?workerId=" +
            LoadSettings.getUserID()
        : LoadSettings.getServer() +
            "maintenanceRequest_Manager?workerId=" +
            LoadSettings.getUserID());

    print("URL 1:" + url);
    var response = await http.get(
      Uri.parse(url),
      headers: {'Connection': "Keep-Alive"},
    );
    var responseBody = jsonDecode(response.body);
    responseBody =
        responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);

    //Creating a list to store input data;

    for (var singleMaintenance in responseBody) {
      // Create a Dog and add it to the disciplinary table
      Maintenance maintenance = Maintenance(
        employee_name: singleMaintenance["RequesterName"],
        employee_id: singleMaintenance["RequesterId"],
        request_id: singleMaintenance["RequestID"],
        description: singleMaintenance["RequestDescription"],
        request_date: singleMaintenance["RequestMaintenanceDateTime"],
        object_id: singleMaintenance["ObjectId"],
        object_name: singleMaintenance["ObjectName"],
        asset_id: singleMaintenance["AssetId"],
        asset_name: singleMaintenance["AssetName"],
        diagnostic_id: singleMaintenance["Diagnostics"],
        diagnostic_name: singleMaintenance["DiagnosticsName"],
        notes: singleMaintenance["Notes"],
        work_order: singleMaintenance["WorkOrder"],
        priority: singleMaintenance["Priority"],
        status: singleMaintenance["OrderStatus"],
        app_id: singleMaintenance["ApplicationId"],
      );
      insertMaintenances(maintenance, table);
    }

    /****************************/
  }
  /*********  Maintenance   END  ***********/

  /*********  Services     ***********/
  // A method that retrieves all the disciplinaries from the disciplinary table.
  Future<List<Services>> services(String tableName) async {
    // Get a reference to the database.
    var dbClient = await db;

    // Query the table for all The disciplinary.
    final List<Map<String, dynamic>> maps = await dbClient.query(tableName);

    print("Save services List");
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Services(
        request_id: maps[i]["request_id"],
        employee_name: maps[i]["employee_name"],
        job_title: maps[i]["job_title"],
        pr_name: maps[i]["pr_name"],
        request_date: maps[i]["request_date"],
        priority: maps[i]["priority"],
        service_type: maps[i]["service_type"],
        product_type: maps[i]["product_type"],
        status: maps[i]["status"],
        app_id: maps[i]["app_id"],
      );
    });
  }

  Future<List<Lines>> servicesLines(String linesTable) async {
    // Get a reference to the database.
    var dbClient = await db;

    // Query the table for all The disciplinary.
    final List<Map<String, dynamic>> maps = await dbClient.query(linesTable);

    print("Save services List");
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Lines(
        line_id: maps[i]["line_id"],
        request_id: maps[i]["request_id"],
        service_item_id: maps[i]["service_item_id"],
        service_item_name: maps[i]["service_item_name"],
        quantity: maps[i]["quantity"],
        unit: maps[i]["unit"],
        delivery_date: maps[i]["delivery_date"],
        po_status: maps[i]["po_status"],
      );
    });
  }

  // Define a function that inserts services into the database
  void insertServices(Services services, String tableName) async {
    // Get a reference to the database.
    var dbClient = await db;

    // Insert the Disciplinary into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same Disciplinary is inserted twice.
    //
    // In this case, replace any previous data.
    await dbClient.insert(
      tableName,
      services.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Define a function that inserts services into the database
  Future<void> insertServicesLines(Lines line, String linesTable) async {
    // Get a reference to the database.
    var dbClient = await db;

    // Insert the Disciplinary into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same Disciplinary is inserted twice.
    //
    // In this case, replace any previous data.
    await dbClient.insert(
      linesTable,
      line.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future getAllServices(String tableName) async {
    var url = (tableName == "service"
        ? LoadSettings.getServer() +
            "purchaseRequisiton?workerId=" +
            LoadSettings.getUserID()
        : LoadSettings.getServer() +
            "purchaseRequisiton_Manager?workerId=" +
            LoadSettings.getUserID());

    print("URL 1:" + url);
    var response = await http.get(
      Uri.parse(url),
      headers: {'Connection': "Keep-Alive"},
    );
    var responseBody = jsonDecode(response.body);
    responseBody =
        responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);

    //Creating a list to store input data;

    int lineCounter = 0;
    for (var singleService in responseBody) {
      // Create a Dog and add it to the disciplinary table
      Services service = Services(
        request_id: singleService["PurchReqId"],
        employee_name: singleService["Preparer"],
        job_title: singleService["JobTitle"],
        pr_name: singleService["PRName"],
        request_date: singleService["RequestedDate"],
        priority: singleService["PurchasePriority"],
        service_type: singleService["PurchaseType"],
        product_type: singleService["ProductType"],
        status: singleService["RequisitionStatus"],
        app_id: singleService["ApplicationId"],
      );
      for (var singleLone in singleService["Lines"]) {
        lineCounter++;
        Lines line = Lines(
          line_id: lineCounter,
          request_id: singleService["PurchReqId"],
          service_item_id: singleLone["ServiceItemID"],
          service_item_name: singleLone["ItemName"],
          quantity: singleLone["Quantity"],
          unit: singleLone["Unit"],
          delivery_date: singleLone["DeliveryDate"],
          po_status: singleLone["POStatus"],
        );
        insertServicesLines(
            line, (tableName == "service" ? "lines" : "lines_manager"));
      }
      insertServices(service, tableName);
    }

    /****************************/
  }
  /*********  Services   END  ***********/

  void truncateTables() async {
    try{

      var dbClient = await db;
      await dbClient.transaction((txn) async {
        var batch = txn.batch();
        batch.delete("sync_errors");
        batch.delete("adv_payment");
        batch.delete("relatedWorkers");
        batch.delete("suggestions");
        batch.delete("suggestions_manager");
        batch.delete("suggestions_local");

        batch.delete("disciplinary_manager");
        batch.delete("disciplinary");
        batch.delete("disciplinary_local");

        batch.delete("leaves");
        batch.delete("leaves_manager");
        batch.delete("leaves_local");

        batch.delete("adv_payment");
        batch.delete("adv_payment_manager");
        batch.delete("adv_payment_local");

        batch.delete("maintenance");
        batch.delete("maintenance_manager");
        batch.delete("maintenance_local");

        batch.delete("service");
        batch.delete("service_manager");
        batch.delete("service_local");
        batch.delete("lines");
        batch.delete("lines_manager");
        batch.delete("lines_local");
        await batch.commit();
      });
    } catch(error){
      throw Exception('DbBase.cleanDatabase: ' + error.toString());
    }


  }

  Future  truncateErrorSyncs() async {
    try{

      var dbClient = await db;
      await dbClient.transaction((txn) async {
        var batch = txn.batch();
        batch.delete("sync_errors");
        await batch.commit();
      });
    } catch(error){
      throw Exception('DbBase.cleanDatabase: ' + error.toString());
    }
  }


  void fetchData() async {
    Setting conf = new Setting();
    String lastUser;
    conf.loadLastLoggedUserID().then((value) {
      if (value == null)
        lastUser = "";
      else
        lastUser = value;

      String newUser = LoadSettings.getUserID();
      if (lastUser=="" || (lastUser != "" && newUser != lastUser)) {
        truncateTables();
        LoadSettings.emptyAllDataLists();
        conf.saveLastLoggedUserID(newUser);
      }
    });

    await getViolationTypes();
    await getRealtedWorkers();
    await getAllWorkers();
    await getVarious();
    await getLeaveTypes();
    await getObjects();
    await getAssets();
    await getDiagnostics();
    await getProducs();

    await getAllsuggestions("suggestions");
    await getAllsuggestions("suggestions_manager");

    await getAllLeaves("leaves");
    await getAllLeaves("leaves_manager");

    await getAllDiscp("disciplinary_manager");
    await getAllDiscp("disciplinary");

    await getAllPayments("adv_payment");
    await getAllPayments("adv_payment_manager");

    await getAllMaintenances("maintenance");
    await getAllMaintenances("maintenance_manager");

    await getAllServices("service");
    await getAllServices("service_manager");

    await saveIntoLists();
  }

  void saveIntoLists() async {
    LoadSettings.setAllWorkersList(await allworkers());
    LoadSettings.setReportedToWorkersList(await workrs());
    LoadSettings.setViolationtypes(await ViolationTypes());
    LoadSettings.setLeaveTypesList(await leaveTypes());
    LoadSettings.setVariousList(await various());
    LoadSettings.setObjectsList(await objects());
    LoadSettings.setAssetsList(await assets());
    LoadSettings.setDiagsList(await diagnostics());
    LoadSettings.setProductsList(await products());
    LoadSettings.setSyncErrorList(await syncErrors());

    LoadSettings.setDiscpList(await discps("disciplinary"));
    LoadSettings.setDiscpManagerList(await discps("disciplinary_manager"));

    LoadSettings.setSuggestList(await suggestions("suggestions"));
    LoadSettings.setSuggestManagertList(
        await suggestions("suggestions_manager"));

    LoadSettings.setLeavesList(await leaves("leaves"));
    LoadSettings.setLeavesManagerList(await leaves("leaves_manager"));

    LoadSettings.setPaymentstList(await payemtns("adv_payment"));
    LoadSettings.setPaymentsManagertList(await payemtns("adv_payment_manager"));

    LoadSettings.setMaintenancesList(await maintenances("maintenance"));
    LoadSettings.setMaintenancesManagerList(
        await maintenances("maintenance_manager"));

    LoadSettings.setServicesList(await services("service"));
    LoadSettings.setServicesManagerList(await services("service_manager"));
    LoadSettings.setLinesList(await servicesLines("lines"));
    LoadSettings.setLinesManagerList(await servicesLines("lines_manager"));
  }
}
