import 'dart:async';
import 'dart:io';
import 'package:amana_foods_hr/pages/load_settings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class Setting  {
/*Server*/



   Future<bool> saveServerP(String ip) async
   {
     SharedPreferences prefs= await SharedPreferences.getInstance();
     prefs.setString("myip", ip);
     print("Save Server ip :"+ip);
     LoadSettings.setServer(ip);
     return prefs.commit();
   }

  Future<String> loadServerIP() async
  {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String ip=prefs.getString("myip");
    //print("Load Server ip :"+ip);
    LoadSettings.setServer(ip);
    return ip;
  }


/*Language*/
  Future<bool> saveSelectedLang(String lang) async
  {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setString("lang", lang);
   LoadSettings.setLang(lang);
    //print("Save lang :"+lang);
    return prefs.commit();
  }

  Future<String> loadSelectedLang() async
  {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String lang=prefs.getString("lang");
    LoadSettings.setLang(lang);
  //  print("Load lang :"+lang);
    return lang;
  }


/*User ID*/
  Future<bool> saveUserID(String userid) async
  {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setString("userid", userid);
    LoadSettings.setUserID(userid);
    //print("Save lang :"+lang);
    return prefs.commit();
  }

  Future<String> loadUserID() async
  {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String userid=prefs.getString("userid");
    LoadSettings.setUserID(userid);
    //  print("Load lang :"+lang);
    return userid;
  }

  /*Last Logged User ID*/
  Future<bool> saveLastLoggedUserID(String lastuserid) async
  {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setString("lastuserid", lastuserid);
    return prefs.commit();
  }

  Future<String> loadLastLoggedUserID() async
  {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String lastuserid=prefs.getString("lastuserid");
    return lastuserid;
  }

  /*User Name*/
  Future<bool> saveUserName(String username) async
  {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setString("username", username);
    LoadSettings.setUserName(username);
    //print("Save lang :"+lang);
    return prefs.commit();
  }

  Future<String> loadUserName() async
  {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String username=prefs.getString("username");
    LoadSettings.setUserName(username);
    //  print("Load lang :"+lang);
    return username;
  }


  /*User Pass*/
  Future<bool> saveUserPass(String userpass) async
  {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setString("userpass", userpass);
    LoadSettings.setUserPass(userpass);
    //print("Save lang :"+lang);
    return prefs.commit();
  }

  Future<String> loadUserPass() async
  {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String userpass=prefs.getString("userpass");
    LoadSettings.setUserPass(userpass);
    //  print("Load lang :"+lang);
    return userpass;
  }



  /*User Comp*/
  Future<bool> saveUserComp(String comp) async
  {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setString("usercomp", comp);
    LoadSettings.setCompanyName(comp);
    //print("Save lang :"+lang);
    return prefs.commit();
  }

  Future<String> loadUserComp() async
  {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String comp= prefs.getString("usercomp");
    LoadSettings.setCompanyName(comp);
    return comp;
  }



  /*Is Logged In*/
  Future<bool> saveIsLoggedIn(String islogedin) async
  {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setString("islogedin", islogedin);
    LoadSettings.setUserPass(islogedin);
    //print("Save lang :"+lang);
    return prefs.commit();
  }

  Future<String> loadIsLoggedIn() async
  {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String islogedin=prefs.getString("islogedin");
    LoadSettings.setUserPass(islogedin);
    //  print("Load lang :"+lang);
    return islogedin;
  }





}
