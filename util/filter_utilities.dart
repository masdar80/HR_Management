import 'dart:convert';

import 'package:amana_foods_hr/util/app_constants.dart';
import 'package:intl/intl.dart';

class FilterUtilities {
  static filterByDynamicString(String value1, String value2, dynamic element, String fieldName, String operation) {
    dynamic dynamicElement = json.decode(json.encode(element));
    if (operation == AppConstants.COMPARATORS[0] && value1 != null) {
      //Equals
      return dynamicElement[fieldName].toLowerCase() == (value1.toLowerCase());
    }
    if (operation == AppConstants.COMPARATORS[1] && value1 != null) {
      //doesn't equal
      return dynamicElement[fieldName].toLowerCase() != (value1.toLowerCase());
    }
    if (operation == AppConstants.COMPARATORS[2] && value1 != null) {
      //contain
      return dynamicElement[fieldName].toLowerCase().contains(value1.toLowerCase());
    }
    if (operation == AppConstants.COMPARATORS[3] && value1 != null) {
      //doesn't contain
      return !dynamicElement[fieldName].toLowerCase().contains(value1.toLowerCase());
    }
    if (operation == AppConstants.COMPARATORS[4] && value1 != null) {
      //starts with
      return dynamicElement[fieldName].toLowerCase().toString().startsWith(value1.toLowerCase());
    }
    if (operation == AppConstants.COMPARATORS[5] && value1 != null) {
      //doesn't starts with
      return !dynamicElement[fieldName].toLowerCase().toString().startsWith(value1.toLowerCase());
    }
    if (operation == AppConstants.COMPARATORS[6] && value1 != null) {
      //ends with
      return dynamicElement[fieldName].toLowerCase().toString().endsWith(value1.toLowerCase());
    }
    if (operation == AppConstants.COMPARATORS[7] && value1 != null) {
      //doesn't ends with
      return !dynamicElement[fieldName].toLowerCase().toString().endsWith(value1.toLowerCase());
    }
    return false;
  }

  static filterByDate(dynamic element, String fieldName, String operation, DateTime searchDate, bool withTimeFormat, {DateTime searchDate2}) {
    dynamic dynamicElement = json.decode(json.encode(element));
    DateTime sourceDateTime = DateFormat(withTimeFormat ? "dd-MM-yyyy HH:mm" : "dd-MM-yyyy").parse(dynamicElement[fieldName]);
    if (operation == AppConstants.DATE_COMPARATORS[0]) {
      return sourceDateTime.isAtSameMomentAs(searchDate);
    }
    if (operation == AppConstants.DATE_COMPARATORS[1]) {
      return (sourceDateTime.isAtSameMomentAs(searchDate) || sourceDateTime.isAfter(searchDate)) &&
          (sourceDateTime.isAtSameMomentAs(searchDate2) || sourceDateTime.isBefore(searchDate2));
    }
    if (operation == AppConstants.DATE_COMPARATORS[2]) {
      return sourceDateTime.isAtSameMomentAs(searchDate) || sourceDateTime.isBefore(searchDate);
    }
    if (operation == AppConstants.DATE_COMPARATORS[3]) {
      return !sourceDateTime.isBefore(searchDate);
    }
    if (operation == AppConstants.DATE_COMPARATORS[4]) {
      return sourceDateTime.isAtSameMomentAs(searchDate) || sourceDateTime.isAfter(searchDate);
    }
    if (operation == AppConstants.DATE_COMPARATORS[5]) {
      return !sourceDateTime.isAfter(searchDate);
    }
    return false;
  }

  static filterByNumber(dynamic element, String fieldName, String operation, String v1, String v2) {
    dynamic dynamicElement = json.decode(json.encode(element));
    double doubleV1 = dynamicElement[fieldName];
    print("Parsed Double $doubleV1");
    double value1 = double.parse(v1);
    double value2 = v2 != null && v2.isNotEmpty ? double.parse(v2) : 0;
    if (operation == AppConstants.NUMBER_COMPARATORS[0]) {
      return doubleV1 == value1;
    }
    if (operation == AppConstants.NUMBER_COMPARATORS[1]) {
      return doubleV1 != value1;
    }
    if (operation == AppConstants.NUMBER_COMPARATORS[2]) {
      return (doubleV1 >= value1 && doubleV1 <= value2);
    }
    if (operation == AppConstants.NUMBER_COMPARATORS[3]) {
      return !(doubleV1 >= value1 && doubleV1 <= value2);
    }
    if (operation == AppConstants.NUMBER_COMPARATORS[4]) {
      return (doubleV1 > value1);
    }
    if (operation == AppConstants.NUMBER_COMPARATORS[5]) {
      return (doubleV1 < value1);
    }
    if (operation == AppConstants.NUMBER_COMPARATORS[6]) {
      return (doubleV1 >= value1);
    }
    if (operation == AppConstants.NUMBER_COMPARATORS[7]) {
      return (doubleV1 <= value1);
    }
  }

  static filterByDocumentType(dynamic element, String fieldName, String selectedCompareOption) {
    dynamic dynamicElement = json.decode(json.encode(element));
    String documentType = dynamicElement[fieldName];
    return documentType.toLowerCase() == selectedCompareOption.toLowerCase() || AppConstants.TYPE_ALL.toLowerCase() == selectedCompareOption.toLowerCase();
  }
}
