class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int voteCount;
  final String releaseDate;
  final List<int> genreIds;
  final bool adult;
  final String originalLanguage;
  final String originalTitle;
  final double popularity;
  final bool video;
  final bool isFavorite;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    required this.releaseDate,
    required this.genreIds,
    required this.adult,
    required this.originalLanguage,
    required this.originalTitle,
    required this.popularity,
    required this.video,
    this.isFavorite = false,
  });

  Movie copyWith({
    int? id,
    String? title,
    String? overview,
    String? posterPath,
    String? backdropPath,
    double? voteAverage,
    int? voteCount,
    String? releaseDate,
    List<int>? genreIds,
    bool? adult,
    String? originalLanguage,
    String? originalTitle,
    double? popularity,
    bool? video,
    bool? isFavorite,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      releaseDate: releaseDate ?? this.releaseDate,
      genreIds: genreIds ?? this.genreIds,
      adult: adult ?? this.adult,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      originalTitle: originalTitle ?? this.originalTitle,
      popularity: popularity ?? this.popularity,
      video: video ?? this.video,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  // Helper getter for full poster URL
  String get fullPosterUrl {
    if (posterPath == null || posterPath!.isEmpty) {
      return 'https://via.placeholder.com/500x750?text=No+Image';
    }
    
    // Eğer posterPath zaten tam URL ise (http ile başlıyorsa) direkt kullan
    if (posterPath!.startsWith('http')) {
      return posterPath!;
    }
    
    // Eğer sadece path ise TMDB base URL'si ekle
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }
} 