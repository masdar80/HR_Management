import 'dart:async';
import 'dart:convert';

import 'dart:io';

import 'package:amana_foods_hr/classes/assets.dart';
import 'package:amana_foods_hr/classes/companies.dart';
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
import 'package:amana_foods_hr/db/db_class.dart';
import 'package:amana_foods_hr/db/get_data_class.dart';
import 'package:amana_foods_hr/login/Login.dart';
import 'package:amana_foods_hr/pages/leaves/addLeave.dart';
import 'package:amana_foods_hr/pages/leaves/leaves_list.dart';
import 'package:amana_foods_hr/pages/maintenance/addMainenance.dart';
import 'package:amana_foods_hr/pages/maintenance/maintenances_list.dart';
import 'package:amana_foods_hr/pages/payments/addPayment.dart';
import 'package:amana_foods_hr/pages/payments/payments_list.dart';
import 'package:amana_foods_hr/pages/service/addService.dart';
import 'package:amana_foods_hr/pages/service/service_info.dart';
import 'package:amana_foods_hr/pages/service/services_list.dart';
import 'package:amana_foods_hr/pages/suggestion/addSuggestion.dart';
import 'package:amana_foods_hr/pages/suggestion/suggestions_list.dart';
import 'package:amana_foods_hr/pages/sync_notification.dart';
import 'package:amana_foods_hr/util/app_constants.dart';
import 'package:amana_foods_hr/util/utilities.dart';
import 'about.dart';
import 'disciplinary/addDisciplinary.dart';
import 'disciplinary/disciplinaries_list.dart';
import 'package:amana_foods_hr/pages/setup_page.dart';
import 'package:amana_foods_hr/util/Settings.dart';
import 'package:amana_foods_hr/util/translation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'homepage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoadSettings extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    print("First Load:");
    //_lang=Setting.getSelectedLang();
    print(_lang);
    print(_server);

    return ScreenUtilInit(
        designSize: Size(360, 690),
        builder: () => GetMaterialApp(
              translations: Translation(),
              locale: Locale(_lang),
              fallbackLocale: Locale('en'),
              debugShowCheckedModeBanner: false,
              title: 'AMANA HR',
              theme: ThemeData(
                  primaryColor: Color(0xFF64A70B),
                  textSelectionTheme: TextSelectionThemeData(
                    selectionColor: Color(0xFF4A7729),
                  ),
                  inputDecorationTheme: InputDecorationTheme(

                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    labelStyle: TextStyle(color: Colors.black),
                    hintStyle: TextStyle(color: Colors.grey),

                    /* prefixStyle: TextStyle(color: Colors.grey),
              suffixStyle: TextStyle(color: Colors.grey)*/
                  ),
                  primaryColorDark: Color(0xFF4A7729),
                  accentColor: Color(0xFF7A7C7A),
                  dividerColor: Color(0xFFD3D3D3),
                  hintColor: Color(0xFFa5a5a5),
                  backgroundColor: Color(0xFFCCf7f7),
                  fontFamily: 'SFProDisplay'),

              builder: (context, widget) {
                return MediaQuery(
                  //Setting font does not change with system font size
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: widget,
                );
              },

              home: (getUserID() == '') ? LoginPage() : HomePage(),
              routes: {
                'load': (context) {
                  return LoadSettings();
                },
                'homepage': (context) {
                  return HomePage();
                },
                'login': (context) {
                  return LoginPage();
                },
                'setup': (context) {
                  return SetupPage();
                },
                'sync': (context) {
                  return SyncNotification(AppConstants.TYPE_ALL);
                },
                'about': (context) {
                  return About();
                },
                'discplinaries': (context) {
                  return DisciplinariesList(AppConstants.TYPE_ALL);
                },
                'add_disciplinaries': (context) {
                  return AddDisciplinaries();
                },
                'suggestions': (context) {
                  return SuggestionsList(AppConstants.TYPE_ALL);
                },
                'add_suggestion': (context) {
                  return AddSuggestion();
                },
                'leaves': (context) {
                  return LeavesList(AppConstants.TYPE_ALL);
                },
                'add_leave': (context) {
                  return AddLeave();
                },
                'services': (context) {
                  return ServicesList(AppConstants.TYPE_ALL);
                },
                'add_service': (context) {
                  return AddService();
                },
                'service_info': (context) {
                  return Serviceinfo(AppConstants.TYPE_ALL);
                },
                'payments': (context) {
                  return PaymentsList(AppConstants.TYPE_ALL);
                },
                'add_payment': (context) {
                  return AddPayment();
                },
                'maintenance': (context) {
                  return MaintenancesList(AppConstants.TYPE_ALL);
                },
                'add_maintenance': (context) {
                  return AddMainenance();
                }
              }, //
            ));
  }


  /********  Discplinary ***************/
  static List<Disciplinary> _discpManagerList;

  static List<Disciplinary> getDiscpManagerList() {
    return _discpManagerList;
  }

  static void setDiscpManagerList(List<Disciplinary> value) {
    _discpManagerList = value;
  }


  static List<Disciplinary> _discpList;

  static List<Disciplinary> getDiscpList() {
    return _discpList;
  }

  static void setDiscpList(List<Disciplinary> value) {
    _discpList = value;
  }
  /********  Discplinary end ***************/




  /********  Suggestion ***************/

  static List<SuggestionCompliance> _suggestList;

  static List<SuggestionCompliance> getSuggestList() {
    return _suggestList;
  }

  static void setSuggestList(List<SuggestionCompliance> value) {
    _suggestList = value;
  }


  static List<SuggestionCompliance> _suggesManagertList;

  static List<SuggestionCompliance> getSuggestManagerList() {
    return _suggesManagertList;
  }

  static void setSuggestManagertList(List<SuggestionCompliance> value) {
    _suggesManagertList = value;
  }

  /********  Suggestion end***************/

  /********  Payment ***************/
  static List<Payment> _paymentstList;

  static List<Payment> getPaymentList() {
    return _paymentstList;
  }

  static void setPaymentstList(List<Payment> value) {
    _paymentstList = value;
  }

  static List<Payment> _paymentsManagertList;

  static List<Payment> getPaymentManagerList() {
    return _paymentsManagertList;
  }

  static void setPaymentsManagertList(List<Payment> value) {
    _paymentsManagertList = value;
  }

  /********  Payment end***************/

  /********  Leave ***************/
  static List<Leave> _leavesList;

  static List<Leave> getLeavesList() {
    return _leavesList;
  }

  static void setLeavesList(List<Leave> value) {
    _leavesList = value;
  }

  static List<Leave> _leavesManagerList;

  static List<Leave> getLeavesManagerList() {
    return _leavesManagerList;
  }

  static void setLeavesManagerList(List<Leave> value) {
    _leavesManagerList = value;
  }
  /********  Leave end ***************/

  /********  Maintenance ***************/
  static List<Maintenance> _maintenanceList;

  static List<Maintenance> getMaintenancesList() {
    return _maintenanceList;
  }

  static void setMaintenancesList(List<Maintenance> value) {
    _maintenanceList = value;
  }

  static List<Maintenance> _maintenanceManagerList;

  static List<Maintenance> getMaintenancesManagerList() {
    return _maintenanceManagerList;
  }

  static void setMaintenancesManagerList(List<Maintenance> value) {
    _maintenanceManagerList = value;
  }

  /********  Maintenance end***************/


  /********  Services ***************/
  static List<Services> _servicesList;

  static List<Services> getServicesList() {
    return _servicesList;
  }

  static void setServicesList(List<Services> value) {
    _servicesList = value;
  }


  static List<Services> _servicesManagerList;

  static List<Services> getServicesManagerList() {
    return _servicesManagerList;
  }

  static void setServicesManagerList(List<Services> value) {
    _servicesManagerList = value;
  }

  static List<Lines> _tempServiceLinesList;
  static List<Lines> get_tempServiceLinesList() {
    return _tempServiceLinesList;
  }

  static void set_tempServiceLinesList(List<Lines> value) {
    _tempServiceLinesList = value;
  }
  static void addItem_tempServiceLinesList(Lines newvalue) {
    _tempServiceLinesList.add(newvalue);
  }

  /********  Services end ***************/



  /********  Lines ***************/
  static List<Lines> _linesList;

  static List<Lines> getLinesList() {
    return _linesList;
  }

  static void setLinesList(List<Lines> value) {
    _linesList = value;
  }


  static List<Lines> _linesManagerList;
  static List<Lines> getLinesManagerList() {
    return _linesManagerList;
  }

  static void setLinesManagerList(List<Lines> value) {
    _linesManagerList = value;
  }
  /********  Lines end ***************/

