import 'package:amana_foods_hr/login/Login.dart';
import 'package:amana_foods_hr/pages/load_settings.dart';
import 'package:amana_foods_hr/util/HttpUtils.dart';
import 'package:amana_foods_hr/util/ScreenUtil.dart';
import 'package:amana_foods_hr/util/Settings.dart';
import 'package:amana_foods_hr/util/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SetupPage extends StatefulWidget {
  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double transfom_paddTop;
  static double transfom_paddBot;
  String langVale;
  String serverIP;
  String userID;
  String userName;
  String password;
  String oldpassword;
  bool _obscureText = true;
  FToast fToast;

  final serverIpController = TextEditingController();
  final userIdController = TextEditingController();
  final userNameController = TextEditingController();
  final passController = TextEditingController();
  final def_company = TextEditingController();
  final viol_daysContrloller= TextEditingController();
  final leave_daysContrloller= TextEditingController();
  final adv_pay__daysContrloller= TextEditingController();
  final feed_daysContrloller= TextEditingController();
  final services_daysContrloller= TextEditingController();
  final mainten_daysContrloller= TextEditingController();

  @override
  void initState() {
    super.initState();
    Setting conf = new Setting();
    conf.loadUserID().then((value) => userIdController.text=value);
    conf.loadUserPass().then((value) => passController.text=value);
    conf.loadUserName().then((value) => userNameController.text=value);

    serverIpController.text=LoadSettings.getServer();
    /*userIdController.text=LoadSettings.getUserID();
    userNameController.text=LoadSettings.getUserName();
    passController.text=LoadSettings.getUserPass();
    oldpassword=LoadSettings.getUserPass();*/
    oldpassword=userNameController.text;
    langVale=LoadSettings.getLang();

    def_company.text=LoadSettings.getCompanyName();
    fToast = FToast();
    fToast.init(context);

   /* langVale=LoadSettings.getLang();
    serverIP=LoadSettings.getServer();
    userID=LoadSettings.getUserID();*/
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    serverIpController.dispose();
    userIdController.dispose();
    userNameController.dispose();
    passController.dispose();
    super.dispose();
  }
  Setting conf = new Setting();
  @override
  Widget build(BuildContext context) {


    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    transfom_paddTop=(LoadSettings.getLang()=='ar'?30:17);
    transfom_paddBot=50;



    if (screenWidth < screenHeight) screenHeight = screenHeight * 0.7;
    if (screenWidth > screenHeight) screenHeight = screenHeight * 0.7;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight:ScreenUtils.GetAppBarHeight(),

          actions: [
            // action button
            Padding(
                padding: EdgeInsets.fromLTRB(8.sp,0,8.sp,0),
                child: IconButton(
              icon: Icon( Icons.save_outlined,size: ScreenUtils.GetBarIconSize()),
              onPressed: ()
              {
                /*in Case we want to save user Details*/
                /*conf.saveUserID(userIdController.text);
                conf.saveUserName(userNameController.text);
                conf.saveUserPass(passController.text);*/
                //******************************////



                conf.saveServerP(serverIpController.text);

                setState(() {
                  conf.saveSelectedLang(langVale);
                  print("Saved lang");
                  print(LoadSettings.getLang());
                  Get.updateLocale(Locale(langVale));

                });
                // If password changed LOGOUT
                if(passController.text!=oldpassword)
                  HttpUtils.changePassword(oldpassword,passController.text).then((value) {
                    print("value returned from changing password : ${value}");
                    if (value.contains("successfully")) {
                      print("Done:");
                      Utilities.showToast(false, "needLogout", fToast);
                      conf.saveUserID('');
                      conf.saveUserName('');
                      conf.saveUserPass('');
                      conf.saveLastLoggedUserID(LoadSettings.getUserID());
                      //LoadSettings.emptyAllDataLists();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    }
                  });
                print ("Saved");


              },
            )),

          ],
          leading:Padding(
              padding: EdgeInsets.fromLTRB(8.sp,0,8.sp,0),
              child:  IconButton(

            icon: Icon(Icons.arrow_back, color: Colors.white,size: ScreenUtils.GetBarIconSize()),
            onPressed: () => Navigator.of(context).pushNamed('homepage'),
          )),
          title: Text("setup".tr,style:TextStyle(color: Colors.white,fontSize:6+ScreenUtils.GetHomePageFontSize())),
          centerTitle: true,
          //backgroundColor:  ScreenUtils.getAppColor(),
        ),
        //drawer: MyDrawer(),
        body: Center(
          child: Container(
             width: (screenWidth*0.95 ),
              child: ListView(
                children: [

                  Container(
                    width: (screenWidth*0.95 ),
                    //  height: screenHeight / 5,
                    alignment: (LoadSettings.getLang()=='en'?Alignment.centerLeft:Alignment.centerRight),
                    padding: EdgeInsets.fromLTRB(10,
                        (screenHeight /transfom_paddTop),10,(screenHeight /transfom_paddBot)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          //   width: (screenWidth * 0.95),
                          margin: ScreenUtils.GetAddPageMargins(),
                          child: TextField(
                            enabled: false,
                            controller: serverIpController,
                            style: ScreenUtils.getItemsDetailsTextstyle(),
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: 'server'.tr),
                          ),
                        ),// Server
                        Container(
                          //   width: (screenWidth * 0.95),
                          margin: ScreenUtils.GetAddPageMargins(),
                          child: TextField(
                            enabled: false,
                            controller: def_company,
                            style: ScreenUtils.getItemsDetailsTextstyle(),
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: 'company'.tr),
                          ),
                        ),//Company
                        Container(
                          //   width: (screenWidth * 0.95),
                          margin: ScreenUtils.GetAddPageMargins(),
                          child: TextField(
                            enabled: false,
                            controller: userNameController,
                            style: ScreenUtils.getItemsDetailsTextstyle(),
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: 'username'.tr),
                          ),
                        ),//User Name
                        Container(
                          //   width: (screenWidth * 0.95),
                          margin: ScreenUtils.GetAddPageMargins(),
                          child: TextField(
                            enabled: false,
                            controller: userIdController,
                            style: ScreenUtils.getItemsDetailsTextstyle(),
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: 'userid'.tr),
                          ),
                        ),//User ID
                        Container(
                          //   width: (screenWidth * 0.95),
                          margin: ScreenUtils.GetAddPageMargins(),
                          child: TextField(
                            //enabled: false,
                            controller: passController,
                            style: ScreenUtils.getItemsDetailsTextstyle(),
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: 'password'.tr,
                                suffixIcon: IconButton(
                                    icon :getPassFieldIcon(),
                                    onPressed: (){
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    }
                                )
                            ),
                          ),
                        ),//Password
                        Text("lang".tr,
                            style:ScreenUtils.getItemsDetailsTextstyle()
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 15.sp, 10, 15.sp),
                          margin: ScreenUtils.GetAddPageMargins(),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: DropdownButtonFormField(
                            decoration: InputDecoration.collapsed(hintText: ""),
                            value: LoadSettings.getLang().tr,
                            style: ScreenUtils.getItemsDetailsTextstyle(),

                            items: [
                              DropdownMenuItem(

                                  child: Text("En".tr),
                                  value: 'en'),
                              DropdownMenuItem(
                                  child: Text("Ar".tr),
                                value: 'ar'),
                              DropdownMenuItem(

                                  child: Text("Tr".tr),
                                  value: 'tr')
                            ],
                            onChanged: (value){

                              this.langVale=value;

                            },

                          ),
                        ),
                        new Visibility(
                            visible: false,
                            child:Container(
                          //   width: (screenWidth * 0.95),
                          margin: ScreenUtils.GetAddPageMargins(),
                          child: TextField(
                          //  enabled: false,
                            controller: viol_daysContrloller,
                            style: ScreenUtils.getItemsDetailsTextstyle(),
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: 'viol_days'.tr),
                          ),
                        )),//Discip Days
                        new Visibility(
                            visible: false,
                            child:Container(
                          //   width: (screenWidth * 0.95),
                          margin: ScreenUtils.GetAddPageMargins(),
                          child: TextField(
                            //enabled: false,
                            controller: feed_daysContrloller,
                            style: ScreenUtils.getItemsDetailsTextstyle(),
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: 'feedback_days'.tr),
                          ),
                        )),//Feed Days
                        new Visibility(
                            visible: false,
                            child:Container(
                          //   width: (screenWidth * 0.95),
                          margin: ScreenUtils.GetAddPageMargins(),
                          child: TextField(
                          //  enabled: false,
                            controller: leave_daysContrloller,
                            style: ScreenUtils.getItemsDetailsTextstyle(),
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: 'leave_days'.tr),
                          ),
                        )),//Leave Days
                        new Visibility(
                            visible: false,
                            child:Container(
                          //   width: (screenWidth * 0.95),
                          margin: ScreenUtils.GetAddPageMargins(),
                          child: TextField(
                           // enabled: false,
                            controller: adv_pay__daysContrloller,
                            style: ScreenUtils.getItemsDetailsTextstyle(),
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: 'adv_pay_days'.tr),
                          ),
                        )),//Adv Payment Days
                        new Visibility(
                            visible: false,
                            child:Container(
                          //   width: (screenWidth * 0.95),
                          margin: ScreenUtils.GetAddPageMargins(),
                          child: TextField(
                            //enabled: false,
                            controller: services_daysContrloller,
                            style: ScreenUtils.getItemsDetailsTextstyle(),
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: 'service_days'.tr),
                          ),
                        )),//Services Days
                        new Visibility(
                            visible: false,
                            child:Container(
                          //   width: (screenWidth * 0.95),
                          margin: ScreenUtils.GetAddPageMargins(),
                          child: TextField(
                            //enabled: false,
                            controller: mainten_daysContrloller,
                            style: ScreenUtils.getItemsDetailsTextstyle(),
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: 'mainten_days'.tr),
                          ),
                        )),//Maintenance Days

                      ],
                    ),
                  ),

                ],
              )),
        ));
  }

  Icon getPassFieldIcon()
  {
   return  (_obscureText?Icon(Icons.visibility):Icon(Icons.visibility_off));
  }
}
