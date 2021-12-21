import 'dart:convert';

import 'package:amana_foods_hr/classes/service.dart';
import 'package:amana_foods_hr/classes/various_lists.dart';
import 'package:amana_foods_hr/db/db_class.dart';
import 'package:amana_foods_hr/db/get_data_class.dart';
import 'package:amana_foods_hr/pages/load_settings.dart';
import 'package:amana_foods_hr/util/ScreenUtil.dart';
import 'package:amana_foods_hr/util/Settings.dart';
import 'package:amana_foods_hr/util/app_constants.dart';
import 'package:amana_foods_hr/util/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'addLineServic.dart';

class AddService extends StatefulWidget {
  @override
  _AddServiceState createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  FToast fToast;
  List<Widget> listScreens;
  List<Lines> serviceLinesList = [];
  List<Lines> emptylinesList= List<Lines>();
  int tabIndex = 0;
  static int linesCounter=1;

  DateTime selectedDate = DateTime.now();
  String priority_type="0";
  String purchase_type="0";
  String product_type="3";

  static bool show = false;
  static bool err = false;
  static String msg = "";
  DB_Class db= new DB_Class();


  final PRController= TextEditingController();
  final dateController = TextEditingController();
  final appIDController = TextEditingController();
  bool receipted_flag = false;


