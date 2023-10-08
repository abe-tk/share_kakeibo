// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Event _$$_EventFromJson(Map<String, dynamic> json) => _$_Event(
      id: json['id'] as String,
      date: const TimestampConverter().fromJson(json['date'] as Timestamp),
      registerDate: const TimestampConverter()
          .fromJson(json['registerDate'] as Timestamp),
      price: json['price'] as String,
      largeCategory: json['largeCategory'] as String,
      smallCategory: json['smallCategory'] as String,
      memo: json['memo'] as String,
      paymentUser: json['paymentUser'] as String,
    );

Map<String, dynamic> _$$_EventToJson(_$_Event instance) => <String, dynamic>{
      'id': instance.id,
      'date': const TimestampConverter().toJson(instance.date),
      'registerDate': const TimestampConverter().toJson(instance.registerDate),
      'price': instance.price,
      'largeCategory': instance.largeCategory,
      'smallCategory': instance.smallCategory,
      'memo': instance.memo,
      'paymentUser': instance.paymentUser,
    };
