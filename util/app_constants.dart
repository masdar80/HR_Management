import 'package:intl/intl.dart';

class AppConstants {
  static const String TYPE_SALES = "Sales quotation";
  static const String TYPE_PURCHASE = "Purchase requisition";
  static const String TYPE_NON_CONFORMANCE = "Non conformance";
  static const String TYPE_PRICE_LIST = "Price/discount agreement journal table";
  static const String TYPE_ALL = "ALL";

  static String SERVICES_ALL = "no";
  static String LINES_ALL = "no";
  static String DISCPS_ALL = "no";
  static String LEAVE_ALL = "no";
  static String MAINT_ALL = "no";
  static String FEED_ALL = "no";
  static String PAYEMENT_ALL = "no";
  static String MANAGER_VIEW = "no";

  static const String APPROVALS_JSON_RESPONSE_KEY = "Data";

  static const String USER_ID_KEY = "user_id";

  static const String ACTION_DELEGATE = "Delegate";
  static const String ACTION_CHANGE_REQUEST = "RequestChange";

  static const String REFRESH_LIST = "refresh_list";

  static const String SERVER_SETTING_KEY = "server_url";
  static const String DEFAULT_SERVER = "http://188.247.90.187:81/ApprovalsAppTest/Workflow/";

  static const String APPROVALS_DATA_KEY = "approvals_data";
  static const String FIRE_BASE_TOKEN_KEY = "fire_base_token";

  static const int CONNECTION_TIME_OUT_SECONDS = 10;

  static NumberFormat formatter = NumberFormat.decimalPattern();

  static const Map<String, String> APPROVAL_TYPES = {
    TYPE_ALL: "Pending Approvals",
    TYPE_SALES: "Sales Quotation",
    TYPE_PURCHASE: "Purchase Requisition",
    TYPE_NON_CONFORMANCE: "Non Conformance",
    TYPE_PRICE_LIST: "Price List"
  };

  static const Map<String, String> AVAILABLE_UNITS = {
    "%": "%",
    "*": "*",
    "1/2 cu. in": "1/2 cu. in",
    "1/2 in": "1/2 in",
    "1/2 lb": "1/2 lb",
    "1/2 pt": "1/2 pt",
    "1/2 sq. in": "1/2 sq. in",
    "1/4 cu. in": "1/4 cu. in",
    "1/4 in": "1/4 in",
    "1/4 lb": "1/4 lb",
    "1/4 sq. in": "1/4 sq. in",
    "1/8 cu. in": "1/8 cu. in",
    "1/8 in": "1/8 in",
    "1/8 lb": "1/8 lb",
    "1/8 sq. in": "1/8 sq. in",
  };

  static const List<String> COMPARATORS = [
    "Equals",
    "Does Not Equal",
    "Contains",
    "Does Not Contain",
    "Begins With",
    "Does Not Begin With",
    "Ends With",
    "Does Not End With",
    "Contains Data",
    "Does Not Contain Data",
  ];

  static const List<String> NUMBER_COMPARATORS = [
    "Equals",
    "Does Not Equal",
    "Between",
    "Not Between",
    "Is Greater Than",
    "Is Less Than",
    "Is Greater Than or Equals To",
    "Is Less Than or Equals To",
  ];

  static const List<String> DATE_COMPARATORS = [
    "On",
    "Between",
    "Before",
    "Is not Before",
    "After",
    "Is not After",
  ];
}
