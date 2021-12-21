import 'package:amana_foods_hr/classes/main_menu.dart';
import 'package:amana_foods_hr/pages/load_settings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';

import 'ScreenUtil.dart';

class MainMenuItem extends StatelessWidget {
  final MenuItem _menuItem;

  const MainMenuItem(this._menuItem);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Card(
        elevation: 0,
        margin: EdgeInsets.only(top: 5.sp, right: 5, left: 5, bottom: 5.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(top: 5.sp, left: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.fromLTRB(8.sp,0,8.sp,0),
                      child:Icon(
                    _menuItem.icon,
                    color: Theme.of(context).primaryColor,
                    size: 35.sp,
                  )),
                  SizedBox(
                    width: 20.sp,
                  ),
                  Wrap(
                    spacing: 5.sp,
                    runSpacing: 5.sp,
                    direction: Axis.vertical,
                    children: <Widget>[
                      Text(
                        _menuItem.text,
                        style:ScreenUtils.getTitleViewTextstyle(),
                      ),
                      Text(
                        _menuItem.description,
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
