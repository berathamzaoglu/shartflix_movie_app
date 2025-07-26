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
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AuthEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthEvent()';
  }
}

/// @nodoc
class $AuthEventCopyWith<$Res> {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthCheckStatusRequested value)? checkAuthStatus,
    TResult Function(AuthLoginRequested value)? loginRequested,
    TResult Function(AuthRegisterRequested value)? registerRequested,
    TResult Function(AuthLogoutRequested value)? logoutRequested,
    TResult Function(AuthForgotPasswordRequested value)?
        forgotPasswordRequested,
    TResult Function(AuthUpdateProfilePhotoRequested value)? updateProfilePhoto,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case AuthCheckStatusRequested() when checkAuthStatus != null:
        return checkAuthStatus(_that);
      case AuthLoginRequested() when loginRequested != null:
        return loginRequested(_that);
      case AuthRegisterRequested() when registerRequested != null:
        return registerRequested(_that);
      case AuthLogoutRequested() when logoutRequested != null:
        return logoutRequested(_that);
      case AuthForgotPasswordRequested() when forgotPasswordRequested != null:
        return forgotPasswordRequested(_that);
      case AuthUpdateProfilePhotoRequested() when updateProfilePhoto != null:
        return updateProfilePhoto(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthCheckStatusRequested value) checkAuthStatus,
    required TResult Function(AuthLoginRequested value) loginRequested,
    required TResult Function(AuthRegisterRequested value) registerRequested,
    required TResult Function(AuthLogoutRequested value) logoutRequested,
    required TResult Function(AuthForgotPasswordRequested value)
        forgotPasswordRequested,
    required TResult Function(AuthUpdateProfilePhotoRequested value)
        updateProfilePhoto,
  }) {
    final _that = this;
    switch (_that) {
      case AuthCheckStatusRequested():
        return checkAuthStatus(_that);
      case AuthLoginRequested():
        return loginRequested(_that);
      case AuthRegisterRequested():
        return registerRequested(_that);
      case AuthLogoutRequested():
        return logoutRequested(_that);
      case AuthForgotPasswordRequested():
        return forgotPasswordRequested(_that);
      case AuthUpdateProfilePhotoRequested():
        return updateProfilePhoto(_that);
      case _:
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthCheckStatusRequested value)? checkAuthStatus,
    TResult? Function(AuthLoginRequested value)? loginRequested,
    TResult? Function(AuthRegisterRequested value)? registerRequested,
    TResult? Function(AuthLogoutRequested value)? logoutRequested,
    TResult? Function(AuthForgotPasswordRequested value)?
        forgotPasswordRequested,
    TResult? Function(AuthUpdateProfilePhotoRequested value)?
        updateProfilePhoto,
  }) {
    final _that = this;
    switch (_that) {
      case AuthCheckStatusRequested() when checkAuthStatus != null:
        return checkAuthStatus(_that);
      case AuthLoginRequested() when loginRequested != null:
        return loginRequested(_that);
      case AuthRegisterRequested() when registerRequested != null:
        return registerRequested(_that);
      case AuthLogoutRequested() when logoutRequested != null:
        return logoutRequested(_that);
      case AuthForgotPasswordRequested() when forgotPasswordRequested != null:
        return forgotPasswordRequested(_that);
      case AuthUpdateProfilePhotoRequested() when updateProfilePhoto != null:
        return updateProfilePhoto(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checkAuthStatus,
    TResult Function(String email, String password, bool rememberMe)?
        loginRequested,
    TResult Function(String name, String email, String password)?
        registerRequested,
    TResult Function()? logoutRequested,
    TResult Function(String email)? forgotPasswordRequested,
    TResult Function(String photoUrl)? updateProfilePhoto,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case AuthCheckStatusRequested() when checkAuthStatus != null:
        return checkAuthStatus();
      case AuthLoginRequested() when loginRequested != null:
        return loginRequested(_that.email, _that.password, _that.rememberMe);
      case AuthRegisterRequested() when registerRequested != null:
        return registerRequested(_that.name, _that.email, _that.password);
      case AuthLogoutRequested() when logoutRequested != null:
        return logoutRequested();
      case AuthForgotPasswordRequested() when forgotPasswordRequested != null:
        return forgotPasswordRequested(_that.email);
      case AuthUpdateProfilePhotoRequested() when updateProfilePhoto != null:
        return updateProfilePhoto(_that.photoUrl);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checkAuthStatus,
    required TResult Function(String email, String password, bool rememberMe)
        loginRequested,
    required TResult Function(String name, String email, String password)
        registerRequested,
    required TResult Function() logoutRequested,
    required TResult Function(String email) forgotPasswordRequested,
    required TResult Function(String photoUrl) updateProfilePhoto,
  }) {
    final _that = this;
    switch (_that) {
      case AuthCheckStatusRequested():
        return checkAuthStatus();
      case AuthLoginRequested():
        return loginRequested(_that.email, _that.password, _that.rememberMe);
      case AuthRegisterRequested():
        return registerRequested(_that.name, _that.email, _that.password);
      case AuthLogoutRequested():
        return logoutRequested();
      case AuthForgotPasswordRequested():
        return forgotPasswordRequested(_that.email);
      case AuthUpdateProfilePhotoRequested():
        return updateProfilePhoto(_that.photoUrl);
      case _:
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checkAuthStatus,
    TResult? Function(String email, String password, bool rememberMe)?
        loginRequested,
    TResult? Function(String name, String email, String password)?
        registerRequested,
    TResult? Function()? logoutRequested,
    TResult? Function(String email)? forgotPasswordRequested,
    TResult? Function(String photoUrl)? updateProfilePhoto,
  }) {
    final _that = this;
    switch (_that) {
      case AuthCheckStatusRequested() when checkAuthStatus != null:
        return checkAuthStatus();
      case AuthLoginRequested() when loginRequested != null:
        return loginRequested(_that.email, _that.password, _that.rememberMe);
      case AuthRegisterRequested() when registerRequested != null:
        return registerRequested(_that.name, _that.email, _that.password);
      case AuthLogoutRequested() when logoutRequested != null:
        return logoutRequested();
      case AuthForgotPasswordRequested() when forgotPasswordRequested != null:
        return forgotPasswordRequested(_that.email);
      case AuthUpdateProfilePhotoRequested() when updateProfilePhoto != null:
        return updateProfilePhoto(_that.photoUrl);
      case _:
        return null;
    }
  }
}