  @override
  void initState() {
    dateController.text = DateFormat('dd/MM/yyyy')
        .format(DateTime.parse("${selectedDate.toLocal()}"));
    appIDController.text=Utilities.generatAppID("Ser", LoadSettings.getUserID());

    LoadSettings.set_tempServiceLinesList(emptylinesList);
    serviceLinesList=LoadSettings.get_tempServiceLinesList();


     purchase_type="0";
     product_type="3";
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    // print ("screenWidth:");print (screenWidth);
    screenHeight = _mediaQueryData.size.height;
    // print ("screenHeight:");print (screenHeight);
    AppConstants.LEAVE_ALL="no";

    ScreenUtils.setWidth(screenWidth);

    ScreenUtils.setHeight(screenHeight);
    listScreens = [
      headerTab(),
      detailsTab(),

    ];

    return Scaffold(
        appBar: AppBar(
          key: _scaffoldKey,
          toolbarHeight: ScreenUtils.GetAppBarHeight(),
          actions: [
            // action button

            (tabIndex==1? Padding(
                padding: EdgeInsets.fromLTRB(0,0,0,0),
                child: IconButton(
                  icon: Icon( Icons.add,size: ScreenUtils.GetBarIconSize()),
                  onPressed: ()  {
                    _showAddLineialog();
                  },
                )):Container()),
            Padding(
               padding: EdgeInsets.fromLTRB(0,0,0,0),
                child: IconButton(
                  icon: Icon( Icons.save_outlined,size: ScreenUtils.GetBarIconSize()),
                  onPressed: ()  {
                    saveNewService();
                  },
                ))

          ],
          leading: Padding(
              padding: EdgeInsets.fromLTRB(8.sp,0,8.sp,0),
              child: IconButton(

            icon: Icon(Icons.arrow_back, color: Colors.white,size: ScreenUtils.GetBarIconSize()),
            onPressed: () => Navigator.of(context).pushNamed('services'),
          )),
          title: Text("service_desc".tr, style: ScreenUtils.geHeaderextstyle()),
          centerTitle: true,
         // backgroundColor:  ScreenUtils.getAppColor(),
        ),
        //drawer: MyDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[400],
        backgroundColor: Theme.of(context).primaryColor,
        currentIndex: tabIndex,
        onTap: (int index) {
          setState(() {
            tabIndex = index;
          });
        },
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.view_headline,size: ScreenUtils.GetIconSize(),),
            label: "header".tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.details_outlined,size: ScreenUtils.GetIconSize()),
            label: "details".tr,
          ),

        ],
      ),
        body: listScreens[tabIndex],
    );
  }

  Widget headerTab()
  {
    return Center(
      child: Container(
          width: ScreenUtils.GetAddPageContainerScreenWidth(),
          child: ListView(
            children: [
              // Utilities.errmsg(msg.tr, show, err),
              Container(
                alignment: (LoadSettings.getLang() == 'en'
                    ? Alignment.centerLeft
                    : Alignment.centerRight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [// object id
                    Text("pr_name".tr,
                        // textAlign: (LoadSettings.getLang() == 'ar' ? TextAlign.right : TextAlign.left),
                        style:
                        ScreenUtils.getItemsDetailsTextstyle()),
                    Container(
                      //   width: (screenWidth * 0.95),
                      margin: ScreenUtils.GetAddPageMargins(),
                      child: TextField(
                        controller: PRController,
                        style: ScreenUtils.getItemsDetailsTextstyle(),
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                           // labelText: 'pr_name'.tr
                        ),
                      ),
                    ),// PR Name
                    Text("product_type".tr,
                        style: ScreenUtils.getItemsDetailsTextstyle()), //Product type
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 15.sp, 10, 15.sp),
                      margin: ScreenUtils.GetAddPageMargins(),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      child: DropdownButtonFormField(
                        value:"3",
                        decoration: InputDecoration.collapsed(hintText: ""),
                        style: ScreenUtils.getItemsDetailsTextstyle(),

                        items: LoadSettings.getVariousList().where((i) => i.name=="Prodcut Type")
                            .map((VariousLists item) => DropdownMenuItem<String>(
                            child: Text(item.desc),
                            value: item.id.toString()))
                            .toList(),
                      /*  onChanged: (value) {  Nabil asked to fix this value at HR (04/09/2021)
                          product_type = value;
                        },*/
                      ),
                    ), // type drop down
                    Text("purchase_type".tr,
                        style: ScreenUtils.getItemsDetailsTextstyle()), //Purchase type
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 15.sp, 10, 15.sp),
                      margin: ScreenUtils.GetAddPageMargins(),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      child: DropdownButtonFormField(
                       value:"0",
                        style: ScreenUtils.getItemsDetailsTextstyle(),
                        decoration: InputDecoration.collapsed(hintText: ""),

                        items: LoadSettings.getVariousList().where((i) => i.name=="Purchase type")
                            .map((VariousLists item) => DropdownMenuItem<String>(
                            child: Text(item.desc),
                            value: item.id.toString()))
                            .toList(),
                       /* onChanged: (value) { Nabil asked to fix this value at Local (04/09/2021)
                          purchase_type = value;
                        },*/
                      ),
                    ), // type drop down
                    Text("priority".tr,
                        style: ScreenUtils.getItemsDetailsTextstyle()), //Priority
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 15.sp, 10, 15.sp),
                      margin: ScreenUtils.GetAddPageMargins(),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      child: DropdownButtonFormField(
                        value: (priority_type==""?"0":priority_type),
                        style: ScreenUtils.getItemsDetailsTextstyle(),
                        decoration: InputDecoration.collapsed(hintText: ""),

                        items: LoadSettings.getVariousList().where((i) => i.name=="Purchase priority")
                            .map((VariousLists item) => DropdownMenuItem<String>(
                            child: Text(item.desc),
                            value: item.id.toString()))
                            .toList(),
                        onChanged: (value) {
                          priority_type = value;
                        },
                      ),
                    ), // Priority drop down
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("_date".tr,
                              // textAlign: (LoadSettings.getLang() == 'ar' ? TextAlign.right : TextAlign.left),
                              style: ScreenUtils.getItemsDetailsTextstyle()),
                          TextField(
                            controller: dateController,
                            keyboardType: TextInputType.datetime,
                            style: ScreenUtils.getItemsDetailsTextstyle(),
                          ),
                        ],
                      ),
                    ), // requested date
                   /* Container(
                      //width: (screenWidth * 0.95),
                      margin: ScreenUtils.GetAddPageMargins(),
                      child: TextField(
                        enabled: false,
                        controller: appIDController,
                        style: ScreenUtils.getItemsDetailsTextstyle(),
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            labelText: 'application_id'.tr),
                      ),
                    ),*/ //application ID
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget detailsTab()
  {
    return Container(
      padding: EdgeInsets.only(left: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [


          (serviceLinesList== null || serviceLinesList.isEmpty)
              ? Container(
            alignment: Alignment.topCenter,
            height: 200,
            child: Center(
              child:  Text("noitems".tr) ,
            ),
          )
              : Expanded(
            child: ListView.builder(
              itemBuilder: (context, i) {
                return Column(children: <Widget>[
                  serviceLinesList[i],
                  Divider(
                    color: Color.fromRGBO(130, 130, 130, 1),
                    height: 1,
                  ),
                ]);
              },
              itemCount: serviceLinesList.length,
            ),
          ),
        ],
      ),

    );
  }

  _showAddLineialog() {

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AddLineService(_lineListData,appIDController.text,linesCounter++);
            },
          ),
        );
      },
    );
  }
  void saveNewService() async {

    if(PRController.text==""||priority_type=="" ||product_type==""||purchase_type==""||dateController.text=="")
    {
      Utilities.showToast(true, "fillFields".tr,fToast);
    }
    else
      {
        String json = "'PRName':'" +PRController.text +
            "','PurchasePriority': '" +priority_type +
            "','ProductType': '" +product_type +
            "','PurchaseType': '" +purchase_type +
            "','Preparer': '" +LoadSettings.getUserID() +
            "','RequestedDate':'" + dateController.text +
            "', 'ApplicationId':'" +appIDController.text+""
            "','Lines': [" +getLinesJson()+"]";
        print("{'Data':[{" + json + "}]}");
        Utilities.saveNewObject(LoadSettings.getCompanyName(),json, "createPurchReq").then((body) async {
          var dbHelper = DB_Class();
          if (body == "timeout") {

            Services service = Services(
              request_id: "",
              employee_name: LoadSettings.getUserID(),
              job_title:"" ,
              pr_name: PRController.text,
              request_date: dateController.text ,
              priority: priority_type,
              service_type: purchase_type,
              product_type:product_type ,

              status: "",
              app_id: appIDController.text,
            );
            dbHelper.insertServices(service, "service_local");
            for(var singleLine in  LoadSettings.get_tempServiceLinesList())
            {
              dbHelper.insertServicesLines(singleLine, "lines_local");
            }
            Utilities.showToast(err, body.tr, fToast);
          }else{
          var responseBody = jsonDecode(body);
          responseBody =
              responseBody.remove(AppConstants.APPROVALS_JSON_RESPONSE_KEY);
          setState(() {
            show = true;
            if (body.contains("successfully")) {
              print("Done:");
              print(responseBody);
              msg = responseBody;
              err = false;
            } else {
              print("ID:");
              print(responseBody[0]["id"]);
              print("text");
              print(responseBody[0]["text"]);
              msg = responseBody[0]["text"];
              err = true;
            }
            Utilities.showToast(err, msg, fToast);
          });

          if (!err)
            {

              await dbHelper.getAllServices("service");
              LoadSettings.setServicesList(
                  await dbHelper.services("service"));
              LoadSettings.setLinesList(
              await dbHelper.servicesLines("lines"));
              LoadSettings.set_tempServiceLinesList(emptylinesList);
            }

        }
          Future.delayed(Duration(seconds: 5)).then((value) =>
          {
            setState(() {
              show = false;
              if (!err) {
                Navigator.of(context).pushNamed('services');
              }
            })
          });
        });
      }

//{\"Data\":\"Insert record successfully # Vio-000000045\"}
    //{\"Data\":[{\"id\":\"Error\",\"text\":\"Application Id hhhh already exist.\"}]}
  }
  String getLinesJson()
  {

    int counter=0;
    String linesjson="";
    for(var singleLone in  LoadSettings.get_tempServiceLinesList())
      {
        linesjson+= "{'ServiceItemID':'" +singleLone.service_item_id+
        "','Quantity': '" +singleLone.quantity +
        "','DeliveryDate': '" +singleLone.delivery_date + "'}" ;
        counter++;
        if(counter<LoadSettings.get_tempServiceLinesList().length)
          linesjson+=",";
      }

    return linesjson;
  }
  _showToast(bool err,String msg) {

    fToast.showToast(
      child: Utilities.getToastNotification(err,msg),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 4),
    );
  }

  _lineListData() {
    setState(() {
      serviceLinesList = LoadSettings.get_tempServiceLinesList();
    });
  }
}
