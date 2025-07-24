// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AuthEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checkAuthStatus,
    required TResult Function(String email, String password, bool rememberMe)
        loginRequested,
    required TResult Function(String name, String email, String password)
        registerRequested,
    required TResult Function() logoutRequested,
    required TResult Function(String email) forgotPasswordRequested,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checkAuthStatus,
    TResult? Function(String email, String password, bool rememberMe)?
        loginRequested,
    TResult? Function(String name, String email, String password)?
        registerRequested,
    TResult? Function()? logoutRequested,
    TResult? Function(String email)? forgotPasswordRequested,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checkAuthStatus,
    TResult Function(String email, String password, bool rememberMe)?
        loginRequested,
    TResult Function(String name, String email, String password)?
        registerRequested,
    TResult Function()? logoutRequested,
    TResult Function(String email)? forgotPasswordRequested,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthCheckStatusRequested value) checkAuthStatus,
    required TResult Function(AuthLoginRequested value) loginRequested,
    required TResult Function(AuthRegisterRequested value) registerRequested,
    required TResult Function(AuthLogoutRequested value) logoutRequested,
    required TResult Function(AuthForgotPasswordRequested value)
        forgotPasswordRequested,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthCheckStatusRequested value)? checkAuthStatus,
    TResult? Function(AuthLoginRequested value)? loginRequested,
    TResult? Function(AuthRegisterRequested value)? registerRequested,
    TResult? Function(AuthLogoutRequested value)? logoutRequested,
    TResult? Function(AuthForgotPasswordRequested value)?
        forgotPasswordRequested,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthCheckStatusRequested value)? checkAuthStatus,
    TResult Function(AuthLoginRequested value)? loginRequested,
    TResult Function(AuthRegisterRequested value)? registerRequested,
    TResult Function(AuthLogoutRequested value)? logoutRequested,
    TResult Function(AuthForgotPasswordRequested value)?
        forgotPasswordRequested,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthEventCopyWith<$Res> {
  factory $AuthEventCopyWith(AuthEvent value, $Res Function(AuthEvent) then) =
      _$AuthEventCopyWithImpl<$Res, AuthEvent>;
}

/// @nodoc
class _$AuthEventCopyWithImpl<$Res, $Val extends AuthEvent>
    implements $AuthEventCopyWith<$Res> {
  _$AuthEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$AuthCheckStatusRequestedImplCopyWith<$Res> {
  factory _$$AuthCheckStatusRequestedImplCopyWith(
          _$AuthCheckStatusRequestedImpl value,
          $Res Function(_$AuthCheckStatusRequestedImpl) then) =
      __$$AuthCheckStatusRequestedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthCheckStatusRequestedImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthCheckStatusRequestedImpl>
    implements _$$AuthCheckStatusRequestedImplCopyWith<$Res> {
  __$$AuthCheckStatusRequestedImplCopyWithImpl(
      _$AuthCheckStatusRequestedImpl _value,
      $Res Function(_$AuthCheckStatusRequestedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AuthCheckStatusRequestedImpl implements AuthCheckStatusRequested {
  const _$AuthCheckStatusRequestedImpl();

  @override
  String toString() {
    return 'AuthEvent.checkAuthStatus()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthCheckStatusRequestedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checkAuthStatus,
    required TResult Function(String email, String password, bool rememberMe)
        loginRequested,
    required TResult Function(String name, String email, String password)
        registerRequested,
    required TResult Function() logoutRequested,
    required TResult Function(String email) forgotPasswordRequested,
  }) {
    return checkAuthStatus();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checkAuthStatus,
    TResult? Function(String email, String password, bool rememberMe)?
        loginRequested,
    TResult? Function(String name, String email, String password)?
        registerRequested,
    TResult? Function()? logoutRequested,
    TResult? Function(String email)? forgotPasswordRequested,
  }) {
    return checkAuthStatus?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checkAuthStatus,
    TResult Function(String email, String password, bool rememberMe)?
        loginRequested,
    TResult Function(String name, String email, String password)?
        registerRequested,
    TResult Function()? logoutRequested,
    TResult Function(String email)? forgotPasswordRequested,
    required TResult orElse(),
  }) {
    if (checkAuthStatus != null) {
      return checkAuthStatus();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthCheckStatusRequested value) checkAuthStatus,
    required TResult Function(AuthLoginRequested value) loginRequested,
    required TResult Function(AuthRegisterRequested value) registerRequested,
    required TResult Function(AuthLogoutRequested value) logoutRequested,
    required TResult Function(AuthForgotPasswordRequested value)
        forgotPasswordRequested,
  }) {
    return checkAuthStatus(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthCheckStatusRequested value)? checkAuthStatus,
    TResult? Function(AuthLoginRequested value)? loginRequested,
    TResult? Function(AuthRegisterRequested value)? registerRequested,
    TResult? Function(AuthLogoutRequested value)? logoutRequested,
    TResult? Function(AuthForgotPasswordRequested value)?
        forgotPasswordRequested,
  }) {
    return checkAuthStatus?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthCheckStatusRequested value)? checkAuthStatus,
    TResult Function(AuthLoginRequested value)? loginRequested,
    TResult Function(AuthRegisterRequested value)? registerRequested,
    TResult Function(AuthLogoutRequested value)? logoutRequested,
    TResult Function(AuthForgotPasswordRequested value)?
        forgotPasswordRequested,
    required TResult orElse(),
  }) {
    if (checkAuthStatus != null) {
      return checkAuthStatus(this);
    }
    return orElse();
  }
}

