import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    required String name,
    String? photoUrl,
    String? fcmToken,
    @Default('child') String role,
    @Default(false) bool isGuest,
    String? linkCode,
    String? linkedParentId,
    @Default([]) List<String> linkedChildIds,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
