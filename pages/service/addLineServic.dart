import 'dart:convert';

import 'package:amana_foods_hr/classes/products.dart';
import 'package:amana_foods_hr/classes/service.dart';
import 'package:amana_foods_hr/classes/various_lists.dart';
import 'package:amana_foods_hr/db/db_class.dart';
import 'package:amana_foods_hr/db/get_data_class.dart';
import 'package:amana_foods_hr/pages/load_settings.dart';
import 'package:amana_foods_hr/util/ScreenUtil.dart';
import 'package:amana_foods_hr/util/Settings.dart';
import 'package:amana_foods_hr/util/app_constants.dart';
import 'package:amana_foods_hr/util/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:searchable_dropdown/searchable_dropdown.dart';

class AddLineService extends StatefulWidget {
  @override
  _AddLineServiceState createState() => _AddLineServiceState();
  final Function() linesListFunction;
  final app_id;
  final linesCounter;
  AddLineService(this.linesListFunction,this.app_id,this.linesCounter);
}

class _AddLineServiceState extends State<AddLineService> {


  String itemid="",ItemName="";

  //FToast fToast2;

  DateTime selectedDate = DateTime.now();


  static bool show = false;
  static bool err = false;
  static String msg = "";
  DB_Class db= new DB_Class();


 // final ServiceIDController= TextEditingController();
  final dateController = TextEditingController();
  final quantityController = TextEditingController();
  final unitController = TextEditingController();
  //final priceController = TextEditingController();


  @override
  void initState() {
    dateController.text = DateFormat('dd/MM/yyyy')
        .format(DateTime.parse("${selectedDate.toLocal()}"));

    super.initState();
    //fToast2 = FToast();
   // fToast2.init(context);
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.fromLTRB(25.sp, 2.sp, 25.sp, 2.sp),
        width: ScreenUtils.GetAddPageContainerScreenWidth()*(2/3),
        height:(ScreenUtils.getHeight()>750?310.sp:355.sp) ,

        child: ListView(
          children: [
            Container(
              alignment: (LoadSettings.getLang() == 'en'
                  ? Alignment.centerLeft
                  : Alignment.centerRight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: ScreenUtils.GetAddPageMargins(),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      child:SearchableDropdown<Product>.single(
                        isExpanded: true,

                        //decoration: InputDecoration.collapsed(hintText: ""),
                        style: ScreenUtils.getItemsDetailsTextstyle(),
                        hint: Text(
                          "Select Item",
                          style: TextStyle(color: Colors.black),
                        ),
                        disabledHint: Text("Select Item"),

                        onChanged:(Product newValue) {
                          setState(() {
                            print("new value to set is $newValue");
                            if(newValue!=null)
                            {itemid = newValue.id;
                            ItemName=newValue.name;
                            unitController.text=newValue.unit;}
                            else
                              {
                                itemid ="";
                                ItemName="";
                                unitController.text="";

                              }
                          });
                        },
                        onClear:() {
                          setState(() {

                            itemid ="";
                            ItemName="";
                            unitController.text="";
                          });
                        },
                        items: LoadSettings.getProductsList()
                            .map((Product item) => DropdownMenuItem<Product>(
                            child: Text(item.name),
                            value: item))
                            .toList(),
                      )
                  ),

                  Container(
                    // width: (screenWidth * 0.95),
                    //margin: ScreenUtils.GetAddPageMargins(),
                    child: TextField(
                      enabled: false,
                      controller: unitController,
                      keyboardType: TextInputType.number,
                      style: ScreenUtils.getItemsDetailsTextstyle(),
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: 'unit'.tr),
                    ),
                  ),
                  Container(
                    // width: (screenWidth * 0.95),
                    //margin: ScreenUtils.GetAddPageMargins(),
                    child: TextField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      style: ScreenUtils.getItemsDetailsTextstyle(),
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: 'quantity'.tr),
                    ),
                  ),// Quantity
                  /*Container(
                    // width: (screenWidth * 0.95),
                    //margin: ScreenUtils.GetAddPageMargins(),
                    child: TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      style: ScreenUtils.getItemsDetailsTextstyle(),
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: 'price'.tr),
                    ),
                  ),*/// Price
                  Container(
                    margin: ScreenUtils.GetAddPageMargins(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("_date".tr,
                            // textAlign: (LoadSettings.getLang() == 'ar' ? TextAlign.right : TextAlign.left),
                            style: ScreenUtils.getItemsDetailsTextstyle()),
                        TextField(
                          controller: dateController,
                          keyboardType: TextInputType.datetime,
                          style: ScreenUtils.getItemsDetailsTextstyle(),
                        ),
                      ],
                    ),
                  ),//date
                  Container(

                    padding: EdgeInsets.only(left: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(20.sp, 5.sp, 20.sp, 5.sp),
    primary:Theme.of(context).primaryColorDark ),

                          child: Text(
                            "cancel".tr,
                            style: TextStyle(
                                color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 15.sp,

                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
//                FlatButton(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(20.sp, 5.sp, 20.sp, 5.sp),
                              primary:Theme.of(context).primaryColorDark ),// This is what you need!
                          child: Text(
                            "add".tr,
                            style: TextStyle(
                                color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 15.sp,
                               // backgroundColor: Theme.of(context).primaryColor
                            ),
                          ),
                          onPressed: () => addLine(),
                        ),
                      ],
                    ),
                    //color: Theme.of(context).primaryColor,
                  ),

                ],
              ),
            ),
          ],
        ));
  }



    void addLine() {
      if (itemid == "" || quantityController.text == "" ||
           dateController.text == "") {
        //Utilities.showToast(true, "fillFields".tr,fToast2);
      }
      else
        {
          Lines line = Lines(
          line_id: widget.linesCounter,
          service_item_id: itemid,
          quantity: quantityController.text,
          delivery_date: dateController.text ,
          po_status: '',
          unit: unitController.text,
          request_id: widget.app_id,
          service_item_name: ItemName,


        );
      LoadSettings.addItem_tempServiceLinesList(line);
        Navigator.of(context).pop();
        widget.linesListFunction();
        }
    }



}
