import 'dart:async';

import 'package:amana_foods_hr/classes/companies.dart';
import 'package:amana_foods_hr/classes/discipilinary.dart';
import 'package:amana_foods_hr/classes/user.dart';
import 'package:amana_foods_hr/db/db_class.dart';
import 'package:amana_foods_hr/exceptions/app_exception.dart';
import 'package:amana_foods_hr/pages/load_settings.dart';
import 'package:amana_foods_hr/util/HttpUtils.dart';
import 'package:amana_foods_hr/util/ScreenUtil.dart';
import 'package:amana_foods_hr/util/Settings.dart';
import 'package:amana_foods_hr/util/app_constants.dart';
import 'package:amana_foods_hr/util/notification.dart';
import 'package:amana_foods_hr/util/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';




class LoginPage extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  /*Connection check*/
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  FToast fToast;
  String company="Select";


  final serverIpController = TextEditingController();
  final usernameController = TextEditingController();
  final passController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  Setting conf= new Setting();

  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static bool flex_heigt=false;
  static bool isoffline = false;
  bool showServerField = false;
  String _username;
  String _password;
  List<DropdownMenuItem<String>> dropDownItems;

  @override
  Widget build(BuildContext context) {

    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

    LoadSettings.setScreenWidth(screenWidth)  ;
    LoadSettings.setScreenHeight(screenHeight)  ;
    dropDownItems=LoadSettings.getCompanyiesList().map((Company item) =>DropdownMenuItem<String>(child: Text(item.comp_id), value: item.comp_id)).toList();
    /*print("Screen Width:");
    print(screenWidth);
    print("Screen Height:");
    print(screenHeight);*/
    if (screenWidth < screenHeight) screenHeight = screenHeight * 0.50;
   // printScreenInformation();
    return WillPopScope(
        onWillPop: () async => false,
    child:Scaffold(
      appBar: AppBar(
        toolbarHeight: ScreenUtils.GetAppBarHeight(),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,size:  ScreenUtils.GetBarIconSize()),
          onPressed: () => SystemNavigator.pop(),
        ),
        backwardsCompatibility: true,

        title: Text("login".tr,style:  TextStyle(color: Colors.white,fontSize:21.sp)),



    centerTitle: true,
       // backgroundColor:  ScreenUtils.getAppColor(),
      ),
      body: Center(
        child: Container(
         // height: screenHeight / 0.2,
          //width: screenWidth / 1.05,

          child: Form(
            key:formKey,
            child: ListView(children: <Widget>[
              errmsg("noCon".tr, isoffline),
             Container(

                padding:  EdgeInsets.fromLTRB(0, 25, 0, 0),
                height: (screenHeight / 2.35),
                    child: Row(
                  children: [
                    Container(
                      width: ((screenWidth)/6),


                    ),

                    Container(
                      width: ((screenWidth )*2/3),

                      child: Image.asset(
                        "assets/img/logo.png",

                      ),
                    ),
                    Container(
                      width: ((screenWidth )/8),
                      alignment: (LoadSettings.getLang()=='ar'?Alignment.topLeft:Alignment.topRight),
                      child:IconButton(
                        icon: Image.asset("assets/icons/ic_action_connection25.png"),
                       // iconSize: 16.sp,

                        onPressed: () {
                          setState(() {
                            showServerField=!showServerField;

                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: (showServerField?(screenHeight/1):(screenHeight/1.25)),
                width: screenWidth/2,
                margin: EdgeInsets.fromLTRB(screenWidth / 20, screenHeight / 25, screenWidth / 20, screenHeight / 20),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  boxShadow:  [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 9,
                      offset: Offset(2, 3), // changes position of shadow
                    ),
                  ],
                  //border: Border.all(color: Colors.black, width: 2),
                  color: Colors.white70,

                ),
                child: ListView(children: buildInputs()),
              )
              //crossAxisAlignment: CrossAxisAlignment.stretch,
            ]),
          ),
        ),
      ),
    ));
  }

  @override
  void initState() {
    serverIpController.text=LoadSettings.getServer();


    super.initState();
    initConnectivity();
    fToast = FToast();
    fToast.init(context);

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);



  }


  @override
  void dispose() {
    serverIpController.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }


/*
  bool validateAndSave() {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }

    _showToast();
    return false;
  }*/


  /*_showToast() {

    fToast.showToast(
      child: Utilities.getToastNotification(true,"fillFields".tr),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }*/
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }
  /***************/
  static bool validateString(String value) {
    return (value.isEmpty || value=="Select")? false: true;
  }
  bool validateAndSave() {
    final FormState form = formKey.currentState;
    if (validateString(usernameController.text) && validateString(passController.text)&&validateString(serverIpController.text)) {
      conf.saveServerP(serverIpController.text);
      LoadSettings.setServer(serverIpController.text);
      return true;
    }
    Utilities.showToast(true, "fillFields".tr, fToast);
    //_showToast();
    return false;
  }

  Future<void> validateAndSubmit() async {


    Setting conf= new Setting();

    print('Connection Status: ${_connectionStatus.toString()}');
    if(_connectionStatus.toString()=='ConnectivityResult.none')
    {
      setState(() {
        isoffline=true;
      });
    }else{
      isoffline=false;
      //Navigator.of(context).pushNamed('homepage');
      if (validateAndSave()) {
        String username = usernameController.text;
        String password = passController.text;
        try {

          //serverIpController.text=LoadSettings.getServer();
         // LoadSettings.setServer(serverIpController.text);
          // PreferencesManager.setString(AppConstants.SERVER_SETTING_KEY, _currentServer);
          //Utilities.showLoaderDialog(context);
          try {
            HttpUtils.login(username, password).then((response) {
              try {
                Map<String, dynamic> responseBody = Utilities.returnHttpResponse(response);
                List<dynamic> userJson = responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);
                if (userJson[0]['id'] == 'Error') {
                 // Navigator.pop(context);
                  //Utilities.showSnackBar(context, userJson[0]['text'], 4);
                  Utilities.showToast(true,userJson[0]['text'],fToast);
                  //return;
                }
else
                {
                  User user = User.fromJson(userJson.first);
                  /*  these functions will be called on save functions from Setting Class
                  */LoadSettings.setUserID(user.id);
                  LoadSettings.setUserName(user.name);
                  LoadSettings.setUserPass(password);

                  LoadSettings.setCompanyName(user.def_company);
                  LoadSettings.setCashedLogin('1');
                  // print("Default Company:");
                  //  print(user.def_company);

                  Setting conf = new Setting();

                  conf.saveUserID(user.id);
                  conf.saveUserName(user.name);
                  conf.saveUserPass(password);
                  conf.saveUserComp(user.def_company);


                  // PreferencesManager.setString(AppConstants.USER_ID_KEY, username);
                  //Navigator.of(context).pop();
                  print('Signed in: $username');
                  //  _handleSubmit(context);
                /*  Show Load Before going to home page:
                 LoadSettings.handleSubmit(context, _keyLoader).then((value) =>

                     {
                   Navigator.of(context).pushNamedAndRemoveUntil( 'homepage', (Route<dynamic> route) => false)
                     }
                   );*/

                  LoadSettings.handleSubmit(context, _keyLoader);

                  Navigator.of(context).pushNamedAndRemoveUntil(
                      'homepage', (Route<dynamic> route) => false);


                }
                //  Navigator.of(context).pushNamed('homepage');
                //  Navigator.of(context).pushReplacementNamed("/approvals_list");
              } on Exception catch (e) {
                Navigator.pop(context);
                Utilities.showSnackBar(context, e.toString(), 4);
              }
            });
          } on UnAuthorizedException catch (ex) {
            Navigator.pop(context);
            Utilities.showSnackBar(context, ex.toString(), 4);
          }


          /* final String userId = "1"; //get id from backend;

          widget.onSignedIn();*/
        } catch (e) {
          print('Error: $e');
        }
      }else{

        setState(() {
          flex_heigt=true;
        });


      }
    }


  }
  void printScreenInformation() {
    print('Device width dp:${1.sw}dp');
    print('Device height dp:${1.sh}dp');
    print('Device pixel density:${ScreenUtil().pixelRatio}');
    print('Bottom safe zone distance dp:${ScreenUtil().bottomBarHeight}dp');
    print('Status bar height dp:${ScreenUtil().statusBarHeight}dp');
    print('The ratio of actual width to UI design:${ScreenUtil().scaleWidth}');
    print(
        'The ratio of actual height to UI design:${ScreenUtil().scaleHeight}');
    print('System font scaling:${ScreenUtil().textScaleFactor}');
    print('0.5 times the screen width:${0.5.sw}dp');
    print('0.5 times the screen height:${0.5.sh}dp');
    print('Screen orientation:${ScreenUtil().orientation}');
  }
   List<Widget> buildInputs() {
    return <Widget>[
      Container(
        //height: screenHeight/3.9 ,
        padding: EdgeInsets.fromLTRB(screenWidth/17,screenHeight/20,screenWidth/17,screenHeight/50),

        child: TextFormField(
          onChanged: _changerDropDownItems,

          style: TextStyle(fontSize:ScreenUtils.GetHomePageFontSize(),color: ScreenUtils.GetMainColor()),
          keyboardType: TextInputType.number,

          controller:usernameController,
          key: Key('username'),
          decoration: InputDecoration(

            contentPadding: EdgeInsets.all(16.sp),

              fillColor: Colors.white,
              filled: true,
              //isCollapsed: false,
              //labelText: 'username'.tr,
              hintText: 'username'.tr,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8.0),
              ),
              prefixIcon: Padding(
                  padding: EdgeInsets.all(6.sp),
                  child:Icon(
                Icons.account_circle,
                    color: Colors.grey,
                size: 18.sp,
              ))
          ),
          validator: UserNameFieldValidator.validate,
          onSaved: (String value) => _username = value,
        ),
      ),

      Container(
        //height: screenHeight/3.9 ,
        //padding: EdgeInsets.fromLTRB(screenWidth/10,screenHeight/25,screenWidth/10,screenHeight/25),
        padding: EdgeInsets.fromLTRB(screenWidth/17,screenHeight/27,screenWidth/17,screenHeight/18),
        //color: Colors.white,
        child: TextFormField(
          style: TextStyle(fontSize:ScreenUtils.GetHomePageFontSize(),color: ScreenUtils.GetMainColor()),

          controller:passController,
          key: Key('password'),
          decoration: InputDecoration(
            //hoverColor: Colors.red,
              contentPadding: EdgeInsets.all(16.sp),
              fillColor: Colors.white,
              filled: true,
             // isCollapsed: true,
              hintText: 'password'.tr,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8.0),
              ),
              prefixIcon:  Padding(
                  padding: EdgeInsets.all(6.sp),
                  child:Icon(Icons.lock_outline_rounded
              ,  color: Colors.grey,
                    size: 18.sp,))
          ),
          obscureText: true,
          validator: PasswordFieldValidator.validate,
          onSaved: (String value) => _password = value,
        ),
      ),
     Visibility(
     visible:false,
         child: Container(
     // height: screenHeight/7 ,
     margin: EdgeInsets.fromLTRB(screenWidth/16,0,screenWidth/16,screenWidth/25),
     padding: EdgeInsets.fromLTRB(20.sp,16.sp,10,12.sp),

     decoration: ShapeDecoration(
     color: Colors.white,

     shape: RoundedRectangleBorder(

     side: BorderSide(width: 0.0, style: BorderStyle.solid),
     borderRadius: BorderRadius.all(Radius.circular(5.0)),
     ),
     ),
     child:  DropdownButtonFormField(


     decoration: InputDecoration.collapsed(hintText: ""),
     key: Key('company'),
     validator: CompanyFieldValidator.validate,

     value: "Select",
     style: ScreenUtils.getItemsDetailsTextstyle(),


     //
     //
     items: dropDownItems,

////////////******Enable this when the COmpanies drop downlist is enabled******///////////
     /* onChanged: (value){
           company=value;

            LoadSettings.setCompanyName(value);

          },*/

     ),
     )),


      serverField(showServerField),
      Container(
        height: screenHeight / 8,
        //width: screenWidth / 15,
        padding: EdgeInsets.fromLTRB(screenWidth/5.5,0,screenWidth/5.5,0),
        child: RaisedButton(
        shape:RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)),


          key: Key('signIn'),
          color: Color(0xFF4A7729),
          textColor: Colors.white,
          child: Text('login'.tr, style: TextStyle(fontSize: 4+ScreenUtils.GetHomePageFontSize())),
          onPressed: validateAndSubmit,
        ),
      ),

    ];
  }


  Widget serverField(bool show){
    //error message widget.
    if(show == true){
      return Container(
        //height: screenHeight/5 ,
        //width: screenWidth / 20,
        padding: EdgeInsets.fromLTRB(screenWidth/17,0,screenWidth/17,screenHeight/20),
      //  padding: EdgeInsets.fromLTRB(screenWidth/17,screenHeight/27,screenWidth/17,screenHeight/13),

        //margin: EdgeInsets.fromLTRB(0,0,0,screenHeight/20),
        //color: Colors.red,
        child: TextFormField(
          style: TextStyle(fontSize: ScreenUtils.GetHomePageFontSize(),color: ScreenUtils.GetMainColor()),
          controller:serverIpController,
          key: Key('server'),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(16.sp),
              fillColor: Colors.white,
              filled: true,
              isCollapsed: false,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8.0),
              ),

          ),
          //obscureText: true,
          validator: ServerFieldValidator.validate,
          //onSaved: (String value) => _password = value,
        ),
      );
    }else{
      return Container();
      //if error is false, return empty container.
    }
  }



  // Error message if no connection
  Widget errmsg(String text,bool show){
    //error message widget.
    if(show == true){
      //if error is true then show error message box
      return Container(
        padding: EdgeInsets.all(10.00),
        margin: EdgeInsets.only(bottom: 10.00),
        color: Colors.red,
        child: Row(children: [

          Container(
            margin: EdgeInsets.only(right:6.00),
            child: Icon(Icons.info, color: Colors.white),
          ), // icon for error message

          Text(text, style: TextStyle(color: Colors.white)),
          //show error message text
        ]),
      );
    }else{
      return Container();
      //if error is false, return empty container.
    }
  }


  void _changerDropDownItems(String value) {

      LoadSettings.getAllUseCompanies(usernameController.text).then((value){

        if(value!=null) {
          // print("SKATAAA:");
          LoadSettings.setCompanyiesList(value);
          setState(() {dropDownItems=LoadSettings.getCompanyiesList().map((Company item) =>
              DropdownMenuItem<String>(
                  child: Text(item.comp_id), value: item.comp_id)).toList();});
        } });

  }
}

class UserNameFieldValidator {
  static String validate(String value) {

    if (value.isEmpty) {
      return '';
    } else {
      return null;
    }
  }
}

class PasswordFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'validate_pass'.tr : null;
  }
}

class CompanyFieldValidator {
  static String validate(String value) {
    return (value.isEmpty || value=="Select")? 'validate_company'.tr : null;
  }
}

class ServerFieldValidator {
  static String validate(String value) {
    return (value.isEmpty )? 'validate_server'.tr : null;
  }
}
