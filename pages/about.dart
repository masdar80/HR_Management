import 'package:amana_foods_hr/util/ScreenUtil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'load_settings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: LoadSettings.getLang()=='ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight:ScreenUtils.GetAppBarHeight(),

          title: Text("abt".tr,style:  TextStyle(color: Colors.white,fontSize:6+ScreenUtils.GetHomePageFontSize())),
          leading: Padding(
              padding: EdgeInsets.fromLTRB(8.sp,0,8.sp,0),
              child: IconButton(

            icon: Icon(Icons.arrow_back, color: Colors.white,size: ScreenUtils.GetBarIconSize()),
            onPressed: () => Navigator.of(context).pushNamed('homepage'),
          )),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            height: ScreenUtils.getHeight(),
            width: ScreenUtils.getWidth(),
            padding: EdgeInsets.only(top:ScreenUtils.getHeight()/10),
            child: Column(
             // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(

                    height: ScreenUtils.getHeight()/2.8,
                  //  width: ScreenUtils.getWidth()/2,
                    child: Image.asset("assets/img/logo.png")),
                Container(
                  padding: EdgeInsets.only(top:ScreenUtils.getHeight()/14),
                  child: Text(
                    "Amana HR V1.0",
                    style: TextStyle(
                        fontSize: ScreenUtils.GetHomePageFontSize()+6,
                        color: Colors.black,
                        //fontWeight: FontWeight.bold
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
