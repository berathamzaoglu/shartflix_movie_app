import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shartflix_movie_app/features/home/domain/entities/movie.dart';
import 'package:shartflix_movie_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:shartflix_movie_app/features/profile/presentation/bloc/profile_state.dart';
import 'package:shartflix_movie_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:shartflix_movie_app/l10n/app_localizations.dart';
import 'package:shartflix_movie_app/core/services/analytics_helper.dart';
import 'package:shartflix_movie_app/core/services/crashlytics_helper.dart';
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
    // ProfileBloc'tan favori filmleri al - bir sonraki frame'de
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        try {
          final profileBloc = context.read<ProfileBloc>();
          if (!profileBloc.state.maybeWhen(
            loading: () => true,
            orElse: () => false,
          )) {
            profileBloc.add(const ProfileEvent.loadFavoriteMovies());
          }
        } catch (e) {
          // BLoC henüz hazır değilse veya kapatılmışsa hata verme
          debugPrint('ProfileBloc not ready: $e');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.whenOrNull(
          unauthenticated: () {
            // Logout başarılı olduğunda login sayfasına yönlendir
            context.go('/login');
          },
        );
      },
      child: Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF090909),
        elevation: 0,
        title: Text(
          l10n.profile_profile_details,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          // Limited Offer Button
          GestureDetector(
            onTap: () {
              showLimitedOfferBottomSheet(context);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
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
                  Text(
                    l10n.limited_offer_limited_offer,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Logout Button
          GestureDetector(
            onTap: () => _showLogoutDialog(context),
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withAlpha(128),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    l10n.profile_logout,
                    style: const TextStyle(
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
      body: SafeArea(
        child: Column(
          children: [
            // Profile Info
            _buildProfileInfo(),
            
            // Liked Movies Section
            Expanded(
              child: _buildLikedMoviesSection(),
            ),
          ],
        ),
      ),)
    );
  }

  Widget _buildProfileInfo() {
    final l10n = AppLocalizations.of(context)!;
    
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
                    
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    
                    
                     ConstrainedBox(constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.4), 
                     child:Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${l10n.profile_user_id}: ${user.id}',
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withAlpha(128),
                              ),
                            ),
                          ),
                          IconButton(onPressed: (){
                              Clipboard.setData(ClipboardData(text: user.id));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.profile_id_copied),
                                  backgroundColor:  Colors.green,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }, icon: const Icon(
                                Icons.copy,
                                color: Color(0xFF94A3B8),
                                size: 16,
                              ),),
                         
                        ],
                      ),)
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
                    child: Text(
                      l10n.profile_add_photo,
                      style: const TextStyle(
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
    final l10n = AppLocalizations.of(context)!;
    
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(l10n.auth_select_photo),
        message: Text(l10n.auth_how_change_photo),  
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _pickImage(context, ImageSource.camera);
            },
            child: Text(l10n.auth_take_photo),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _pickImage(context, ImageSource.gallery);
            },
            child: Text(l10n.auth_choose_from_gallery),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(l10n.auth_cancel),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          l10n.profile_logout_confirmation,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          l10n.profile_logout_confirmation,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 14,
          ),
        ),
        actions: [

            FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  l10n.profile_logout_cancel,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          
          
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _performLogout(context);
            },
          
            child: Text(
              l10n.profile_logout_confirm,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _performLogout(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    authBloc.add(const AuthEvent.logoutRequested());
    
    // Analytics: Logout event
    AnalyticsHelper.logCustomEvent(
      name: 'user_logout',
      parameters: {'source': 'profile_page'},
    );
    
    // Crashlytics: Log logout
    CrashlyticsHelper.log('User logged out from profile page');
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      debugPrint('🖼️ Starting image picker for source: $source');
      
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
        debugPrint('📸 Image selected: ${image.path}');
        
        // Show loading indicator
        if (context.mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.auth_photo_uploading),
              backgroundColor: const Color(0xFF8B5CF6),
            ),
          );
        }
        
        // Convert XFile to File
        final File imageFile = File(image.path);
        debugPrint('📁 File created: ${imageFile.path}');
        
        // Upload photo to server
        debugPrint('🚀 Starting upload...');
        final result = await authBloc.uploadProfilePhoto(imageFile);
        debugPrint('📤 Upload completed, result: $result');
        
        if (context.mounted) {
          result.fold(
            (failure) {
              debugPrint('❌ Upload failed: ${failure.message}');
              final l10n = AppLocalizations.of(context)!;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.auth_photo_upload_error),
                  backgroundColor: const Color(0xFFE53E3E),
                ),
              );
            },
            (success) {
              debugPrint('✅ Upload successful');
              final l10n = AppLocalizations.of(context)!;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.auth_photo_upload_success),
                  backgroundColor: const Color(0xFF10B981),
                ),
              );
            },
          );
        }
      } else {
        debugPrint('❌ No image selected');
      }
    } catch (e) {
      debugPrint('💥 Exception in _pickImage: $e');
      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.auth_photo_pick_error),
            backgroundColor: const Color(0xFFE53E3E),
          ),
        );
      }
    }
  }

  Widget _buildLikedMoviesSection() {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            l10n.profile_favorite_movies,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        
        // Movies Grid
        Expanded(
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return state.when(
                initial: () => const _LoadingView(),
                loading: () => const _LoadingView(),
                loaded: (movies) {
                  if (movies.isEmpty) {
                    return _buildEmptyState();
                  }
                  
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<ProfileBloc>().add(
                        const ProfileEvent.refreshFavoriteMovies(),
                      );
                    },
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 153/263,
                        crossAxisSpacing: 16,
                      ),
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        final movie = movies[index];
                        return _LikedMovieCard(movie: movie);
                      },
                    ),
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

  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 64,
            color: Colors.grey.shade600,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.profile_no_favorite_movies,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.profile_favorite_movies_hint,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _LikedMovieCard extends StatelessWidget {
  final Movie movie;

  const _LikedMovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
    
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movie Poster
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius:  BorderRadius.circular(12),
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
                        // Favori filmden çıkar
                        context.read<ProfileBloc>().add(
                          ProfileEvent.removeFavorite(movie.id),
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
                      fontFamily: 'EuclidCircular',
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
                        : l10n.common_na,
                    style:  TextStyle(
                      color: Colors.white.withAlpha(128),
                      fontSize: 12,
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
    final l10n = AppLocalizations.of(context)!;
    
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.profile_not_logged_in,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.profile_please_login,
                  style: const TextStyle(
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
            child: Text(
              l10n.profile_login_button,
              style: const TextStyle(
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
    final l10n = AppLocalizations.of(context)!;
    
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
                Text(
                  l10n.profile_error,
                  style: const TextStyle(
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
            child: Text(
              l10n.profile_retry,
              style: const TextStyle(
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