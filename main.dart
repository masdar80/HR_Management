import 'dart:async';

import 'package:amana_foods_hr/pages/homepage.dart';
import 'package:amana_foods_hr/pages/load_settings.dart';
import 'package:amana_foods_hr/util/ScreenUtil.dart';
import 'package:amana_foods_hr/util/app_constants.dart';
import 'package:amana_foods_hr/util/preferences_manager.dart';
import 'package:amana_foods_hr/util/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'classes/companies.dart';
import 'db/db_class.dart';
import 'exceptions/app_exception.dart';
import 'login/Login.dart';
import 'package:amana_foods_hr/util/Settings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


//import'pa'

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PreferencesManager.getInstance();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.




  @override
  Widget build(BuildContext context) {
    if (PreferencesManager.getStringVal(AppConstants.SERVER_SETTING_KEY) == null) {
      PreferencesManager.setString(AppConstants.SERVER_SETTING_KEY, AppConstants.DEFAULT_SERVER);
    }
    return MaterialApp(

     // fallbackLocale: Locale('en'),

      debugShowCheckedModeBanner: false,
      title: 'AMANA HR',

      home: SplashScreen(),

    );
  }
}


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {

  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;


  static bool isoffline = false;
  @override
  void initState() {


    Setting conf= new Setting();



   // Utilities.showSnackBar(context, e.toString(), 4);

    //DB_Class.createTables();



    conf.loadUserID().then((value){

      if(value==null) {
        // print("SKATAAA:");
        LoadSettings.setUserID('');
        LoadSettings.setCashedLogin('0');
      }else
      {
        LoadSettings.setUserID(value);
        LoadSettings.setLastUserID(value);
      }


    });


    conf.loadUserComp().then((value){

      if(value==null) {
         print("SKATAAA:Company");

      }else
      {
        LoadSettings.setCompanyName(value);

      }


    });
    conf.loadServerIP().then((value){

      if(value==null) {
        print("SKATAAA:Server");

      }else
      {
        LoadSettings.setServer(value);

      }


    });


    conf.loadSelectedLang().then((value){

      if(value==null) {
       // print("SKATAAA:");
        LoadSettings.setLang('en');
      }


    });

   /* LoadSettings.getLeaveTypes().then((value) {
      LoadSettings.setLeaveTypesList(value);
    });*/
   /* LoadSettings.getViolationTypes().then((value) {
      LoadSettings.setViolationtypes(value);
    });
    LoadSettings.getVarious().then((value) {
      LoadSettings.setVariousList(value);
    });

    LoadSettings.getObjects().then((value) {
      LoadSettings.setObjectsList(value);
    });
    LoadSettings.getAssets().then((value) {
      LoadSettings.setAssetsList(value);
    });
    LoadSettings.getDiagnostics().then((value) {
      LoadSettings.setDiagsList(value);
    });

    LoadSettings.getProducts().then((value) {
      LoadSettings.setProductsList(value);
    });*/
//////////*****USE this Block just in case we want to return companies on load******///////
   /* LoadSettings.getAllCOmpanies(LoadSettings.getUserID()).then((value){

      if(value!=null) {
        // print("SKATAAA:");
        LoadSettings.setCompanyiesList(value);



        LoadSettings.getViolationTypes().then((value2){
          if(value2!=null) {
            LoadSettings.setViolationtypes(value2);
          }
        });

       Timer(Duration(seconds: 1),
                ()=>Navigator.pushReplacement(context,
                MaterialPageRoute(builder:
                    (context) =>

                    LoadSettings()

                )
            )
        );

      }
      else setState(() {

        isoffline=true;
      });


    });*/

///////////////////////********************//////////////////////////////

    Utilities.checkonline().then((body) async {

      if (body == "timeout") {


        LoadSettings.setOffline(true);
      }else
      {
        LoadSettings.setOffline(false);
      }
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder:
              (context) =>

              LoadSettings()

          )
      );
   
    });
    /*
    Timer(Duration(seconds: 1),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>

                LoadSettings()

            )
        )
    );*/












/*

    conf.loadServerIP().then((value) {
      LoadSettings.setServer(value);

      print("Server IP init:" + value);
    });


    conf.loadUserID().then((value) {
      LoadSettings.setUserID(value);

      print("user id:" + value);
    });
    conf.loadUserName().then((value) {
      LoadSettings.setUserName(value);

      print("user name:" + value);
    });
    conf.loadUserPass().then((value) {
      LoadSettings.setUserPass(value);

      print("user pass:" + value);
    });*/

    super.initState();
   // checkConnectivity();

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
    var msg = LoadSettings.getErrorMessage();
    return
      Container(

        child:ListView(children: <Widget>[
          isoffline?Utilities.errmsg(msg, true, true):Utilities.errmsg("Network Err", false, true),
       Container(
         height: screenHeight,
         color: Colors.white,
         child: Image.asset("assets/img/splash.png"),
       )
        ]),
    );
  }




}
