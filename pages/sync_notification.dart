import 'dart:convert';

import 'package:amana_foods_hr/classes/discipilinary.dart';
import 'package:amana_foods_hr/classes/syncError.dart';
import 'package:amana_foods_hr/db/db_class.dart';
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
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as dateF;
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SyncNotification extends StatefulWidget {
  @override
  _SyncNotificationState createState() => _SyncNotificationState();
  final String documentType;
  SyncNotification(this.documentType);
}

class _SyncNotificationState extends State<SyncNotification> {


  Setting conf = new Setting();
  List<SyncError> syncErrors;
  List<SyncError> filteredList = [];
  FilterBarWidget filterBarWidget;



  @override
  void initState() {
    // getData();
    super.initState();
    syncErrors = LoadSettings.getSyncErrorList();
  }

  @override
  Widget build(BuildContext context) {
    AppConstants.DISCPS_ALL="yes";

    filterBarWidget = new FilterBarWidget(_searchList, _showFilterDialog, _showSortDialog, filterEnabled, false);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: ScreenUtils.GetAppBarHeight(),

        leading: Padding(
            padding: EdgeInsets.fromLTRB(8.sp,0,8.sp,0),
            child:IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,size: ScreenUtils.GetBarIconSize()),
          onPressed: () => Navigator.of(context).pushNamed('homepage'),
        )),
        title: Text("sync_notification".tr,style:TextStyle(color: Colors.white,fontSize:6+ScreenUtils.GetHomePageFontSize())),
        centerTitle: true,
       // backgroundColor:  ScreenUtils.getAppColor(),
      ),

      floatingActionButton:
      FloatingActionButton.extended(

        onPressed: () {
          clearNotifications();
          setState(() {
            LoadSettings.setSyncErrorList(null);
            syncErrors = null;
          });

        },
        label:  Text('clearnot'.tr),
        icon:  Icon(Icons.edit),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height, minHeight: 75),
        child: Column(
          children: [
            filterBarWidget,
            (_getDataToShow()== null || _getDataToShow().isEmpty)
                ? Container(
              //height: 200,
              child: Center(
                child: Text("noresults".tr),
              ),
            )
                : Expanded(
              child: ListView.builder(
                itemBuilder: (context, i) {
                  return Column(children: <Widget>[
                    _getDataToShow()[i],
                    Divider(
                      color: Color.fromRGBO(130, 130, 130,130),
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


 clearNotifications()
 {
   var dbHelper = DB_Class();
   dbHelper.truncateErrorSyncs();
 }


  List<SyncError> _getDataToShow() {
    return filterEnabled ? filteredList : syncErrors;
  }



  bool filterEnabled = false;
  bool filterEnabledManager = false;
  _searchList(String searchQuery) {
    setState(() {
      if (searchQuery.trim().isEmpty) {
        filteredList = null;
        filterEnabled = false;
        return;
      }
      filteredList = syncErrors.where((element) {
        return _filterByName(element) && _filterByID(searchQuery.trim(), element);
      }).toList();
      filteredList.sort((a, b) => a.doc_id.compareTo(b.doc_id));
      filterEnabled = true;

   });
  }


  _filterByName(SyncError element) {
    return widget.documentType.toLowerCase() == AppConstants.TYPE_ALL.toLowerCase() || element.doc_id.toLowerCase() == widget.documentType.toLowerCase();
  }

  _filterByID(String query, SyncError element) {
    return element.doc_id.toLowerCase().contains(query.toLowerCase());
  }

  List<String> sortingHeaders = ["Violation ID","Violation Type", "Employee", "Date"];
  List<bool> sortArray = [false, false, false, false, false, false, false, false];

  List<FilterModel> filters = [
    FilterModel(caption: "Violation ID", fieldName: "ViolationID", checked: false, selectedCompareOption: "", isNumber: false, isDate: false),
    FilterModel(caption: "Violation Type", fieldName: "ViolationType", checked: false, selectedCompareOption: "", isNumber: false, isDate: false),
    FilterModel(caption: "Employee", fieldName: "EmployeeName", checked: false, selectedCompareOption: "", isNumber: false, isDate: false),
    FilterModel(caption: "Date", fieldName: "ViolationDateTime", isDate: true, selectedCompareOption: "", isNumber: false, checked: false, fromDate: DateTime.now(), toDate: DateTime.now()),
  ];

  _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SortingDialogWidget(_sortData, sortArray, sortingHeaders);
            },
          ),
        );
      },
    );
  }


  _showFilterDialog() {
    FilterModel typeFilter = FilterModel(caption: "Violation Type", fieldName: "ViolationType", selectedCompareOption: "", isDocumentTypeFilter: true);
    if (widget.documentType.toLowerCase() == AppConstants.TYPE_ALL.toLowerCase()) {
     // if (filters.where((element) => element.isDocumentTypeFilter).isEmpty) filters.add(typeFilter);
    }
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return FilterDialogWidget(filters, _filterData);
            },
          ),
        );
      },
    );
  }



  _sortData(int sortingIndex) {
    sortArray.asMap().forEach((key, value) {
      sortArray[key] = false;
    });

    if (sortingIndex >= 0) sortArray[sortingIndex] = true;

    setState(() {
     // Navigator.pop(context);
      if (sortingIndex == -1) {
        _getDataToShow().sort((a, b) => a.doc_id.compareTo(b.doc_id));
      } else {
        _getDataToShow().sort((a, b) => _sortBy(a, b, sortingIndex));
      }
    });
  }


  final dateF.DateFormat dateFormat = dateF.DateFormat("dd-MM-y HH:mm");
  _sortBy(SyncError a, SyncError b, int sortingIndex) {
    switch (sortingIndex) {
      case 0:
        return a.doc_id.trim().compareTo(b.doc_id.trim());
      case 1:
        return b.doc_id.trim().compareTo(a.doc_id.trim());

      case 2:
        return a.doc_type.trim().compareTo(b.doc_type.trim());
      case 3:
        return b.doc_type.trim().compareTo(a.doc_type.trim());

    }
  }

  _filterData() {
    if (filteredList != null) filteredList.clear();
    List<FilterModel> enabledFilters = filters.where((e) => e.checked).toList();
    if (enabledFilters.isNotEmpty) {
      enabledFilters.forEach((filterModel) {
        filteredList = ((filteredList!=null && filteredList.isNotEmpty) ? filteredList : syncErrors).where((discplinary) {
          return filterModel.isDocumentTypeFilter
              ? FilterUtilities.filterByDocumentType(discplinary, filterModel.fieldName, filterModel.selectedCompareOption)
              : (_filterByName(discplinary) && filterModel.isDate
              ? FilterUtilities.filterByDate(discplinary, filterModel.fieldName, filterModel.selectedCompareOption, filterModel.fromDate, false, searchDate2: filterModel.toDate)
              : FilterUtilities.filterByDynamicString(filterModel.value1, filterModel.value2, discplinary, filterModel.fieldName, filterModel.selectedCompareOption));
        }).toList();
      });
    }
    setState(() {
      filterEnabled = enabledFilters.isNotEmpty;
    });
  }

}
