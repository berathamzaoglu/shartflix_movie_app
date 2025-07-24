// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MovieModel {
  @JsonKey(name: '_id')
  String get id;
  @JsonKey(name: 'Title')
  String get title;
  @JsonKey(name: 'Year')
  String get year;
  @JsonKey(name: 'Rated')
  String get rated;
  @JsonKey(name: 'Released')
  String get released;
  @JsonKey(name: 'Runtime')
  String get runtime;
  @JsonKey(name: 'Genre')
  String get genre;
  @JsonKey(name: 'Director')
  String get director;
  @JsonKey(name: 'Writer')
  String get writer;
  @JsonKey(name: 'Actors')
  String get actors;
  @JsonKey(name: 'Plot')
  String get plot;
  @JsonKey(name: 'Language')
  String get language;
  @JsonKey(name: 'Country')
  String get country;
  @JsonKey(name: 'Awards')
  String get awards;
  @JsonKey(name: 'Poster')
  String get poster;
  @JsonKey(name: 'Metascore')
  String get metascore;
  @JsonKey(name: 'imdbRating')
  String get imdbRating;
  @JsonKey(name: 'imdbVotes')
  String get imdbVotes;
  @JsonKey(name: 'imdbID')
  String get imdbId;
  @JsonKey(name: 'Type')
  String get type;
  @JsonKey(name: 'Response')
  String get response;
  @JsonKey(name: 'Images')
  List<String> get images;
  @JsonKey(name: 'ComingSoon')
  bool get comingSoon;
  @JsonKey(name: 'isFavorite')
  bool get isFavorite;

  /// Create a copy of MovieModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MovieModelCopyWith<MovieModel> get copyWith =>
      _$MovieModelCopyWithImpl<MovieModel>(this as MovieModel, _$identity);

  /// Serializes this MovieModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MovieModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.rated, rated) || other.rated == rated) &&
            (identical(other.released, released) ||
                other.released == released) &&
            (identical(other.runtime, runtime) || other.runtime == runtime) &&
            (identical(other.genre, genre) || other.genre == genre) &&
            (identical(other.director, director) ||
                other.director == director) &&
            (identical(other.writer, writer) || other.writer == writer) &&
            (identical(other.actors, actors) || other.actors == actors) &&
            (identical(other.plot, plot) || other.plot == plot) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.awards, awards) || other.awards == awards) &&
            (identical(other.poster, poster) || other.poster == poster) &&
            (identical(other.metascore, metascore) ||
                other.metascore == metascore) &&
            (identical(other.imdbRating, imdbRating) ||
                other.imdbRating == imdbRating) &&
            (identical(other.imdbVotes, imdbVotes) ||
                other.imdbVotes == imdbVotes) &&
            (identical(other.imdbId, imdbId) || other.imdbId == imdbId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.response, response) ||
                other.response == response) &&
            const DeepCollectionEquality().equals(other.images, images) &&
            (identical(other.comingSoon, comingSoon) ||
                other.comingSoon == comingSoon) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        title,
        year,
        rated,
        released,
        runtime,
        genre,
        director,
        writer,
        actors,
        plot,
        language,
        country,
        awards,
        poster,
        metascore,
        imdbRating,
        imdbVotes,
        imdbId,
        type,
        response,
        const DeepCollectionEquality().hash(images),
        comingSoon,
        isFavorite
      ]);

  @override
  String toString() {
    return 'MovieModel(id: $id, title: $title, year: $year, rated: $rated, released: $released, runtime: $runtime, genre: $genre, director: $director, writer: $writer, actors: $actors, plot: $plot, language: $language, country: $country, awards: $awards, poster: $poster, metascore: $metascore, imdbRating: $imdbRating, imdbVotes: $imdbVotes, imdbId: $imdbId, type: $type, response: $response, images: $images, comingSoon: $comingSoon, isFavorite: $isFavorite)';
  }
}

