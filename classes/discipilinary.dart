import 'package:amana_foods_hr/classes/violationTypes.dart';
import 'package:amana_foods_hr/pages/disciplinary/disciplinary_info.dart';
import 'package:amana_foods_hr/pages/load_settings.dart';
import 'package:amana_foods_hr/util/app_constants.dart';
import 'package:amana_foods_hr/util/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amana_foods_hr/util/ScreenUtil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Disciplinary extends StatelessWidget {
  final employee_name;
  final employee_id; //char
  final created_by; //char
  final violation_id; // char foreign key
  final violation_name; //char
  final violation_date_time; // date time
  final violation_date;
  final explanation; //multi line  char
  final damage_; //multi line  char
  final acceptance; // dropdown yes no
  final employee_comments; //multi line  char
  final decision; //dropdown
  final appointment_date_time;//AppointmentDateTime
  final penaltyType;
  final penaltyValue;
  final status; //dropdown
  final app_id;
  final editFlage; //boolean
  final employee_company;
  Disciplinary({
    this.employee_name,
    this.employee_id,
    this.created_by,
    this.violation_id,
    this.violation_name,
    this.violation_date_time,
    this.violation_date,
    this.explanation,
    this.damage_,
    this.appointment_date_time,
    this.penaltyType,
    this.penaltyValue,
    this.acceptance,
    this.employee_comments,
    this.decision,
    this.status,
    this.app_id,
    this.editFlage,
    this.employee_company,
  });

  Map<String, dynamic> _DisciplinaryToJson(Disciplinary instance) =>
      <String, dynamic>{
        'EmployeeName': instance.employee_name,
        'EmployeeId': instance.employee_id,
        'CreatedBy': instance.created_by,
        'ViolationID': instance.violation_id,
        'ViolationType': instance.violation_name,
        'ViolationDateTime': instance.violation_date_time,
        'ViolationDate': instance.violation_date,
        'Explanation': instance.explanation,
        'Damage': instance.damage_,
        'Reject': instance.acceptance,
        'Comments': instance.employee_comments,
        'CommitteeDecision': instance.decision,
        'AppointmentDateTime': instance.appointment_date_time,
        'PenaltyType': instance.penaltyType,
        'PenaltyValue': instance.penaltyValue,
        'ViolationStatus': instance.status,
        'ApplicationId': instance.app_id,
      };
  Map<String, dynamic> toJson() => _DisciplinaryToJson(this);

  Map<String, dynamic> toMap() {
    return {
      'employee_name': employee_name,
      'employee_id': employee_id,
      'created_by': created_by,
      'violation_id': violation_id,
      'violation_name': violation_name,
      'violation_date_time': violation_date_time,
      'violation_date': violation_date,
      'explanation': explanation,
      'damage_': damage_,
      'acceptance': acceptance,
      'employee_comments': employee_comments,
      'decision': decision,
      'appointment_date_time': appointment_date_time,
      'penaltyValue': penaltyValue,
      'penaltyType': penaltyType,
      'status': status,
      'app_id': app_id,
      'editFlage': editFlage,
      'employee_company': employee_company,
    };
  }
