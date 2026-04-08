import 'package:freezed_annotation/freezed_annotation.dart';

part 'child_status.freezed.dart';

enum ChildStatusType {
  school,
  playing,
  home,
  arrived,
  unknown,
}

extension ChildStatusTypeExt on ChildStatusType {
  String get label {
    switch (this) {
      case ChildStatusType.school:
        return 'Đi học';
      case ChildStatusType.playing:
        return 'Đang chơi';
      case ChildStatusType.home:
        return 'Về nhà';
      case ChildStatusType.arrived:
        return 'Đã đến';
      case ChildStatusType.unknown:
        return 'Không rõ';
    }
  }

  String get emoji {
    switch (this) {
      case ChildStatusType.school:
        return '🏫';
      case ChildStatusType.playing:
        return '⚽';
      case ChildStatusType.home:
        return '🏠';
      case ChildStatusType.arrived:
        return '✅';
      case ChildStatusType.unknown:
        return '❓';
    }
  }
}

@freezed
class ChildStatus with _$ChildStatus {
  const factory ChildStatus({
    required String childId,
    required ChildStatusType type,
    required DateTime updatedAt,
    String? note,
  }) = _ChildStatus;
}
