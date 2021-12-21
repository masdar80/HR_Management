// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApprovalRequest _$ApprovalRequestFromJson(Map<String, dynamic> json) {
  return ApprovalRequest(
    id: json['Id'] as String,
    transType:  json['TransType '] as String,
   /* companyLabel: json['Company_Label'] as String,
    company: json['Company'] as String,
    referenceTableIdLabel: json['ReferenceTableId_Label'] as String,
    referenceTableId: json['ReferenceTableId'] as int,
    referenceRecordIdLabel: json['ReferenceRecordId_Label'] as String,
    referenceRecordId: json['ReferenceRecordId'] as int,
    workItemLabel: json['WorkItem_Label'] as String,
    workItem: json['WorkItem'] as String,
    idLabel: json['ID_Label'] as String,
    id: json['ID'] as String,
    documentTypeLabel: json['DocumentType_Label'] as String,
    documentType: json['DocumentType'] as String,
    subjectLabel: json['Subject_Label'] as String,
    subject: json['Subject'] as String,
    dueDateTimeLabel: json['DueDateTime_Label'] as String,
    dueDateTime: json['DueDateTime'] as String,
    createdDateTimeLabel: json['CreatedDateTime_Label'] as String,
    createdDateTime: json['CreatedDateTime'] as String,*/
  );
}

Map<String, dynamic> _$ApprovalRequestToJson(ApprovalRequest instance) =>
    <String, dynamic>{

      'Id': instance.id,
      'TransType': instance.transType,
     /* 'Company_Label': instance.companyLabel,
      'Company': instance.company,
      'ReferenceTableId_Label': instance.referenceTableIdLabel,
      'ReferenceTableId': instance.referenceTableId,
      'ReferenceRecordId_Label': instance.referenceRecordIdLabel,
      'ReferenceRecordId': instance.referenceRecordId,
      'WorkItem_Label': instance.workItemLabel,
      'WorkItem': instance.workItem,
      'ID_Label': instance.idLabel,
      'ID': instance.id,
      'DocumentType_Label': instance.documentTypeLabel,
      'DocumentType': instance.documentType,
      'Subject_Label': instance.subjectLabel,
      'Subject': instance.subject,
      'DueDateTime_Label': instance.dueDateTimeLabel,
      'DueDateTime': instance.dueDateTime,
      'CreatedDateTime_Label': instance.createdDateTimeLabel,
      'CreatedDateTime': instance.createdDateTime,*/
    };
