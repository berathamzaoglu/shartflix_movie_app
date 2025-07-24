// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_result_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AuthResultModel _$AuthResultModelFromJson(Map<String, dynamic> json) {
  return _AuthResultModel.fromJson(json);
}

/// @nodoc
mixin _$AuthResultModel {
  UserModel get user => throw _privateConstructorUsedError;
  String get token => throw _privateConstructorUsedError;
  @JsonKey(name: 'refresh_token')
  String get refreshToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_in')
  int get expiresIn => throw _privateConstructorUsedError;

  /// Serializes this AuthResultModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthResultModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthResultModelCopyWith<AuthResultModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthResultModelCopyWith<$Res> {
  factory $AuthResultModelCopyWith(
          AuthResultModel value, $Res Function(AuthResultModel) then) =
      _$AuthResultModelCopyWithImpl<$Res, AuthResultModel>;
  @useResult
  $Res call(
      {UserModel user,
      String token,
      @JsonKey(name: 'refresh_token') String refreshToken,
      @JsonKey(name: 'expires_in') int expiresIn});

  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class _$AuthResultModelCopyWithImpl<$Res, $Val extends AuthResultModel>
    implements $AuthResultModelCopyWith<$Res> {
  _$AuthResultModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthResultModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? token = null,
    Object? refreshToken = null,
    Object? expiresIn = null,
  }) {
    return _then(_value.copyWith(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of AuthResultModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res> get user {
    return $UserModelCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthResultModelImplCopyWith<$Res>
    implements $AuthResultModelCopyWith<$Res> {
  factory _$$AuthResultModelImplCopyWith(_$AuthResultModelImpl value,
          $Res Function(_$AuthResultModelImpl) then) =
      __$$AuthResultModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {UserModel user,
      String token,
      @JsonKey(name: 'refresh_token') String refreshToken,
      @JsonKey(name: 'expires_in') int expiresIn});

  @override
  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class __$$AuthResultModelImplCopyWithImpl<$Res>
    extends _$AuthResultModelCopyWithImpl<$Res, _$AuthResultModelImpl>
    implements _$$AuthResultModelImplCopyWith<$Res> {
  __$$AuthResultModelImplCopyWithImpl(
      _$AuthResultModelImpl _value, $Res Function(_$AuthResultModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthResultModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? token = null,
    Object? refreshToken = null,
    Object? expiresIn = null,
  }) {
    return _then(_$AuthResultModelImpl(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthResultModelImpl implements _AuthResultModel {
  const _$AuthResultModelImpl(
      {required this.user,
      required this.token,
      @JsonKey(name: 'refresh_token') required this.refreshToken,
      @JsonKey(name: 'expires_in') required this.expiresIn});

  factory _$AuthResultModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthResultModelImplFromJson(json);

  @override
  final UserModel user;
  @override
  final String token;
  @override
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  @override
  @JsonKey(name: 'expires_in')
  final int expiresIn;

  @override
  String toString() {
    return 'AuthResultModel(user: $user, token: $token, refreshToken: $refreshToken, expiresIn: $expiresIn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthResultModelImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.expiresIn, expiresIn) ||
                other.expiresIn == expiresIn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, user, token, refreshToken, expiresIn);

  /// Create a copy of AuthResultModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthResultModelImplCopyWith<_$AuthResultModelImpl> get copyWith =>
      __$$AuthResultModelImplCopyWithImpl<_$AuthResultModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthResultModelImplToJson(
      this,
    );
  }
}

abstract class _AuthResultModel implements AuthResultModel {
  const factory _AuthResultModel(
          {required final UserModel user,
          required final String token,
          @JsonKey(name: 'refresh_token') required final String refreshToken,
          @JsonKey(name: 'expires_in') required final int expiresIn}) =
      _$AuthResultModelImpl;

  factory _AuthResultModel.fromJson(Map<String, dynamic> json) =
      _$AuthResultModelImpl.fromJson;

  @override
  UserModel get user;
  @override
  String get token;
  @override
  @JsonKey(name: 'refresh_token')
  String get refreshToken;
  @override
  @JsonKey(name: 'expires_in')
  int get expiresIn;

  /// Create a copy of AuthResultModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthResultModelImplCopyWith<_$AuthResultModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
