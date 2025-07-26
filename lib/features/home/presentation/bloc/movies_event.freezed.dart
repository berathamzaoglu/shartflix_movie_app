// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movies_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MoviesEvent {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is MoviesEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MoviesEvent()';
  }
}

/// @nodoc
class $MoviesEventCopyWith<$Res> {
  $MoviesEventCopyWith(MoviesEvent _, $Res Function(MoviesEvent) __);
}

/// Adds pattern-matching-related methods to [MoviesEvent].
extension MoviesEventPatterns on MoviesEvent {
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
    TResult Function(LoadPopularMovies value)? loadPopularMovies,
    TResult Function(LoadMoreMovies value)? loadMoreMovies,
    TResult Function(RefreshMovies value)? refreshMovies,
    TResult Function(ToggleFavorite value)? toggleFavorite,
    TResult Function(SearchMovies value)? searchMovies,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case LoadPopularMovies() when loadPopularMovies != null:
        return loadPopularMovies(_that);
      case LoadMoreMovies() when loadMoreMovies != null:
        return loadMoreMovies(_that);
      case RefreshMovies() when refreshMovies != null:
        return refreshMovies(_that);
      case ToggleFavorite() when toggleFavorite != null:
        return toggleFavorite(_that);
      case SearchMovies() when searchMovies != null:
        return searchMovies(_that);
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
    required TResult Function(LoadPopularMovies value) loadPopularMovies,
    required TResult Function(LoadMoreMovies value) loadMoreMovies,
    required TResult Function(RefreshMovies value) refreshMovies,
    required TResult Function(ToggleFavorite value) toggleFavorite,
    required TResult Function(SearchMovies value) searchMovies,
  }) {
    final _that = this;
    switch (_that) {
      case LoadPopularMovies():
        return loadPopularMovies(_that);
      case LoadMoreMovies():
        return loadMoreMovies(_that);
      case RefreshMovies():
        return refreshMovies(_that);
      case ToggleFavorite():
        return toggleFavorite(_that);
      case SearchMovies():
        return searchMovies(_that);
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
    TResult? Function(LoadPopularMovies value)? loadPopularMovies,
    TResult? Function(LoadMoreMovies value)? loadMoreMovies,
    TResult? Function(RefreshMovies value)? refreshMovies,
    TResult? Function(ToggleFavorite value)? toggleFavorite,
    TResult? Function(SearchMovies value)? searchMovies,
  }) {
    final _that = this;
    switch (_that) {
      case LoadPopularMovies() when loadPopularMovies != null:
        return loadPopularMovies(_that);
      case LoadMoreMovies() when loadMoreMovies != null:
        return loadMoreMovies(_that);
      case RefreshMovies() when refreshMovies != null:
        return refreshMovies(_that);
      case ToggleFavorite() when toggleFavorite != null:
        return toggleFavorite(_that);
      case SearchMovies() when searchMovies != null:
        return searchMovies(_that);
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
    TResult Function()? loadPopularMovies,
    TResult Function()? loadMoreMovies,
    TResult Function()? refreshMovies,
    TResult Function(Movie movie)? toggleFavorite,
    TResult Function(String query)? searchMovies,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case LoadPopularMovies() when loadPopularMovies != null:
        return loadPopularMovies();
      case LoadMoreMovies() when loadMoreMovies != null:
        return loadMoreMovies();
      case RefreshMovies() when refreshMovies != null:
        return refreshMovies();
      case ToggleFavorite() when toggleFavorite != null:
        return toggleFavorite(_that.movie);
      case SearchMovies() when searchMovies != null:
        return searchMovies(_that.query);
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
    required TResult Function() loadPopularMovies,
    required TResult Function() loadMoreMovies,
    required TResult Function() refreshMovies,
    required TResult Function(Movie movie) toggleFavorite,
    required TResult Function(String query) searchMovies,
  }) {
    final _that = this;
    switch (_that) {
      case LoadPopularMovies():
        return loadPopularMovies();
      case LoadMoreMovies():
        return loadMoreMovies();
      case RefreshMovies():
        return refreshMovies();
      case ToggleFavorite():
        return toggleFavorite(_that.movie);
      case SearchMovies():
        return searchMovies(_that.query);
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
    TResult? Function()? loadPopularMovies,
    TResult? Function()? loadMoreMovies,
    TResult? Function()? refreshMovies,
    TResult? Function(Movie movie)? toggleFavorite,
    TResult? Function(String query)? searchMovies,
  }) {
    final _that = this;
    switch (_that) {
      case LoadPopularMovies() when loadPopularMovies != null:
        return loadPopularMovies();
      case LoadMoreMovies() when loadMoreMovies != null:
        return loadMoreMovies();
      case RefreshMovies() when refreshMovies != null:
        return refreshMovies();
      case ToggleFavorite() when toggleFavorite != null:
        return toggleFavorite(_that.movie);
      case SearchMovies() when searchMovies != null:
        return searchMovies(_that.query);
      case _:
        return null;
    }
  }
}

