import 'dart:async';
import 'dart:convert';

import 'package:amana_foods_hr/classes/main_menu.dart';
import 'package:amana_foods_hr/db/db_class.dart';
import 'package:amana_foods_hr/db/get_data_class.dart';
import 'package:amana_foods_hr/login/Login.dart';
import 'package:amana_foods_hr/model/approval_request.dart';
import 'package:amana_foods_hr/pages/load_settings.dart';
import 'package:amana_foods_hr/util/HttpUtils.dart';
import 'package:amana_foods_hr/util/Settings.dart';
import 'package:amana_foods_hr/util/ScreenUtil.dart';
import 'package:amana_foods_hr/util/app_constants.dart';
import 'package:amana_foods_hr/util/main_menu_list_item.dart';
import 'package:amana_foods_hr/util/preferences_manager.dart';
import 'package:amana_foods_hr/util/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'disciplinary/disciplinary_info.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
BuildContext globalContext;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void _initializeLocalNotification() async {
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('ic_launcher');

  final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (int id, String title, String body, String payload) async {
        print("ID : $id , Title : $title , BODY: $body , PAYLOAD: $payload");
      });

  final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  // await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: _onSelectNotification);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: _onSelectNotification);
}

Future _onSelectNotification(String payload) async {
  try {
    print("_onSelectNotification $payload");
    if (payload != null) {
      Map<String, dynamic> workItem = json.decode(payload)[0];
      ApprovalRequest request = ApprovalRequest.fromJson(workItem);
     /* if(request.transType=="Leave")
        Navigator.of(globalContext).push(MaterialPageRoute<void>(builder: (context) => DisciplinaryInfo(request.id)));*/
    }
  } on Exception catch (e) {
    print(e);
  }
}

