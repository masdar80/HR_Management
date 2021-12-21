import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:developer';

import 'package:amana_foods_hr/classes/discipilinary.dart';
import 'package:amana_foods_hr/classes/leave.dart';
import 'package:amana_foods_hr/classes/maintenance.dart';
import 'package:amana_foods_hr/classes/payment.dart';
import 'package:amana_foods_hr/classes/service.dart';
import 'package:amana_foods_hr/classes/suggestion.dart';
import 'package:amana_foods_hr/pages/load_settings.dart';
import 'package:amana_foods_hr/util/app_constants.dart';
import 'package:flutter/widgets.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as io;
class DB_Class_old  {




  static void createTables() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    // String path = join('d:/temp/', 'demo.db');


    final database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'hr_db15.db'),
      // When the database is first created, create a table to store disciplinary.
      onCreate: (Database db, int version) async {
        // When creating the db, create the table

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
                     status TEXT)''');

        await db.execute(
            '''CREATE TABLE disciplinary (
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
                 employee_comments TEXT,
                 decision TEXT,
                 app_id TEXT,
                 isoffline TEXT default "no",
                 status TEXT)'''

        );

        await db.execute(
            '''CREATE TABLE leaves (
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
                 status TEXT)'''

        );

        await db.execute(
            '''CREATE TABLE adv_payment (
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
                 receipted TEXT,
                 app_id TEXT,
                 status TEXT)'''

        );

        await db.execute(
            '''CREATE TABLE maintenance (
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
                 status TEXT)'''

        );

        await db.execute(
            '''CREATE TABLE service (
                 request_id TEXT PRIMARY KEY,
                 employee_name TEXT,
                 job_title TEXT,
                 pr_name TEXT,
                 request_date datetime,
                 priority TEXT,
                 service_type TEXT,
                 product_type TEXT,
                 app_id TEXT,
                 status TEXT)'''

        );

        await db.execute(
            '''CREATE TABLE lines (
                 line_id int PRIMARY KEY,
                 request_id TEXT,
                 service_item_id TEXT,
                 service_item_name TEXT,
                 quantity real,
                 price real,
                 delivery_date TEXT,
                 app_id TEXT,
                 po_status TEXT)'''

        );

      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 4,
    );

    /*********   Disciplinary   ***********/
    // A method that retrieves all the disciplinaries from the disciplinary table.
    Future<List<Disciplinary>> discps() async {
      // Get a reference to the database.
      final db = await database;

      // Query the table for all The disciplinary.
      final List<Map<String, dynamic>> maps = await db.query('disciplinary');

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
          status: maps[i]['status'],
        );
      });
    }

    // Define a function that inserts Disciplinary into the database
    Future<void> insertDisciplinaries(Disciplinary disc) async {
      // Get a reference to the database.
      final db = await database;

      // Insert the Disciplinary into the correct table. You might also specify the
      // `conflictAlgorithm` to use in case the same Disciplinary is inserted twice.
      //
      // In this case, replace any previous data.
      await db.insert(
        'disciplinary',
        disc.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }




    Future getAllDiscp() async {
      //String IP=conf.getServerIP();
      //print("IP:"+IP);
      var url= LoadSettings.getServer()+"violation?company="+LoadSettings.getCompanyName()+"&workerId="+LoadSettings.getUserID();
      print("URL 1:"+url);
      var response = await http.get(Uri.parse(url),headers: {'Connection': "Keep-Alive"},);
      var responseBody = jsonDecode(response.body);
      responseBody=responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);

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
          status: singleDiscp["ViolationStatus"],
        );
        await insertDisciplinaries(disp);
      }



    }
    /*********   Disciplinary   END ***********/



    /*********   SuggestionCompliance   ***********/
    // A method that retrieves all the suggestions from the disciplinary table.
    Future<List<SuggestionCompliance>> suggestions() async {
      // Get a reference to the database.
      final db = await database;

      // Query the table for all The suggestions.
      final List<Map<String, dynamic>> maps = await db.query('suggestions');

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
          status: maps[i]['status'],
        );
      });
    }

    // Define a function that inserts SuggestionCompliance into the database
    Future<void> insertSuggestionCompliance(SuggestionCompliance suggestion) async {
      // Get a reference to the database.
      final db = await database;

      // Insert the SuggestionCompliance into the correct table. You might also specify the
      // `conflictAlgorithm` to use in case the same SuggestionCompliance is inserted twice.
      //
      // In this case, replace any previous data.
      await db.insert(
        'suggestions',
        suggestion.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }


    Future getAllsuggestions() async {
      //String IP=conf.getServerIP();
      //print("IP:"+IP);


      var url= LoadSettings.getServer()+"compliments?company="+LoadSettings.getCompanyName()+"&workerId="+LoadSettings.getUserID();
      print("URL 1:"+url);
      var response = await http.get(Uri.parse(url),headers: {'Connection': "Keep-Alive"},);
      var responseBody = jsonDecode(response.body);
      responseBody=responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);



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
        );
        await insertSuggestionCompliance(suggest);
      }


      /*test block to be deleted


      Disciplinary disp1 = Disciplinary(
        employee_name: "EployeeNae",
        employee_id: "EmployeeId",
        created_by: "CreatedBy",
        violation_id: "ViolationID",
        violation_name: "ViolationType",
        violation_date_time: "01-01-2021 11:55",
        explanation: "Explanation",
        damage_: "Damage",
        acceptance: "Reject",
        employee_comments: "Comments",
        decision: "CommitteeDecision",
        status: "ViolationStatus",
      );
      await insertDisciplinaries(disp1);
      ***************************/
    }

    /*********   SuggestionCompliance   END ***********/




    /*********   Advanced Payment   ***********/
    // A method that retrieves all the Payments from the Payment table.
    Future<List<Payment>> payemtns() async {
      // Get a reference to the database.
      final db = await database;

      // Query the table for all The Payments.
      final List<Map<String, dynamic>> maps = await db.query('adv_payment');

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
          receipted: maps[i]["receipted"],
        );
      });
    }

    // Define a function that inserts Payment into the database
    Future<void> insertPayments(Payment payment) async {
      // Get a reference to the database.
      final db = await database;

      // Insert the Payment into the correct table. You might also specify the
      // `conflictAlgorithm` to use in case the same Disciplinary is inserted twice.
      //
      // In this case, replace any previous data.
      await db.insert(
        'adv_payment',
        payment.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    Future getAllPayments() async {
      //String IP=conf.getServerIP();
      //print("IP:"+IP);


      var url= LoadSettings.getServer()+"advanceOnSalary?company="+LoadSettings.getCompanyName()+"&workerId="+LoadSettings.getUserID();
      print("URL 1:"+url);
      var response = await http.get(Uri.parse(url),headers: {'Connection': "Keep-Alive"},);
      var responseBody = jsonDecode(response.body);
      responseBody=responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);



      //Creating a list to store input data;

      for (var singlePayment in responseBody) {


        // Create a Dog and add it to the disciplinary table
        Payment payment = Payment(
          adv_pay_id: singlePayment["AdvancedSalaryID"],
          employee_name: singlePayment["EmployeeName"],
          employee_id: singlePayment["EmployeeId"],
          job_title: singlePayment["WorkerPosition"],
          employee_comments: singlePayment["EmployeeComments"],
          status: singlePayment["status"],
          req_mount: singlePayment["RequestedAmount"],
          accepted_amount: singlePayment["AmountAccepted"],
          hr_comments: singlePayment["HRComments"],
          hr_decision: singlePayment["HRDecision"],
          account_dep_comments: singlePayment["AccountingComments"],
          receipted: singlePayment["Receipted"],
        );
        await insertPayments(payment);
      }


      /****************************/
    }
    /*********  Advanced Payment   EN  ***********/





    /*********  Leaves     ***********/
    // A method that retrieves all the disciplinaries from the disciplinary table.
    Future<List<Leave>> leaves() async {
      // Get a reference to the database.
      final db = await database;

      // Query the table for all The disciplinary.
      final List<Map<String, dynamic>> maps = await db.query('leaves');

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
        );
      });
    }

    // Define a function that inserts Disciplinary into the database
    Future<void> insertLeaves(Leave leave) async {
      // Get a reference to the database.
      final db = await database;

      // Insert the Disciplinary into the correct table. You might also specify the
      // `conflictAlgorithm` to use in case the same Disciplinary is inserted twice.
      //
      // In this case, replace any previous data.
      await db.insert(
        'leaves',
        leave.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    Future getAllLeaves() async {
      //String IP=conf.getServerIP();
      //print("IP:"+IP);

      var url= LoadSettings.getServer()+"leaveRequest?company="+LoadSettings.getCompanyName()+"&workerId="+LoadSettings.getUserID();
      print("URL 1:"+url);
      var response = await http.get(Uri.parse(url),headers: {'Connection': "Keep-Alive"},);
      var responseBody = jsonDecode(response.body);
      responseBody=responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);



      //Creating a list to store input data;

      for (var singleLeave in responseBody) {


        // Create a Dog and add it to the disciplinary table
        Leave leave = Leave(
          employee_name: singleLeave["EmployeeName"],
          employee_id: singleLeave["EmployeeId"],
          leave_id: singleLeave["LeaveRequestID"],
          job_title: singleLeave["WorkerPosition"],
          from_date_time: singleLeave["FromDate"],
          to_date_time: singleLeave["ToDate"],
          direct_manager_comments: singleLeave["ManagerComments"],
          direct_manager_decision: singleLeave["ManagerDecision"],
          employee_comments: singleLeave["Comments"],
          status: singleLeave["ViolationStatus"],
        );
        await insertLeaves(leave);
      }


      /****************************/
    }
    /*********  Leaves   END  ***********/


    /*********  Maintenance     ***********/
    // A method that retrieves all the disciplinaries from the disciplinary table.
    Future<List<Maintenance>> maintenances() async {
      // Get a reference to the database.
      final db = await database;

      // Query the table for all The disciplinary.
      final List<Map<String, dynamic>> maps = await db.query('maintenance');

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
        );
      });
    }

    // Define a function that inserts Disciplinary into the database
    Future<void> insertMaintenances(Maintenance maintenance) async {
      // Get a reference to the database.
      final db = await database;

      // Insert the Disciplinary into the correct table. You might also specify the
      // `conflictAlgorithm` to use in case the same Disciplinary is inserted twice.
      //
      // In this case, replace any previous data.
      await db.insert(
        'maintenance',
        maintenance.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    Future getAllMaintenances() async {
      //String IP=conf.getServerIP();
      //print("IP:"+IP);

      var url= LoadSettings.getServer()+"maintenanceRequest?company="+LoadSettings.getCompanyName()+"&workerId="+LoadSettings.getUserID();
      print("URL 1:"+url);
      var response = await http.get(Uri.parse(url),headers: {'Connection': "Keep-Alive"},);
      var responseBody = jsonDecode(response.body);
      responseBody=responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);



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
        );
        await insertMaintenances(maintenance);
      }


      /****************************/
    }
    /*********  Maintenance   END  ***********/




    /*********  Services     ***********/
    // A method that retrieves all the disciplinaries from the disciplinary table.
    Future<List<Services>> services() async {
      // Get a reference to the database.
      final db = await database;

      // Query the table for all The disciplinary.
      final List<Map<String, dynamic>> maps = await db.query('service');

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
        );
      });
    }

    // Define a function that inserts services into the database
    Future<void> insertServices(Services services) async {
      // Get a reference to the database.
      final db = await database;

      // Insert the Disciplinary into the correct table. You might also specify the
      // `conflictAlgorithm` to use in case the same Disciplinary is inserted twice.
      //
      // In this case, replace any previous data.
      await db.insert(
        'service',
        services.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    // Define a function that inserts services into the database
    Future<void> insertServicesLines(Lines line) async {
      // Get a reference to the database.
      final db = await database;

      // Insert the Disciplinary into the correct table. You might also specify the
      // `conflictAlgorithm` to use in case the same Disciplinary is inserted twice.
      //
      // In this case, replace any previous data.
      await db.insert(
        'lines',
        line.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    Future getAllServices() async {
      //String IP=conf.getServerIP();
      //print("IP:"+IP);

      var url= LoadSettings.getServer()+"purchaseRequisiton?company="+LoadSettings.getCompanyName()+"&workerId="+LoadSettings.getUserID();
      print("URL 1:"+url);
      var response = await http.get(Uri.parse(url),headers: {'Connection': "Keep-Alive"},);
      var responseBody = jsonDecode(response.body);
      responseBody=responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);



      //Creating a list to store input data;

      for (var singleService in responseBody) {


        int lineCounter=0;
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
        );
        for(var singleLone in singleService["Lines"]){
          lineCounter++;
          Lines line=Lines(
            line_id: lineCounter,
            request_id: singleService["PurchReqId"],
            service_item_id: singleLone["ServiceItemID"],
            service_item_name: singleLone["ItemName"],
            quantity: singleLone["Quantity"],
            delivery_date: singleLone["DeliveryDate"],
            po_status: singleLone["POStatus"],
          );
          await  insertServicesLines(line);
        }
        await insertServices(service);
      }


      /****************************/
    }
    /*********  Services   END  ***********/


    await getAllDiscp();
    await getAllsuggestions();
    await getAllPayments();
    await getAllLeaves();
    await getAllMaintenances();
    await getAllServices();

/*


    LoadSettings.setDiscpList(await discps());
    LoadSettings.setSuggestList(await suggestions());
    LoadSettings.setPaymentstList(await payemtns());
    LoadSettings.setLeavesList(await leaves());
    LoadSettings.setMaintenancesList(await maintenances());*/

  }


}
