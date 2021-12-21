import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'approval_request.g.dart';

@JsonSerializable(nullable: false)
class ApprovalRequest{

  @JsonKey(name: "Id")
  final String id ;
  @JsonKey(name: "TransType ")
  final String transType;
  /*@JsonKey(name: "Company_Label")
  final String companyLabel ;
  @JsonKey(name: "Company")
  final String company;
  @JsonKey(name: "ReferenceTableId_Label")
  final String referenceTableIdLabel;
  @JsonKey(name: "ReferenceTableId")
  final int referenceTableId;
  @JsonKey(name: "ReferenceRecordId_Label")
  final String referenceRecordIdLabel ;
  @JsonKey(name: "ReferenceRecordId")
  final int referenceRecordId;
  @JsonKey(name: "WorkItem_Label")
  final String workItemLabel;
  @JsonKey(name: "WorkItem")
  final String workItem;
  @JsonKey(name: "ID_Label")
  final String idLabel;
  @JsonKey(name: "ID")
  final String id;
  @JsonKey(name: "DocumentType_Label")
  final String documentTypeLabel;
  @JsonKey(name: "DocumentType")
  final String documentType;
  @JsonKey(name: "Subject_Label")
  final String subjectLabel;
  @JsonKey(name: "Subject")
  final String subject;
  @JsonKey(name: "DueDateTime_Label")
  final String dueDateTimeLabel;
  @JsonKey(name:"DueDateTime")
  final String dueDateTime;
  @JsonKey(name: "CreatedDateTime_Label")
  final String createdDateTimeLabel;
  @JsonKey(name: "CreatedDateTime")
  final String createdDateTime;*/

  ApprovalRequest({
    @required this.id ,
    @required this.transType,
   /* @required this.companyLabel ,
    @required this.company,
    @required this.referenceTableIdLabel,
    @required this.referenceTableId,
    @required this.referenceRecordIdLabel ,
    @required this.referenceRecordId,
    @required this.workItemLabel,
    @required this.workItem,
    @required this.idLabel,
    @required this.id,
    @required this.documentTypeLabel,
    @required this.documentType,
    @required this.subjectLabel,
    @required this.subject,
    @required this.dueDateTimeLabel,
    @required this.dueDateTime,
    @required this.createdDateTimeLabel,
    @required this.createdDateTime,*/
  });

  factory ApprovalRequest.fromJson(Map<String, dynamic> json) => _$ApprovalRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ApprovalRequestToJson(this);
}
