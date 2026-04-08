// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LocationEventModel _$LocationEventModelFromJson(Map<String, dynamic> json) {
  return _LocationEventModel.fromJson(json);
}

/// @nodoc
mixin _$LocationEventModel {
  String get id => throw _privateConstructorUsedError;
  String get childId => throw _privateConstructorUsedError;
  String get childName => throw _privateConstructorUsedError;
  LocationEventType get eventType => throw _privateConstructorUsedError;
  String get zoneName => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  double? get lat => throw _privateConstructorUsedError;
  double? get lng => throw _privateConstructorUsedError;
  String? get statusLabel => throw _privateConstructorUsedError;

  /// Serializes this LocationEventModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LocationEventModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationEventModelCopyWith<LocationEventModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationEventModelCopyWith<$Res> {
  factory $LocationEventModelCopyWith(
    LocationEventModel value,
    $Res Function(LocationEventModel) then,
  ) = _$LocationEventModelCopyWithImpl<$Res, LocationEventModel>;
  @useResult
  $Res call({
    String id,
    String childId,
    String childName,
    LocationEventType eventType,
    String zoneName,
    DateTime timestamp,
    double? lat,
    double? lng,
    String? statusLabel,
  });
}

/// @nodoc
class _$LocationEventModelCopyWithImpl<$Res, $Val extends LocationEventModel>
    implements $LocationEventModelCopyWith<$Res> {
  _$LocationEventModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocationEventModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? childId = null,
    Object? childName = null,
    Object? eventType = null,
    Object? zoneName = null,
    Object? timestamp = null,
    Object? lat = freezed,
    Object? lng = freezed,
    Object? statusLabel = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            childId: null == childId
                ? _value.childId
                : childId // ignore: cast_nullable_to_non_nullable
                      as String,
            childName: null == childName
                ? _value.childName
                : childName // ignore: cast_nullable_to_non_nullable
                      as String,
            eventType: null == eventType
                ? _value.eventType
                : eventType // ignore: cast_nullable_to_non_nullable
                      as LocationEventType,
            zoneName: null == zoneName
                ? _value.zoneName
                : zoneName // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            lat: freezed == lat
                ? _value.lat
                : lat // ignore: cast_nullable_to_non_nullable
                      as double?,
            lng: freezed == lng
                ? _value.lng
                : lng // ignore: cast_nullable_to_non_nullable
                      as double?,
            statusLabel: freezed == statusLabel
                ? _value.statusLabel
                : statusLabel // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LocationEventModelImplCopyWith<$Res>
    implements $LocationEventModelCopyWith<$Res> {
  factory _$$LocationEventModelImplCopyWith(
    _$LocationEventModelImpl value,
    $Res Function(_$LocationEventModelImpl) then,
  ) = __$$LocationEventModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String childId,
    String childName,
    LocationEventType eventType,
    String zoneName,
    DateTime timestamp,
    double? lat,
    double? lng,
    String? statusLabel,
  });
}

/// @nodoc
class __$$LocationEventModelImplCopyWithImpl<$Res>
    extends _$LocationEventModelCopyWithImpl<$Res, _$LocationEventModelImpl>
    implements _$$LocationEventModelImplCopyWith<$Res> {
  __$$LocationEventModelImplCopyWithImpl(
    _$LocationEventModelImpl _value,
    $Res Function(_$LocationEventModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LocationEventModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? childId = null,
    Object? childName = null,
    Object? eventType = null,
    Object? zoneName = null,
    Object? timestamp = null,
    Object? lat = freezed,
    Object? lng = freezed,
    Object? statusLabel = freezed,
  }) {
    return _then(
      _$LocationEventModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        childId: null == childId
            ? _value.childId
            : childId // ignore: cast_nullable_to_non_nullable
                  as String,
        childName: null == childName
            ? _value.childName
            : childName // ignore: cast_nullable_to_non_nullable
                  as String,
        eventType: null == eventType
            ? _value.eventType
            : eventType // ignore: cast_nullable_to_non_nullable
                  as LocationEventType,
        zoneName: null == zoneName
            ? _value.zoneName
            : zoneName // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        lat: freezed == lat
            ? _value.lat
            : lat // ignore: cast_nullable_to_non_nullable
                  as double?,
        lng: freezed == lng
            ? _value.lng
            : lng // ignore: cast_nullable_to_non_nullable
                  as double?,
        statusLabel: freezed == statusLabel
            ? _value.statusLabel
            : statusLabel // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LocationEventModelImpl implements _LocationEventModel {
  const _$LocationEventModelImpl({
    required this.id,
    required this.childId,
    required this.childName,
    required this.eventType,
    required this.zoneName,
    required this.timestamp,
    this.lat,
    this.lng,
    this.statusLabel,
  });

  factory _$LocationEventModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocationEventModelImplFromJson(json);

  @override
  final String id;
  @override
  final String childId;
  @override
  final String childName;
  @override
  final LocationEventType eventType;
  @override
  final String zoneName;
  @override
  final DateTime timestamp;
  @override
  final double? lat;
  @override
  final double? lng;
  @override
  final String? statusLabel;

  @override
  String toString() {
    return 'LocationEventModel(id: $id, childId: $childId, childName: $childName, eventType: $eventType, zoneName: $zoneName, timestamp: $timestamp, lat: $lat, lng: $lng, statusLabel: $statusLabel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationEventModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.childId, childId) || other.childId == childId) &&
            (identical(other.childName, childName) ||
                other.childName == childName) &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType) &&
            (identical(other.zoneName, zoneName) ||
                other.zoneName == zoneName) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.statusLabel, statusLabel) ||
                other.statusLabel == statusLabel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    childId,
    childName,
    eventType,
    zoneName,
    timestamp,
    lat,
    lng,
    statusLabel,
  );

  /// Create a copy of LocationEventModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationEventModelImplCopyWith<_$LocationEventModelImpl> get copyWith =>
      __$$LocationEventModelImplCopyWithImpl<_$LocationEventModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LocationEventModelImplToJson(this);
  }
}

abstract class _LocationEventModel implements LocationEventModel {
  const factory _LocationEventModel({
    required final String id,
    required final String childId,
    required final String childName,
    required final LocationEventType eventType,
    required final String zoneName,
    required final DateTime timestamp,
    final double? lat,
    final double? lng,
    final String? statusLabel,
  }) = _$LocationEventModelImpl;

  factory _LocationEventModel.fromJson(Map<String, dynamic> json) =
      _$LocationEventModelImpl.fromJson;

  @override
  String get id;
  @override
  String get childId;
  @override
  String get childName;
  @override
  LocationEventType get eventType;
  @override
  String get zoneName;
  @override
  DateTime get timestamp;
  @override
  double? get lat;
  @override
  double? get lng;
  @override
  String? get statusLabel;

  /// Create a copy of LocationEventModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationEventModelImplCopyWith<_$LocationEventModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
