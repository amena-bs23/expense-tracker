// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoginState<T> {

 bool get rememberMe; Status get status; String? get error;
/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginStateCopyWith<T, LoginState<T>> get copyWith => _$LoginStateCopyWithImpl<T, LoginState<T>>(this as LoginState<T>, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginState<T>&&(identical(other.rememberMe, rememberMe) || other.rememberMe == rememberMe)&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,rememberMe,status,error);

@override
String toString() {
  return 'LoginState<$T>(rememberMe: $rememberMe, status: $status, error: $error)';
}


}

/// @nodoc
abstract mixin class $LoginStateCopyWith<T,$Res>  {
  factory $LoginStateCopyWith(LoginState<T> value, $Res Function(LoginState<T>) _then) = _$LoginStateCopyWithImpl;
@useResult
$Res call({
 bool rememberMe, Status status, String? error
});




}
/// @nodoc
class _$LoginStateCopyWithImpl<T,$Res>
    implements $LoginStateCopyWith<T, $Res> {
  _$LoginStateCopyWithImpl(this._self, this._then);

  final LoginState<T> _self;
  final $Res Function(LoginState<T>) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rememberMe = null,Object? status = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
rememberMe: null == rememberMe ? _self.rememberMe : rememberMe // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as Status,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LoginState].
extension LoginStatePatterns<T> on LoginState<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginState<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginState<T> value)  $default,){
final _that = this;
switch (_that) {
case _LoginState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginState<T> value)?  $default,){
final _that = this;
switch (_that) {
case _LoginState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool rememberMe,  Status status,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginState() when $default != null:
return $default(_that.rememberMe,_that.status,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool rememberMe,  Status status,  String? error)  $default,) {final _that = this;
switch (_that) {
case _LoginState():
return $default(_that.rememberMe,_that.status,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool rememberMe,  Status status,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _LoginState() when $default != null:
return $default(_that.rememberMe,_that.status,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _LoginState<T> extends LoginState<T> {
  const _LoginState({this.rememberMe = false, this.status = Status.initial, this.error}): super._();
  

@override@JsonKey() final  bool rememberMe;
@override@JsonKey() final  Status status;
@override final  String? error;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginStateCopyWith<T, _LoginState<T>> get copyWith => __$LoginStateCopyWithImpl<T, _LoginState<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginState<T>&&(identical(other.rememberMe, rememberMe) || other.rememberMe == rememberMe)&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,rememberMe,status,error);

@override
String toString() {
  return 'LoginState<$T>(rememberMe: $rememberMe, status: $status, error: $error)';
}


}

/// @nodoc
abstract mixin class _$LoginStateCopyWith<T,$Res> implements $LoginStateCopyWith<T, $Res> {
  factory _$LoginStateCopyWith(_LoginState<T> value, $Res Function(_LoginState<T>) _then) = __$LoginStateCopyWithImpl;
@override @useResult
$Res call({
 bool rememberMe, Status status, String? error
});




}
/// @nodoc
class __$LoginStateCopyWithImpl<T,$Res>
    implements _$LoginStateCopyWith<T, $Res> {
  __$LoginStateCopyWithImpl(this._self, this._then);

  final _LoginState<T> _self;
  final $Res Function(_LoginState<T>) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rememberMe = null,Object? status = null,Object? error = freezed,}) {
  return _then(_LoginState<T>(
rememberMe: null == rememberMe ? _self.rememberMe : rememberMe // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as Status,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