/// @nodoc
abstract mixin class $MovieModelCopyWith<$Res> {
  factory $MovieModelCopyWith(
          MovieModel value, $Res Function(MovieModel) _then) =
      _$MovieModelCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      @JsonKey(name: 'Title') String title,
      @JsonKey(name: 'Year') String year,
      @JsonKey(name: 'Rated') String rated,
      @JsonKey(name: 'Released') String released,
      @JsonKey(name: 'Runtime') String runtime,
      @JsonKey(name: 'Genre') String genre,
      @JsonKey(name: 'Director') String director,
      @JsonKey(name: 'Writer') String writer,
      @JsonKey(name: 'Actors') String actors,
      @JsonKey(name: 'Plot') String plot,
      @JsonKey(name: 'Language') String language,
      @JsonKey(name: 'Country') String country,
      @JsonKey(name: 'Awards') String awards,
      @JsonKey(name: 'Poster') String poster,
      @JsonKey(name: 'Metascore') String metascore,
      @JsonKey(name: 'imdbRating') String imdbRating,
      @JsonKey(name: 'imdbVotes') String imdbVotes,
      @JsonKey(name: 'imdbID') String imdbId,
      @JsonKey(name: 'Type') String type,
      @JsonKey(name: 'Response') String response,
      @JsonKey(name: 'Images') List<String> images,
      @JsonKey(name: 'ComingSoon') bool comingSoon,
      @JsonKey(name: 'isFavorite') bool isFavorite});
}

/// @nodoc
class _$MovieModelCopyWithImpl<$Res> implements $MovieModelCopyWith<$Res> {
  _$MovieModelCopyWithImpl(this._self, this._then);

  final MovieModel _self;
  final $Res Function(MovieModel) _then;

