import 'package:amana_foods_hr/classes/discipilinary.dart';
import 'package:amana_foods_hr/classes/leave.dart';
import 'package:amana_foods_hr/classes/maintenance.dart';
import 'package:amana_foods_hr/classes/payment.dart';
import 'package:amana_foods_hr/classes/service.dart';
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

class PaymentInfo extends StatefulWidget {
  @override
  _PaymentInfoState createState() => _PaymentInfoState();
  final String req_id;
  PaymentInfo(this.req_id);
}

class _PaymentInfoState extends State<PaymentInfo> {

  Setting conf = new Setting();
  List<Payment> payments;

  @override
  void initState() {

    super.initState();


  }

  @override
  Widget build(BuildContext context) {


    payments =  (
        AppConstants.MANAGER_VIEW =="no"?
        LoadSettings.getPaymentList().where((i) => i.adv_pay_id==widget.req_id).toList()
            :LoadSettings.getPaymentManagerList().where((i) => i.adv_pay_id==widget.req_id).toList()
    );




    return Scaffold(
      appBar: AppBar(
        toolbarHeight: ScreenUtils.GetAppBarHeight(),

        leading: Padding(
            padding: EdgeInsets.fromLTRB(8.sp,0,8.sp,0),
            child: IconButton(

          icon: Icon(Icons.arrow_back, color: Colors.white,size: ScreenUtils.GetBarIconSize()),
          onPressed: () => Navigator.of(context).pushNamed('payments'),
        )),
        title: Text("payment_info".tr, style: ScreenUtils.geHeaderextstyle()),
        centerTitle: true,
        //backgroundColor:  ScreenUtils.getAppColor(),
      ),
      //drawer: MyDrawer(),

      body: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: ScreenUtils.getHeight(), minHeight: 75),
        child: Column(
          children: [
            //filterBarWidget,
            (_getDataToShow() == null || _getDataToShow().isEmpty)
                ? Container(
              height: 200,
              child: Center(
                child: Text("noresults".tr) ,
              ),
            )
                : Expanded(
              child: ListView.builder(
                itemBuilder: (context, i) {
                  return Column(children: <Widget>[
                    _getDataToShow()[i],
                    Divider(
                      color: Color.fromRGBO(130, 130, 130, 1),
                      height: 1,
                    ),
                  ]);
                },
                itemCount: _getDataToShow().length,
              ),
            )
          ],
        ),
      ),
    );
  }


  List<Payment> _getDataToShow() {
    return payments;
  }



}
