// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'geofence_zone_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GeofenceZoneModel _$GeofenceZoneModelFromJson(Map<String, dynamic> json) {
  return _GeofenceZoneModel.fromJson(json);
}

/// @nodoc
mixin _$GeofenceZoneModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get lat => throw _privateConstructorUsedError;
  double get lng => throw _privateConstructorUsedError;
  double get radiusMeters => throw _privateConstructorUsedError;
  String get emoji => throw _privateConstructorUsedError;

  /// Serializes this GeofenceZoneModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GeofenceZoneModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GeofenceZoneModelCopyWith<GeofenceZoneModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeofenceZoneModelCopyWith<$Res> {
  factory $GeofenceZoneModelCopyWith(
    GeofenceZoneModel value,
    $Res Function(GeofenceZoneModel) then,
  ) = _$GeofenceZoneModelCopyWithImpl<$Res, GeofenceZoneModel>;
  @useResult
  $Res call({
    String id,
    String name,
    double lat,
    double lng,
    double radiusMeters,
    String emoji,
  });
}

/// @nodoc
class _$GeofenceZoneModelCopyWithImpl<$Res, $Val extends GeofenceZoneModel>
    implements $GeofenceZoneModelCopyWith<$Res> {
  _$GeofenceZoneModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GeofenceZoneModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? lat = null,
    Object? lng = null,
    Object? radiusMeters = null,
    Object? emoji = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            lat: null == lat
                ? _value.lat
                : lat // ignore: cast_nullable_to_non_nullable
                      as double,
            lng: null == lng
                ? _value.lng
                : lng // ignore: cast_nullable_to_non_nullable
                      as double,
            radiusMeters: null == radiusMeters
                ? _value.radiusMeters
                : radiusMeters // ignore: cast_nullable_to_non_nullable
                      as double,
            emoji: null == emoji
                ? _value.emoji
                : emoji // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GeofenceZoneModelImplCopyWith<$Res>
    implements $GeofenceZoneModelCopyWith<$Res> {
  factory _$$GeofenceZoneModelImplCopyWith(
    _$GeofenceZoneModelImpl value,
    $Res Function(_$GeofenceZoneModelImpl) then,
  ) = __$$GeofenceZoneModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    double lat,
    double lng,
    double radiusMeters,
    String emoji,
  });
}

/// @nodoc
class __$$GeofenceZoneModelImplCopyWithImpl<$Res>
    extends _$GeofenceZoneModelCopyWithImpl<$Res, _$GeofenceZoneModelImpl>
    implements _$$GeofenceZoneModelImplCopyWith<$Res> {
  __$$GeofenceZoneModelImplCopyWithImpl(
    _$GeofenceZoneModelImpl _value,
    $Res Function(_$GeofenceZoneModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GeofenceZoneModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? lat = null,
    Object? lng = null,
    Object? radiusMeters = null,
    Object? emoji = null,
  }) {
    return _then(
      _$GeofenceZoneModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        lat: null == lat
            ? _value.lat
            : lat // ignore: cast_nullable_to_non_nullable
                  as double,
        lng: null == lng
            ? _value.lng
            : lng // ignore: cast_nullable_to_non_nullable
                  as double,
        radiusMeters: null == radiusMeters
            ? _value.radiusMeters
            : radiusMeters // ignore: cast_nullable_to_non_nullable
                  as double,
        emoji: null == emoji
            ? _value.emoji
            : emoji // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GeofenceZoneModelImpl implements _GeofenceZoneModel {
  const _$GeofenceZoneModelImpl({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    this.radiusMeters = 1000.0,
    this.emoji = '🏠',
  });

  factory _$GeofenceZoneModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GeofenceZoneModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double lat;
  @override
  final double lng;
  @override
  @JsonKey()
  final double radiusMeters;
  @override
  @JsonKey()
  final String emoji;

  @override
  String toString() {
    return 'GeofenceZoneModel(id: $id, name: $name, lat: $lat, lng: $lng, radiusMeters: $radiusMeters, emoji: $emoji)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeofenceZoneModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.radiusMeters, radiusMeters) ||
                other.radiusMeters == radiusMeters) &&
            (identical(other.emoji, emoji) || other.emoji == emoji));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, lat, lng, radiusMeters, emoji);

  /// Create a copy of GeofenceZoneModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GeofenceZoneModelImplCopyWith<_$GeofenceZoneModelImpl> get copyWith =>
      __$$GeofenceZoneModelImplCopyWithImpl<_$GeofenceZoneModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GeofenceZoneModelImplToJson(this);
  }
}

abstract class _GeofenceZoneModel implements GeofenceZoneModel {
  const factory _GeofenceZoneModel({
    required final String id,
    required final String name,
    required final double lat,
    required final double lng,
    final double radiusMeters,
    final String emoji,
  }) = _$GeofenceZoneModelImpl;

  factory _GeofenceZoneModel.fromJson(Map<String, dynamic> json) =
      _$GeofenceZoneModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get lat;
  @override
  double get lng;
  @override
  double get radiusMeters;
  @override
  String get emoji;

  /// Create a copy of GeofenceZoneModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GeofenceZoneModelImplCopyWith<_$GeofenceZoneModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
