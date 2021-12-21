import 'package:amana_foods_hr/util/utilities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SortingDialogWidget extends StatefulWidget {
  @override
  _SortingDialogWidgetState createState() => _SortingDialogWidgetState();

  final void Function(int) sortData;
  final List<bool> sortArray;
  final List<String> sortingHeaders;
  SortingDialogWidget(this.sortData,this.sortArray,this.sortingHeaders);

}

class _SortingDialogWidgetState extends State<SortingDialogWidget> {
  @override
  Widget build(BuildContext context) {
    builderIndex = -2;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(left: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Utilities.buildExpandedText("sortby".tr , textColor: Colors.white),
                FlatButton(),
//                          FlatButton(
//                            child: Text("Default", style: TextStyle(color: Colors.white),),
//                            onPressed: () => _sortData(-1),
//                          ),
              ],
            ),
            color: Theme.of(context).primaryColor,
          ),
          Container(
            padding: EdgeInsets.all(18),
            child: Table(
              defaultColumnWidth:  FixedColumnWidth((MediaQuery.of(context).size.width ) / 4),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: widget.sortingHeaders.map((e) {
                builderIndex +=2 ;
                return _buildSortingRow(e, builderIndex);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  int builderIndex = -2;
  TableRow _buildSortingRow(String caption, int index ){
    return TableRow(
        children: [
          Text(caption,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),) ,
          Container(
            padding: EdgeInsets.only(left: 8),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
              child: Text(
                "asc".tr,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),
              ),
              color: widget.sortArray[index] ? Theme.of(context).primaryColor : Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
              widget.sortData(index);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 8),
            child:  FlatButton(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
              child: Text("desc".tr,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),),
              color: widget.sortArray[index+1] ? Theme.of(context).primaryColor : Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
                widget.sortData(index+1);
              } ,
            ),
          ),
        ]
    );
  }

}
