import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/logger.dart';
import '../../domain/entities/movie.dart';

part 'movie_model.freezed.dart';
part 'movie_model.g.dart';

@freezed
abstract class MovieModel with _$MovieModel {
  const factory MovieModel({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'Title') required String title,
    @JsonKey(name: 'Year') required String year,
    @JsonKey(name: 'Rated') required String rated,
    @JsonKey(name: 'Released') required String released,
    @JsonKey(name: 'Runtime') required String runtime,
    @JsonKey(name: 'Genre') required String genre,
    @JsonKey(name: 'Director') required String director,
    @JsonKey(name: 'Writer') required String writer,
    @JsonKey(name: 'Actors') required String actors,
    @JsonKey(name: 'Plot') required String plot,
    @JsonKey(name: 'Language') required String language,
    @JsonKey(name: 'Country') required String country,
    @JsonKey(name: 'Awards') required String awards,
    @JsonKey(name: 'Poster') required String poster,
    @JsonKey(name: 'Metascore') required String metascore,
    @JsonKey(name: 'imdbRating') required String imdbRating,
    @JsonKey(name: 'imdbVotes') required String imdbVotes,
    @JsonKey(name: 'imdbID') required String imdbId,
    @JsonKey(name: 'Type') required String type,
    @JsonKey(name: 'Response') required String response,
    @JsonKey(name: 'Images') @Default([]) List<String> images,
    @JsonKey(name: 'ComingSoon') @Default(false) bool comingSoon,
    @JsonKey(name: 'isFavorite') @Default(false) bool isFavorite,
  }) = _MovieModel;

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);
}

extension MovieModelX on MovieModel {
  Movie toEntity() {
    // Released alanından yıl kısmını çıkar (örn: "18 Dec 2009" -> "2009")
    String extractYear(String released) {
      final parts = released.split(' ');
      if (parts.isNotEmpty) {
        final lastPart = parts.last;
        if (lastPart.length == 4 && int.tryParse(lastPart) != null) {
          return lastPart;
        }
      }
      return released; // Eğer yıl çıkarılamazsa orijinal değeri döndür
    }

    // Poster URL'sini temizle
    String cleanPosterUrl(String posterUrl) {
      if (posterUrl.isEmpty) return '';
      // HTTP'yi HTTPS'e çevir (mobil güvenlik için)
      if (posterUrl.startsWith('http://')) {
        posterUrl = posterUrl.replaceFirst('http://', 'https://');
      }
      // Eğer URL geçerli değilse boş string döndür
      if (!posterUrl.startsWith('https://')) {
        return '';
      }
      return posterUrl;
    }

    return Movie(
      id: id.isNotEmpty ? id : imdbId,
      title: title.isNotEmpty ? title : 'Bilinmiyor',
      overview: plot.isNotEmpty ? plot : 'Açıklama yok',
      posterPath: cleanPosterUrl(poster),
      backdropPath: images.isNotEmpty ? images.first : null,
      voteAverage: double.tryParse(imdbRating) ?? 0.0,
      voteCount: int.tryParse(imdbVotes.replaceAll(',', '')) ?? 0,
      releaseDate: released.isNotEmpty ? released : year,
      genreIds: genre.isNotEmpty ? genre.split(', ').map((g) => g.hashCode).toList() : [],
      adult: rated == 'R',
      originalLanguage: language.isNotEmpty ? language.split(',').first : 'en',
      originalTitle: title.isNotEmpty ? title : 'Bilinmiyor',
      popularity: double.tryParse(metascore) ?? 0.0,
      video: false,
      isFavorite: isFavorite,
    );
  }
}

extension MovieX on Movie {
  MovieModel toModel() {
    return MovieModel(
      id: id,
      title: title,
      year: releaseDate.split(' ').last,
      rated: adult ? 'R' : 'PG-13',
      released: releaseDate,
      runtime: '120 min',
      genre: 'Action, Adventure',
      director: 'Unknown',
      writer: 'Unknown',
      actors: 'Unknown',
      plot: overview,
      language: originalLanguage,
      country: 'USA',
      awards: 'N/A',
      poster: posterPath ?? '',
      metascore: popularity.toString(),
      imdbRating: voteAverage.toString(),
      imdbVotes: voteCount.toString(),
      imdbId: 'tt0000000',
      type: 'movie',
      response: 'True',
      images: backdropPath != null ? [backdropPath!] : [],
      comingSoon: false,
      isFavorite: isFavorite,
    );
  }
} 