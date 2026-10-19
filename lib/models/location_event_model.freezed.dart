// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LocationEventModel {

 String get id; String get childId; String get childName; LocationEventType get eventType; String get zoneName; DateTime get timestamp; double? get lat; double? get lng; String? get statusLabel;
/// Create a copy of LocationEventModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationEventModelCopyWith<LocationEventModel> get copyWith => _$LocationEventModelCopyWithImpl<LocationEventModel>(this as LocationEventModel, _$identity);

  /// Serializes this LocationEventModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocationEventModel&&(identical(other.id, id) || other.id == id)&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.childName, childName) || other.childName == childName)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.zoneName, zoneName) || other.zoneName == zoneName)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.statusLabel, statusLabel) || other.statusLabel == statusLabel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,childId,childName,eventType,zoneName,timestamp,lat,lng,statusLabel);

@override
String toString() {
  return 'LocationEventModel(id: $id, childId: $childId, childName: $childName, eventType: $eventType, zoneName: $zoneName, timestamp: $timestamp, lat: $lat, lng: $lng, statusLabel: $statusLabel)';
}


}

/// @nodoc
abstract mixin class $LocationEventModelCopyWith<$Res>  {
  factory $LocationEventModelCopyWith(LocationEventModel value, $Res Function(LocationEventModel) _then) = _$LocationEventModelCopyWithImpl;
@useResult
$Res call({
 String id, String childId, String childName, LocationEventType eventType, String zoneName, DateTime timestamp, double? lat, double? lng, String? statusLabel
});




}
/// @nodoc
class _$LocationEventModelCopyWithImpl<$Res>
    implements $LocationEventModelCopyWith<$Res> {
  _$LocationEventModelCopyWithImpl(this._self, this._then);

  final LocationEventModel _self;
  final $Res Function(LocationEventModel) _then;

/// Create a copy of LocationEventModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? childId = null,Object? childName = null,Object? eventType = null,Object? zoneName = null,Object? timestamp = null,Object? lat = freezed,Object? lng = freezed,Object? statusLabel = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,childId: null == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as LocationEventType,zoneName: null == zoneName ? _self.zoneName : zoneName // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,statusLabel: freezed == statusLabel ? _self.statusLabel : statusLabel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LocationEventModel].
extension LocationEventModelPatterns on LocationEventModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocationEventModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocationEventModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocationEventModel value)  $default,){
final _that = this;
switch (_that) {
case _LocationEventModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocationEventModel value)?  $default,){
final _that = this;
switch (_that) {
case _LocationEventModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String childId,  String childName,  LocationEventType eventType,  String zoneName,  DateTime timestamp,  double? lat,  double? lng,  String? statusLabel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocationEventModel() when $default != null:
return $default(_that.id,_that.childId,_that.childName,_that.eventType,_that.zoneName,_that.timestamp,_that.lat,_that.lng,_that.statusLabel);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String childId,  String childName,  LocationEventType eventType,  String zoneName,  DateTime timestamp,  double? lat,  double? lng,  String? statusLabel)  $default,) {final _that = this;
switch (_that) {
case _LocationEventModel():
return $default(_that.id,_that.childId,_that.childName,_that.eventType,_that.zoneName,_that.timestamp,_that.lat,_that.lng,_that.statusLabel);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String childId,  String childName,  LocationEventType eventType,  String zoneName,  DateTime timestamp,  double? lat,  double? lng,  String? statusLabel)?  $default,) {final _that = this;
switch (_that) {
case _LocationEventModel() when $default != null:
return $default(_that.id,_that.childId,_that.childName,_that.eventType,_that.zoneName,_that.timestamp,_that.lat,_that.lng,_that.statusLabel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LocationEventModel implements LocationEventModel {
  const _LocationEventModel({required this.id, required this.childId, required this.childName, required this.eventType, required this.zoneName, required this.timestamp, this.lat, this.lng, this.statusLabel});
  factory _LocationEventModel.fromJson(Map<String, dynamic> json) => _$LocationEventModelFromJson(json);

@override final  String id;
@override final  String childId;
@override final  String childName;
@override final  LocationEventType eventType;
@override final  String zoneName;
@override final  DateTime timestamp;
@override final  double? lat;
@override final  double? lng;
@override final  String? statusLabel;

/// Create a copy of LocationEventModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationEventModelCopyWith<_LocationEventModel> get copyWith => __$LocationEventModelCopyWithImpl<_LocationEventModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LocationEventModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocationEventModel&&(identical(other.id, id) || other.id == id)&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.childName, childName) || other.childName == childName)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.zoneName, zoneName) || other.zoneName == zoneName)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.statusLabel, statusLabel) || other.statusLabel == statusLabel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,childId,childName,eventType,zoneName,timestamp,lat,lng,statusLabel);

@override
String toString() {
  return 'LocationEventModel(id: $id, childId: $childId, childName: $childName, eventType: $eventType, zoneName: $zoneName, timestamp: $timestamp, lat: $lat, lng: $lng, statusLabel: $statusLabel)';
}


}

/// @nodoc
abstract mixin class _$LocationEventModelCopyWith<$Res> implements $LocationEventModelCopyWith<$Res> {
  factory _$LocationEventModelCopyWith(_LocationEventModel value, $Res Function(_LocationEventModel) _then) = __$LocationEventModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String childId, String childName, LocationEventType eventType, String zoneName, DateTime timestamp, double? lat, double? lng, String? statusLabel
});




}
/// @nodoc
class __$LocationEventModelCopyWithImpl<$Res>
    implements _$LocationEventModelCopyWith<$Res> {
  __$LocationEventModelCopyWithImpl(this._self, this._then);

  final _LocationEventModel _self;
  final $Res Function(_LocationEventModel) _then;

/// Create a copy of LocationEventModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? childId = null,Object? childName = null,Object? eventType = null,Object? zoneName = null,Object? timestamp = null,Object? lat = freezed,Object? lng = freezed,Object? statusLabel = freezed,}) {
  return _then(_LocationEventModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,childId: null == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as LocationEventType,zoneName: null == zoneName ? _self.zoneName : zoneName // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,statusLabel: freezed == statusLabel ? _self.statusLabel : statusLabel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
