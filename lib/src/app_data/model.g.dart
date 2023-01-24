// GENERATED CODE - DO NOT MODIFY BY HAND

part of craft_dynamic;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StandingOrder _$StandingOrderFromJson(Map<String, dynamic> json) =>
    StandingOrder(
      amount: (json['Amount'] as num?)?.toDouble(),
      standingOrderID: json['SOID'] as String?,
      effectiveDate: json['EffectiveDate'] as String?,
      frequencyID: json['FrequencyID'] as String?,
      lastExecutionDate: json['LastExecutionDate'] as String?,
      createdBy: json['CreatedBy'] as String?,
      requestData: json['RequestData'] as String?,
    );

Map<String, dynamic> _$StandingOrderToJson(StandingOrder instance) =>
    <String, dynamic>{
      'Amount': instance.amount,
      'SOID': instance.standingOrderID,
      'EffectiveDate': instance.effectiveDate,
      'FrequencyID': instance.frequencyID,
      'LastExecutionDate': instance.lastExecutionDate,
      'CreatedBy': instance.createdBy,
      'RequestData': instance.requestData,
    };
