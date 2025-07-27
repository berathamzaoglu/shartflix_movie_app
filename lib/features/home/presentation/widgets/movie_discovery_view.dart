import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../bloc/movies_bloc.dart';
import '../bloc/movies_event.dart';
import '../bloc/movies_state.dart';
import 'movie_page_view.dart';
import 'loading_view.dart';
import 'empty_view.dart';
import 'error_view.dart';

class MovieDiscoveryView extends StatefulWidget {
  const MovieDiscoveryView({super.key});

  @override
  State<MovieDiscoveryView> createState() => _MovieDiscoveryViewState();
}

class _MovieDiscoveryViewState extends State<MovieDiscoveryView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    final newPage = _pageController.page?.round() ?? 0;
    if (newPage != _currentPage) {
      setState(() {
        _currentPage = newPage;
      });
      
      // Son sayfaya yaklaştığında daha fazla film yükle
      final moviesBloc = context.read<MoviesBloc>();
      final state = moviesBloc.state;
      state.when(
        initial: () {},
        loading: () {},
        loaded: (movies, hasReachedMax, currentPage) {
          if (!hasReachedMax && newPage >= movies.length - 3) {
            moviesBloc.add(const MoviesEvent.loadMoreMovies());
          }
        },
        error: (message) {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return BlocBuilder<MoviesBloc, MoviesState>(
      builder: (context, state) {
        Logger.debug('MovieDiscoveryView rebuild - State: ${state.runtimeType}');
        
        return state.when(
          initial: () => const LoadingView(),
          loading: () => const LoadingView(),
          loaded: (movies, hasReachedMax, currentPage) {
            Logger.debug('Loaded state with ${movies.length} movies');
            // Favori durumlarını kontrol et
            final favoriteCount = movies.where((m) => m.isFavorite).length;
            Logger.debug('Favorite movies count: $favoriteCount');
            
            if (movies.isEmpty) {
              return const EmptyView();
            }
            return MoviePageView(
              movies: movies,
              pageController: _pageController,
              hasReachedMax: hasReachedMax,
              onToggleFavorite: (movie) {
                Logger.info('Favori butonuna tıklandı: ${movie.title} (ID: ${movie.id})');
                Logger.info('Mevcut favorite durumu: ${movie.isFavorite}');
                context.read<MoviesBloc>().add(
                  MoviesEvent.toggleFavorite(movie),
                );
              },
              currentPage: _currentPage,
            );
          },
          error: (message) => ErrorView(message: message),
        );
      },
    );
  }
} 