  /// Create a copy of MovieModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? year = null,
    Object? rated = null,
    Object? released = null,
    Object? runtime = null,
    Object? genre = null,
    Object? director = null,
    Object? writer = null,
    Object? actors = null,
    Object? plot = null,
    Object? language = null,
    Object? country = null,
    Object? awards = null,
    Object? poster = null,
    Object? metascore = null,
    Object? imdbRating = null,
    Object? imdbVotes = null,
    Object? imdbId = null,
    Object? type = null,
    Object? response = null,
    Object? images = null,
    Object? comingSoon = null,
    Object? isFavorite = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _self.year
          : year // ignore: cast_nullable_to_non_nullable
              as String,
      rated: null == rated
          ? _self.rated
          : rated // ignore: cast_nullable_to_non_nullable
              as String,
      released: null == released
          ? _self.released
          : released // ignore: cast_nullable_to_non_nullable
              as String,
      runtime: null == runtime
          ? _self.runtime
          : runtime // ignore: cast_nullable_to_non_nullable
              as String,
      genre: null == genre
          ? _self.genre
          : genre // ignore: cast_nullable_to_non_nullable
              as String,
      director: null == director
          ? _self.director
          : director // ignore: cast_nullable_to_non_nullable
              as String,
      writer: null == writer
          ? _self.writer
          : writer // ignore: cast_nullable_to_non_nullable
              as String,
      actors: null == actors
          ? _self.actors
          : actors // ignore: cast_nullable_to_non_nullable
              as String,
      plot: null == plot
          ? _self.plot
          : plot // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _self.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _self.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      awards: null == awards
          ? _self.awards
          : awards // ignore: cast_nullable_to_non_nullable
              as String,
      poster: null == poster
          ? _self.poster
          : poster // ignore: cast_nullable_to_non_nullable
              as String,
      metascore: null == metascore
          ? _self.metascore
          : metascore // ignore: cast_nullable_to_non_nullable
              as String,
      imdbRating: null == imdbRating
          ? _self.imdbRating
          : imdbRating // ignore: cast_nullable_to_non_nullable
              as String,
      imdbVotes: null == imdbVotes
          ? _self.imdbVotes
          : imdbVotes // ignore: cast_nullable_to_non_nullable
              as String,
      imdbId: null == imdbId
          ? _self.imdbId
          : imdbId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      response: null == response
          ? _self.response
          : response // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _self.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      comingSoon: null == comingSoon
          ? _self.comingSoon
          : comingSoon // ignore: cast_nullable_to_non_nullable
              as bool,
      isFavorite: null == isFavorite
          ? _self.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [MovieModel].
extension MovieModelPatterns on MovieModel {
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
    TResult Function(_MovieModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MovieModel() when $default != null:
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
    TResult Function(_MovieModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MovieModel():
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
    TResult? Function(_MovieModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MovieModel() when $default != null:
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
            @JsonKey(name: '_id') String id,
            @JsonKey(name: 'Title') String title,
            @JsonKey(name: 'Year') String year,
            @JsonKey(name: 'Rated') String rated,
            @JsonKey(name: 'Released') String released,
            @JsonKey(name: 'Runtime') String runtime,
            @JsonKey(name: 'Genre') String genre,
            @JsonKey(name: 'Director') String director,
            @JsonKey(name: 'Writer') String writer,
            @JsonKey(name: 'Actors') String actors,
            @JsonKey(name: 'Plot') String plot,
            @JsonKey(name: 'Language') String language,
            @JsonKey(name: 'Country') String country,
            @JsonKey(name: 'Awards') String awards,
            @JsonKey(name: 'Poster') String poster,
            @JsonKey(name: 'Metascore') String metascore,
            @JsonKey(name: 'imdbRating') String imdbRating,
            @JsonKey(name: 'imdbVotes') String imdbVotes,
            @JsonKey(name: 'imdbID') String imdbId,
            @JsonKey(name: 'Type') String type,
            @JsonKey(name: 'Response') String response,
            @JsonKey(name: 'Images') List<String> images,
            @JsonKey(name: 'ComingSoon') bool comingSoon,
            @JsonKey(name: 'isFavorite') bool isFavorite)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MovieModel() when $default != null:
        return $default(
            _that.id,
            _that.title,
            _that.year,
            _that.rated,
            _that.released,
            _that.runtime,
            _that.genre,
            _that.director,
            _that.writer,
            _that.actors,
            _that.plot,
            _that.language,
            _that.country,
            _that.awards,
            _that.poster,
            _that.metascore,
            _that.imdbRating,
            _that.imdbVotes,
            _that.imdbId,
            _that.type,
            _that.response,
            _that.images,
            _that.comingSoon,
            _that.isFavorite);
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
            @JsonKey(name: '_id') String id,
            @JsonKey(name: 'Title') String title,
            @JsonKey(name: 'Year') String year,
            @JsonKey(name: 'Rated') String rated,
            @JsonKey(name: 'Released') String released,
            @JsonKey(name: 'Runtime') String runtime,
            @JsonKey(name: 'Genre') String genre,
            @JsonKey(name: 'Director') String director,
            @JsonKey(name: 'Writer') String writer,
            @JsonKey(name: 'Actors') String actors,
            @JsonKey(name: 'Plot') String plot,
            @JsonKey(name: 'Language') String language,
            @JsonKey(name: 'Country') String country,
            @JsonKey(name: 'Awards') String awards,
            @JsonKey(name: 'Poster') String poster,
            @JsonKey(name: 'Metascore') String metascore,
            @JsonKey(name: 'imdbRating') String imdbRating,
            @JsonKey(name: 'imdbVotes') String imdbVotes,
            @JsonKey(name: 'imdbID') String imdbId,
            @JsonKey(name: 'Type') String type,
            @JsonKey(name: 'Response') String response,
            @JsonKey(name: 'Images') List<String> images,
            @JsonKey(name: 'ComingSoon') bool comingSoon,
            @JsonKey(name: 'isFavorite') bool isFavorite)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MovieModel():
        return $default(
            _that.id,
            _that.title,
            _that.year,
            _that.rated,
            _that.released,
            _that.runtime,
            _that.genre,
            _that.director,
            _that.writer,
            _that.actors,
            _that.plot,
            _that.language,
            _that.country,
            _that.awards,
            _that.poster,
            _that.metascore,
            _that.imdbRating,
            _that.imdbVotes,
            _that.imdbId,
            _that.type,
            _that.response,
            _that.images,
            _that.comingSoon,
            _that.isFavorite);
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
            @JsonKey(name: '_id') String id,
            @JsonKey(name: 'Title') String title,
            @JsonKey(name: 'Year') String year,
            @JsonKey(name: 'Rated') String rated,
            @JsonKey(name: 'Released') String released,
            @JsonKey(name: 'Runtime') String runtime,
            @JsonKey(name: 'Genre') String genre,
            @JsonKey(name: 'Director') String director,
            @JsonKey(name: 'Writer') String writer,
            @JsonKey(name: 'Actors') String actors,
            @JsonKey(name: 'Plot') String plot,
            @JsonKey(name: 'Language') String language,
            @JsonKey(name: 'Country') String country,
            @JsonKey(name: 'Awards') String awards,
            @JsonKey(name: 'Poster') String poster,
            @JsonKey(name: 'Metascore') String metascore,
            @JsonKey(name: 'imdbRating') String imdbRating,
            @JsonKey(name: 'imdbVotes') String imdbVotes,
            @JsonKey(name: 'imdbID') String imdbId,
            @JsonKey(name: 'Type') String type,
            @JsonKey(name: 'Response') String response,
            @JsonKey(name: 'Images') List<String> images,
            @JsonKey(name: 'ComingSoon') bool comingSoon,
            @JsonKey(name: 'isFavorite') bool isFavorite)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MovieModel() when $default != null:
        return $default(
            _that.id,
            _that.title,
            _that.year,
            _that.rated,
            _that.released,
            _that.runtime,
            _that.genre,
            _that.director,
            _that.writer,
            _that.actors,
            _that.plot,
            _that.language,
            _that.country,
            _that.awards,
            _that.poster,
            _that.metascore,
            _that.imdbRating,
            _that.imdbVotes,
            _that.imdbId,
            _that.type,
            _that.response,
            _that.images,
            _that.comingSoon,
            _that.isFavorite);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MovieModel implements MovieModel {
  const _MovieModel(
      {@JsonKey(name: '_id') required this.id,
      @JsonKey(name: 'Title') required this.title,
      @JsonKey(name: 'Year') required this.year,
      @JsonKey(name: 'Rated') required this.rated,
      @JsonKey(name: 'Released') required this.released,
      @JsonKey(name: 'Runtime') required this.runtime,
      @JsonKey(name: 'Genre') required this.genre,
      @JsonKey(name: 'Director') required this.director,
      @JsonKey(name: 'Writer') required this.writer,
      @JsonKey(name: 'Actors') required this.actors,
      @JsonKey(name: 'Plot') required this.plot,
      @JsonKey(name: 'Language') required this.language,
      @JsonKey(name: 'Country') required this.country,
      @JsonKey(name: 'Awards') required this.awards,
      @JsonKey(name: 'Poster') required this.poster,
      @JsonKey(name: 'Metascore') required this.metascore,
      @JsonKey(name: 'imdbRating') required this.imdbRating,
      @JsonKey(name: 'imdbVotes') required this.imdbVotes,
      @JsonKey(name: 'imdbID') required this.imdbId,
      @JsonKey(name: 'Type') required this.type,
      @JsonKey(name: 'Response') required this.response,
      @JsonKey(name: 'Images') final List<String> images = const [],
      @JsonKey(name: 'ComingSoon') this.comingSoon = false,
      @JsonKey(name: 'isFavorite') this.isFavorite = false})
      : _images = images;
  factory _MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  @JsonKey(name: 'Title')
  final String title;
  @override
  @JsonKey(name: 'Year')
  final String year;
  @override
  @JsonKey(name: 'Rated')
  final String rated;
  @override
  @JsonKey(name: 'Released')
  final String released;
  @override
  @JsonKey(name: 'Runtime')
  final String runtime;
  @override
  @JsonKey(name: 'Genre')
  final String genre;
  @override
  @JsonKey(name: 'Director')
  final String director;
  @override
  @JsonKey(name: 'Writer')
  final String writer;
  @override
  @JsonKey(name: 'Actors')
  final String actors;
  @override
  @JsonKey(name: 'Plot')
  final String plot;
  @override
  @JsonKey(name: 'Language')
  final String language;
  @override
  @JsonKey(name: 'Country')
  final String country;
  @override
  @JsonKey(name: 'Awards')
  final String awards;
  @override
  @JsonKey(name: 'Poster')
  final String poster;
  @override
  @JsonKey(name: 'Metascore')
  final String metascore;
  @override
  @JsonKey(name: 'imdbRating')
  final String imdbRating;
  @override
  @JsonKey(name: 'imdbVotes')
  final String imdbVotes;
  @override
  @JsonKey(name: 'imdbID')
  final String imdbId;
  @override
  @JsonKey(name: 'Type')
  final String type;
  @override
  @JsonKey(name: 'Response')
  final String response;
  final List<String> _images;
  @override
  @JsonKey(name: 'Images')
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  @JsonKey(name: 'ComingSoon')
  final bool comingSoon;
  @override
  @JsonKey(name: 'isFavorite')
  final bool isFavorite;

  /// Create a copy of MovieModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MovieModelCopyWith<_MovieModel> get copyWith =>
      __$MovieModelCopyWithImpl<_MovieModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MovieModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MovieModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.rated, rated) || other.rated == rated) &&
            (identical(other.released, released) ||
                other.released == released) &&
            (identical(other.runtime, runtime) || other.runtime == runtime) &&
            (identical(other.genre, genre) || other.genre == genre) &&
            (identical(other.director, director) ||
                other.director == director) &&
            (identical(other.writer, writer) || other.writer == writer) &&
            (identical(other.actors, actors) || other.actors == actors) &&
            (identical(other.plot, plot) || other.plot == plot) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.awards, awards) || other.awards == awards) &&
            (identical(other.poster, poster) || other.poster == poster) &&
            (identical(other.metascore, metascore) ||
                other.metascore == metascore) &&
            (identical(other.imdbRating, imdbRating) ||
                other.imdbRating == imdbRating) &&
            (identical(other.imdbVotes, imdbVotes) ||
                other.imdbVotes == imdbVotes) &&
            (identical(other.imdbId, imdbId) || other.imdbId == imdbId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.response, response) ||
                other.response == response) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.comingSoon, comingSoon) ||
                other.comingSoon == comingSoon) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        title,
        year,
        rated,
        released,
        runtime,
        genre,
        director,
        writer,
        actors,
        plot,
        language,
        country,
        awards,
        poster,
        metascore,
        imdbRating,
        imdbVotes,
        imdbId,
        type,
        response,
        const DeepCollectionEquality().hash(_images),
        comingSoon,
        isFavorite
      ]);

  @override
  String toString() {
    return 'MovieModel(id: $id, title: $title, year: $year, rated: $rated, released: $released, runtime: $runtime, genre: $genre, director: $director, writer: $writer, actors: $actors, plot: $plot, language: $language, country: $country, awards: $awards, poster: $poster, metascore: $metascore, imdbRating: $imdbRating, imdbVotes: $imdbVotes, imdbId: $imdbId, type: $type, response: $response, images: $images, comingSoon: $comingSoon, isFavorite: $isFavorite)';
  }
}