/*********             Sync Errors             **********/

  static List<SyncError> _syncError;

  static List<SyncError> getSyncErrorList() {
    return _syncError;
  }

  static void setSyncErrorList(List<SyncError> value) {
    _syncError = value;
  }

  /**************************Reported Workers*********************************/
  static Future<List<User>> getReportedToWorkers() async {
    List<User> usersList = new List<User>();

    var url = LoadSettings.getServer() +"workers?workerId="+LoadSettings.getUserID();// This link doesn't work from backend yet
    print("URL 1:"+url);
    var response = await http.get(
      Uri.parse(url),
      headers: {'Connection': "Keep-Alive"},
    );
    var responseBody = jsonDecode(response.body);
    responseBody =
        responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);

    for (var singleUser in responseBody) {
      // Create a Dog and add it to the disciplinary table

        User obj = User(
          id:  singleUser["Id"],
          name : singleUser["Name"],
          def_company: singleUser["DefaultCompany"],
        );
        usersList.add(obj);
    }
    return usersList;
  }

  static List<User> _workersList;
  static List<User> getReportedToWorkersList() {
    return _workersList;
  }

  static void setReportedToWorkersList(List<User> value) {
    _workersList = value;
  }

  /**************************All Workers*********************************/

  static List<User> _allWorkersList;
  static List<User> getAllWorkersList() {
    return _allWorkersList;
  }

  static void setAllWorkersList(List<User> value) {
    _allWorkersList = value;
  }

  static String getCompanyByWorker(String workerid){
    User worker =
        _allWorkersList.firstWhere((element) =>
        element.id == workerid,
            orElse: () {
              return null;
            });
    return worker.def_company;
  }