abstract class AuthCheckStatusRequested implements AuthEvent {
  const factory AuthCheckStatusRequested() = _$AuthCheckStatusRequestedImpl;
}

/// @nodoc
abstract class _$$AuthLoginRequestedImplCopyWith<$Res> {
  factory _$$AuthLoginRequestedImplCopyWith(_$AuthLoginRequestedImpl value,
          $Res Function(_$AuthLoginRequestedImpl) then) =
      __$$AuthLoginRequestedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String email, String password, bool rememberMe});
}

/// @nodoc
class __$$AuthLoginRequestedImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthLoginRequestedImpl>
    implements _$$AuthLoginRequestedImplCopyWith<$Res> {
  __$$AuthLoginRequestedImplCopyWithImpl(_$AuthLoginRequestedImpl _value,
      $Res Function(_$AuthLoginRequestedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? rememberMe = null,
  }) {
    return _then(_$AuthLoginRequestedImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      rememberMe: null == rememberMe
          ? _value.rememberMe
          : rememberMe // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$AuthLoginRequestedImpl implements AuthLoginRequested {
  const _$AuthLoginRequestedImpl(
      {required this.email, required this.password, this.rememberMe = false});

  @override
  final String email;
  @override
  final String password;
  @override
  @JsonKey()
  final bool rememberMe;

  @override
  String toString() {
    return 'AuthEvent.loginRequested(email: $email, password: $password, rememberMe: $rememberMe)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthLoginRequestedImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.rememberMe, rememberMe) ||
                other.rememberMe == rememberMe));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email, password, rememberMe);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthLoginRequestedImplCopyWith<_$AuthLoginRequestedImpl> get copyWith =>
      __$$AuthLoginRequestedImplCopyWithImpl<_$AuthLoginRequestedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checkAuthStatus,
    required TResult Function(String email, String password, bool rememberMe)
        loginRequested,
    required TResult Function(String name, String email, String password)
        registerRequested,
    required TResult Function() logoutRequested,
    required TResult Function(String email) forgotPasswordRequested,
  }) {
    return loginRequested(email, password, rememberMe);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checkAuthStatus,
    TResult? Function(String email, String password, bool rememberMe)?
        loginRequested,
    TResult? Function(String name, String email, String password)?
        registerRequested,
    TResult? Function()? logoutRequested,
    TResult? Function(String email)? forgotPasswordRequested,
  }) {
    return loginRequested?.call(email, password, rememberMe);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checkAuthStatus,
    TResult Function(String email, String password, bool rememberMe)?
        loginRequested,
    TResult Function(String name, String email, String password)?
        registerRequested,
    TResult Function()? logoutRequested,
    TResult Function(String email)? forgotPasswordRequested,
    required TResult orElse(),
  }) {
    if (loginRequested != null) {
      return loginRequested(email, password, rememberMe);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthCheckStatusRequested value) checkAuthStatus,
    required TResult Function(AuthLoginRequested value) loginRequested,
    required TResult Function(AuthRegisterRequested value) registerRequested,
    required TResult Function(AuthLogoutRequested value) logoutRequested,
    required TResult Function(AuthForgotPasswordRequested value)
        forgotPasswordRequested,
  }) {
    return loginRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthCheckStatusRequested value)? checkAuthStatus,
    TResult? Function(AuthLoginRequested value)? loginRequested,
    TResult? Function(AuthRegisterRequested value)? registerRequested,
    TResult? Function(AuthLogoutRequested value)? logoutRequested,
    TResult? Function(AuthForgotPasswordRequested value)?
        forgotPasswordRequested,
  }) {
    return loginRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthCheckStatusRequested value)? checkAuthStatus,
    TResult Function(AuthLoginRequested value)? loginRequested,
    TResult Function(AuthRegisterRequested value)? registerRequested,
    TResult Function(AuthLogoutRequested value)? logoutRequested,
    TResult Function(AuthForgotPasswordRequested value)?
        forgotPasswordRequested,
    required TResult orElse(),
  }) {
    if (loginRequested != null) {
      return loginRequested(this);
    }
    return orElse();
  }
}

