// Home Feature - Barrel Export File

// Data Layer
export 'data/datasources/movies_remote_datasource.dart';
export 'data/models/movie_model.dart';
export 'data/models/movies_response_model.dart';
export 'data/models/pagination_model.dart';
export 'data/repositories/movies_repository_impl.dart';

// Domain Layer
export 'domain/entities/movie.dart';
export 'domain/entities/genre.dart';
export 'domain/repositories/movies_repository.dart';
export 'domain/usecases/get_popular_movies_usecase.dart';
export 'domain/usecases/toggle_favorite_usecase.dart';

// Presentation Layer
export 'presentation/bloc/movies_bloc.dart';
export 'presentation/bloc/movies_event.dart';
export 'presentation/bloc/movies_state.dart';
export 'presentation/pages/movie_discovery_page.dart';
export 'presentation/widgets/movie_discovery_view.dart';
export 'presentation/widgets/bottom_navigation_bar.dart'; 