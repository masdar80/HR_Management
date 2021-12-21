import 'package:amana_foods_hr/pages/leaves/leave_info.dart';
import 'package:amana_foods_hr/pages/load_settings.dart';
import 'package:amana_foods_hr/util/app_constants.dart';
import 'package:amana_foods_hr/util/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amana_foods_hr/util/ScreenUtil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Leave extends StatelessWidget{
  final employee_name; //char
  final employee_id; //char
  final job_title; //char
  final leave_id; // char foreign key
  final leave_type_id; // char foreign key
  final from_date_time; // date time
  final to_date_time; // date time
  final employee_comments; //multi line  char
  final direct_manager_comments; //multi line  char
  final direct_manager_decision; //dropdown
  final status; //dropdown
  final app_id;
  final editFlage;
  Leave({
    this.employee_name,
    this.employee_id,
    this.job_title,
    this.leave_id,
    this.leave_type_id,
    this.from_date_time,
    this.to_date_time,
    this.employee_comments,
    this.direct_manager_comments,
    this.direct_manager_decision,
    this.status,
    this.app_id,
    this.editFlage,
  });


  Map<String, dynamic> _LeaveToJson(Leave instance) =>
      <String, dynamic>{
        'EmployeeName': instance.employee_name,
        'EmployeeId': instance.employee_id,
        'WorkerPosition': instance.job_title,
        'LeaveRequestID': instance.leave_id,
        'LeaveTypeId': instance.leave_type_id,
        'FromDate': instance.from_date_time,
        'ToDate': instance.to_date_time,
        'ManagerComments': instance.direct_manager_comments,
        'ManagerDecision': instance.direct_manager_decision,
        'Employee Comments': instance.employee_comments,
        'LeaveStatus': instance.status,
        'ApplicationId': instance.app_id,
      };
  Map<String, dynamic> toJson() => _LeaveToJson(this);

  Map<String, dynamic> toMap() {
    return {
      'employee_name': employee_name,
      'employee_id': employee_id,
      'job_title': job_title,
      'leave_id': leave_id,
      'leave_type_id': leave_type_id,
      'from_date_time': from_date_time,
      'to_date_time': to_date_time,
      'employee_comments': employee_comments,
      'direct_manager_comments': direct_manager_comments,
      'direct_manager_decision': direct_manager_decision,
      'status': status,
      'app_id': app_id,
      'editFlage': editFlage,
    };
  }

  @override
  Widget build(BuildContext context) {

    return (AppConstants.LEAVE_ALL.toLowerCase()=="yes"?
    InkWell(
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
                      "_id".tr +" :",
                      style: ScreenUtils.getItemsTitleTextstyle(),
                    ),
                    Utilities.buildExpandedText(this.leave_id)
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "type".tr+" :",
                      style: ScreenUtils.getItemsTitleTextstyle(),
                    ),
                    Utilities.buildExpandedText(this.leave_type_id.toString())
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "emp_name".tr+" :",
                      style: ScreenUtils.getItemsTitleTextstyle(),
                    ),
                    Utilities.buildExpandedText(this.employee_name)
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "leave_date_from".tr+" :",
                      style: ScreenUtils.getItemsTitleTextstyle(),
                    ),
                    Utilities.buildExpandedText(this.from_date_time)
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "leave_date_to".tr+" :",
                      style: ScreenUtils.getItemsTitleTextstyle(),
                    ),
                    Utilities.buildExpandedText(this.to_date_time)
                  ],
                ),

              ],
            ),
          ),

        ),
        onTap: () {
          AppConstants.LEAVE_ALL="no";
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LeaveInfo(this.leave_id),
            ),
          );
        })
        :
    Card(
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(5.0),
        // padding: ScreenUtils.GetEdgeinsests(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            Utilities.buildViewRow("_id".tr , this.leave_id),//_id
            Utilities.buildViewRow("emp_id".tr , this.employee_id),//emp_id
            Utilities.buildViewRow("emp_name".tr , this.employee_name),//emp_name
            Utilities.buildViewRow("job_title".tr , this.job_title),//job_title
            Utilities.buildViewRow("leave_type".tr , this.leave_type_id.toString()),//leave_type
            Utilities.buildViewRow("leave_date_from".tr , this.from_date_time),//leave_date_from
            Utilities.buildViewRow("leave_date_to".tr , this.to_date_time),//leave_date_to
            Utilities.buildViewRow("emp_comment".tr , (this.employee_comments!=null?this.employee_comments:"")),//emp_comment
            Utilities.buildViewRow("status".tr , (this.status!=null?this.status:"")),//status
            Utilities.buildViewRow("dir_man_comment".tr , this.direct_manager_comments),//dir_man_comment
            Utilities.buildViewRow("dir_man_decision".tr , this.direct_manager_decision),//dir_man_decision
            /*Utilities.buildViewRow("application_id".tr , this.app_id),*///application_id

          ],
        ),
      ),
    )

    );
  }
}