/// @nodoc
abstract mixin class _$MovieModelCopyWith<$Res>
    implements $MovieModelCopyWith<$Res> {
  factory _$MovieModelCopyWith(
          _MovieModel value, $Res Function(_MovieModel) _then) =
      __$MovieModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      @JsonKey(name: 'Title') String title,
      @JsonKey(name: 'Year') String year,
      @JsonKey(name: 'Rated') String rated,
      @JsonKey(name: 'Released') String released,
      @JsonKey(name: 'Runtime') String runtime,
      @JsonKey(name: 'Genre') String genre,
      @JsonKey(name: 'Director') String director,
      @JsonKey(name: 'Writer') String writer,
      @JsonKey(name: 'Actors') String actors,
      @JsonKey(name: 'Plot') String plot,
      @JsonKey(name: 'Language') String language,
      @JsonKey(name: 'Country') String country,
      @JsonKey(name: 'Awards') String awards,
      @JsonKey(name: 'Poster') String poster,
      @JsonKey(name: 'Metascore') String metascore,
      @JsonKey(name: 'imdbRating') String imdbRating,
      @JsonKey(name: 'imdbVotes') String imdbVotes,
      @JsonKey(name: 'imdbID') String imdbId,
      @JsonKey(name: 'Type') String type,
      @JsonKey(name: 'Response') String response,
      @JsonKey(name: 'Images') List<String> images,
      @JsonKey(name: 'ComingSoon') bool comingSoon,
      @JsonKey(name: 'isFavorite') bool isFavorite});
}

