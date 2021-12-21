import 'package:amana_foods_hr/langs/ar.dart';
import 'package:amana_foods_hr/langs/en.dart';
import 'package:amana_foods_hr/langs/tr.dart';
import 'package:get/get.dart';
class Translation extends Translations{
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    'en':en,
    'ar':ar,
    'tr':tr,

  };

}