/// @nodoc

class LoadPopularMovies implements MoviesEvent {
  const LoadPopularMovies();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is LoadPopularMovies);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MoviesEvent.loadPopularMovies()';
  }
}

/// @nodoc

class LoadMoreMovies implements MoviesEvent {
  const LoadMoreMovies();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is LoadMoreMovies);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MoviesEvent.loadMoreMovies()';
  }
}

/// @nodoc

class RefreshMovies implements MoviesEvent {
  const RefreshMovies();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is RefreshMovies);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MoviesEvent.refreshMovies()';
  }
}

/// @nodoc

class ToggleFavorite implements MoviesEvent {
  const ToggleFavorite(this.movie);

  final Movie movie;

  /// Create a copy of MoviesEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ToggleFavoriteCopyWith<ToggleFavorite> get copyWith =>
      _$ToggleFavoriteCopyWithImpl<ToggleFavorite>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ToggleFavorite &&
            (identical(other.movie, movie) || other.movie == movie));
  }

  @override
  int get hashCode => Object.hash(runtimeType, movie);

  @override
  String toString() {
    return 'MoviesEvent.toggleFavorite(movie: $movie)';
  }
}

/// @nodoc
abstract mixin class $ToggleFavoriteCopyWith<$Res>
    implements $MoviesEventCopyWith<$Res> {
  factory $ToggleFavoriteCopyWith(
          ToggleFavorite value, $Res Function(ToggleFavorite) _then) =
      _$ToggleFavoriteCopyWithImpl;
  @useResult
  $Res call({Movie movie});
}

/// @nodoc
class _$ToggleFavoriteCopyWithImpl<$Res>
    implements $ToggleFavoriteCopyWith<$Res> {
  _$ToggleFavoriteCopyWithImpl(this._self, this._then);

  final ToggleFavorite _self;
  final $Res Function(ToggleFavorite) _then;

  /// Create a copy of MoviesEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? movie = null,
  }) {
    return _then(ToggleFavorite(
      null == movie
          ? _self.movie
          : movie // ignore: cast_nullable_to_non_nullable
              as Movie,
    ));
  }
}

/// @nodoc

class SearchMovies implements MoviesEvent {
  const SearchMovies(this.query);

  final String query;

  /// Create a copy of MoviesEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SearchMoviesCopyWith<SearchMovies> get copyWith =>
      _$SearchMoviesCopyWithImpl<SearchMovies>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SearchMovies &&
            (identical(other.query, query) || other.query == query));
  }

  @override
  int get hashCode => Object.hash(runtimeType, query);

  @override
  String toString() {
    return 'MoviesEvent.searchMovies(query: $query)';
  }
}

/// @nodoc
abstract mixin class $SearchMoviesCopyWith<$Res>
    implements $MoviesEventCopyWith<$Res> {
  factory $SearchMoviesCopyWith(
          SearchMovies value, $Res Function(SearchMovies) _then) =
      _$SearchMoviesCopyWithImpl;
  @useResult
  $Res call({String query});
}

/// @nodoc
class _$SearchMoviesCopyWithImpl<$Res> implements $SearchMoviesCopyWith<$Res> {
  _$SearchMoviesCopyWithImpl(this._self, this._then);

  final SearchMovies _self;
  final $Res Function(SearchMovies) _then;

  /// Create a copy of MoviesEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? query = null,
  }) {
    return _then(SearchMovies(
      null == query
          ? _self.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
