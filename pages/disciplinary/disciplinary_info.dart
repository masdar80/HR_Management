import 'package:amana_foods_hr/classes/discipilinary.dart';
import 'package:amana_foods_hr/classes/service.dart';
import 'package:amana_foods_hr/classes/violationTypes.dart';
import 'package:amana_foods_hr/pages/load_settings.dart';
import 'package:amana_foods_hr/util/ScreenUtil.dart';
import 'package:amana_foods_hr/util/Settings.dart';
import 'package:amana_foods_hr/util/app_constants.dart';
import 'package:amana_foods_hr/util/filter_bar.dart';
import 'package:amana_foods_hr/util/filter_dialog.dart';
import 'package:amana_foods_hr/util/filter_model.dart';
import 'package:amana_foods_hr/util/filter_utilities.dart';
import 'package:amana_foods_hr/util/sorting_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart' as dateF;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'editDisciplinary.dart';

class DisciplinaryInfo extends StatefulWidget {
  @override
  _DisciplinaryInfoState createState() => _DisciplinaryInfoState();
  final String discip_id;
  DisciplinaryInfo(this.discip_id);
}

class _DisciplinaryInfoState extends State<DisciplinaryInfo> {

  Setting conf = new Setting();
  List<Disciplinary> disciplinaries;
  bool editable=false;

  @override
  void initState() {

    super.initState();


    disciplinaries = (
        AppConstants.MANAGER_VIEW =="no"?
        LoadSettings.getDiscpList().where((i) => i.violation_id==widget.discip_id).toList()
            :LoadSettings.getDiscpManagerList().where((i) => i.violation_id==widget.discip_id).toList()
    );
    // Get the allow Committee Value from Violations Types List
 String isAllowCommittee="0";
    //اذا كنا في قائمة المدير فلا داعي لتشييك نوع المخالفة لاننا بالاساس لن نسمح له بالتعديل
    if(AppConstants.MANAGER_VIEW =="no") {
      List<ViolationType> tempArr=LoadSettings.getViolationTypesList().where((i) => i.id == disciplinaries[0].violation_name&&i.company.toLowerCase()==LoadSettings.getCompanyName().toLowerCase()).toList();
      isAllowCommittee =tempArr[0]
              .allowcommittee;
      print("editable comite length inside");
      print(tempArr.length);
    }
    // حتى نسمح بالتعديل يجب أن تكون حالة الرفض/قبول هي لا و نوع المخالفة يسمح بالتعديل و أن نكون في قائمة المستخدم

    editable=(disciplinaries[0].acceptance=="No"&&isAllowCommittee=="1"&&disciplinaries[0].status!="Closed"?true:false);

  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(

        toolbarHeight: ScreenUtils.GetAppBarHeight(),

        leading: Padding(
            padding: EdgeInsets.fromLTRB(8.sp,0,8.sp,0),
            child: IconButton(

          icon: Icon(Icons.arrow_back, color: Colors.white,size: ScreenUtils.GetBarIconSize()),
          onPressed: () => Navigator.of(context).pushNamed('discplinaries'),
        )),
        title: Text("violation".tr, style: ScreenUtils.geHeaderextstyle()),
        centerTitle: true,

        //backgroundColor:  ScreenUtils.getAppColor(),
      ),


      floatingActionButton:
      new Visibility(
          visible: ( AppConstants.MANAGER_VIEW =="no"&&editable?true:false),
          child: FloatingActionButton.extended(

        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditDisciplinaries(widget.discip_id),
            ),
          );
        },
        label:  Text('edit'.tr),
        icon:  Icon(Icons.edit),
        backgroundColor: Theme.of(context).primaryColor,
      )),
      body: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: ScreenUtils.getHeight(), minHeight: 75),
        child: Column(
          children: [
            //filterBarWidget,
            (disciplinaries == null || disciplinaries.isEmpty)
                ? Container(
              height: 200,
              child: Center(
                child: Text("noresults".tr) ,
              ),
            )
                : Expanded(
              child: ListView.builder(
                itemBuilder: (context, i) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        disciplinaries[i],
                    Divider(
                      color: Color.fromRGBO(130, 130, 130, 1),
                      height: 1,
                    ),
                  ]);
                },
                itemCount: disciplinaries.length,
              ),
            )
          ],
        ),
      ),
    );
  }




  final dateF.DateFormat dateFormat = dateF.DateFormat("dd-MM-y");

}
