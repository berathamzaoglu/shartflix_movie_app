// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthResult {
  User get user;
  String get token;
  String get refreshToken;
  int get expiresIn;

  /// Create a copy of AuthResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthResultCopyWith<AuthResult> get copyWith =>
      _$AuthResultCopyWithImpl<AuthResult>(this as AuthResult, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthResult &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.expiresIn, expiresIn) ||
                other.expiresIn == expiresIn));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, user, token, refreshToken, expiresIn);

  @override
  String toString() {
    return 'AuthResult(user: $user, token: $token, refreshToken: $refreshToken, expiresIn: $expiresIn)';
  }
}

/// @nodoc
abstract mixin class $AuthResultCopyWith<$Res> {
  factory $AuthResultCopyWith(
          AuthResult value, $Res Function(AuthResult) _then) =
      _$AuthResultCopyWithImpl;
  @useResult
  $Res call({User user, String token, String refreshToken, int expiresIn});

  $UserCopyWith<$Res> get user;
}

/// @nodoc
class _$AuthResultCopyWithImpl<$Res> implements $AuthResultCopyWith<$Res> {
  _$AuthResultCopyWithImpl(this._self, this._then);

  final AuthResult _self;
  final $Res Function(AuthResult) _then;

  /// Create a copy of AuthResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? token = null,
    Object? refreshToken = null,
    Object? expiresIn = null,
  }) {
    return _then(_self.copyWith(
      user: null == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      token: null == token
          ? _self.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _self.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _self.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  /// Create a copy of AuthResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get user {
    return $UserCopyWith<$Res>(_self.user, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

/// Adds pattern-matching-related methods to [AuthResult].
extension AuthResultPatterns on AuthResult {
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
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AuthResult value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AuthResult() when $default != null:
        return $default(_that);
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
  TResult map<TResult extends Object?>(
    TResult Function(_AuthResult value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthResult():
        return $default(_that);
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
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AuthResult value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthResult() when $default != null:
        return $default(_that);
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
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            User user, String token, String refreshToken, int expiresIn)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AuthResult() when $default != null:
        return $default(
            _that.user, _that.token, _that.refreshToken, _that.expiresIn);
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
  TResult when<TResult extends Object?>(
    TResult Function(
            User user, String token, String refreshToken, int expiresIn)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthResult():
        return $default(
            _that.user, _that.token, _that.refreshToken, _that.expiresIn);
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
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            User user, String token, String refreshToken, int expiresIn)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthResult() when $default != null:
        return $default(
            _that.user, _that.token, _that.refreshToken, _that.expiresIn);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _AuthResult implements AuthResult {
  const _AuthResult(
      {required this.user,
      required this.token,
      required this.refreshToken,
      required this.expiresIn});

  @override
  final User user;
  @override
  final String token;
  @override
  final String refreshToken;
  @override
  final int expiresIn;

  /// Create a copy of AuthResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AuthResultCopyWith<_AuthResult> get copyWith =>
      __$AuthResultCopyWithImpl<_AuthResult>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AuthResult &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.expiresIn, expiresIn) ||
                other.expiresIn == expiresIn));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, user, token, refreshToken, expiresIn);

  @override
  String toString() {
    return 'AuthResult(user: $user, token: $token, refreshToken: $refreshToken, expiresIn: $expiresIn)';
  }
}

/// @nodoc
abstract mixin class _$AuthResultCopyWith<$Res>
    implements $AuthResultCopyWith<$Res> {
  factory _$AuthResultCopyWith(
          _AuthResult value, $Res Function(_AuthResult) _then) =
      __$AuthResultCopyWithImpl;
  @override
  @useResult
  $Res call({User user, String token, String refreshToken, int expiresIn});

  @override
  $UserCopyWith<$Res> get user;
}

/// @nodoc
class __$AuthResultCopyWithImpl<$Res> implements _$AuthResultCopyWith<$Res> {
  __$AuthResultCopyWithImpl(this._self, this._then);

  final _AuthResult _self;
  final $Res Function(_AuthResult) _then;

  /// Create a copy of AuthResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? user = null,
    Object? token = null,
    Object? refreshToken = null,
    Object? expiresIn = null,
  }) {
    return _then(_AuthResult(
      user: null == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      token: null == token
          ? _self.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _self.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _self.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  /// Create a copy of AuthResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get user {
    return $UserCopyWith<$Res>(_self.user, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

// dart format on