abstract class AuthLoginRequested implements AuthEvent {
  const factory AuthLoginRequested(
      {required final String email,
      required final String password,
      final bool rememberMe}) = _$AuthLoginRequestedImpl;

  String get email;
  String get password;
  bool get rememberMe;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthLoginRequestedImplCopyWith<_$AuthLoginRequestedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthRegisterRequestedImplCopyWith<$Res> {
  factory _$$AuthRegisterRequestedImplCopyWith(
          _$AuthRegisterRequestedImpl value,
          $Res Function(_$AuthRegisterRequestedImpl) then) =
      __$$AuthRegisterRequestedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String name, String email, String password});
}

/// @nodoc
class __$$AuthRegisterRequestedImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthRegisterRequestedImpl>
    implements _$$AuthRegisterRequestedImplCopyWith<$Res> {
  __$$AuthRegisterRequestedImplCopyWithImpl(_$AuthRegisterRequestedImpl _value,
      $Res Function(_$AuthRegisterRequestedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? email = null,
    Object? password = null,
  }) {
    return _then(_$AuthRegisterRequestedImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AuthRegisterRequestedImpl implements AuthRegisterRequested {
  const _$AuthRegisterRequestedImpl(
      {required this.name, required this.email, required this.password});

  @override
  final String name;
  @override
  final String email;
  @override
  final String password;

  @override
  String toString() {
    return 'AuthEvent.registerRequested(name: $name, email: $email, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthRegisterRequestedImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, email, password);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthRegisterRequestedImplCopyWith<_$AuthRegisterRequestedImpl>
      get copyWith => __$$AuthRegisterRequestedImplCopyWithImpl<
          _$AuthRegisterRequestedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checkAuthStatus,
    required TResult Function(String email, String password, bool rememberMe)
        loginRequested,
    required TResult Function(String name, String email, String password)
        registerRequested,
    required TResult Function() logoutRequested,
    required TResult Function(String email) forgotPasswordRequested,
  }) {
    return registerRequested(name, email, password);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checkAuthStatus,
    TResult? Function(String email, String password, bool rememberMe)?
        loginRequested,
    TResult? Function(String name, String email, String password)?
        registerRequested,
    TResult? Function()? logoutRequested,
    TResult? Function(String email)? forgotPasswordRequested,
  }) {
    return registerRequested?.call(name, email, password);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checkAuthStatus,
    TResult Function(String email, String password, bool rememberMe)?
        loginRequested,
    TResult Function(String name, String email, String password)?
        registerRequested,
    TResult Function()? logoutRequested,
    TResult Function(String email)? forgotPasswordRequested,
    required TResult orElse(),
  }) {
    if (registerRequested != null) {
      return registerRequested(name, email, password);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthCheckStatusRequested value) checkAuthStatus,
    required TResult Function(AuthLoginRequested value) loginRequested,
    required TResult Function(AuthRegisterRequested value) registerRequested,
    required TResult Function(AuthLogoutRequested value) logoutRequested,
    required TResult Function(AuthForgotPasswordRequested value)
        forgotPasswordRequested,
  }) {
    return registerRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthCheckStatusRequested value)? checkAuthStatus,
    TResult? Function(AuthLoginRequested value)? loginRequested,
    TResult? Function(AuthRegisterRequested value)? registerRequested,
    TResult? Function(AuthLogoutRequested value)? logoutRequested,
    TResult? Function(AuthForgotPasswordRequested value)?
        forgotPasswordRequested,
  }) {
    return registerRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthCheckStatusRequested value)? checkAuthStatus,
    TResult Function(AuthLoginRequested value)? loginRequested,
    TResult Function(AuthRegisterRequested value)? registerRequested,
    TResult Function(AuthLogoutRequested value)? logoutRequested,
    TResult Function(AuthForgotPasswordRequested value)?
        forgotPasswordRequested,
    required TResult orElse(),
  }) {
    if (registerRequested != null) {
      return registerRequested(this);
    }
    return orElse();
  }
}

