// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'child_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChildStatus {

 String get childId; ChildStatusType get type; DateTime get updatedAt; String? get note;
/// Create a copy of ChildStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChildStatusCopyWith<ChildStatus> get copyWith => _$ChildStatusCopyWithImpl<ChildStatus>(this as ChildStatus, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChildStatus&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.type, type) || other.type == type)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,childId,type,updatedAt,note);

@override
String toString() {
  return 'ChildStatus(childId: $childId, type: $type, updatedAt: $updatedAt, note: $note)';
}


}

/// @nodoc
abstract mixin class $ChildStatusCopyWith<$Res>  {
  factory $ChildStatusCopyWith(ChildStatus value, $Res Function(ChildStatus) _then) = _$ChildStatusCopyWithImpl;
@useResult
$Res call({
 String childId, ChildStatusType type, DateTime updatedAt, String? note
});




}
/// @nodoc
class _$ChildStatusCopyWithImpl<$Res>
    implements $ChildStatusCopyWith<$Res> {
  _$ChildStatusCopyWithImpl(this._self, this._then);

  final ChildStatus _self;
  final $Res Function(ChildStatus) _then;

/// Create a copy of ChildStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? childId = null,Object? type = null,Object? updatedAt = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
childId: null == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ChildStatusType,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChildStatus].
extension ChildStatusPatterns on ChildStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChildStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChildStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChildStatus value)  $default,){
final _that = this;
switch (_that) {
case _ChildStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChildStatus value)?  $default,){
final _that = this;
switch (_that) {
case _ChildStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String childId,  ChildStatusType type,  DateTime updatedAt,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChildStatus() when $default != null:
return $default(_that.childId,_that.type,_that.updatedAt,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String childId,  ChildStatusType type,  DateTime updatedAt,  String? note)  $default,) {final _that = this;
switch (_that) {
case _ChildStatus():
return $default(_that.childId,_that.type,_that.updatedAt,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String childId,  ChildStatusType type,  DateTime updatedAt,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _ChildStatus() when $default != null:
return $default(_that.childId,_that.type,_that.updatedAt,_that.note);case _:
  return null;

}
}

}

/// @nodoc


class _ChildStatus implements ChildStatus {
  const _ChildStatus({required this.childId, required this.type, required this.updatedAt, this.note});
  

@override final  String childId;
@override final  ChildStatusType type;
@override final  DateTime updatedAt;
@override final  String? note;

/// Create a copy of ChildStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChildStatusCopyWith<_ChildStatus> get copyWith => __$ChildStatusCopyWithImpl<_ChildStatus>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChildStatus&&(identical(other.childId, childId) || other.childId == childId)&&(identical(other.type, type) || other.type == type)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,childId,type,updatedAt,note);

@override
String toString() {
  return 'ChildStatus(childId: $childId, type: $type, updatedAt: $updatedAt, note: $note)';
}


}

/// @nodoc
abstract mixin class _$ChildStatusCopyWith<$Res> implements $ChildStatusCopyWith<$Res> {
  factory _$ChildStatusCopyWith(_ChildStatus value, $Res Function(_ChildStatus) _then) = __$ChildStatusCopyWithImpl;
@override @useResult
$Res call({
 String childId, ChildStatusType type, DateTime updatedAt, String? note
});




}
/// @nodoc
class __$ChildStatusCopyWithImpl<$Res>
    implements _$ChildStatusCopyWith<$Res> {
  __$ChildStatusCopyWithImpl(this._self, this._then);

  final _ChildStatus _self;
  final $Res Function(_ChildStatus) _then;

/// Create a copy of ChildStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? childId = null,Object? type = null,Object? updatedAt = null,Object? note = freezed,}) {
  return _then(_ChildStatus(
childId: null == childId ? _self.childId : childId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ChildStatusType,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
