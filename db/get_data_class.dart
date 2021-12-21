import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:developer';

import 'package:amana_foods_hr/classes/companies.dart';
import 'package:amana_foods_hr/classes/discipilinary.dart';
import 'package:amana_foods_hr/classes/leav_types.dart';
import 'package:amana_foods_hr/classes/leave.dart';
import 'package:amana_foods_hr/classes/maintenance.dart';
import 'package:amana_foods_hr/classes/payment.dart';
import 'package:amana_foods_hr/classes/service.dart';
import 'package:amana_foods_hr/classes/suggestion.dart';
import 'package:amana_foods_hr/pages/load_settings.dart';
import 'package:amana_foods_hr/util/app_constants.dart';
import 'package:http/http.dart' as http;

class Data_Class  {
  static void getDataLists() async {

    /*LoadSettings.setLeaveTypesList(await LoadSettings.getLeaveTypes());
    LoadSettings.setViolationtypes(await LoadSettings.getViolationTypes());
    LoadSettings.setObjectsList(await LoadSettings.getObjects());
    LoadSettings.setAssetsList(await LoadSettings.getAssets());
    LoadSettings.setDiagsList(await LoadSettings.getDiagnostics());
    LoadSettings.setVariousList(await LoadSettings.getVarious());*/

   /* */


    LoadSettings.setReportedToWorkersList(await  LoadSettings.getReportedToWorkers());
    LoadSettings.setAllWorkersList(LoadSettings.getAllWorkersList());

/*
    LoadSettings.setDiscpList(await getAllDiscp());
    LoadSettings.setDiscpManagerList(await getAllManagerDiscp());

    LoadSettings.setSuggestList(await getAllsuggestions());
    LoadSettings.setSuggestManagertList(await getAllManagersuggestions());

    LoadSettings.setPaymentstList(await getAllPayments());
    LoadSettings.setPaymentsManagertList(await getAllManagerPayments());

    LoadSettings.setLeavesList(await getAllLeaves());
    LoadSettings.setLeavesManagerList(await getAllManagerLeaves());

    LoadSettings.setMaintenancesList(await getAllMaintenances());
    LoadSettings.setMaintenancesManagerList(await getAllManagerMaintenances());

    LoadSettings.setServicesList(await getAllServices());
    LoadSettings.setServicesManagerList(await getAllManagerServices());


*/

  }

