import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/movies_bloc.dart';
import '../bloc/movies_event.dart';
import '../widgets/movie_discovery_view.dart';

class MovieDiscoveryPage extends StatefulWidget {
  const MovieDiscoveryPage({super.key});

  @override
  State<MovieDiscoveryPage> createState() => _MovieDiscoveryPageState();
}

class _MovieDiscoveryPageState extends State<MovieDiscoveryPage> {
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    // Sadece ilk yüklemede event ekle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasInitialized) {
        _hasInitialized = true;
        context.read<MoviesBloc>().add(const MoviesEvent.loadPopularMovies());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF090909),
      body: MovieDiscoveryView(),
    );
  }
} 