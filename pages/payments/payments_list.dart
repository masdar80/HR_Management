import 'package:amana_foods_hr/classes/payment.dart';
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

class PaymentsList extends StatefulWidget {
  @override
  _PaymentsListState createState() => _PaymentsListState();
  final String documentType;
  PaymentsList(this.documentType);
}

class _PaymentsListState extends State<PaymentsList> {

  Setting conf = new Setting();
  List<Payment> payments,paymentsManager;
  List<Payment> filteredList = [],filteredListManager = [];
  FilterBarWidget filterBarWidget,filterBarWidgetManager;
  List<Widget> listScreens;
  int tabIndex = 0;
  @override
  void initState() {
    super.initState();
    tabIndex=(AppConstants.MANAGER_VIEW=="no"?0:1);
    payments = LoadSettings.getPaymentList();
    paymentsManager = LoadSettings.getPaymentManagerList();
  }
  @override
  Widget build(BuildContext context) {
    AppConstants.PAYEMENT_ALL="YES";

    filterBarWidget = FilterBarWidget(_searchList, _showFilterDialog, _showSortDialog, filterEnabled, false);
    filterBarWidgetManager = FilterBarWidget(_searchManagerList, _showFilterManagerDialog, _showSortManagerDialog, filterEnabledManager, false);

    listScreens = [

      paymentTab(_getDataToShow(),filterBarWidget),
      paymentTab(_getDataManagerToShow(),filterBarWidgetManager),

    ];
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: ScreenUtils.GetAppBarHeight(),
          actions: [
            // action button
            Padding(
                padding: EdgeInsets.fromLTRB(8.sp,0,8.sp,0),
                child: IconButton(
              icon: Icon( Icons.add,size: ScreenUtils.GetBarIconSize()),
              onPressed: () => Navigator.of(context).pushNamed('add_payment'),
            )),

          ],
          leading:Padding(
              padding: EdgeInsets.fromLTRB(8.sp,0,8.sp,0),
              child:  IconButton(

            icon: Icon(Icons.arrow_back, color: Colors.white,size: ScreenUtils.GetBarIconSize()),
            onPressed: () => Navigator.of(context).pushNamed('homepage'),
          )),
          title: Text("adv_payment".tr,style:TextStyle(color: Colors.white,fontSize:6+ScreenUtils.GetHomePageFontSize())),
          centerTitle: true,
         // backgroundColor:  ScreenUtils.getAppColor(),
        ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[400],
        backgroundColor: Theme.of(context).primaryColor,
        currentIndex: tabIndex,
        onTap: (int index) {
          setState(() {
            tabIndex = index;
            AppConstants.MANAGER_VIEW=(index==0?"no":"yes");

          });
        },
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list,size: ScreenUtils.GetIconSize(),),
            label: "user".tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle_sharp,size: ScreenUtils.GetIconSize()),
            label: "team".tr,
          ),

        ],
      ),
        body: listScreens[tabIndex],
    );
  }

  Widget paymentTab(List<Payment> list,FilterBarWidget  filterWidg)
  {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height, minHeight: 75),
      child: Column(
        children: [
          filterWidg,
          (list== null || list.isEmpty)
              ? Container(
            height: 200,
            child: Center(
              child:Text("noresults".tr) ,//child: filterEnabled ? Text("noresults".tr) : CircularProgressIndicator(),
            ),
          )
              : Expanded(
            child: ListView.builder(
              itemBuilder: (context, i) {
                return Column(children: <Widget>[
                  list[i],
                  Divider(
                    color: Color.fromRGBO(130, 130, 130, 1),
                    height: 1,
                  ),
                ]);
              },
              itemCount: list.length,
            ),
          )
        ],
      ),
    );
  }
  List<Payment> _getDataToShow() {
    return filterEnabled ? filteredList : payments;
  }
  List<Payment> _getDataManagerToShow() {
    return filterEnabledManager ? filteredListManager : paymentsManager;
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
      filteredList = payments.where((element) {
        return _filterByName(element) && _filterByID(searchQuery.trim(), element);
      }).toList();
      filteredList.sort((a, b) => a.adv_pay_id.compareTo(b.adv_pay_id));
      filterEnabled = true;

    });
  }
  _searchManagerList(String searchQuery) {
    setState(() {
      if (searchQuery.trim().isEmpty) {
        filteredListManager = null;
        filterEnabledManager = false;
        return;
      }
      filteredListManager = paymentsManager.where((element) {
        return _filterByName(element) && _filterByID(searchQuery.trim(), element);
      }).toList();
      filteredListManager.sort((a, b) => a.adv_pay_id.compareTo(b.adv_pay_id));
      filterEnabledManager = true;

    });
  }


  _filterByName(Payment element) {
    return widget.documentType.toLowerCase() == AppConstants.TYPE_ALL.toLowerCase() || element.adv_pay_id.toLowerCase() == widget.documentType.toLowerCase();
  }

  _filterByID(String query, Payment element) {
    return element.adv_pay_id.toLowerCase().contains(query.toLowerCase());
  }

  List<String> sortingHeaders = ["ID", "Employee Name","Amount"];
  List<bool> sortArray = [false, false, false, false, false, false];

  List<FilterModel> filters = [
    FilterModel(caption: "ID", fieldName: "AdvancedSalaryID", checked: false, selectedCompareOption: "", isNumber: false, isDate: false),
    FilterModel(caption: "Employee Name", fieldName: "EmployeeName", checked: false, selectedCompareOption: "", isNumber: false, isDate: false),
    FilterModel(caption: "Amount", fieldName: "RequestedAmount", checked: false, selectedCompareOption: "", isNumber: true, isDate: false),
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
  _showSortManagerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SortingDialogWidget(_sortDataManager, sortArray, sortingHeaders);
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
  _showFilterManagerDialog() {
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
              return FilterDialogWidget(filters, _filterDataManager);
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
        _getDataToShow().sort((a, b) => a.adv_pay_id.compareTo(b.adv_pay_id));
      } else {
        _getDataToShow().sort((a, b) => _sortBy(a, b, sortingIndex));
      }
    });
  }
  _sortDataManager(int sortingIndex) {
    sortArray.asMap().forEach((key, value) {
      sortArray[key] = false;
    });

    if (sortingIndex >= 0) sortArray[sortingIndex] = true;

    setState(() {
      // Navigator.pop(context);
      if (sortingIndex == -1) {
        _getDataManagerToShow().sort((a, b) => a.adv_pay_id.compareTo(b.adv_pay_id));
      } else {
        _getDataManagerToShow().sort((a, b) => _sortBy(a, b, sortingIndex));
      }
    });
  }

  final dateF.DateFormat dateFormat = dateF.DateFormat("dd-MM-y HH:mm");
  _sortBy(Payment a, Payment b, int sortingIndex) {
    switch (sortingIndex) {
      case 0:
        return a.adv_pay_id.trim().compareTo(b.adv_pay_id.trim());
      case 1:
        return b.adv_pay_id.trim().compareTo(a.adv_pay_id.trim());

      case 2:
        return a.employee_name.trim().compareTo(b.employee_name.trim());
      case 3:
        return b.employee_name.trim().compareTo(a.employee_name.trim());

      case 4:
        return a.req_mount.trim().compareTo(b.req_mount.trim());
      case 5:
        return b.req_mount.trim().compareTo(a.req_mount.trim());



    }
  }

  _filterData() {
    if (filteredList != null) filteredList.clear();
    List<FilterModel> enabledFilters = filters.where((e) => e.checked).toList();
    if (enabledFilters.isNotEmpty) {
      enabledFilters.forEach((filterModel) {
        filteredList = (filteredList.isNotEmpty ? filteredList : payments).where((suggestion) {
          return filterModel.isDocumentTypeFilter
              ? FilterUtilities.filterByDocumentType(suggestion, filterModel.fieldName, filterModel.selectedCompareOption)
              : (_filterByName(suggestion) && filterModel.isDate
              ? FilterUtilities.filterByDate(suggestion, filterModel.fieldName, filterModel.selectedCompareOption, filterModel.fromDate, false, searchDate2: filterModel.toDate)
              : FilterUtilities.filterByDynamicString(filterModel.value1, filterModel.value2, suggestion, filterModel.fieldName, filterModel.selectedCompareOption));
        }).toList();
      });
    }
    setState(() {
      filterEnabled = enabledFilters.isNotEmpty;
    });
  }
  _filterDataManager() {
    if (filteredListManager != null) filteredListManager.clear();
    List<FilterModel> enabledFilters = filters.where((e) => e.checked).toList();
    if (enabledFilters.isNotEmpty) {
      enabledFilters.forEach((filterModel) {
        filteredListManager = ((filteredListManager!=null &&filteredListManager.isNotEmpty) ? filteredListManager : paymentsManager).where((suggestion) {
          return filterModel.isDocumentTypeFilter
              ? FilterUtilities.filterByDocumentType(suggestion, filterModel.fieldName, filterModel.selectedCompareOption)
              : (_filterByName(suggestion) && filterModel.isDate
              ? FilterUtilities.filterByDate(suggestion, filterModel.fieldName, filterModel.selectedCompareOption, filterModel.fromDate, false, searchDate2: filterModel.toDate)
              : FilterUtilities.filterByDynamicString(filterModel.value1, filterModel.value2, suggestion, filterModel.fieldName, filterModel.selectedCompareOption));
        }).toList();
      });
    }
    setState(() {
      filterEnabledManager = enabledFilters.isNotEmpty;
    });
  }
}