  /*********   Disciplinary   ***********/
  // A method that retrieves all the disciplinaries from the disciplinary table.
  static Future<List<Disciplinary>> getAllDiscp() async {
    List<Disciplinary> discpList= List<Disciplinary>();
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
        app_id: singleDiscp["ApplicationId"],
      );
      discpList.add(disp);

    }
    return discpList;
  }


  static Future<List<Disciplinary>> getAllManagerDiscp() async {
    List<Disciplinary> discpList= List<Disciplinary>();
    var url= LoadSettings.getServer()+"violation_Manager?company="+LoadSettings.getCompanyName()+"&workerId="+LoadSettings.getUserID();
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
        app_id: singleDiscp["ApplicationId"],
      );
      discpList.add(disp);

    }
    return discpList;
  }

  /*********   Disciplinary   END ***********/



  /*********   SuggestionCompliance   ***********/


  static Future  <List<SuggestionCompliance>>getAllsuggestions() async {
    List<SuggestionCompliance> complianceList= List<SuggestionCompliance>();

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
        app_id: singleSuggest["ApplicationId"],
      );
      complianceList.add(suggest);
    }
    return complianceList;

  }


  static Future  <List<SuggestionCompliance>>getAllManagersuggestions() async {
    List<SuggestionCompliance> complianceList= List<SuggestionCompliance>();

    var url= LoadSettings.getServer()+"compliments_Manager?company="+LoadSettings.getCompanyName()+"&workerId="+LoadSettings.getUserID();
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
        app_id: singleSuggest["ApplicationId"],
      );
      complianceList.add(suggest);
    }
    return complianceList;

  }

  /*********   SuggestionCompliance   END ***********/




  /*********   Advanced Payment   ***********/

  static Future <List<Payment>>getAllPayments() async {
    List<Payment> paymentList= List<Payment>();

    var url= LoadSettings.getServer()+"advanceOnSalary?company="+LoadSettings.getCompanyName()+"&workerId="+LoadSettings.getUserID();
    print("URL 1:"+url);
    var response = await http.get(Uri.parse(url),headers: {'Connection': "Keep-Alive"},);
    var responseBody = jsonDecode(response.body);
    responseBody=responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);

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
        app_id: singlePayment["ApplicationId"],
      );
      paymentList.add(payment);
    }

    return paymentList;
    /****************************/
  }

  static Future <List<Payment>>getAllManagerPayments() async {
    List<Payment> paymentList= List<Payment>();

    var url= LoadSettings.getServer()+"advanceOnSalary_Manager?company="+LoadSettings.getCompanyName()+"&workerId="+LoadSettings.getUserID();
    print("URL 1:"+url);
    var response = await http.get(Uri.parse(url),headers: {'Connection': "Keep-Alive"},);
    var responseBody = jsonDecode(response.body);
    responseBody=responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);

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
        app_id: singlePayment["ApplicationId"],
      );
      paymentList.add(payment);
    }

    return paymentList;
    /****************************/
  }
  /*********  Advanced Payment   EN  ***********/





  /*********  Leaves     ***********/

  static Future <List<Leave>>getAllLeaves() async {
    List<Leave> leavList= List<Leave>();

    var url= LoadSettings.getServer()+"leaveRequest?company="+LoadSettings.getCompanyName()+"&workerId="+LoadSettings.getUserID();
    print("URL 1:"+url);
    var response = await http.get(Uri.parse(url),headers: {'Connection': "Keep-Alive"},);
    var responseBody = jsonDecode(response.body);
    responseBody=responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);

    for (var singleLeave in responseBody) {

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
        employee_comments: singleLeave["Comments"],
        status: singleLeave["LeaveStatus"],
        app_id: singleLeave["ApplicationId"],
      );
      leavList.add(leave);
    }

    return leavList;

    /****************************/
  }

  static Future <List<Leave>>getAllManagerLeaves() async {
    List<Leave> leavList= List<Leave>();

    var url= LoadSettings.getServer()+"leaveRequest_Manager?company="+LoadSettings.getCompanyName()+"&workerId="+LoadSettings.getUserID();
    print("URL 1:"+url);
    var response = await http.get(Uri.parse(url),headers: {'Connection': "Keep-Alive"},);
    var responseBody = jsonDecode(response.body);
    responseBody=responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);

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
        employee_comments: singleLeave["Comments"],
        status: singleLeave["LeaveStatus"],
        app_id: singleLeave["ApplicationId"],
      );
      leavList.add(leave);
    }

    return leavList;

    /****************************/
  }
  /*********  Leaves   END  ***********/


  /*********  Maintenance     ***********/

  static Future <List<Maintenance>>getAllMaintenances() async {
    List<Maintenance> maintenList= List<Maintenance>();
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
        app_id: singleMaintenance["ApplicationId"],
      );
      maintenList.add(maintenance);
    }

    return maintenList;

    /****************************/
  }

  static Future <List<Maintenance>>getAllManagerMaintenances() async {
    List<Maintenance> maintenList= List<Maintenance>();
    var url= LoadSettings.getServer()+"maintenanceRequest_Manager?company="+LoadSettings.getCompanyName()+"&workerId="+LoadSettings.getUserID();
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
        app_id: singleMaintenance["ApplicationId"],
      );
      maintenList.add(maintenance);
    }

    return maintenList;

    /****************************/
  }
  /*********  Maintenance   END  ***********/

  /*********  Services     ***********/

  static Future <List<Services>>getAllServices() async {

    List<Services> serviceList= List<Services>();
    List<Lines> serviceLineList= List<Lines>();

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
        app_id: singleService["ApplicationId"],
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
        serviceLineList.add(line);
      }
      serviceList.add(service);
    }
    LoadSettings.setLinesList(serviceLineList);

    return serviceList;

    /****************************/
  }

  static Future <List<Services>>getAllManagerServices() async {

    List<Services> serviceList= List<Services>();
    List<Lines> serviceLineList= List<Lines>();

    var url= LoadSettings.getServer()+"purchaseRequisiton_Manager?company="+LoadSettings.getCompanyName()+"&workerId="+LoadSettings.getUserID();
    print("URL 1:"+url);
    var response = await http.get(Uri.parse(url),headers: {'Connection': "Keep-Alive"},);
    var responseBody = jsonDecode(response.body);
    responseBody=responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);



    //Creating a list to store input data;

    for (var singleService in responseBody) {
      int lineCounter=0;

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
        serviceLineList.add(line);
      }
      serviceList.add(service);
    }
    LoadSettings.setLinesManagerList(serviceLineList);

    return serviceList;

    /****************************/
  }
/*********  Services   END  ***********/





}