//
  //

  @override
  Widget build(BuildContext context) {
    bool editable = false;
    String isAllowCommittee = "0";

    //اذا كنا في قائمة المدير فلا داعي لتشييك نوع المخالفة لاننا بالاساس لن نسمح له بالتعديل
    List<ViolationType> tempArr = LoadSettings.getViolationTypesList()
        .where((i) =>
            i.id == this.violation_name &&
            i.company.toLowerCase() ==
                LoadSettings.getCompanyName().toLowerCase())
        .toList();
    print("editable comite length");
    print(tempArr.length);
    if (AppConstants.MANAGER_VIEW == "no" && tempArr.length > 0) {
      isAllowCommittee = tempArr[0].allowcommittee;
    }
    editable =
        (isAllowCommittee == "1" ? true : false);
    return (AppConstants.DISCPS_ALL.toLowerCase() == "yes"
        ? InkWell(
            child: Card(
              elevation: 0,
              child: Padding(
                padding: EdgeInsets.all(7.0),
                child: Wrap(
                  runSpacing: 5.sp,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "violation_id".tr + " :",
                          style: ScreenUtils.getItemsTitleTextstyle(),
                        ),
                        Utilities.buildExpandedText(this.violation_id)
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "violation_type".tr + " :",
                          style: ScreenUtils.getItemsTitleTextstyle(),
                        ),
                        Utilities.buildExpandedText(this.violation_name)
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "emp_name".tr + " :",
                          style: ScreenUtils.getItemsTitleTextstyle(),
                        ),
                        Utilities.buildExpandedText(this.employee_name)
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "_date".tr + " :",
                          style: ScreenUtils.getItemsTitleTextstyle(),
                        ),
                        Utilities.buildExpandedText(this.violation_date_time)
                      ],
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              AppConstants.DISCPS_ALL = "no";
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DisciplinaryInfo(this.violation_id),
                ),
              );
              // Navigator.of(context).pushNamed('service_info');
            })
        : Card(
            color: Colors.white,
            elevation: 0,
            child: Padding(
              padding: EdgeInsets.all(5.0),
              // padding: ScreenUtils.GetEdgeinsests(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Utilities.buildViewRow(
                      "violation_id".tr, this.violation_id), //violation_id
                  Utilities.buildViewRow(
                      "violation_name".tr,
                      LoadSettings.getViolationTypesList()
                          .where((i) => i.id == this.violation_name)
                          .toList()[0]
                          .desc), //violation_name
                  Utilities.buildViewRow("status".tr, this.status), //status
                  Utilities.buildViewRow(
                      "emp_name".tr, this.employee_name), //emp_name
                  Utilities.buildViewRow(
                      "_date".tr, this.violation_date_time), //_date
                  Utilities.buildViewRow(
                      "created_by".tr, this.created_by), //created_by
                  Utilities.buildViewRow(
                      "explanation".tr, this.explanation), //explanation
                  Utilities.buildViewRow(
                      "damage_result".tr, this.damage_), //damage_result
                  new Visibility(
                      visible: (AppConstants.MANAGER_VIEW == "no" && editable
                          ? true
                          : false),
                      child: Utilities.buildViewRow("appointment_date_time".tr,
                          this.appointment_date_time)),
                  new Visibility(
                      visible: (AppConstants.MANAGER_VIEW == "no" && editable
                          ? true
                          : false),
                      child: Utilities.buildViewRow("emp_comment".tr,
                          this.employee_comments)), //emp_comment
                  new Visibility(
                      visible: (tempArr.length > 0
                          ? true
                          : false),
                      child: Utilities.buildViewRow(
                          "discpl_board_decision".tr, this.decision)), //id
                  Visibility(
                      visible: ( tempArr.length > 0  &&this.penaltyType!=""),
                      child: Utilities.buildViewRow("penalty_type".tr , LoadSettings.getVariousList().where((i) =>i.name=="PenaltyType" &&i.id==this.penaltyType).toList()[0].desc)),// penalty_type
                  Visibility(
                      visible: ( tempArr.length > 0  &&this.penaltyType!=""),
                      child: Utilities.buildViewRow("penalty_value".tr , this.penaltyValue)),// penalty_value
                  new Visibility(
                      visible: (AppConstants.MANAGER_VIEW == "no" && editable
                          ? true
                          : false),
                      child: Utilities.buildViewRow(
                          "acceptance".tr, this.acceptance)), //acceptance
                  /* Utilities.buildViewRow("application_id".tr , this.app_id),*/ //application_id
                  /* Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          //  width: ScreenUtils.GetListItemContainerScreenWidth(),
                          alignment: (LoadSettings.getLang() == 'ar'
                              ? Alignment.centerRight
                              : Alignment.centerLeft),
                          child: Text(
                            "violation_id".tr + " :",
                            style: ScreenUtils.getItemsTitleTextstyle(),
                          ),
                        ),
                        Container(
                          // width: (LoadSettings.getScreenWidth() * 0.40),
                          alignment: Alignment.center,
                          child: Text(
                            this.violation_id,
                            textAlign: TextAlign.left,
                            style: ScreenUtils.getDetailViewTextstyle(),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          //  width: ScreenUtils.GetListItemContainerScreenWidth(),
                          alignment: (LoadSettings.getLang() == 'ar'
                              ? Alignment.centerRight
                              : Alignment.centerLeft),
                          child: Text(
                            "violation_name".tr + " :",
                            style: ScreenUtils.getTitleViewTextstyle(),
                          ),
                        ),
                        Container(
                          // width: (LoadSettings.getScreenWidth() * 0.40),
                          alignment: Alignment.center,
                          child: Text(
                            this.violation_name,
                            textAlign: TextAlign.left,
                            style: ScreenUtils.getDetailViewTextstyle(),
                          ),
                        )
                      ],
                    ),
                  ), // name
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          //  width: ScreenUtils.GetListItemContainerScreenWidth(),
                          alignment: (LoadSettings.getLang() == 'ar'
                              ? Alignment.centerRight
                              : Alignment.centerLeft),
                          child: Text(
                            "status".tr + " :",
                            style: ScreenUtils.getTitleViewTextstyle(),
                          ),
                        ),
                        Container(
                          // width: (LoadSettings.getScreenWidth() * 0.40),
                          alignment: Alignment.center,
                          child: Text(
                            this.status,
                            textAlign: TextAlign.left,
                            style: ScreenUtils.getDetailViewTextstyle(),
                          ),
                        )
                      ],
                    ),
                  ), //status
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          //  width: ScreenUtils.GetListItemContainerScreenWidth(),
                          alignment: (LoadSettings.getLang() == 'ar'
                              ? Alignment.centerRight
                              : Alignment.centerLeft),
                          child: Text(
                            "emp_name".tr + " :",
                            style: ScreenUtils.getTitleViewTextstyle(),
                          ),
                        ),
                        Container(
                          // width: (LoadSettings.getScreenWidth() * 0.40),
                          alignment: Alignment.center,
                          child: Text(
                            this.employee_name,
                            textAlign: TextAlign.left,
                            style: ScreenUtils.getDetailViewTextstyle(),
                          ),
                        )
                      ],
                    ),
                  ), // employee
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          //  width: ScreenUtils.GetListItemContainerScreenWidth(),
                          alignment: (LoadSettings.getLang() == 'ar'
                              ? Alignment.centerRight
                              : Alignment.centerLeft),
                          child: Text(
                            "_date".tr + " :",
                            style: ScreenUtils.getTitleViewTextstyle(),
                          ),
                        ),
                        Container(
                          // width: (LoadSettings.getScreenWidth() * 0.40),
                          alignment: Alignment.center,
                          child: Text(
                            this.violation_date_time,
                            textAlign: TextAlign.left,
                            style: ScreenUtils.getDetailViewTextstyle(),
                          ),
                        )
                      ],
                    ),
                  ), // date
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          //  width: ScreenUtils.GetListItemContainerScreenWidth(),
                          alignment: (LoadSettings.getLang() == 'ar'
                              ? Alignment.centerRight
                              : Alignment.centerLeft),
                          child: Text(
                            "created_by".tr + " :",
                            style: ScreenUtils.getTitleViewTextstyle(),
                          ),
                        ),
                        Container(
                          // width: (LoadSettings.getScreenWidth() * 0.40),
                          alignment: Alignment.center,
                          child: Text(
                            this.created_by,
                            textAlign: TextAlign.left,
                            style: ScreenUtils.getDetailViewTextstyle(),
                          ),
                        )
                      ],
                    ),
                  ), // created by
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          //  width: ScreenUtils.GetListItemContainerScreenWidth(),
                          alignment: (LoadSettings.getLang() == 'ar'
                              ? Alignment.centerRight
                              : Alignment.centerLeft),
                          child: Text(
                            "explanation".tr + " :",
                            style: ScreenUtils.getTitleViewTextstyle(),
                          ),
                        ),
                        Container(
                          // width: (LoadSettings.getScreenWidth() * 0.40),
                          alignment: Alignment.center,
                          child: Text(
                            this.explanation,
                            textAlign: TextAlign.left,
                            style: ScreenUtils.getDetailViewTextstyle(),
                          ),
                        )
                      ],
                    ),
                  ), //explanation
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          //  width: ScreenUtils.GetListItemContainerScreenWidth(),
                          alignment: (LoadSettings.getLang() == 'ar'
                              ? Alignment.centerRight
                              : Alignment.centerLeft),
                          child: Text(
                            "damage_result".tr + " :",
                            style: ScreenUtils.getTitleViewTextstyle(),
                          ),
                        ),
                        Container(
                          // width: (LoadSettings.getScreenWidth() * 0.40),
                          alignment: Alignment.center,
                          child: Text(
                            this.damage_,
                            textAlign: TextAlign.left,
                            style: ScreenUtils.getDetailViewTextstyle(),
                          ),
                        )
                      ],
                    ),
                  ), //damage_result
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          //  width: ScreenUtils.GetListItemContainerScreenWidth(),
                          alignment: (LoadSettings.getLang() == 'ar'
                              ? Alignment.centerRight
                              : Alignment.centerLeft),
                          child: Text(
                            "emp_comment".tr + " :",
                            style: ScreenUtils.getTitleViewTextstyle(),
                          ),
                        ),
                        Container(
                          // width: (LoadSettings.getScreenWidth() * 0.40),
                          alignment: Alignment.center,
                          child: Text(
                            this.employee_comments,
                            textAlign: TextAlign.left,
                            style: ScreenUtils.getDetailViewTextstyle(),
                          ),
                        )
                      ],
                    ),
                  ), //emp_comment
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          //  width: ScreenUtils.GetListItemContainerScreenWidth(),
                          alignment: (LoadSettings.getLang() == 'ar'
                              ? Alignment.centerRight
                              : Alignment.centerLeft),
                          child: Text(
                            "discpl_board_decision".tr + " :",
                            style: ScreenUtils.getTitleViewTextstyle(),
                          ),
                        ),
                        Container(
                          // width: (LoadSettings.getScreenWidth() * 0.40),
                          alignment: Alignment.center,
                          child: Text(
                            this.decision,
                            textAlign: TextAlign.left,
                            style: ScreenUtils.getDetailViewTextstyle(),
                          ),
                        )
                      ],
                    ),
                  ), //discpl_board_decision
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          //  width: ScreenUtils.GetListItemContainerScreenWidth(),
                          alignment: (LoadSettings.getLang() == 'ar'
                              ? Alignment.centerRight
                              : Alignment.centerLeft),
                          child: Text(
                            "acceptance".tr + " :",
                            style: ScreenUtils.getTitleViewTextstyle(),
                          ),
                        ),
                        Container(
                          // width: (LoadSettings.getScreenWidth() * 0.40),
                          alignment: Alignment.center,
                          child: Text(
                            this.acceptance,
                            textAlign: TextAlign.left,
                            style: ScreenUtils.getDetailViewTextstyle(),
                          ),
                        )
                      ],
                    ),
                  ), //acceptance
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          //  width: ScreenUtils.GetListItemContainerScreenWidth(),
                          alignment: (LoadSettings.getLang() == 'ar'
                              ? Alignment.centerRight
                              : Alignment.centerLeft),
                          child: Text(
                            "application_id".tr + " :",
                            style: ScreenUtils.getTitleViewTextstyle(),
                          ),
                        ),
                        Container(
                          // width: (LoadSettings.getScreenWidth() * 0.40),
                          alignment: Alignment.center,
                          child: Text(
                            this.app_id,
                            textAlign: TextAlign.left,
                            style: ScreenUtils.getDetailViewTextstyle(),
                          ),
                        )
                      ],
                    ),
                  ),*/
                ],
              ),
            ),
          ));
  }
}
