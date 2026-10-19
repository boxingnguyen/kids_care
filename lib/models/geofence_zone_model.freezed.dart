// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'geofence_zone_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GeofenceZoneModel {

 String get id; String get name; double get lat; double get lng; double get radiusMeters; String get emoji;
/// Create a copy of GeofenceZoneModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeofenceZoneModelCopyWith<GeofenceZoneModel> get copyWith => _$GeofenceZoneModelCopyWithImpl<GeofenceZoneModel>(this as GeofenceZoneModel, _$identity);

  /// Serializes this GeofenceZoneModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeofenceZoneModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.radiusMeters, radiusMeters) || other.radiusMeters == radiusMeters)&&(identical(other.emoji, emoji) || other.emoji == emoji));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,lat,lng,radiusMeters,emoji);

@override
String toString() {
  return 'GeofenceZoneModel(id: $id, name: $name, lat: $lat, lng: $lng, radiusMeters: $radiusMeters, emoji: $emoji)';
}


}

/// @nodoc
abstract mixin class $GeofenceZoneModelCopyWith<$Res>  {
  factory $GeofenceZoneModelCopyWith(GeofenceZoneModel value, $Res Function(GeofenceZoneModel) _then) = _$GeofenceZoneModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, double lat, double lng, double radiusMeters, String emoji
});




}
/// @nodoc
class _$GeofenceZoneModelCopyWithImpl<$Res>
    implements $GeofenceZoneModelCopyWith<$Res> {
  _$GeofenceZoneModelCopyWithImpl(this._self, this._then);

  final GeofenceZoneModel _self;
  final $Res Function(GeofenceZoneModel) _then;

/// Create a copy of GeofenceZoneModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? lat = null,Object? lng = null,Object? radiusMeters = null,Object? emoji = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,radiusMeters: null == radiusMeters ? _self.radiusMeters : radiusMeters // ignore: cast_nullable_to_non_nullable
as double,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GeofenceZoneModel].
extension GeofenceZoneModelPatterns on GeofenceZoneModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeofenceZoneModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeofenceZoneModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeofenceZoneModel value)  $default,){
final _that = this;
switch (_that) {
case _GeofenceZoneModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeofenceZoneModel value)?  $default,){
final _that = this;
switch (_that) {
case _GeofenceZoneModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  double lat,  double lng,  double radiusMeters,  String emoji)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeofenceZoneModel() when $default != null:
return $default(_that.id,_that.name,_that.lat,_that.lng,_that.radiusMeters,_that.emoji);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  double lat,  double lng,  double radiusMeters,  String emoji)  $default,) {final _that = this;
switch (_that) {
case _GeofenceZoneModel():
return $default(_that.id,_that.name,_that.lat,_that.lng,_that.radiusMeters,_that.emoji);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  double lat,  double lng,  double radiusMeters,  String emoji)?  $default,) {final _that = this;
switch (_that) {
case _GeofenceZoneModel() when $default != null:
return $default(_that.id,_that.name,_that.lat,_that.lng,_that.radiusMeters,_that.emoji);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeofenceZoneModel implements GeofenceZoneModel {
  const _GeofenceZoneModel({required this.id, required this.name, required this.lat, required this.lng, this.radiusMeters = 1000.0, this.emoji = '🏠'});
  factory _GeofenceZoneModel.fromJson(Map<String, dynamic> json) => _$GeofenceZoneModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  double lat;
@override final  double lng;
@override@JsonKey() final  double radiusMeters;
@override@JsonKey() final  String emoji;

/// Create a copy of GeofenceZoneModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeofenceZoneModelCopyWith<_GeofenceZoneModel> get copyWith => __$GeofenceZoneModelCopyWithImpl<_GeofenceZoneModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeofenceZoneModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeofenceZoneModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.radiusMeters, radiusMeters) || other.radiusMeters == radiusMeters)&&(identical(other.emoji, emoji) || other.emoji == emoji));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,lat,lng,radiusMeters,emoji);

@override
String toString() {
  return 'GeofenceZoneModel(id: $id, name: $name, lat: $lat, lng: $lng, radiusMeters: $radiusMeters, emoji: $emoji)';
}


}

/// @nodoc
abstract mixin class _$GeofenceZoneModelCopyWith<$Res> implements $GeofenceZoneModelCopyWith<$Res> {
  factory _$GeofenceZoneModelCopyWith(_GeofenceZoneModel value, $Res Function(_GeofenceZoneModel) _then) = __$GeofenceZoneModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, double lat, double lng, double radiusMeters, String emoji
});




}
/// @nodoc
class __$GeofenceZoneModelCopyWithImpl<$Res>
    implements _$GeofenceZoneModelCopyWith<$Res> {
  __$GeofenceZoneModelCopyWithImpl(this._self, this._then);

  final _GeofenceZoneModel _self;
  final $Res Function(_GeofenceZoneModel) _then;

/// Create a copy of GeofenceZoneModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? lat = null,Object? lng = null,Object? radiusMeters = null,Object? emoji = null,}) {
  return _then(_GeofenceZoneModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,radiusMeters: null == radiusMeters ? _self.radiusMeters : radiusMeters // ignore: cast_nullable_to_non_nullable
as double,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