abstract class AuthRegisterRequested implements AuthEvent {
  const factory AuthRegisterRequested(
      {required final String name,
      required final String email,
      required final String password}) = _$AuthRegisterRequestedImpl;

  String get name;
  String get email;
  String get password;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthRegisterRequestedImplCopyWith<_$AuthRegisterRequestedImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthLogoutRequestedImplCopyWith<$Res> {
  factory _$$AuthLogoutRequestedImplCopyWith(_$AuthLogoutRequestedImpl value,
          $Res Function(_$AuthLogoutRequestedImpl) then) =
      __$$AuthLogoutRequestedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthLogoutRequestedImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthLogoutRequestedImpl>
    implements _$$AuthLogoutRequestedImplCopyWith<$Res> {
  __$$AuthLogoutRequestedImplCopyWithImpl(_$AuthLogoutRequestedImpl _value,
      $Res Function(_$AuthLogoutRequestedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AuthLogoutRequestedImpl implements AuthLogoutRequested {
  const _$AuthLogoutRequestedImpl();

  @override
  String toString() {
    return 'AuthEvent.logoutRequested()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthLogoutRequestedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checkAuthStatus,
    required TResult Function(String email, String password, bool rememberMe)
        loginRequested,
    required TResult Function(String name, String email, String password)
        registerRequested,
    required TResult Function() logoutRequested,
    required TResult Function(String email) forgotPasswordRequested,
  }) {
    return logoutRequested();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checkAuthStatus,
    TResult? Function(String email, String password, bool rememberMe)?
        loginRequested,
    TResult? Function(String name, String email, String password)?
        registerRequested,
    TResult? Function()? logoutRequested,
    TResult? Function(String email)? forgotPasswordRequested,
  }) {
    return logoutRequested?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checkAuthStatus,
    TResult Function(String email, String password, bool rememberMe)?
        loginRequested,
    TResult Function(String name, String email, String password)?
        registerRequested,
    TResult Function()? logoutRequested,
    TResult Function(String email)? forgotPasswordRequested,
    required TResult orElse(),
  }) {
    if (logoutRequested != null) {
      return logoutRequested();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthCheckStatusRequested value) checkAuthStatus,
    required TResult Function(AuthLoginRequested value) loginRequested,
    required TResult Function(AuthRegisterRequested value) registerRequested,
    required TResult Function(AuthLogoutRequested value) logoutRequested,
    required TResult Function(AuthForgotPasswordRequested value)
        forgotPasswordRequested,
  }) {
    return logoutRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthCheckStatusRequested value)? checkAuthStatus,
    TResult? Function(AuthLoginRequested value)? loginRequested,
    TResult? Function(AuthRegisterRequested value)? registerRequested,
    TResult? Function(AuthLogoutRequested value)? logoutRequested,
    TResult? Function(AuthForgotPasswordRequested value)?
        forgotPasswordRequested,
  }) {
    return logoutRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthCheckStatusRequested value)? checkAuthStatus,
    TResult Function(AuthLoginRequested value)? loginRequested,
    TResult Function(AuthRegisterRequested value)? registerRequested,
    TResult Function(AuthLogoutRequested value)? logoutRequested,
    TResult Function(AuthForgotPasswordRequested value)?
        forgotPasswordRequested,
    required TResult orElse(),
  }) {
    if (logoutRequested != null) {
      return logoutRequested(this);
    }
    return orElse();
  }
}

