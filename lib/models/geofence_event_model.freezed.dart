// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'geofence_event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GeofenceEventModel {

 String get id; String get zoneId; String get zoneName; String get childUid; String get childName; String get status;// 'enter' | 'exit'
 DateTime get timestamp;
/// Create a copy of GeofenceEventModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeofenceEventModelCopyWith<GeofenceEventModel> get copyWith => _$GeofenceEventModelCopyWithImpl<GeofenceEventModel>(this as GeofenceEventModel, _$identity);

  /// Serializes this GeofenceEventModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeofenceEventModel&&(identical(other.id, id) || other.id == id)&&(identical(other.zoneId, zoneId) || other.zoneId == zoneId)&&(identical(other.zoneName, zoneName) || other.zoneName == zoneName)&&(identical(other.childUid, childUid) || other.childUid == childUid)&&(identical(other.childName, childName) || other.childName == childName)&&(identical(other.status, status) || other.status == status)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,zoneId,zoneName,childUid,childName,status,timestamp);

@override
String toString() {
  return 'GeofenceEventModel(id: $id, zoneId: $zoneId, zoneName: $zoneName, childUid: $childUid, childName: $childName, status: $status, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $GeofenceEventModelCopyWith<$Res>  {
  factory $GeofenceEventModelCopyWith(GeofenceEventModel value, $Res Function(GeofenceEventModel) _then) = _$GeofenceEventModelCopyWithImpl;
@useResult
$Res call({
 String id, String zoneId, String zoneName, String childUid, String childName, String status, DateTime timestamp
});




}
/// @nodoc
class _$GeofenceEventModelCopyWithImpl<$Res>
    implements $GeofenceEventModelCopyWith<$Res> {
  _$GeofenceEventModelCopyWithImpl(this._self, this._then);

  final GeofenceEventModel _self;
  final $Res Function(GeofenceEventModel) _then;

/// Create a copy of GeofenceEventModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? zoneId = null,Object? zoneName = null,Object? childUid = null,Object? childName = null,Object? status = null,Object? timestamp = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,zoneId: null == zoneId ? _self.zoneId : zoneId // ignore: cast_nullable_to_non_nullable
as String,zoneName: null == zoneName ? _self.zoneName : zoneName // ignore: cast_nullable_to_non_nullable
as String,childUid: null == childUid ? _self.childUid : childUid // ignore: cast_nullable_to_non_nullable
as String,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [GeofenceEventModel].
extension GeofenceEventModelPatterns on GeofenceEventModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeofenceEventModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeofenceEventModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeofenceEventModel value)  $default,){
final _that = this;
switch (_that) {
case _GeofenceEventModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeofenceEventModel value)?  $default,){
final _that = this;
switch (_that) {
case _GeofenceEventModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String zoneId,  String zoneName,  String childUid,  String childName,  String status,  DateTime timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeofenceEventModel() when $default != null:
return $default(_that.id,_that.zoneId,_that.zoneName,_that.childUid,_that.childName,_that.status,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String zoneId,  String zoneName,  String childUid,  String childName,  String status,  DateTime timestamp)  $default,) {final _that = this;
switch (_that) {
case _GeofenceEventModel():
return $default(_that.id,_that.zoneId,_that.zoneName,_that.childUid,_that.childName,_that.status,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String zoneId,  String zoneName,  String childUid,  String childName,  String status,  DateTime timestamp)?  $default,) {final _that = this;
switch (_that) {
case _GeofenceEventModel() when $default != null:
return $default(_that.id,_that.zoneId,_that.zoneName,_that.childUid,_that.childName,_that.status,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeofenceEventModel implements GeofenceEventModel {
  const _GeofenceEventModel({required this.id, required this.zoneId, required this.zoneName, required this.childUid, required this.childName, required this.status, required this.timestamp});
  factory _GeofenceEventModel.fromJson(Map<String, dynamic> json) => _$GeofenceEventModelFromJson(json);

@override final  String id;
@override final  String zoneId;
@override final  String zoneName;
@override final  String childUid;
@override final  String childName;
@override final  String status;
// 'enter' | 'exit'
@override final  DateTime timestamp;

/// Create a copy of GeofenceEventModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeofenceEventModelCopyWith<_GeofenceEventModel> get copyWith => __$GeofenceEventModelCopyWithImpl<_GeofenceEventModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeofenceEventModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeofenceEventModel&&(identical(other.id, id) || other.id == id)&&(identical(other.zoneId, zoneId) || other.zoneId == zoneId)&&(identical(other.zoneName, zoneName) || other.zoneName == zoneName)&&(identical(other.childUid, childUid) || other.childUid == childUid)&&(identical(other.childName, childName) || other.childName == childName)&&(identical(other.status, status) || other.status == status)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,zoneId,zoneName,childUid,childName,status,timestamp);

@override
String toString() {
  return 'GeofenceEventModel(id: $id, zoneId: $zoneId, zoneName: $zoneName, childUid: $childUid, childName: $childName, status: $status, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$GeofenceEventModelCopyWith<$Res> implements $GeofenceEventModelCopyWith<$Res> {
  factory _$GeofenceEventModelCopyWith(_GeofenceEventModel value, $Res Function(_GeofenceEventModel) _then) = __$GeofenceEventModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String zoneId, String zoneName, String childUid, String childName, String status, DateTime timestamp
});




}
/// @nodoc
class __$GeofenceEventModelCopyWithImpl<$Res>
    implements _$GeofenceEventModelCopyWith<$Res> {
  __$GeofenceEventModelCopyWithImpl(this._self, this._then);

  final _GeofenceEventModel _self;
  final $Res Function(_GeofenceEventModel) _then;

/// Create a copy of GeofenceEventModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? zoneId = null,Object? zoneName = null,Object? childUid = null,Object? childName = null,Object? status = null,Object? timestamp = null,}) {
  return _then(_GeofenceEventModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,zoneId: null == zoneId ? _self.zoneId : zoneId // ignore: cast_nullable_to_non_nullable
as String,zoneName: null == zoneName ? _self.zoneName : zoneName // ignore: cast_nullable_to_non_nullable
as String,childUid: null == childUid ? _self.childUid : childUid // ignore: cast_nullable_to_non_nullable
as String,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
