// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pagination_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaginationModel {
  @JsonKey(name: 'totalCount')
  int get totalCount;
  @JsonKey(name: 'perPage')
  int get perPage;
  @JsonKey(name: 'maxPage')
  int get maxPage;
  @JsonKey(name: 'currentPage')
  int get currentPage;

  /// Create a copy of PaginationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PaginationModelCopyWith<PaginationModel> get copyWith =>
      _$PaginationModelCopyWithImpl<PaginationModel>(
          this as PaginationModel, _$identity);

  /// Serializes this PaginationModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PaginationModel &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.perPage, perPage) || other.perPage == perPage) &&
            (identical(other.maxPage, maxPage) || other.maxPage == maxPage) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, totalCount, perPage, maxPage, currentPage);

  @override
  String toString() {
    return 'PaginationModel(totalCount: $totalCount, perPage: $perPage, maxPage: $maxPage, currentPage: $currentPage)';
  }
}

/// @nodoc
abstract mixin class $PaginationModelCopyWith<$Res> {
  factory $PaginationModelCopyWith(
          PaginationModel value, $Res Function(PaginationModel) _then) =
      _$PaginationModelCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'totalCount') int totalCount,
      @JsonKey(name: 'perPage') int perPage,
      @JsonKey(name: 'maxPage') int maxPage,
      @JsonKey(name: 'currentPage') int currentPage});
}

/// @nodoc
class _$PaginationModelCopyWithImpl<$Res>
    implements $PaginationModelCopyWith<$Res> {
  _$PaginationModelCopyWithImpl(this._self, this._then);

  final PaginationModel _self;
  final $Res Function(PaginationModel) _then;

  /// Create a copy of PaginationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCount = null,
    Object? perPage = null,
    Object? maxPage = null,
    Object? currentPage = null,
  }) {
    return _then(_self.copyWith(
      totalCount: null == totalCount
          ? _self.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _self.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      maxPage: null == maxPage
          ? _self.maxPage
          : maxPage // ignore: cast_nullable_to_non_nullable
              as int,
      currentPage: null == currentPage
          ? _self.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [PaginationModel].
extension PaginationModelPatterns on PaginationModel {
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
    TResult Function(_PaginationModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PaginationModel() when $default != null:
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
    TResult Function(_PaginationModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PaginationModel():
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
    TResult? Function(_PaginationModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PaginationModel() when $default != null:
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
            @JsonKey(name: 'totalCount') int totalCount,
            @JsonKey(name: 'perPage') int perPage,
            @JsonKey(name: 'maxPage') int maxPage,
            @JsonKey(name: 'currentPage') int currentPage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PaginationModel() when $default != null:
        return $default(
            _that.totalCount, _that.perPage, _that.maxPage, _that.currentPage);
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
            @JsonKey(name: 'totalCount') int totalCount,
            @JsonKey(name: 'perPage') int perPage,
            @JsonKey(name: 'maxPage') int maxPage,
            @JsonKey(name: 'currentPage') int currentPage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PaginationModel():
        return $default(
            _that.totalCount, _that.perPage, _that.maxPage, _that.currentPage);
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
            @JsonKey(name: 'totalCount') int totalCount,
            @JsonKey(name: 'perPage') int perPage,
            @JsonKey(name: 'maxPage') int maxPage,
            @JsonKey(name: 'currentPage') int currentPage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PaginationModel() when $default != null:
        return $default(
            _that.totalCount, _that.perPage, _that.maxPage, _that.currentPage);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PaginationModel implements PaginationModel {
  const _PaginationModel(
      {@JsonKey(name: 'totalCount') required this.totalCount,
      @JsonKey(name: 'perPage') required this.perPage,
      @JsonKey(name: 'maxPage') required this.maxPage,
      @JsonKey(name: 'currentPage') required this.currentPage});
  factory _PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);

  @override
  @JsonKey(name: 'totalCount')
  final int totalCount;
  @override
  @JsonKey(name: 'perPage')
  final int perPage;
  @override
  @JsonKey(name: 'maxPage')
  final int maxPage;
  @override
  @JsonKey(name: 'currentPage')
  final int currentPage;

  /// Create a copy of PaginationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PaginationModelCopyWith<_PaginationModel> get copyWith =>
      __$PaginationModelCopyWithImpl<_PaginationModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PaginationModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PaginationModel &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.perPage, perPage) || other.perPage == perPage) &&
            (identical(other.maxPage, maxPage) || other.maxPage == maxPage) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, totalCount, perPage, maxPage, currentPage);

  @override
  String toString() {
    return 'PaginationModel(totalCount: $totalCount, perPage: $perPage, maxPage: $maxPage, currentPage: $currentPage)';
  }
}

/// @nodoc
abstract mixin class _$PaginationModelCopyWith<$Res>
    implements $PaginationModelCopyWith<$Res> {
  factory _$PaginationModelCopyWith(
          _PaginationModel value, $Res Function(_PaginationModel) _then) =
      __$PaginationModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'totalCount') int totalCount,
      @JsonKey(name: 'perPage') int perPage,
      @JsonKey(name: 'maxPage') int maxPage,
      @JsonKey(name: 'currentPage') int currentPage});
}

/// @nodoc
class __$PaginationModelCopyWithImpl<$Res>
    implements _$PaginationModelCopyWith<$Res> {
  __$PaginationModelCopyWithImpl(this._self, this._then);

  final _PaginationModel _self;
  final $Res Function(_PaginationModel) _then;

  /// Create a copy of PaginationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? totalCount = null,
    Object? perPage = null,
    Object? maxPage = null,
    Object? currentPage = null,
  }) {
    return _then(_PaginationModel(
      totalCount: null == totalCount
          ? _self.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _self.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      maxPage: null == maxPage
          ? _self.maxPage
          : maxPage // ignore: cast_nullable_to_non_nullable
              as int,
      currentPage: null == currentPage
          ? _self.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
