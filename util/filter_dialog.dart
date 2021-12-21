import 'package:amana_foods_hr/util/filter_model.dart';
import 'package:amana_foods_hr/util/app_constants.dart';
import 'package:amana_foods_hr/util/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterDialogWidget extends StatefulWidget {
  @override
  _FilterDialogWidgetState createState() => _FilterDialogWidgetState();

  final List<FilterModel> filters;
  final Function() filterFunction;
  FilterDialogWidget(this.filters, this.filterFunction);
}

class _FilterDialogWidgetState extends State<FilterDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(left: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Utilities.buildExpandedText("select_filter".tr, textColor: Colors.white, bold: true),
//                FlatButton(),
                FlatButton(
                  child: Text(
                    "filter_data".tr,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => _triggerFilterCallBack(),
                ),
              ],
            ),
            color: Theme.of(context).primaryColor,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 1.4, minHeight: 75),
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return new GestureDetector(
                  child: _buildFilterRow(widget.filters[index]),
                );
              },
              itemCount: widget.filters.length,
            ),
          ),
        ],
      )),
    );
  }

  ExpansionTile _buildFilterRow(FilterModel model) {
    return ExpansionTile(
      childrenPadding: EdgeInsets.only(left: 30, right: 30, bottom: 8),
      key: GlobalKey(),
      onExpansionChanged: (expanded) {
        setState(() {
          model.checked = expanded;
        });
      },
      initiallyExpanded: model.checked,
      leading: Checkbox(
        value: model.checked,
        onChanged: (newValue) {
          setState(() {
            model.checked = newValue;
          });
        },
      ),
      title: Text(model.caption),
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _getExpandedViewWidgets(model),
        ),
      ],
      trailing: Text(""),
    );
  }

  _getStringsComparatorItems() {
    return AppConstants.COMPARATORS.map<DropdownMenuItem<String>>((String comparator) {
      return DropdownMenuItem<String>(
        value: comparator,
        child: Text(comparator),
      );
    }).toList();
  }

  _getNumbersComparatorItems() {
    return AppConstants.NUMBER_COMPARATORS.map<DropdownMenuItem<String>>((String comparator) {
      return DropdownMenuItem<String>(
        value: comparator,
        child: Text(comparator),
      );
    }).toList();
  }

  _getDocumentTypeFilter() {
    List<DropdownMenuItem<String>> menuItems = new List<DropdownMenuItem<String>>();
    AppConstants.APPROVAL_TYPES.map((key, value) {
      return MapEntry(key, value);
    }).forEach((key, value) {
      menuItems.add(DropdownMenuItem<String>(
        value: key.toLowerCase(),
        child: Text(value == "Pending Approvals" ? "All $value" : value),
      ));
    });
    return menuItems;
  }

  _getDateComparatorItems() {
    return AppConstants.DATE_COMPARATORS.map<DropdownMenuItem<String>>((String comparator) {
      return DropdownMenuItem<String>(
        value: comparator,
        child: Text(comparator),
      );
    }).toList();
  }

  _getComparatorItems(FilterModel model) {
    if (model.isNumber) return _getNumbersComparatorItems();
    if (model.isDate) return _getDateComparatorItems();
    return _getStringsComparatorItems();
  }

  _triggerFilterCallBack() {
    Navigator.of(context).pop();
    widget.filterFunction();
  }

  _getExpandedViewWidgets(FilterModel model) {
    TextEditingController _value1Controller = TextEditingController();
    _value1Controller.text = model.value1;
    TextEditingController _value2Controller = TextEditingController();
    _value2Controller.text = model.value2;
    model.selectedCompareOption = model.selectedCompareOption.isNotEmpty
        ? model.selectedCompareOption
        : model.isDate
            ? AppConstants.DATE_COMPARATORS[0]
            : model.isNumber
                ? AppConstants.NUMBER_COMPARATORS[0]
                : model.isDocumentTypeFilter
                    ? AppConstants.TYPE_ALL.toLowerCase()
                    : AppConstants.COMPARATORS[0];
    List<Widget> expandedWidgets = [];
    if (!model.isDocumentTypeFilter) {
      expandedWidgets.add(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),

          // dropdown below..
          child: DropdownButtonFormField<String>(
            isDense: true,
            hint: Text(
              "select_value".tr,
              style: TextStyle(color: Colors.black),
            ),
            disabledHint: Text("select_value".tr),
            value: model.selectedCompareOption,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            onChanged: (String newValue) {
              setState(() {
                model.selectedCompareOption = newValue;
              });
            },
            items: _getComparatorItems(model),
          ),
        ),
      );
    }
    if (model.isDate) {
      _value1Controller.text = DateFormat("dd-MM-yyyy").format(model.fromDate);
      _value2Controller.text = DateFormat("dd-MM-yyyy").format(model.toDate);
      expandedWidgets.add(TextField(
        readOnly: true,
        onTap: () {
          print("date field tapped");
          _showDatePicker(model, context, false);
        },
        controller: _value1Controller,
        decoration: InputDecoration(
          filled: true,
          hintText: "select_date".tr,
          isDense: true,
          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          fillColor: Colors.white,
        ),
        onChanged: (newText) => model.value1 = newText,
      ));

      expandedWidgets.add(TextField(
        readOnly: true,
        enabled: model.selectedCompareOption == AppConstants.DATE_COMPARATORS[1],
        onTap: () {
          print("date field tapped");
          _showDatePicker(model, context, true);
        },
        controller: _value2Controller,
        decoration: InputDecoration(
          filled: true,
          hintText: "select_date".tr,
          isDense: true,
          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          fillColor: Colors.white,
        ),
        onChanged: (newText) => model.value2 = newText,
      ));
    }
    if (model.isDocumentTypeFilter) {
      expandedWidgets.add(DropdownButtonFormField<String>(
        isDense: true,
        hint: Text(
          "select_value".tr,
          style: TextStyle(color: Colors.black),
        ),
        disabledHint: Text("select_value".tr),
        value: model.selectedCompareOption != null ? model.selectedCompareOption : AppConstants.TYPE_ALL.toLowerCase(),
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        onChanged: (String newValue) {
          setState(() {
            model.selectedCompareOption = newValue;
          });
        },
        items: _getDocumentTypeFilter(),
      ));
    } else if (!model.isDate) {
      expandedWidgets.add(TextField(
        controller: _value1Controller,
        decoration: InputDecoration(
          filled: true,
          hintText: "enter_value".tr,
          isDense: true,
          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          fillColor: Colors.white,
        ),
        onChanged: (newText) => model.value1 = newText,
      ));
    }

    if (_showSecondValueField(model)) {
      TextEditingController _value2Controller = TextEditingController();
      _value2Controller.text = model.value2;
      expandedWidgets.add(TextField(
        controller: _value2Controller,
        decoration: InputDecoration(
          filled: true,
          hintText: "enter_value".tr,
          isDense: true,
          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          fillColor: Colors.white,
        ),
        onChanged: (newText) => model.value2 = newText,
      ));
    }
    return expandedWidgets;
  }

  Future<void> _showDatePicker(FilterModel model, BuildContext context, bool isTo) async {
    final ThemeData theme = Theme.of(context);
    assert(theme.platform != null);
    switch (theme.platform) {
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
      case TargetPlatform.windows:
      case TargetPlatform.android:
        return buildMaterialDatePicker(context, model, isTo);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return buildCupertinoDatePicker(context, model, isTo);
    }
  }

  _showSecondValueField(FilterModel filterModel) {
    return filterModel.isNumber &&
        (filterModel.selectedCompareOption == AppConstants.NUMBER_COMPARATORS[2] || filterModel.selectedCompareOption == AppConstants.NUMBER_COMPARATORS[3]);
  }

  buildMaterialDatePicker(BuildContext context, FilterModel model, bool isTo) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isTo ? model.toDate:model.fromDate,
      firstDate: DateTime(2015, 1),
      lastDate: DateTime(2100),
      initialEntryMode: DatePickerEntryMode.input,
    );
    if (picked != null && picked != (isTo ? model.toDate : model.fromDate))
      setState(() {
        isTo ? model.toDate = picked : model.fromDate = picked;
      });
  }

  buildCupertinoDatePicker(BuildContext context, FilterModel model, bool isTo) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (picked) {
                if (picked != null && picked != (isTo ? model.toDate : model.fromDate))
                  setState(() {
                    isTo ? model.toDate = picked : model.fromDate = picked;
                  });
              },
              initialDateTime: isTo ? model.toDate : model.fromDate,
              minimumYear: 2000,
              maximumYear: 2025,
            ),
          );
        });
  }
}
