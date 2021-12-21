
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {

  static SharedPreferences preferences;
  static PreferencesManager instance;

  initiatePreferences() async{
    if(preferences == null) {
      await SharedPreferences.getInstance().then((p) => preferences = p);
    }
  }

  PreferencesManager._internal() {
    initiatePreferences();
  }


  static PreferencesManager getInstance(){
    if(instance == null){
      instance = PreferencesManager._internal();
    }
    return instance;
  }


  static bool isRTL(){
    return preferences.getInt("language_id") == 2 ;
  }

  static String getLanguageCode(){
    return preferences.getInt("language_id") == 2 ? "ar" : "en-us" ;
  }

  static String getStringVal(String key){
    return preferences.getString(key);
  }

  static int getIntVal(String key){
    return preferences.getInt(key);
  }

  static void setInt(String key, int value) async{
    if(preferences == null){
      await SharedPreferences.getInstance().then((value) => preferences = value);
    }
    preferences.setInt(key, value);
  }
  static void setString(String key, String value) async{
    if(preferences == null){
      await SharedPreferences.getInstance().then((value) => preferences = value);
    }
    preferences.setString(key, value);
  }

}