/**************************Leave Types*********************************/
  static Future<List<LeaveTypes>> getLeaveTypes() async {
    List<LeaveTypes> leavesList = new List<LeaveTypes>();

    var url = LoadSettings.getServer() + "leaveType";
    print("URL 1:" + url);
    var response = await http.get(
      Uri.parse(url),
      headers: {'Connection': "Keep-Alive"},
    );
    var responseBody = jsonDecode(response.body);
    responseBody =
        responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);

    LeaveTypes selectleave = LeaveTypes(
      type_id: 'Select',
      decision: 'Select',
    );
    leavesList.add(selectleave);
    for (var singleLeavType in responseBody) {

        LeaveTypes com = LeaveTypes(
        type_id: singleLeavType["LeaveTypeID"],
        decision: singleLeavType["Description"],
        company: singleLeavType["Company"],
      );
      leavesList.add(com);

    }
    return leavesList;
  }

  static List<LeaveTypes> _leaveTypesList;
  static List<LeaveTypes> getLeaveTypesList() {
    return _leaveTypesList;
  }

  static void setLeaveTypesList(List<LeaveTypes> value) {
    _leaveTypesList = value;
  }

  /**************************Objects ID*********************************/
  static Future<List<Objects>> getObjects() async {
    List<Objects> objectsList = new List<Objects>();

    var url = LoadSettings.getServer() +"objects";
    var response = await http.get(
      Uri.parse(url),
      headers: {'Connection': "Keep-Alive"},
    );
    var responseBody = jsonDecode(response.body);
    responseBody =
        responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);

    for (var singleObject in responseBody) {
      // Create a Dog and add it to the disciplinary table
      if(singleObject["Company"]==LoadSettings.getCompanyName())
      {
        Objects obj = Objects(
        object_id: singleObject["ObjectId"],
        object_name: singleObject["Name"],
        company: singleObject["Company"],
      );
      objectsList.add(obj);}
    }
    return objectsList;
  }

  static List<Objects> _objectsList;
  static List<Objects> getObjectsList() {
    return _objectsList;
  }

  static void setObjectsList(List<Objects> value) {
    _objectsList = value;
  }


  /**************************Products*********************************/
  static Future<List<Product>> getProducts() async {
    List<Product> productsList = new List<Product>();

    var url = LoadSettings.getServer() +"product";
    var response = await http.get(
      Uri.parse(url),
      headers: {'Connection': "Keep-Alive"},
    );
    var responseBody = jsonDecode(response.body);
    responseBody =
        responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);

    for (var singleProduct in responseBody) {
      if(singleProduct["Company"]==LoadSettings.getCompanyName())
      {
        Product obj = Product(
          id: singleProduct["ItemID"],
          name: singleProduct["ItemName"],
          company: singleProduct["Company"],
        );
        productsList.add(obj);}
    }
    return productsList;
  }

  static List<Product> _productsList;
  static List<Product> getProductsList() {
    return _productsList;
  }

  static void setProductsList(List<Product> value) {
    _productsList = value;
  }

  /**************************Assets*********************************/
  static Future<List<Assets>> getAssets() async {
    List<Assets> assetsList = new List<Assets>();

    var url = LoadSettings.getServer() +"assets";
    var response = await http.get(
      Uri.parse(url),
      headers: {'Connection': "Keep-Alive"},
    );
    var responseBody = jsonDecode(response.body);
    responseBody =
        responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);

    for (var singleAsset in responseBody) {
      // Create a Dog and add it to the disciplinary table
      if(singleAsset["Company"]==LoadSettings.getCompanyName())
      {
        Assets asset = Assets(
          asset_id: singleAsset["AssetId"],
          object_id: singleAsset["ObjectId"],
          asset_name: singleAsset["AssetName"],
          company: singleAsset["Company"],
        );
        assetsList.add(asset);}
    }
    return assetsList;
  }

  static List<Assets> _assetsList;
  static List<Assets> getAssetsList() {
    return _assetsList;
  }

  static void setAssetsList(List<Assets> value) {
    _assetsList = value;
  }

  /**************************Diagnostics*********************************/
  static Future<List<Diagnostics>> getDiagnostics() async {
    List<Diagnostics> diagnosticsList = new List<Diagnostics>();

    var url = LoadSettings.getServer() +"diagnostics";
    var response = await http.get(
      Uri.parse(url),
      headers: {'Connection': "Keep-Alive"},
    );
    var responseBody = jsonDecode(response.body);
    responseBody =
        responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);

    for (var singleDiag in responseBody) {
      // Create a Dog and add it to the disciplinary table
      if(singleDiag["Company"]==LoadSettings.getCompanyName())
      {
        Diagnostics diag = Diagnostics(
          diag_id: singleDiag["DiagnosticsId"],
          diag_name: singleDiag["Name"],
          company: singleDiag["Company"],
        );
        diagnosticsList.add(diag);}
    }
    return diagnosticsList;
  }

  static List<Diagnostics> _diagsList;
  static List<Diagnostics> getDiagsList() {
    return _diagsList;
  }

  static void setDiagsList(List<Diagnostics> value) {
    _diagsList = value;
  }

  /**************************Various*********************************/
  static Future<List<VariousLists>> getVarious() async {
    List<VariousLists> objectsList = new List<VariousLists>();

    var url = LoadSettings.getServer() + "lists";
    print("URL 1:" + url);
    var response = await http.get(
      Uri.parse(url),
      headers: {'Connection': "Keep-Alive"},
    );
    var responseBody = jsonDecode(response.body);
    responseBody =
        responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);

    VariousLists  objReject = VariousLists(
      name: "reject",
      id: "Select",
      desc: "Select",
    );
    objectsList.add(objReject);

    objReject = VariousLists(
      name: "reject",
      id: "Yes",
      desc: "Yes",
    );
    objectsList.add(objReject);

    objReject = VariousLists(
      name: "reject",
      id: "No",
      desc: "No",
    );
   objectsList.add(objReject);