/// @nodoc

class AuthCheckStatusRequested implements AuthEvent {
  const AuthCheckStatusRequested();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AuthCheckStatusRequested);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthEvent.checkAuthStatus()';
  }
}

/// @nodoc

class AuthLoginRequested implements AuthEvent {
  const AuthLoginRequested(
      {required this.email, required this.password, this.rememberMe = false});

  final String email;
  final String password;
  @JsonKey()
  final bool rememberMe;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthLoginRequestedCopyWith<AuthLoginRequested> get copyWith =>
      _$AuthLoginRequestedCopyWithImpl<AuthLoginRequested>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthLoginRequested &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.rememberMe, rememberMe) ||
                other.rememberMe == rememberMe));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email, password, rememberMe);

  @override
  String toString() {
    return 'AuthEvent.loginRequested(email: $email, password: $password, rememberMe: $rememberMe)';
  }
}

/// @nodoc
abstract mixin class $AuthLoginRequestedCopyWith<$Res>
    implements $AuthEventCopyWith<$Res> {
  factory $AuthLoginRequestedCopyWith(
          AuthLoginRequested value, $Res Function(AuthLoginRequested) _then) =
      _$AuthLoginRequestedCopyWithImpl;
  @useResult
  $Res call({String email, String password, bool rememberMe});
}

