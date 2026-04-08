// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'child_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ChildStatus {
  String get childId => throw _privateConstructorUsedError;
  ChildStatusType get type => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;

  /// Create a copy of ChildStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChildStatusCopyWith<ChildStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChildStatusCopyWith<$Res> {
  factory $ChildStatusCopyWith(
    ChildStatus value,
    $Res Function(ChildStatus) then,
  ) = _$ChildStatusCopyWithImpl<$Res, ChildStatus>;
  @useResult
  $Res call({
    String childId,
    ChildStatusType type,
    DateTime updatedAt,
    String? note,
  });
}

/// @nodoc
class _$ChildStatusCopyWithImpl<$Res, $Val extends ChildStatus>
    implements $ChildStatusCopyWith<$Res> {
  _$ChildStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChildStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? childId = null,
    Object? type = null,
    Object? updatedAt = null,
    Object? note = freezed,
  }) {
    return _then(
      _value.copyWith(
            childId: null == childId
                ? _value.childId
                : childId // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as ChildStatusType,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChildStatusImplCopyWith<$Res>
    implements $ChildStatusCopyWith<$Res> {
  factory _$$ChildStatusImplCopyWith(
    _$ChildStatusImpl value,
    $Res Function(_$ChildStatusImpl) then,
  ) = __$$ChildStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String childId,
    ChildStatusType type,
    DateTime updatedAt,
    String? note,
  });
}

/// @nodoc
class __$$ChildStatusImplCopyWithImpl<$Res>
    extends _$ChildStatusCopyWithImpl<$Res, _$ChildStatusImpl>
    implements _$$ChildStatusImplCopyWith<$Res> {
  __$$ChildStatusImplCopyWithImpl(
    _$ChildStatusImpl _value,
    $Res Function(_$ChildStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChildStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? childId = null,
    Object? type = null,
    Object? updatedAt = null,
    Object? note = freezed,
  }) {
    return _then(
      _$ChildStatusImpl(
        childId: null == childId
            ? _value.childId
            : childId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as ChildStatusType,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$ChildStatusImpl implements _ChildStatus {
  const _$ChildStatusImpl({
    required this.childId,
    required this.type,
    required this.updatedAt,
    this.note,
  });

  @override
  final String childId;
  @override
  final ChildStatusType type;
  @override
  final DateTime updatedAt;
  @override
  final String? note;

  @override
  String toString() {
    return 'ChildStatus(childId: $childId, type: $type, updatedAt: $updatedAt, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChildStatusImpl &&
            (identical(other.childId, childId) || other.childId == childId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.note, note) || other.note == note));
  }

  @override
  int get hashCode => Object.hash(runtimeType, childId, type, updatedAt, note);

  /// Create a copy of ChildStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChildStatusImplCopyWith<_$ChildStatusImpl> get copyWith =>
      __$$ChildStatusImplCopyWithImpl<_$ChildStatusImpl>(this, _$identity);
}

abstract class _ChildStatus implements ChildStatus {
  const factory _ChildStatus({
    required final String childId,
    required final ChildStatusType type,
    required final DateTime updatedAt,
    final String? note,
  }) = _$ChildStatusImpl;

  @override
  String get childId;
  @override
  ChildStatusType get type;
  @override
  DateTime get updatedAt;
  @override
  String? get note;

  /// Create a copy of ChildStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChildStatusImplCopyWith<_$ChildStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
