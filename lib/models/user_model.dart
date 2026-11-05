import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    required String name,

    /// false = tên mặc định ('Bố/Mẹ'/'Con'), sẽ hỏi đặt tên ở màn home.
    @Default(false) bool nameSet,
    String? email,
    String? photoUrl,
    String? fcmToken,
    @Default('child') String role,
    @Default(false) bool isGuest,
    String? linkCode,
    @Default([]) List<String> linkedParentIds,
    @Default([]) List<String> linkedChildIds,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
