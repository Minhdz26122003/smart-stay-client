// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent()';
}


}

/// @nodoc
class $AuthEventCopyWith<$Res>  {
$AuthEventCopyWith(AuthEvent _, $Res Function(AuthEvent) __);
}


/// Adds pattern-matching-related methods to [AuthEvent].
extension AuthEventPatterns on AuthEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _LoginRequested value)?  loginRequested,TResult Function( _RegisterRequested value)?  registerRequested,TResult Function( _LogoutRequested value)?  logoutRequested,TResult Function( _CheckAuthSession value)?  checkAuthSession,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginRequested() when loginRequested != null:
return loginRequested(_that);case _RegisterRequested() when registerRequested != null:
return registerRequested(_that);case _LogoutRequested() when logoutRequested != null:
return logoutRequested(_that);case _CheckAuthSession() when checkAuthSession != null:
return checkAuthSession(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _LoginRequested value)  loginRequested,required TResult Function( _RegisterRequested value)  registerRequested,required TResult Function( _LogoutRequested value)  logoutRequested,required TResult Function( _CheckAuthSession value)  checkAuthSession,}){
final _that = this;
switch (_that) {
case _LoginRequested():
return loginRequested(_that);case _RegisterRequested():
return registerRequested(_that);case _LogoutRequested():
return logoutRequested(_that);case _CheckAuthSession():
return checkAuthSession(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _LoginRequested value)?  loginRequested,TResult? Function( _RegisterRequested value)?  registerRequested,TResult? Function( _LogoutRequested value)?  logoutRequested,TResult? Function( _CheckAuthSession value)?  checkAuthSession,}){
final _that = this;
switch (_that) {
case _LoginRequested() when loginRequested != null:
return loginRequested(_that);case _RegisterRequested() when registerRequested != null:
return registerRequested(_that);case _LogoutRequested() when logoutRequested != null:
return logoutRequested(_that);case _CheckAuthSession() when checkAuthSession != null:
return checkAuthSession(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String email,  String password,  bool rememberMe)?  loginRequested,TResult Function( String fullName,  String email,  String password,  String role)?  registerRequested,TResult Function()?  logoutRequested,TResult Function()?  checkAuthSession,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginRequested() when loginRequested != null:
return loginRequested(_that.email,_that.password,_that.rememberMe);case _RegisterRequested() when registerRequested != null:
return registerRequested(_that.fullName,_that.email,_that.password,_that.role);case _LogoutRequested() when logoutRequested != null:
return logoutRequested();case _CheckAuthSession() when checkAuthSession != null:
return checkAuthSession();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String email,  String password,  bool rememberMe)  loginRequested,required TResult Function( String fullName,  String email,  String password,  String role)  registerRequested,required TResult Function()  logoutRequested,required TResult Function()  checkAuthSession,}) {final _that = this;
switch (_that) {
case _LoginRequested():
return loginRequested(_that.email,_that.password,_that.rememberMe);case _RegisterRequested():
return registerRequested(_that.fullName,_that.email,_that.password,_that.role);case _LogoutRequested():
return logoutRequested();case _CheckAuthSession():
return checkAuthSession();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String email,  String password,  bool rememberMe)?  loginRequested,TResult? Function( String fullName,  String email,  String password,  String role)?  registerRequested,TResult? Function()?  logoutRequested,TResult? Function()?  checkAuthSession,}) {final _that = this;
switch (_that) {
case _LoginRequested() when loginRequested != null:
return loginRequested(_that.email,_that.password,_that.rememberMe);case _RegisterRequested() when registerRequested != null:
return registerRequested(_that.fullName,_that.email,_that.password,_that.role);case _LogoutRequested() when logoutRequested != null:
return logoutRequested();case _CheckAuthSession() when checkAuthSession != null:
return checkAuthSession();case _:
  return null;

}
}

}

/// @nodoc


class _LoginRequested implements AuthEvent {
  const _LoginRequested({required this.email, required this.password, this.rememberMe = true});
  

 final  String email;
 final  String password;
@JsonKey() final  bool rememberMe;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginRequestedCopyWith<_LoginRequested> get copyWith => __$LoginRequestedCopyWithImpl<_LoginRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginRequested&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.rememberMe, rememberMe) || other.rememberMe == rememberMe));
}


@override
int get hashCode => Object.hash(runtimeType,email,password,rememberMe);

@override
String toString() {
  return 'AuthEvent.loginRequested(email: $email, password: $password, rememberMe: $rememberMe)';
}


}

/// @nodoc
abstract mixin class _$LoginRequestedCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory _$LoginRequestedCopyWith(_LoginRequested value, $Res Function(_LoginRequested) _then) = __$LoginRequestedCopyWithImpl;
@useResult
$Res call({
 String email, String password, bool rememberMe
});




}
/// @nodoc
class __$LoginRequestedCopyWithImpl<$Res>
    implements _$LoginRequestedCopyWith<$Res> {
  __$LoginRequestedCopyWithImpl(this._self, this._then);

  final _LoginRequested _self;
  final $Res Function(_LoginRequested) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,Object? rememberMe = null,}) {
  return _then(_LoginRequested(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,rememberMe: null == rememberMe ? _self.rememberMe : rememberMe // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _RegisterRequested implements AuthEvent {
  const _RegisterRequested({required this.fullName, required this.email, required this.password, required this.role});
  

 final  String fullName;
 final  String email;
 final  String password;
 final  String role;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisterRequestedCopyWith<_RegisterRequested> get copyWith => __$RegisterRequestedCopyWithImpl<_RegisterRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegisterRequested&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.role, role) || other.role == role));
}


@override
int get hashCode => Object.hash(runtimeType,fullName,email,password,role);

@override
String toString() {
  return 'AuthEvent.registerRequested(fullName: $fullName, email: $email, password: $password, role: $role)';
}


}

/// @nodoc
abstract mixin class _$RegisterRequestedCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory _$RegisterRequestedCopyWith(_RegisterRequested value, $Res Function(_RegisterRequested) _then) = __$RegisterRequestedCopyWithImpl;
@useResult
$Res call({
 String fullName, String email, String password, String role
});




}
/// @nodoc
class __$RegisterRequestedCopyWithImpl<$Res>
    implements _$RegisterRequestedCopyWith<$Res> {
  __$RegisterRequestedCopyWithImpl(this._self, this._then);

  final _RegisterRequested _self;
  final $Res Function(_RegisterRequested) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? fullName = null,Object? email = null,Object? password = null,Object? role = null,}) {
  return _then(_RegisterRequested(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _LogoutRequested implements AuthEvent {
  const _LogoutRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LogoutRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.logoutRequested()';
}


}




/// @nodoc


class _CheckAuthSession implements AuthEvent {
  const _CheckAuthSession();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckAuthSession);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.checkAuthSession()';
}


}




// dart format on
