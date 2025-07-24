// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movies_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MoviesResponseModel {
  List<MovieModel> get movies;
  PaginationModel get pagination;

  /// Create a copy of MoviesResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MoviesResponseModelCopyWith<MoviesResponseModel> get copyWith =>
      _$MoviesResponseModelCopyWithImpl<MoviesResponseModel>(
          this as MoviesResponseModel, _$identity);

  /// Serializes this MoviesResponseModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MoviesResponseModel &&
            const DeepCollectionEquality().equals(other.movies, movies) &&
            (identical(other.pagination, pagination) ||
                other.pagination == pagination));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(movies), pagination);

  @override
  String toString() {
    return 'MoviesResponseModel(movies: $movies, pagination: $pagination)';
  }
}

/// @nodoc
abstract mixin class $MoviesResponseModelCopyWith<$Res> {
  factory $MoviesResponseModelCopyWith(
          MoviesResponseModel value, $Res Function(MoviesResponseModel) _then) =
      _$MoviesResponseModelCopyWithImpl;
  @useResult
  $Res call({List<MovieModel> movies, PaginationModel pagination});

  $PaginationModelCopyWith<$Res> get pagination;
}

/// @nodoc
class _$MoviesResponseModelCopyWithImpl<$Res>
    implements $MoviesResponseModelCopyWith<$Res> {
  _$MoviesResponseModelCopyWithImpl(this._self, this._then);

  final MoviesResponseModel _self;
  final $Res Function(MoviesResponseModel) _then;

  /// Create a copy of MoviesResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? movies = null,
    Object? pagination = null,
  }) {
    return _then(_self.copyWith(
      movies: null == movies
          ? _self.movies
          : movies // ignore: cast_nullable_to_non_nullable
              as List<MovieModel>,
      pagination: null == pagination
          ? _self.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as PaginationModel,
    ));
  }

  /// Create a copy of MoviesResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaginationModelCopyWith<$Res> get pagination {
    return $PaginationModelCopyWith<$Res>(_self.pagination, (value) {
      return _then(_self.copyWith(pagination: value));
    });
  }
}

/// Adds pattern-matching-related methods to [MoviesResponseModel].
extension MoviesResponseModelPatterns on MoviesResponseModel {
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
    TResult Function(_MoviesResponseModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MoviesResponseModel() when $default != null:
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
    TResult Function(_MoviesResponseModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MoviesResponseModel():
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
    TResult? Function(_MoviesResponseModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MoviesResponseModel() when $default != null:
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
    TResult Function(List<MovieModel> movies, PaginationModel pagination)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MoviesResponseModel() when $default != null:
        return $default(_that.movies, _that.pagination);
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
    TResult Function(List<MovieModel> movies, PaginationModel pagination)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MoviesResponseModel():
        return $default(_that.movies, _that.pagination);
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
    TResult? Function(List<MovieModel> movies, PaginationModel pagination)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MoviesResponseModel() when $default != null:
        return $default(_that.movies, _that.pagination);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MoviesResponseModel implements MoviesResponseModel {
  const _MoviesResponseModel(
      {required final List<MovieModel> movies, required this.pagination})
      : _movies = movies;
  factory _MoviesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MoviesResponseModelFromJson(json);

  final List<MovieModel> _movies;
  @override
  List<MovieModel> get movies {
    if (_movies is EqualUnmodifiableListView) return _movies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_movies);
  }

  @override
  final PaginationModel pagination;

  /// Create a copy of MoviesResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MoviesResponseModelCopyWith<_MoviesResponseModel> get copyWith =>
      __$MoviesResponseModelCopyWithImpl<_MoviesResponseModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MoviesResponseModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MoviesResponseModel &&
            const DeepCollectionEquality().equals(other._movies, _movies) &&
            (identical(other.pagination, pagination) ||
                other.pagination == pagination));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_movies), pagination);

  @override
  String toString() {
    return 'MoviesResponseModel(movies: $movies, pagination: $pagination)';
  }
}

/// @nodoc
abstract mixin class _$MoviesResponseModelCopyWith<$Res>
    implements $MoviesResponseModelCopyWith<$Res> {
  factory _$MoviesResponseModelCopyWith(_MoviesResponseModel value,
          $Res Function(_MoviesResponseModel) _then) =
      __$MoviesResponseModelCopyWithImpl;
  @override
  @useResult
  $Res call({List<MovieModel> movies, PaginationModel pagination});

  @override
  $PaginationModelCopyWith<$Res> get pagination;
}

/// @nodoc
class __$MoviesResponseModelCopyWithImpl<$Res>
    implements _$MoviesResponseModelCopyWith<$Res> {
  __$MoviesResponseModelCopyWithImpl(this._self, this._then);

  final _MoviesResponseModel _self;
  final $Res Function(_MoviesResponseModel) _then;

  /// Create a copy of MoviesResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? movies = null,
    Object? pagination = null,
  }) {
    return _then(_MoviesResponseModel(
      movies: null == movies
          ? _self._movies
          : movies // ignore: cast_nullable_to_non_nullable
              as List<MovieModel>,
      pagination: null == pagination
          ? _self.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as PaginationModel,
    ));
  }

  /// Create a copy of MoviesResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaginationModelCopyWith<$Res> get pagination {
    return $PaginationModelCopyWith<$Res>(_self.pagination, (value) {
      return _then(_self.copyWith(pagination: value));
    });
  }
}

// dart format on