Future<void> _myBackgroundMessageHandler(RemoteMessage message) async {
  print('on background $message');
  await Firebase.initializeApp();
  HttpUtils.notificationReceived("background notification : ${message.data}");
  if (message.data != null) {
    ApprovalRequest request = ApprovalRequest.fromJson(message.data);
    /*if(request.transType=="Leave")
      Navigator.of(globalContext).push(MaterialPageRoute<void>(builder: (context) => DisciplinaryInfo(request.id)));*/
  }
}
class _HomePageState extends State<HomePage> {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  List<MenuItem> _mainMenuItems = [];
  Setting conf = new Setting();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  FirebaseMessaging _firebaseMessaging;
  FToast fToast;
  _initializeFireBaseNotification() {
    _firebaseMessaging = FirebaseMessaging.instance;

    FirebaseMessaging.onBackgroundMessage(_myBackgroundMessageHandler);

    _firebaseMessaging.getInitialMessage().then((RemoteMessage message) {
      if (message != null && message.data != null) {
        HttpUtils.notificationReceived("background msg :: ${message.data}");
        ApprovalRequest request = ApprovalRequest.fromJson(message.data);
      /*  if(request.transType=="Leave")
          Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) => DisciplinaryInfo(request.id)));*/
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //IOS will catch the message and show the notification automatically
      print("new message received : ${message.notification.body}");
      print("new message received : ${message.notification.title}");
     // Utilities.showfirebaseNotificationToast(message.notification.title,message.notification.body,fToast);

      //print("After Toast");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message)  async {
      print("opened message : ${message.data}");
      ApprovalRequest request = ApprovalRequest.fromJson(message.data);
      await Future.delayed(Duration(milliseconds: 50));
      if(request.transType=="Leave") {
        LoadSettings.setDiscpList(await Data_Class.getAllDiscp());
        LoadSettings.setDiscpManagerList(await Data_Class.getAllManagerDiscp());
        //LoadSettings.setDiscpList(await Data_Class.getAllDiscp());
        //LoadSettings.setDiscpManagerList(await Data_Class.getAllManagerDiscp());
        Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (context) => DisciplinaryInfo(request.id)));
      }
    });

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      try {
        String oldToken = PreferencesManager.getStringVal(AppConstants.FIRE_BASE_TOKEN_KEY);
        if (oldToken != token) {
         print("now saving new token");
         HttpUtils.notificationReceived("token :: $token");
          HttpUtils.registerToken(token).then((value) {
            print("value returned from registering token : ${value}");
          });
        }
      } on Exception catch (e) {
        print(e.toString());
      }
      print("received token :: $token");
    });
  }

  Future<void> _showNotification(String title, String body, String jsonString) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('your channel id', 'your channel name', 'your channel description', importance: Importance.max, priority: Priority.high, ticker: 'ticker');
    const IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails();
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics, payload: jsonString);
  }

  void _requestIOSPermissions() async {
    NotificationSettings messagingSettings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      sound: true,
    );
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    print("Authorization Status : ${messagingSettings.authorizationStatus}");
  }



  @override
  Future<void> initState()  {

    super.initState();

   _initializeFireBaseNotification();
    _initializeLocalNotification();
    _requestIOSPermissions();
    AppConstants.MANAGER_VIEW="no";
    fToast = FToast();
    fToast.init(context);
   /* if( LoadSettings.getCashedLogin()=='0')
    {

      _showDialog();
    }*/

  }

  _showDialog() async {

   /* Utilities.checkonline().then((body) async {
      if (body == "timeout") {
        Utilities.showToast(true, "offline".tr, fToast);
        LoadSettings.localhandleSubmit(context, _keyLoader);
      }else
      {
        LoadSettings.handleSubmit(context, _keyLoader);
      }
    });*/
    LoadSettings.fetchData(context, _keyLoader,fToast);
    LoadSettings.setCashedLogin('1');





  }

  @override
  Widget build(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    // print ("screenWidth:");print (screenWidth);
    screenHeight = _mediaQueryData.size.height;
     print ("screenHeight:");print (screenHeight);

    _mainMenuItems = [
      MenuItem(id: 1, text: "punishment".tr, description:"punishment_list".tr, icon: MaterialCommunityIcons.account_alert),
      MenuItem(id: 2, text: "sug_comp".tr, description: "sug_comp_des".tr, icon: MaterialIcons.feedback),
      MenuItem(id: 3, text: "leave".tr, description: "leave_desc".tr, icon: MaterialIcons.card_travel),
      MenuItem(id: 4, text: "adv_payment".tr, description: "adv_payment_desc".tr, icon: MaterialIcons.payment),
      MenuItem(id: 5, text: "service".tr, description: "service_desc".tr, icon: FontAwesome.server),
      MenuItem(id: 6, text: "maintenance_desc".tr, description: "maintenance".tr, icon: MaterialCommunityIcons.toolbox),
      MenuItem(id: 7, text: "sync_notification".tr, description: "sync_notification".tr, icon: AntDesign.sync),
      MenuItem(id: 8, text: "setup_desc".tr, description: "setup".tr, icon: AntDesign.setting),
      MenuItem(id: 9, text: "abt_desc".tr, description: "abt".tr, icon:  MaterialIcons.info_outline),
    ];
    ScreenUtils.setWidth(screenWidth);

    ScreenUtils.setHeight(screenHeight);

/*
    if (screenWidth < screenHeight) screenHeight = screenHeight * 0.7;
    if (screenWidth > screenHeight) screenHeight = screenHeight * 0.7;

*/
    if( LoadSettings.getCashedLogin()=='0')
    {

      Future.delayed(Duration.zero, () => _showDialog());
    }


    return Scaffold(
        appBar: AppBar(
          toolbarHeight: ScreenUtils.GetAppBarHeight(),
          actions: [
            // action button
            Padding(
                padding: EdgeInsets.fromLTRB(8.sp,0,8.sp,0),
                child: IconButton(
              icon: Icon(
                Icons.power_settings_new,
                size: ScreenUtils.GetBarIconSize() ,
              ),
              onPressed: () {
                conf.saveUserID('');
                conf.saveUserName('');
                conf.saveUserPass('');
                conf.saveUserComp('');
                conf.saveLastLoggedUserID(LoadSettings.getUserID());

                //LoadSettings.emptyAllDataLists();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );

              },
            )),
          ],
          leading: Padding(
              padding: EdgeInsets.fromLTRB(8.sp,0,8.sp,0),
              child:IconButton(
              icon: Icon(
                Icons.sync,
                color: Colors.white,
                size: ScreenUtils.GetBarIconSize(),
              ),
              onPressed: () //=> Navigator.of(context).pushNamed('login'),
                  {

                    _showDialog();
               // LoadSettings.handleSubmit(context, _keyLoader);
              })),
          title: Text("hr".tr, style: ScreenUtils.geHeaderextstyle()),
          centerTitle: true,
          // backgroundColor:  ScreenUtils.getAppColor(),
        ),
        //drawer: MyDrawer(),
        body:Column(
          children: <Widget>[
            _mainMenuItems.length == 0
                ? Column(
              children: <Widget>[Text("noresult".tr)],
            )
                : Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return new GestureDetector(
                      onTap: () => _openMenuItem(_mainMenuItems[index]),
                      child: Column(
                        children: [
                          MainMenuItem(_mainMenuItems[index]),
                          Divider(
                            color: Color.fromRGBO(130, 130, 130, 1),
                            height: 1,
                          )
                        ],
                      ));
                },
                itemCount: _mainMenuItems.length,
              ),
            ),
          ],
        )

);
  }

  void _openMenuItem(MenuItem menuItem) {
    switch (menuItem.id) {
      case 1:
        Navigator.of(context).pushNamed('discplinaries');
        break;
      case 2:
        print("Showing purchases");
        Navigator.of(context).pushNamed('suggestions');
        break;
      case 3:
        Navigator.of(context).pushNamed('leaves');
        break;
      case 4:
        Navigator.of(context).pushNamed('payments');
        break;
      case 5:
        Navigator.of(context).pushNamed('services');
        break;
      case 6:
        Navigator.of(context).pushNamed('maintenance');
        break;
      case 7:
        Navigator.of(context).pushNamed('sync');
        break;
      case 8:
        Navigator.of(context).pushNamed('setup');
        break;
      case 9:
        Navigator.of(context).pushNamed('about');
        break;
    }
  }
}