/// @nodoc
class __$MovieModelCopyWithImpl<$Res> implements _$MovieModelCopyWith<$Res> {
  __$MovieModelCopyWithImpl(this._self, this._then);

  final _MovieModel _self;
  final $Res Function(_MovieModel) _then;

  /// Create a copy of MovieModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? year = null,
    Object? rated = null,
    Object? released = null,
    Object? runtime = null,
    Object? genre = null,
    Object? director = null,
    Object? writer = null,
    Object? actors = null,
    Object? plot = null,
    Object? language = null,
    Object? country = null,
    Object? awards = null,
    Object? poster = null,
    Object? metascore = null,
    Object? imdbRating = null,
    Object? imdbVotes = null,
    Object? imdbId = null,
    Object? type = null,
    Object? response = null,
    Object? images = null,
    Object? comingSoon = null,
    Object? isFavorite = null,
  }) {
    return _then(_MovieModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _self.year
          : year // ignore: cast_nullable_to_non_nullable
              as String,
      rated: null == rated
          ? _self.rated
          : rated // ignore: cast_nullable_to_non_nullable
              as String,
      released: null == released
          ? _self.released
          : released // ignore: cast_nullable_to_non_nullable
              as String,
      runtime: null == runtime
          ? _self.runtime
          : runtime // ignore: cast_nullable_to_non_nullable
              as String,
      genre: null == genre
          ? _self.genre
          : genre // ignore: cast_nullable_to_non_nullable
              as String,
      director: null == director
          ? _self.director
          : director // ignore: cast_nullable_to_non_nullable
              as String,
      writer: null == writer
          ? _self.writer
          : writer // ignore: cast_nullable_to_non_nullable
              as String,
      actors: null == actors
          ? _self.actors
          : actors // ignore: cast_nullable_to_non_nullable
              as String,
      plot: null == plot
          ? _self.plot
          : plot // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _self.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _self.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      awards: null == awards
          ? _self.awards
          : awards // ignore: cast_nullable_to_non_nullable
              as String,
      poster: null == poster
          ? _self.poster
          : poster // ignore: cast_nullable_to_non_nullable
              as String,
      metascore: null == metascore
          ? _self.metascore
          : metascore // ignore: cast_nullable_to_non_nullable
              as String,
      imdbRating: null == imdbRating
          ? _self.imdbRating
          : imdbRating // ignore: cast_nullable_to_non_nullable
              as String,
      imdbVotes: null == imdbVotes
          ? _self.imdbVotes
          : imdbVotes // ignore: cast_nullable_to_non_nullable
              as String,
      imdbId: null == imdbId
          ? _self.imdbId
          : imdbId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      response: null == response
          ? _self.response
          : response // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _self._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      comingSoon: null == comingSoon
          ? _self.comingSoon
          : comingSoon // ignore: cast_nullable_to_non_nullable
              as bool,
      isFavorite: null == isFavorite
          ? _self.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
