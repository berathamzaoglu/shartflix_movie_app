import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shartflix_movie_app/features/home/domain/entities/movie.dart';
import 'package:shartflix_movie_app/features/home/presentation/bloc/movies_bloc.dart';
import 'package:shartflix_movie_app/features/home/presentation/bloc/movies_state.dart';
import 'package:shartflix_movie_app/features/home/presentation/bloc/movies_event.dart';
import 'dart:io';

import '../../../auth/auth_feature.dart';

import '../widgets/limited_offer_bottom_sheet.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // MoviesBloc'tan favori filmleri al
    context.read<MoviesBloc>().add(const MoviesEvent.loadPopularMovies());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            
            // Profile Info
            _buildProfileInfo(),
            
            // Liked Movies Section
            Expanded(
              child: _buildLikedMoviesSection(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Back Button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 20,
            ),
          ),
          
          const Spacer(),
          
          // Title
          const Text(
            'Profil Detayı',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const Spacer(),
          
          // Limited Offer Button
          GestureDetector(
            onTap: () {
              showLimitedOfferBottomSheet(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE53E3E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.diamond,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Sınırlı Teklif',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        return authState.when(
          initial: () => const _LoadingProfileView(),
          loading: () => const _LoadingProfileView(),
          authenticated: (user) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Profile Photo
                GestureDetector(
                  onTap: () => _showImagePickerDialog(context, user),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey.shade800,
                        backgroundImage: user.profilePhoto != null && user.profilePhoto!.isNotEmpty
                            ? NetworkImage(user.profilePhoto!)
                            : null,
                        child: user.profilePhoto == null || user.profilePhoto!.isEmpty
                            ? const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 30,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE53E3E),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${user.id}',
                        style: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Add Photo Button
                GestureDetector(
                  onTap: () => _showImagePickerDialog(context, user),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53E3E),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Fotoğraf Ekle',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          unauthenticated: () => const _UnauthenticatedView(),
          error: (message) => _ErrorProfileView(message: message),
        );
      },
    );
  }

  void _showImagePickerDialog(BuildContext context, User user) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Fotoğraf Seç'),
        message: const Text('Profil fotoğrafınızı nasıl değiştirmek istiyorsunuz?'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _pickImage(context, ImageSource.camera);
            },
            child: const Text('Kameradan Çek'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _pickImage(context, ImageSource.gallery);
            },
            child: const Text('Galeriden Seç'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('İptal'),
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      print('🖼️ Starting image picker for source: $source');
      
      // Get AuthBloc reference before async operations
      final authBloc = context.read<AuthBloc>();
      
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        print('📸 Image selected: ${image.path}');
        
        // Show loading indicator
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fotoğraf yükleniyor...'),
              backgroundColor: Color(0xFF8B5CF6),
            ),
          );
        }
        
        // Convert XFile to File
        final File imageFile = File(image.path);
        print('📁 File created: ${imageFile.path}');
        
        // Upload photo to server
        print('🚀 Starting upload...');
        final result = await authBloc.uploadProfilePhoto(imageFile);
        print('📤 Upload completed, result: $result');
        
        if (context.mounted) {
          result.fold(
            (failure) {
              print('❌ Upload failed: ${failure.message}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Fotoğraf yüklenirken hata oluştu: ${failure.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            (photoUrl) {
              print('✅ Upload successful: $photoUrl');
              // Update the user's profile photo
              authBloc.add(
                AuthEvent.updateProfilePhoto(photoUrl: photoUrl),
              );
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profil fotoğrafı başarıyla güncellendi!'),
                  backgroundColor: Color(0xFFE53E3E),
                ),
              );
            },
          );
        }
      } else {
        print('❌ No image selected');
      }
    } catch (e) {
      print('💥 Exception in _pickImage: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fotoğraf seçilirken hata oluştu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildLikedMoviesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Beğendiğim Filmler',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        
        // Movies Grid
        Expanded(
          child: BlocBuilder<MoviesBloc, MoviesState>(
            builder: (context, state) {
              return state.when(
                initial: () => const _LoadingView(),
                loading: () => const _LoadingView(),
                loaded: (movies, hasReachedMax, currentPage) {
                  // Filter liked movies
                  final likedMoviesList = movies.where((movie) => movie.isFavorite).toList();
                  
                  if (likedMoviesList.isEmpty) {
                    return const _EmptyLikedMoviesView();
                  }
                  
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: likedMoviesList.length,
                    itemBuilder: (context, index) {
                      final movie = likedMoviesList[index];
                      return _LikedMovieCard(movie: movie);
                    },
                  );
                },
                error: (message) => _ErrorView(message: message),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _LikedMovieCard extends StatelessWidget {
  final Movie movie;

  const _LikedMovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF1E293B),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movie Poster
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: movie.fullPosterUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: const Color(0xFF374151),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFE53E3E),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: const Color(0xFF374151),
                        child: const Center(
                          child: Icon(
                            Icons.movie,
                            color: Color(0xFF64748B),
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Favorite Icon with Toggle
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        // Toggle favorite
                        context.read<MoviesBloc>().add(
                          MoviesEvent.toggleFavorite(movie),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: const Color(0xFFE53E3E),
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Movie Info
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    movie.releaseDate.isNotEmpty 
                        ? movie.releaseDate.split('-').first 
                        : 'N/A',
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFFE53E3E),
      ),
    );
  }
}

class _EmptyLikedMoviesView extends StatelessWidget {
  const _EmptyLikedMoviesView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.favorite_border,
            color: Color(0xFF64748B),
            size: 64,
          ),
          const SizedBox(height: 16),
          const Text(
            'Henüz beğendiğiniz film yok',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Filmleri beğenmek için kalp ikonuna tıklayın',
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Color(0xFFE53E3E),
            size: 64,
          ),
          const SizedBox(height: 16),
          const Text(
            'Bir hata oluştu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
} 

class _LoadingProfileView extends StatelessWidget {
  const _LoadingProfileView();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Loading Profile Picture
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey.shade800,
            child: const CircularProgressIndicator(
              color: Color(0xFFE53E3E),
              strokeWidth: 2,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Loading User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 18,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 14,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          
          // Loading Button
          Container(
            height: 32,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ],
      ),
    );
  }
}

class _UnauthenticatedView extends StatelessWidget {
  const _UnauthenticatedView();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Default Profile Picture
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey.shade800,
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 30,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // User Info
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Giriş Yapılmadı',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Lütfen giriş yapın',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Login Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE53E3E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'Giriş Yap',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorProfileView extends StatelessWidget {
  final String message;

  const _ErrorProfileView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Error Profile Picture
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey.shade800,
            child: const Icon(
              Icons.error,
              color: Color(0xFFE53E3E),
              size: 30,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Error Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hata',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Retry Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE53E3E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'Tekrar Dene',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 