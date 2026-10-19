// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  uid: json['uid'] as String,
  name: json['name'] as String,
  photoUrl: json['photoUrl'] as String?,
  fcmToken: json['fcmToken'] as String?,
  role: json['role'] as String? ?? 'child',
  isGuest: json['isGuest'] as bool? ?? false,
  linkCode: json['linkCode'] as String?,
  linkedParentId: json['linkedParentId'] as String?,
  linkedChildIds:
      (json['linkedChildIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'photoUrl': instance.photoUrl,
      'fcmToken': instance.fcmToken,
      'role': instance.role,
      'isGuest': instance.isGuest,
      'linkCode': instance.linkCode,
      'linkedParentId': instance.linkedParentId,
      'linkedChildIds': instance.linkedChildIds,
    };
