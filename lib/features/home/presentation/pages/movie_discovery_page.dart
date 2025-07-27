import 'package:flutter/material.dart';
import '../widgets/movie_discovery_view.dart';

class MovieDiscoveryPage extends StatefulWidget {
  const MovieDiscoveryPage({super.key});

  @override
  State<MovieDiscoveryPage> createState() => _MovieDiscoveryPageState();
}

class _MovieDiscoveryPageState extends State<MovieDiscoveryPage> {
  @override
  void initState() {
    super.initState();
    // MoviesBloc artık global olarak sağlandığı için burada event göndermeye gerek yok
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MovieDiscoveryView(),
    );
  }
} 