/// @nodoc
class _$AuthLoginRequestedCopyWithImpl<$Res>
    implements $AuthLoginRequestedCopyWith<$Res> {
  _$AuthLoginRequestedCopyWithImpl(this._self, this._then);

  final AuthLoginRequested _self;
  final $Res Function(AuthLoginRequested) _then;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? rememberMe = null,
  }) {
    return _then(AuthLoginRequested(
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      rememberMe: null == rememberMe
          ? _self.rememberMe
          : rememberMe // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class AuthRegisterRequested implements AuthEvent {
  const AuthRegisterRequested(
      {required this.name, required this.email, required this.password});

  final String name;
  final String email;
  final String password;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthRegisterRequestedCopyWith<AuthRegisterRequested> get copyWith =>
      _$AuthRegisterRequestedCopyWithImpl<AuthRegisterRequested>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthRegisterRequested &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, email, password);

  @override
  String toString() {
    return 'AuthEvent.registerRequested(name: $name, email: $email, password: $password)';
  }
}

/// @nodoc
abstract mixin class $AuthRegisterRequestedCopyWith<$Res>
    implements $AuthEventCopyWith<$Res> {
  factory $AuthRegisterRequestedCopyWith(AuthRegisterRequested value,
          $Res Function(AuthRegisterRequested) _then) =
      _$AuthRegisterRequestedCopyWithImpl;
  @useResult
  $Res call({String name, String email, String password});
}

/// @nodoc
class _$AuthRegisterRequestedCopyWithImpl<$Res>
    implements $AuthRegisterRequestedCopyWith<$Res> {
  _$AuthRegisterRequestedCopyWithImpl(this._self, this._then);

  final AuthRegisterRequested _self;
  final $Res Function(AuthRegisterRequested) _then;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? email = null,
    Object? password = null,
  }) {
    return _then(AuthRegisterRequested(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class AuthLogoutRequested implements AuthEvent {
  const AuthLogoutRequested();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AuthLogoutRequested);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthEvent.logoutRequested()';
  }
}

/// @nodoc

class AuthForgotPasswordRequested implements AuthEvent {
  const AuthForgotPasswordRequested({required this.email});

  final String email;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthForgotPasswordRequestedCopyWith<AuthForgotPasswordRequested>
      get copyWith => _$AuthForgotPasswordRequestedCopyWithImpl<
          AuthForgotPasswordRequested>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthForgotPasswordRequested &&
            (identical(other.email, email) || other.email == email));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email);

  @override
  String toString() {
    return 'AuthEvent.forgotPasswordRequested(email: $email)';
  }
}

/// @nodoc
abstract mixin class $AuthForgotPasswordRequestedCopyWith<$Res>
    implements $AuthEventCopyWith<$Res> {
  factory $AuthForgotPasswordRequestedCopyWith(
          AuthForgotPasswordRequested value,
          $Res Function(AuthForgotPasswordRequested) _then) =
      _$AuthForgotPasswordRequestedCopyWithImpl;
  @useResult
  $Res call({String email});
}

/// @nodoc
class _$AuthForgotPasswordRequestedCopyWithImpl<$Res>
    implements $AuthForgotPasswordRequestedCopyWith<$Res> {
  _$AuthForgotPasswordRequestedCopyWithImpl(this._self, this._then);

  final AuthForgotPasswordRequested _self;
  final $Res Function(AuthForgotPasswordRequested) _then;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? email = null,
  }) {
    return _then(AuthForgotPasswordRequested(
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class AuthUpdateProfilePhotoRequested implements AuthEvent {
  const AuthUpdateProfilePhotoRequested({required this.photoUrl});

  final String photoUrl;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthUpdateProfilePhotoRequestedCopyWith<AuthUpdateProfilePhotoRequested>
      get copyWith => _$AuthUpdateProfilePhotoRequestedCopyWithImpl<
          AuthUpdateProfilePhotoRequested>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthUpdateProfilePhotoRequested &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl));
  }

  @override
  int get hashCode => Object.hash(runtimeType, photoUrl);

  @override
  String toString() {
    return 'AuthEvent.updateProfilePhoto(photoUrl: $photoUrl)';
  }
}

/// @nodoc
abstract mixin class $AuthUpdateProfilePhotoRequestedCopyWith<$Res>
    implements $AuthEventCopyWith<$Res> {
  factory $AuthUpdateProfilePhotoRequestedCopyWith(
          AuthUpdateProfilePhotoRequested value,
          $Res Function(AuthUpdateProfilePhotoRequested) _then) =
      _$AuthUpdateProfilePhotoRequestedCopyWithImpl;
  @useResult
  $Res call({String photoUrl});
}

/// @nodoc
class _$AuthUpdateProfilePhotoRequestedCopyWithImpl<$Res>
    implements $AuthUpdateProfilePhotoRequestedCopyWith<$Res> {
  _$AuthUpdateProfilePhotoRequestedCopyWithImpl(this._self, this._then);

  final AuthUpdateProfilePhotoRequested _self;
  final $Res Function(AuthUpdateProfilePhotoRequested) _then;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? photoUrl = null,
  }) {
    return _then(AuthUpdateProfilePhotoRequested(
      photoUrl: null == photoUrl
          ? _self.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
