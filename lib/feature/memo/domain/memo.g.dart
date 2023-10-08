// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Memo _$$_MemoFromJson(Map<String, dynamic> json) => _$_Memo(
      id: json['id'] as String,
      memo: json['memo'] as String,
      registerDate: const TimestampConverter()
          .fromJson(json['registerDate'] as Timestamp),
    );

Map<String, dynamic> _$$_MemoToJson(_$_Memo instance) => <String, dynamic>{
      'id': instance.id,
      'memo': instance.memo,
      'registerDate': const TimestampConverter().toJson(instance.registerDate),
    };
