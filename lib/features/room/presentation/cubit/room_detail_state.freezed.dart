// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RoomDetailState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RoomDetailState()';
}


}

/// @nodoc
class $RoomDetailStateCopyWith<$Res>  {
$RoomDetailStateCopyWith(RoomDetailState _, $Res Function(RoomDetailState) __);
}


/// Adds pattern-matching-related methods to [RoomDetailState].
extension RoomDetailStatePatterns on RoomDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _Error value)?  error,TResult Function( _DeleteLoading value)?  deleteLoading,TResult Function( _DeleteSuccess value)?  deleteSuccess,TResult Function( _DeleteError value)?  deleteError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _DeleteLoading() when deleteLoading != null:
return deleteLoading(_that);case _DeleteSuccess() when deleteSuccess != null:
return deleteSuccess(_that);case _DeleteError() when deleteError != null:
return deleteError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _Error value)  error,required TResult Function( _DeleteLoading value)  deleteLoading,required TResult Function( _DeleteSuccess value)  deleteSuccess,required TResult Function( _DeleteError value)  deleteError,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _Error():
return error(_that);case _DeleteLoading():
return deleteLoading(_that);case _DeleteSuccess():
return deleteSuccess(_that);case _DeleteError():
return deleteError(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _Error value)?  error,TResult? Function( _DeleteLoading value)?  deleteLoading,TResult? Function( _DeleteSuccess value)?  deleteSuccess,TResult? Function( _DeleteError value)?  deleteError,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _DeleteLoading() when deleteLoading != null:
return deleteLoading(_that);case _DeleteSuccess() when deleteSuccess != null:
return deleteSuccess(_that);case _DeleteError() when deleteError != null:
return deleteError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( RoomDetail roomDetail,  List<Invoice> invoices,  List<MeterReading> meterReadings,  List<InventoryItem> inventoryItems,  List<Ticket> tickets)?  loaded,TResult Function( String message)?  error,TResult Function()?  deleteLoading,TResult Function()?  deleteSuccess,TResult Function( String message)?  deleteError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.roomDetail,_that.invoices,_that.meterReadings,_that.inventoryItems,_that.tickets);case _Error() when error != null:
return error(_that.message);case _DeleteLoading() when deleteLoading != null:
return deleteLoading();case _DeleteSuccess() when deleteSuccess != null:
return deleteSuccess();case _DeleteError() when deleteError != null:
return deleteError(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( RoomDetail roomDetail,  List<Invoice> invoices,  List<MeterReading> meterReadings,  List<InventoryItem> inventoryItems,  List<Ticket> tickets)  loaded,required TResult Function( String message)  error,required TResult Function()  deleteLoading,required TResult Function()  deleteSuccess,required TResult Function( String message)  deleteError,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.roomDetail,_that.invoices,_that.meterReadings,_that.inventoryItems,_that.tickets);case _Error():
return error(_that.message);case _DeleteLoading():
return deleteLoading();case _DeleteSuccess():
return deleteSuccess();case _DeleteError():
return deleteError(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( RoomDetail roomDetail,  List<Invoice> invoices,  List<MeterReading> meterReadings,  List<InventoryItem> inventoryItems,  List<Ticket> tickets)?  loaded,TResult? Function( String message)?  error,TResult? Function()?  deleteLoading,TResult? Function()?  deleteSuccess,TResult? Function( String message)?  deleteError,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.roomDetail,_that.invoices,_that.meterReadings,_that.inventoryItems,_that.tickets);case _Error() when error != null:
return error(_that.message);case _DeleteLoading() when deleteLoading != null:
return deleteLoading();case _DeleteSuccess() when deleteSuccess != null:
return deleteSuccess();case _DeleteError() when deleteError != null:
return deleteError(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements RoomDetailState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RoomDetailState.initial()';
}


}




/// @nodoc


class _Loading implements RoomDetailState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RoomDetailState.loading()';
}


}




/// @nodoc


class _Loaded implements RoomDetailState {
  const _Loaded({required this.roomDetail, required final  List<Invoice> invoices, required final  List<MeterReading> meterReadings, required final  List<InventoryItem> inventoryItems, required final  List<Ticket> tickets}): _invoices = invoices,_meterReadings = meterReadings,_inventoryItems = inventoryItems,_tickets = tickets;
  

