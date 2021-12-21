class FilterModel {

  String caption = "";
  bool checked = false;
  bool isNumber = false ;
  bool isDate = false;
  bool isDocumentTypeFilter = false;
  String selectedCompareOption = "";
  String value1 = "";
  String value2 = "";
  String fieldName = "";
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  FilterModel(
      {this.caption,this.checked:false,this.isNumber:false,this.selectedCompareOption,this.value1,this.value2,this.fieldName,this.isDate:false,this.fromDate,this.toDate,this.isDocumentTypeFilter:false}
      );

}