abstract class AuthLogoutRequested implements AuthEvent {
  const factory AuthLogoutRequested() = _$AuthLogoutRequestedImpl;
}

/// @nodoc
abstract class _$$AuthForgotPasswordRequestedImplCopyWith<$Res> {
  factory _$$AuthForgotPasswordRequestedImplCopyWith(
          _$AuthForgotPasswordRequestedImpl value,
          $Res Function(_$AuthForgotPasswordRequestedImpl) then) =
      __$$AuthForgotPasswordRequestedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String email});
}

/// @nodoc
class __$$AuthForgotPasswordRequestedImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthForgotPasswordRequestedImpl>
    implements _$$AuthForgotPasswordRequestedImplCopyWith<$Res> {
  __$$AuthForgotPasswordRequestedImplCopyWithImpl(
      _$AuthForgotPasswordRequestedImpl _value,
      $Res Function(_$AuthForgotPasswordRequestedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
  }) {
    return _then(_$AuthForgotPasswordRequestedImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AuthForgotPasswordRequestedImpl implements AuthForgotPasswordRequested {
  const _$AuthForgotPasswordRequestedImpl({required this.email});

  @override
  final String email;

  @override
  String toString() {
    return 'AuthEvent.forgotPasswordRequested(email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthForgotPasswordRequestedImpl &&
            (identical(other.email, email) || other.email == email));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthForgotPasswordRequestedImplCopyWith<_$AuthForgotPasswordRequestedImpl>
      get copyWith => __$$AuthForgotPasswordRequestedImplCopyWithImpl<
          _$AuthForgotPasswordRequestedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checkAuthStatus,
    required TResult Function(String email, String password, bool rememberMe)
        loginRequested,
    required TResult Function(String name, String email, String password)
        registerRequested,
    required TResult Function() logoutRequested,
    required TResult Function(String email) forgotPasswordRequested,
  }) {
    return forgotPasswordRequested(email);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checkAuthStatus,
    TResult? Function(String email, String password, bool rememberMe)?
        loginRequested,
    TResult? Function(String name, String email, String password)?
        registerRequested,
    TResult? Function()? logoutRequested,
    TResult? Function(String email)? forgotPasswordRequested,
  }) {
    return forgotPasswordRequested?.call(email);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checkAuthStatus,
    TResult Function(String email, String password, bool rememberMe)?
        loginRequested,
    TResult Function(String name, String email, String password)?
        registerRequested,
    TResult Function()? logoutRequested,
    TResult Function(String email)? forgotPasswordRequested,
    required TResult orElse(),
  }) {
    if (forgotPasswordRequested != null) {
      return forgotPasswordRequested(email);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthCheckStatusRequested value) checkAuthStatus,
    required TResult Function(AuthLoginRequested value) loginRequested,
    required TResult Function(AuthRegisterRequested value) registerRequested,
    required TResult Function(AuthLogoutRequested value) logoutRequested,
    required TResult Function(AuthForgotPasswordRequested value)
        forgotPasswordRequested,
  }) {
    return forgotPasswordRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthCheckStatusRequested value)? checkAuthStatus,
    TResult? Function(AuthLoginRequested value)? loginRequested,
    TResult? Function(AuthRegisterRequested value)? registerRequested,
    TResult? Function(AuthLogoutRequested value)? logoutRequested,
    TResult? Function(AuthForgotPasswordRequested value)?
        forgotPasswordRequested,
  }) {
    return forgotPasswordRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthCheckStatusRequested value)? checkAuthStatus,
    TResult Function(AuthLoginRequested value)? loginRequested,
    TResult Function(AuthRegisterRequested value)? registerRequested,
    TResult Function(AuthLogoutRequested value)? logoutRequested,
    TResult Function(AuthForgotPasswordRequested value)?
        forgotPasswordRequested,
    required TResult orElse(),
  }) {
    if (forgotPasswordRequested != null) {
      return forgotPasswordRequested(this);
    }
    return orElse();
  }
}

abstract class AuthForgotPasswordRequested implements AuthEvent {
  const factory AuthForgotPasswordRequested({required final String email}) =
      _$AuthForgotPasswordRequestedImpl;

  String get email;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthForgotPasswordRequestedImplCopyWith<_$AuthForgotPasswordRequestedImpl>
      get copyWith => throw _privateConstructorUsedError;
}
