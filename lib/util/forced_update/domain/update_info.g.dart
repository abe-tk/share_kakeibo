// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UpdateInfo _$$_UpdateInfoFromJson(Map<String, dynamic> json) =>
    _$_UpdateInfo(
      latestVersion: json['latestVersion'] as String,
      requiredVersion: json['requiredVersion'] as String,
      enabledAt: DateTime.parse(json['enabledAt'] as String),
    );

Map<String, dynamic> _$$_UpdateInfoToJson(_$_UpdateInfo instance) =>
    <String, dynamic>{
      'latestVersion': instance.latestVersion,
      'requiredVersion': instance.requiredVersion,
      'enabledAt': instance.enabledAt.toIso8601String(),
    };