 final  RoomDetail roomDetail;
 final  List<Invoice> _invoices;
 List<Invoice> get invoices {
  if (_invoices is EqualUnmodifiableListView) return _invoices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_invoices);
}

 final  List<MeterReading> _meterReadings;
 List<MeterReading> get meterReadings {
  if (_meterReadings is EqualUnmodifiableListView) return _meterReadings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_meterReadings);
}

 final  List<InventoryItem> _inventoryItems;
 List<InventoryItem> get inventoryItems {
  if (_inventoryItems is EqualUnmodifiableListView) return _inventoryItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_inventoryItems);
}

 final  List<Ticket> _tickets;
 List<Ticket> get tickets {
  if (_tickets is EqualUnmodifiableListView) return _tickets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tickets);
}


/// Create a copy of RoomDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&(identical(other.roomDetail, roomDetail) || other.roomDetail == roomDetail)&&const DeepCollectionEquality().equals(other._invoices, _invoices)&&const DeepCollectionEquality().equals(other._meterReadings, _meterReadings)&&const DeepCollectionEquality().equals(other._inventoryItems, _inventoryItems)&&const DeepCollectionEquality().equals(other._tickets, _tickets));
}


@override
int get hashCode => Object.hash(runtimeType,roomDetail,const DeepCollectionEquality().hash(_invoices),const DeepCollectionEquality().hash(_meterReadings),const DeepCollectionEquality().hash(_inventoryItems),const DeepCollectionEquality().hash(_tickets));

@override
String toString() {
  return 'RoomDetailState.loaded(roomDetail: $roomDetail, invoices: $invoices, meterReadings: $meterReadings, inventoryItems: $inventoryItems, tickets: $tickets)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $RoomDetailStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 RoomDetail roomDetail, List<Invoice> invoices, List<MeterReading> meterReadings, List<InventoryItem> inventoryItems, List<Ticket> tickets
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of RoomDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? roomDetail = null,Object? invoices = null,Object? meterReadings = null,Object? inventoryItems = null,Object? tickets = null,}) {
  return _then(_Loaded(
roomDetail: null == roomDetail ? _self.roomDetail : roomDetail // ignore: cast_nullable_to_non_nullable
as RoomDetail,invoices: null == invoices ? _self._invoices : invoices // ignore: cast_nullable_to_non_nullable
as List<Invoice>,meterReadings: null == meterReadings ? _self._meterReadings : meterReadings // ignore: cast_nullable_to_non_nullable
as List<MeterReading>,inventoryItems: null == inventoryItems ? _self._inventoryItems : inventoryItems // ignore: cast_nullable_to_non_nullable
as List<InventoryItem>,tickets: null == tickets ? _self._tickets : tickets // ignore: cast_nullable_to_non_nullable
as List<Ticket>,
  ));
}


}

/// @nodoc


class _Error implements RoomDetailState {
  const _Error({required this.message});
  

 final  String message;

/// Create a copy of RoomDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'RoomDetailState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $RoomDetailStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of RoomDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _DeleteLoading implements RoomDetailState {
  const _DeleteLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RoomDetailState.deleteLoading()';
}


}




/// @nodoc


class _DeleteSuccess implements RoomDetailState {
  const _DeleteSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RoomDetailState.deleteSuccess()';
}


}




/// @nodoc


class _DeleteError implements RoomDetailState {
  const _DeleteError({required this.message});
  

 final  String message;

/// Create a copy of RoomDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteErrorCopyWith<_DeleteError> get copyWith => __$DeleteErrorCopyWithImpl<_DeleteError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'RoomDetailState.deleteError(message: $message)';
}


}

/// @nodoc
abstract mixin class _$DeleteErrorCopyWith<$Res> implements $RoomDetailStateCopyWith<$Res> {
  factory _$DeleteErrorCopyWith(_DeleteError value, $Res Function(_DeleteError) _then) = __$DeleteErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$DeleteErrorCopyWithImpl<$Res>
    implements _$DeleteErrorCopyWith<$Res> {
  __$DeleteErrorCopyWithImpl(this._self, this._then);

  final _DeleteError _self;
  final $Res Function(_DeleteError) _then;

/// Create a copy of RoomDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_DeleteError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
