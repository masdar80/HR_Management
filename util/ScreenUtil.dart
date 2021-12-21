import 'dart:ffi';

import 'dart:ui';

import 'package:amana_foods_hr/pages/load_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class   ScreenUtils  {
  final double standardsiz=281182.04;
static double _screenWidth;
static double _screenHeight;

static double transfom_paddTop;
static double transfom_paddBot;
static EdgeInsets test;

static  double getFactorScale()
{
  return 1;

  // print("size::::::");
  // print(((_screenWidth * _screenHeight) - 281182.04081632657));

  if(_screenWidth*_screenHeight<=281184 )
    return 1.0;
  else {

     print("factor scale::::::");
     print ((((_screenWidth * _screenHeight) - 281182.04) / 281182.04));
    return (((_screenWidth * _screenHeight) ) / 281182.04)*0.7;
  }


}
static EdgeInsets GetEdgeinsests()
{
  transfom_paddTop=(LoadSettings.getLang()=='ar'?80.sp:57.sp);
  transfom_paddBot=50.sp;
  return EdgeInsets.fromLTRB((_screenHeight /transfom_paddTop),(_screenHeight /transfom_paddTop),10.sp,(_screenHeight /transfom_paddBot));
}


static EdgeInsets GetIconEdgeinsests()
{
  transfom_paddTop=(LoadSettings.getLang()=='ar'?80.sp:130.sp);
  transfom_paddBot=2;
  return EdgeInsets.fromLTRB((_screenWidth /25),(_screenHeight /100),_screenWidth /25,(_screenHeight /100));
}

static EdgeInsets GetHomePageEdgeinsests()
{
  transfom_paddTop=(LoadSettings.getLang()=='ar'?80.sp:130.sp);
  transfom_paddBot=2;
  return EdgeInsets.fromLTRB((_screenWidth /100),0,_screenWidth /25,0);
}

static EdgeInsets GetHomePageDetailEdgeinsests()
{
  return(LoadSettings.getLang()=='ar'?EdgeInsets.fromLTRB(0,0,0,0):EdgeInsets.fromLTRB(0,0,0,(_screenHeight /150)));

 // return EdgeInsets.fromLTRB(0,0,0,(_screenHeight /150));
}

static EdgeInsets GetAddPageEdgeinsests()
{
  transfom_paddTop=(LoadSettings.getLang()=='ar'?30.sp:25.sp);
  transfom_paddBot=2.sp;
  return EdgeInsets.fromLTRB(10,(_screenHeight /transfom_paddTop),10,(_screenHeight /transfom_paddBot));
}

static EdgeInsets GetAddPageMargins()
{
  return EdgeInsets.fromLTRB(2.sp, _screenHeight / 48.63, 2.sp, _screenHeight / 48.63);
}

static Color GetMainColor()
{
  return Color(0xFF4A7729);
}
static Color GetPrimaryColor()
{
  return Color(0xFF64A70B);
}

static double GetIconSize()
{
    return 32.sp;

}

  static double GetBarIconSize()
  {

      return 18.sp;


  }

  static double GetAppBarHeight()
  {
    return 38.sp;
  }

static setWidth(value)
{
_screenWidth=value;
}

static setHeight(value)
{

_screenHeight=value;
}
static getHeight()
{

  return _screenHeight;
}
static getWidth()
{

  return _screenWidth;
}

  static double GetHomePageFontSize()
{
  return 15.sp;

  /*print("_screenWidth * _screenHeight");
  print(_screenWidth * _screenHeight);

  double size=(_screenWidth * _screenHeight);
  double result=0.0;
  if(size>481182)
    result=(size / 26000)-(100000/(size));
        else
        result=(size / 18000)-(100000/size);

  return result;*/
          //((screenWidth * screenHeight) / 10000)-(100000/( screenWidth * screenHeight))
}


static double GetDatePickerFontSize()
{/*
  print ("_screenWidth:");
  print (_screenWidth);
  print ("_screenHeight:");
  print (_screenHeight);*/
  double result=((_screenWidth * _screenHeight) / 15000)-(110000/(_screenWidth * _screenHeight));
  return result;
  //((screenWidth * screenHeight) / 10000)-(100000/( screenWidth * screenHeight))
}

static double GetHomePageContainerScreenWidth()
{
  return _screenWidth * 0.55;
}

static double GetAddPageContainerScreenWidth()
{
  return _screenWidth * 0.95;
}
static double GetListItemContainerScreenWidth()
{
  return _screenWidth * 0.45;
}
static double GetHomePageContainerScreenHeight()
{
  double height=0.0;
  height= (LoadSettings.getLang()=='ar'? _screenHeight/13:_screenHeight/13);
  return height;
}
static double GetHomePageDetailMainHeight() {
  double height=0.0;
  height= (LoadSettings.getLang()=='ar'? _screenHeight/25:_screenHeight/25);
  return height;
}
static double GetHomePageSubDetailMainHeight() {
  double height=0.0;
  height= (LoadSettings.getLang()=='ar'? _screenHeight/50:_screenHeight/25);
  return height;
}


static Color getAppColor()
{
  return Color(0xFF4A7729);
}

static TextStyle getTitleViewTextstyle(){
  return  TextStyle(
    color: Colors.black,
    fontSize: 16.5.sp,
  );
}

  static TextStyle getFilterTextstyle(){
    return  TextStyle(
      color: Colors.black,
      fontSize: 12.sp,
    );
  }

static TextStyle getDetailViewTextstyle(){
    return  TextStyle(
      color: Colors.black38,
      fontSize: 15.sp,
    );
  }


//  view Style Inkwell
  static TextStyle getItemsTitleTextstyle(){
    return TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 15.sp,
    );
  }



  static TextStyle getItemsDetailsTextstyle(){
    return TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 15.sp,
    );
  }


  //  view Style CARD without link
  static TextStyle getCardItemsTitleTextstyle(){
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16.sp,
    );
  }

  static TextStyle getCardItemsDetailsTextstyle(){
    return TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 16.sp,
    );
  }

static TextStyle geHeaderextstyle(){
  return  TextStyle(
      fontSize: ScreenUtils.GetHomePageFontSize()+4,
      color: Colors.white,
      fontWeight: FontWeight.bold
  );
}

}