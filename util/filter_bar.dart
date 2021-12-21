import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'ScreenUtil.dart';

class FilterBarWidget extends StatefulWidget {
  @override
  _FilterBarWidgetState createState() => _FilterBarWidgetState();

  final void Function() openSortDialog;
  final void Function() openFilterDialog;
  final void Function(String) searchContent;
  final filterEnabled;
  final sortEnabled;
  //final searchFieldController = TextEditingController();
  FilterBarWidget(this.searchContent, this.openFilterDialog, this.openSortDialog, this.filterEnabled, this.sortEnabled);

  /*String getSearchQuery() {
    return searchFieldController.text;
  }*/
}
//final searchFieldController = TextEditingController();


class _FilterBarWidgetState extends State<FilterBarWidget> {

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return Wrap(
      children: [
        Container(
          color: Colors.black12,
          height: ScreenUtils.getHeight()/16,
          child: Table(

            defaultColumnWidth: FixedColumnWidth((MediaQuery.of(context).size.width) / 3),
            border: TableBorder.symmetric(inside: BorderSide(color: Color.fromRGBO(130, 130, 130, 1))),
            children: [
              TableRow(
                children: [
                  TableCell(
                      child: SizedBox(

                          height: 45.sp,
                          child:TextField(

                    onChanged: _dispatchTextChanged,
                    style:  TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 14.sp,
                    ),

                    decoration: InputDecoration(


                     // filled: true,
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 14.sp,
                      ),
                      hintText: "search".tr,
                      prefixIcon: Icon(Icons.search,size:ScreenUtils.GetIconSize()-10,color: Colors.grey,),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  )
        )),
                  TableCell(
                      child: SizedBox(

                          height: 45.sp,
                          child:FlatButton(
                    height: 60,
                    child: Row(
                      children: [
                        Icon(
                          Icons.filter_alt_outlined,
                        size:ScreenUtils.GetIconSize()-10,
                          color: Colors.grey,
                        ),
                        Text("filter".tr,
                            style: ScreenUtils.getCardItemsDetailsTextstyle()),
                      ],
                    ),
                    onPressed: () {
                      widget.openFilterDialog();
                    },
                  )
    )),
                  TableCell(
                      child: SizedBox(

                          height: 45.sp,
                          child:FlatButton(
                    height: 60,
                    child: Row(
                      children: [
                        Icon(
                          Icons.sort_by_alpha,
                          size:ScreenUtils.GetIconSize()-10,
                          color:  Colors.grey,
                        ),
                        Text("sort".tr,
                            style:  ScreenUtils.getCardItemsDetailsTextstyle(),),
                      ],
                    ),
                    onPressed: () {
                      widget.openSortDialog();
                    },
                  )
    )),
                ],
              ),
            ],
          ),
        ),
        Divider(
          color: Color.fromRGBO(130, 130, 130, 2),
          height: 3,
        ),
      ],
    );
  }

  _dispatchTextChanged(String newText) {
    setState(() {
      widget.searchContent(newText);
    });
  }
}
