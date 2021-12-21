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

class Serviceinfo extends StatefulWidget {
  @override
  _ServiceinfoState createState() => _ServiceinfoState();
  final String service_id;
  Serviceinfo(this.service_id);
}

class _ServiceinfoState extends State<Serviceinfo> {

  Setting conf = new Setting();
  List<Services> services;
  List<Lines> lines;
  List<Services> filteredList = [];
  FilterBarWidget filterBarWidget;
  List<Widget> listScreens;
  int tabIndex = 0;

  @override
  void initState() {

    super.initState();


  }

  @override
  Widget build(BuildContext context) {

    AppConstants.LEAVE_ALL="yes";

    if(AppConstants.MANAGER_VIEW =="no")
    {
      services = LoadSettings.getServicesList().where((i) => i.request_id==widget.service_id).toList();
    lines=LoadSettings.getLinesList().where((i) => i.request_id==widget.service_id).toList();
    }
    else{
      services = LoadSettings.getServicesManagerList().where((i) => i.request_id==widget.service_id).toList();
      lines=LoadSettings.getLinesManagerList().where((i) => i.request_id==widget.service_id).toList();
    }


    filterBarWidget = FilterBarWidget(_searchList, _showFilterDialog, _showSortDialog, filterEnabled, false);

    listScreens = [
      headerTab(),
      detailsTab(),

    ];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: ScreenUtils.GetAppBarHeight(),

        leading: Padding(
            padding: EdgeInsets.fromLTRB(8.sp,0,8.sp,0),
            child:IconButton(

          icon: Icon(Icons.arrow_back, color: Colors.white,size: ScreenUtils.GetBarIconSize()),
          onPressed: () => Navigator.of(context).pushNamed('services'),
        )),
        title: Text("service".tr, style: ScreenUtils.geHeaderextstyle()),
        centerTitle: true,
        //backgroundColor:  ScreenUtils.getAppColor(),
      ),
      //drawer: MyDrawer(),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[400],
        backgroundColor: Theme.of(context).primaryColor,
        currentIndex: tabIndex,
        onTap: (int index) {
          setState(() {
            tabIndex = index;
          });
        },
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.view_headline,size: ScreenUtils.GetIconSize(),),
            label: "header".tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.details_outlined,size: ScreenUtils.GetIconSize()),
            label: "details".tr,
          ),

        ],
      ),
      body: listScreens[tabIndex],
    );
  }



  Widget detailsTab()
  {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: ScreenUtils.getHeight(), minHeight: 75),
      child: Column(
        children: [
          //filterBarWidget,
          (_getDetailsDataToShow() == null || _getDetailsDataToShow().isEmpty)
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
                  _getDetailsDataToShow()[i],
                  Divider(
                    color: Color.fromRGBO(130, 130, 130, 1),
                    height: 1,
                  ),
                ]);
              },
              itemCount: _getDetailsDataToShow().length,
            ),
          )
        ],
      ),
    );
  }
  Widget headerTab()
  {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: ScreenUtils.getHeight(), minHeight: 75),
      child: Column(
        children: [
          //filterBarWidget,
          (_getDataToShow() == null || _getDataToShow().isEmpty)
              ? Container(
            height: 200,
            child: Center(
              child: filterEnabled ? Text("noresults".tr) : CircularProgressIndicator(),
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
    );
  }
  List<Services> _getDataToShow() {
    return filterEnabled ? filteredList : services;
  }
  List<Lines> _getDetailsDataToShow() {
    return  lines;
  }

  buildItem(Services discp) {
    /* switch (widget.documentType) {
      case AppConstants.TYPE_SALES:
        return SalesApprovalItemCard(discp);
      case AppConstants.TYPE_PURCHASE:
        return PurchaseApprovalItemCard(discp);
      case AppConstants.TYPE_NON_CONFORMANCE:
        return NonConformanceApprovalItemCard(discp);
      case AppConstants.TYPE_PRICE_LIST:
        return PriceListApprovalItemCard(discp);
      case AppConstants.TYPE_ALL:
        return ApprovalItemCard(discp);
    }*/
  }

  bool filterEnabled = false;
  _searchList(String searchQuery) {
    setState(() {
      if (searchQuery.trim().isEmpty) {
        filteredList = null;
        filterEnabled = false;
        return;
      }
      filteredList = services.where((element) {
        return _filterByName(element) && _filterByID(searchQuery.trim(), element);
      }).toList();
      filteredList.sort((a, b) => a.request_id.compareTo(b.request_id));
      filterEnabled = true;

    });
  }

  _filterByName(Services element) {
    return widget.service_id.toLowerCase() == AppConstants.TYPE_ALL.toLowerCase() || element.request_id.toLowerCase() == widget.service_id.toLowerCase();
  }

  _filterByID(String query, Services element) {
    return element.request_id.toLowerCase().contains(query.toLowerCase());
  }

  List<String> sortingHeaders = ["Request ID","Preparer", "Status", "Date"];
  List<bool> sortArray = [false, false, false, false, false, false, false, false];

  List<FilterModel> filters = [                  //PurchReqId
    FilterModel(caption: "Request ID", fieldName: "PurchReqId", checked: false, selectedCompareOption: "", isNumber: false, isDate: false),
    FilterModel(caption: "Preparer", fieldName: "Preparer", checked: false, selectedCompareOption: "", isNumber: false, isDate: false),
    FilterModel(caption: "Status", fieldName: "RequisitionStatus", checked: false, selectedCompareOption: "", isNumber: false, isDate: false),
    FilterModel(caption: "Date", fieldName: "RequestedDate", isDate: true, selectedCompareOption: "", isNumber: false, checked: false, fromDate: DateTime.now(), toDate: DateTime.now()),
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
    if (widget.service_id.toLowerCase() == AppConstants.TYPE_ALL.toLowerCase()) {
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
        _getDataToShow().sort((a, b) => a.request_id.compareTo(b.request_id));
      } else {
        _getDataToShow().sort((a, b) => _sortBy(a, b, sortingIndex));
      }
    });
  }

  final dateF.DateFormat dateFormat = dateF.DateFormat("dd-MM-y");
  _sortBy(Services a, Services b, int sortingIndex) {
    switch (sortingIndex) {
      case 0:
        return a.request_id.trim().compareTo(b.request_id.trim());
      case 1:
        return b.request_id.trim().compareTo(a.request_id.trim());

      case 2:
        return a.employee_name.trim().compareTo(b.employee_name.trim());
      case 3:
        return b.employee_name.trim().compareTo(a.employee_name.trim());

      case 4:
        return a.status.trim().compareTo(b.status.trim());
      case 5:
        return b.status.trim().compareTo(a.status.trim());

      case 6:
        return dateFormat.parse(a.request_date).compareTo(dateFormat.parse(b.request_date));
      case 7:
        return dateFormat.parse(b.request_date).compareTo(dateFormat.parse(a.request_date));

    }
  }

  _filterData() {
    if (filteredList != null) filteredList.clear();
    List<FilterModel> enabledFilters = filters.where((e) => e.checked).toList();
    if (enabledFilters.isNotEmpty) {
      enabledFilters.forEach((filterModel) {
        filteredList = (filteredList.isNotEmpty ? filteredList : services).where((serv) {
          return filterModel.isDocumentTypeFilter
              ? FilterUtilities.filterByDocumentType(serv, filterModel.fieldName, filterModel.selectedCompareOption)
              : (_filterByName(serv) && filterModel.isDate
              ? FilterUtilities.filterByDate(serv, filterModel.fieldName, filterModel.selectedCompareOption, filterModel.fromDate, false, searchDate2: filterModel.toDate)
              : FilterUtilities.filterByDynamicString(filterModel.value1, filterModel.value2, serv, filterModel.fieldName, filterModel.selectedCompareOption));
        }).toList();
      });
    }
    setState(() {
      filterEnabled = enabledFilters.isNotEmpty;
    });
  }
}
