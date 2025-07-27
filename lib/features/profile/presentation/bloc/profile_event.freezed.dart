// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfileEvent {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ProfileEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ProfileEvent()';
  }
}

/// @nodoc
class $ProfileEventCopyWith<$Res> {
  $ProfileEventCopyWith(ProfileEvent _, $Res Function(ProfileEvent) __);
}

/// Adds pattern-matching-related methods to [ProfileEvent].
extension ProfileEventPatterns on ProfileEvent {
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
    TResult Function(LoadFavoriteMovies value)? loadFavoriteMovies,
    TResult Function(RemoveFavorite value)? removeFavorite,
    TResult Function(RefreshFavoriteMovies value)? refreshFavoriteMovies,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case LoadFavoriteMovies() when loadFavoriteMovies != null:
        return loadFavoriteMovies(_that);
      case RemoveFavorite() when removeFavorite != null:
        return removeFavorite(_that);
      case RefreshFavoriteMovies() when refreshFavoriteMovies != null:
        return refreshFavoriteMovies(_that);
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
    required TResult Function(LoadFavoriteMovies value) loadFavoriteMovies,
    required TResult Function(RemoveFavorite value) removeFavorite,
    required TResult Function(RefreshFavoriteMovies value)
        refreshFavoriteMovies,
  }) {
    final _that = this;
    switch (_that) {
      case LoadFavoriteMovies():
        return loadFavoriteMovies(_that);
      case RemoveFavorite():
        return removeFavorite(_that);
      case RefreshFavoriteMovies():
        return refreshFavoriteMovies(_that);
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
    TResult? Function(LoadFavoriteMovies value)? loadFavoriteMovies,
    TResult? Function(RemoveFavorite value)? removeFavorite,
    TResult? Function(RefreshFavoriteMovies value)? refreshFavoriteMovies,
  }) {
    final _that = this;
    switch (_that) {
      case LoadFavoriteMovies() when loadFavoriteMovies != null:
        return loadFavoriteMovies(_that);
      case RemoveFavorite() when removeFavorite != null:
        return removeFavorite(_that);
      case RefreshFavoriteMovies() when refreshFavoriteMovies != null:
        return refreshFavoriteMovies(_that);
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
    TResult Function()? loadFavoriteMovies,
    TResult Function(String movieId)? removeFavorite,
    TResult Function()? refreshFavoriteMovies,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case LoadFavoriteMovies() when loadFavoriteMovies != null:
        return loadFavoriteMovies();
      case RemoveFavorite() when removeFavorite != null:
        return removeFavorite(_that.movieId);
      case RefreshFavoriteMovies() when refreshFavoriteMovies != null:
        return refreshFavoriteMovies();
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
    required TResult Function() loadFavoriteMovies,
    required TResult Function(String movieId) removeFavorite,
    required TResult Function() refreshFavoriteMovies,
  }) {
    final _that = this;
    switch (_that) {
      case LoadFavoriteMovies():
        return loadFavoriteMovies();
      case RemoveFavorite():
        return removeFavorite(_that.movieId);
      case RefreshFavoriteMovies():
        return refreshFavoriteMovies();
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
    TResult? Function()? loadFavoriteMovies,
    TResult? Function(String movieId)? removeFavorite,
    TResult? Function()? refreshFavoriteMovies,
  }) {
    final _that = this;
    switch (_that) {
      case LoadFavoriteMovies() when loadFavoriteMovies != null:
        return loadFavoriteMovies();
      case RemoveFavorite() when removeFavorite != null:
        return removeFavorite(_that.movieId);
      case RefreshFavoriteMovies() when refreshFavoriteMovies != null:
        return refreshFavoriteMovies();
      case _:
        return null;
    }
  }
}

/// @nodoc

class LoadFavoriteMovies implements ProfileEvent {
  const LoadFavoriteMovies();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is LoadFavoriteMovies);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ProfileEvent.loadFavoriteMovies()';
  }
}

/// @nodoc

class RemoveFavorite implements ProfileEvent {
  const RemoveFavorite(this.movieId);

  final String movieId;

  /// Create a copy of ProfileEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RemoveFavoriteCopyWith<RemoveFavorite> get copyWith =>
      _$RemoveFavoriteCopyWithImpl<RemoveFavorite>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RemoveFavorite &&
            (identical(other.movieId, movieId) || other.movieId == movieId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, movieId);

  @override
  String toString() {
    return 'ProfileEvent.removeFavorite(movieId: $movieId)';
  }
}

/// @nodoc
abstract mixin class $RemoveFavoriteCopyWith<$Res>
    implements $ProfileEventCopyWith<$Res> {
  factory $RemoveFavoriteCopyWith(
          RemoveFavorite value, $Res Function(RemoveFavorite) _then) =
      _$RemoveFavoriteCopyWithImpl;
  @useResult
  $Res call({String movieId});
}

/// @nodoc
class _$RemoveFavoriteCopyWithImpl<$Res>
    implements $RemoveFavoriteCopyWith<$Res> {
  _$RemoveFavoriteCopyWithImpl(this._self, this._then);

  final RemoveFavorite _self;
  final $Res Function(RemoveFavorite) _then;

  /// Create a copy of ProfileEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? movieId = null,
  }) {
    return _then(RemoveFavorite(
      null == movieId
          ? _self.movieId
          : movieId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class RefreshFavoriteMovies implements ProfileEvent {
  const RefreshFavoriteMovies();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is RefreshFavoriteMovies);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ProfileEvent.refreshFavoriteMovies()';
  }
}

// dart format on