/*
     objReject = VariousLists(
      name: "ManagerDecision",
      id: "Select",
      desc: "Select",
    );
    objectsList.add(objReject);
    objReject = VariousLists(
      name: "ManagerDecision",
      id: "0",
      desc: "Open",
    );
    objectsList.add(objReject);

    objReject = VariousLists(
      name: "ManagerDecision",
      id: "1",
      desc: "Approved",
    );
    objectsList.add(objReject);

    objReject = VariousLists(
      name: "ManagerDecision",
      id: "2",
      desc: "Reject",
    );
    objectsList.add(objReject);*/

    for (var singleObject in responseBody) {
      // Create a Dog and add it to the disciplinary table
      VariousLists obj = VariousLists(
        name: singleObject["ListName"],
        id: singleObject["Id"],
        desc: singleObject["Description"],
      );
      objectsList.add(obj);
    }
    return objectsList;
  }

  static List<VariousLists> _variousList;

  static List<VariousLists> getVariousList() {
    return _variousList;
  }

  static void setVariousList(List<VariousLists> value) {
    _variousList = value;
  }

  /**************************Companies List*********************************/
  static List<Company> _companiesList;

  static List<Company> getCompanyiesList() {
    if(_companiesList==null)
      {
        _companiesList = new List<Company>();
        Company selectcom = Company(
        comp_id: 'Select',
        comp_name: 'Select',
      );
    _companiesList.add(selectcom);}
    return _companiesList;
  }

  static void setCompanyiesList(List<Company> value) {
    _companiesList = value;
  }

  /**************************Violation Types*********************************/
  static Future<List<ViolationType>> getViolationTypes() async {
    List<ViolationType> violationTypesList = new List<ViolationType>();

    var url = LoadSettings.getServer() +"violationType" ;
    print("URL 1:" + url);
    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {'Connection': "Keep-Alive"},
      );
      var responseBody = jsonDecode(response.body);
      responseBody =
          responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);

      ViolationType selectvio = ViolationType(
        id: 'Select',
        desc: 'Select',
      );
      violationTypesList.add(selectvio);
      for (var singlevio in responseBody) {
        // Create a Dog and add it to the disciplinary table
        if(singlevio["Company"]==LoadSettings.getCompanyName())
        {ViolationType vio = ViolationType(
          id: singlevio["ViolationType"],
          desc: singlevio["ViolationTypeDescription"],
        );
        violationTypesList.add(vio);}
      }
      return violationTypesList;
    } on TimeoutException catch (te) {
      setErrorMessage("Time out:" + te.message);
      return null;
    } on SocketException catch (se) {
      setErrorMessage("socket:" + se.osError.message);
      return null;
    }
  }
  static List<ViolationType> _violationTypes;

  static List<ViolationType> getViolationTypesList() {
    return _violationTypes;
  }

  static void setViolationtypes(List<ViolationType> value) {
    _violationTypes = value;
  }



  static Future<List<Company>> getAllUseCompanies(String user_id) async {
    List<Company> companiesList = new List<Company>();
    /**********THIS FUNCTION  must be edited in case we need to show companies list now on first run there is no user id************/
    var url = LoadSettings.getServer() + "companies?workerId="+user_id;
    print("URL 1:" + url);
    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {'Connection': "Keep-Alive"},
      ).timeout(const Duration(seconds: 10));
      var responseBody = jsonDecode(response.body);
      responseBody =
          responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);

      Company selectcom = Company(
        comp_id: 'Select',
        comp_name: 'Select',
      );
      companiesList.add(selectcom);

      /*  this loop was handled by masdar on 30-80-2020  cause there is no need now to load companies on load
      */for (var singleCompany in responseBody) {
        // Create a Dog and add it to the disciplinary table
        if(singleCompany["Id"]!=null)
        {  Company com = Company(
          comp_id: singleCompany["Id"],
          comp_name: singleCompany["Name"],
        );
        companiesList.add(com);}
      }
      return companiesList;
    } on TimeoutException catch (te) {
      setErrorMessage("Time out:" + te.message);
      return null;
    } on SocketException catch (se) {
      setErrorMessage("socket:" + se.osError.message);
      return null;
    }
  }


  static double _screen_width;
  static double getScreenWidth() {
    return _screen_width;
  }

  static void setScreenWidth(width) {
    _screen_width = width;
  }

  static double _screen_height;
  static double getScreenHeight() {
    return _screen_height;
  }

  static void setScreenHeight(height) {
    _screen_height = height;
  }

  static String _lang = 'en';
  static String getLang() {
    // print(" Getter here :"+_sl);

    return _lang;
  }

  static void setLang(lang) {
    _lang = lang;
  }

  /*Server*/

  static String _server = 'your API Services IP';

  //static String _server = '';
  static String getServer() {
    return _server;
  }

  static void setServer(server) {
    _server = server;
  }

  static String _error = 'generic error';
  static String getErrorMessage() {
    return _error;
  }

  static void setErrorMessage(error) {
    _error = error;
  }

  /*CashedLogin*/

  static String _cashedLogin = '0';
  static String getCashedLogin() {
    return _cashedLogin;
  }

  static void setCashedLogin(cashed) {
    _cashedLogin = cashed;
  }

  /*User ID*/

  static String _userid = '1';
  static String getUserID() {
    return _userid;
  }

  static void setUserID(userid) {
    _userid = userid;
  }

  /*Last User ID*/

  static String _lastuserid = '1';
  static String getLastUserID() {
    return _lastuserid;
  }

  static void setLastUserID(lastuserid) {
    _lastuserid = lastuserid;
  }

  /*User Name*/

  static String _username = '1';
  static String getUserName() {
    return _username;
  }

  static void setUserName(username) {
    _username = username;
  }

  /*User Password*/

  static String _userpass = '1';
  static String getUserPass() {
    return _userpass;
  }

  static void setUserPass(userpass) {
    _userpass = userpass;
  }


  /*User Deafult Company*/

  static String _defcompany= '1';
  static String getUserDefCompany() {
    return _defcompany;
  }

  static void setUserDefCompany(defcompany) {
    _defcompany = defcompany;
  }

  /*Is Logged In*/

  static String _islogedin = '1';
  static String getIsLoggedIn() {
    return _islogedin;
  }

  static void setLoggedIn(islogedin) {
    _islogedin = islogedin;
  }


  /*Is Offline*/

  static bool _isoffline = true;
  static bool getIsOfflinn() {
    return _isoffline;
  }

  static void setOffline(isoffline) {
    _isoffline = isoffline;
  }

  /*Company Name*/

  static String _company = '';

  static String getCompanyName() {

    return _company;
  }

  static void setCompanyName(company) {
    _company = company;
  }

  static void emptyAllDataLists()
  {
    LoadSettings.setDiscpManagerList(null);
    LoadSettings.setDiscpList(null);

    LoadSettings.setLeavesList(null);
    LoadSettings.setLeavesManagerList(null);

    LoadSettings.setPaymentstList(null);
    LoadSettings.setPaymentsManagertList(null);

    LoadSettings.setSuggestList(null);
    LoadSettings.setSuggestManagertList(null);

    LoadSettings.setMaintenancesList(null);
    LoadSettings.setMaintenancesManagerList(null);

    LoadSettings.setServicesList(null);
    LoadSettings.setSuggestManagertList(null);

    LoadSettings.setLinesList(null);
    LoadSettings.setLinesManagerList(null);
    
    LoadSettings.setReportedToWorkersList(null);
  }

  static void fetchData(BuildContext context, GlobalKey<State> _keyLoader,FToast fToast) async {
    try {


      var dbHelper = DB_Class();
     /* Utilities.checkonline().then((body) async {
        Utilities.showLoadingDialog(context, _keyLoader);
        if (body == "timeout") {
          Utilities.showToast(true, "offline".tr, fToast);
          await dbHelper.saveIntoLists();
        }else
        {
          await dbHelper.UploadData();
          await dbHelper.fetchData();
        }
        Navigator.of(_keyLoader.currentContext, rootNavigator: false).pop();
      });*/


        Utilities.showLoadingDialog(context, _keyLoader);
        if (LoadSettings.getIsOfflinn()) {
          Utilities.showToast(true, "offline".tr, fToast);
          await dbHelper.saveIntoLists();
        }else
        {
          await dbHelper.UploadData();
          await dbHelper.fetchData();
        }
      //await Future.delayed(Duration(milliseconds: 1000));
        Navigator.of(_keyLoader.currentContext, rootNavigator: false).pop();






    } catch (error) {
      print(error);
    }
  }

  static Future<bool> handleSubmit(BuildContext context, GlobalKey<State> _keyLoader) async {
    try {
      Utilities.showLoadingDialog(context, _keyLoader);

      var dbHelper = DB_Class();
      await dbHelper.fetchData();
      // await Data_Class.getDataLists();

      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

      return true;

    } catch (error) {
      print(error);
      return false;
    }
  }
 /* static void localhandleSubmit(BuildContext context, GlobalKey<State> _keyLoader) async {
    try {
      Utilities.showLoadingDialog(context, _keyLoader);
      var dbHelper = DB_Class();
      await dbHelper.saveIntoLists();
     // await Data_Class.getDataLists();

      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

    } catch (error) {
      print(error);
    }
  }*/
}
