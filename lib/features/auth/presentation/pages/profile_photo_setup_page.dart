import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shartflix_movie_app/l10n/app_localizations.dart';
import 'dart:io';

import '../../../../core/injection_container.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

class ProfilePhotoSetupPage extends StatefulWidget {
  const ProfilePhotoSetupPage({super.key});

  @override
  State<ProfilePhotoSetupPage> createState() => _ProfilePhotoSetupPageState();
}

class _ProfilePhotoSetupPageState extends State<ProfilePhotoSetupPage> {
  File? _selectedImage;
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          state.whenOrNull(
            authenticated: (user) {
              // Profil fotoğrafı yüklendikten sonra ana sayfaya yönlendir
              context.go('/home');
            },
            error: (message) {
              _showErrorMessage(context, message);
            },
          );
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            _isUploading = state.maybeWhen(
              loading: () => true,
              orElse: () => false,
            );

            return Scaffold(
              backgroundColor: const Color(0xFF090909),
              appBar: AppBar(
                backgroundColor: const Color(0xFF090909),
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.go('/home'),
                ),
                title: Text(
                  l10n.profile_profile_details,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                centerTitle: true,
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      
                      // Title
                      Text(
                        l10n.auth_upload_photo,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Text(
                        'Resources out incentivize relaxation floor loss cc.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withAlpha(128),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 48),
                      
                      // Photo Upload Area
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [   
                    GestureDetector(
                            onTap: _isUploading ? null : _showImagePickerDialog,
                            child: Container(
                              width: 168,
                              height: 164,
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(25),
                                borderRadius: BorderRadius.circular(31),
                                border: Border.all(
                                  color: Colors.white.withAlpha(25),
                                  width: 1.55,
                                ),
                              ),
                              child: _selectedImage != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Image.file(
                                        _selectedImage!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  :  Icon(
                                      Icons.add,
                                      color: Colors.white.withAlpha(128),
                                      size: 26,
                                    ),
                            ),
                          ),
                   ],),     
                      
                    const Spacer(),
                      
                      // Continue Button
                      FilledButton(
                        onPressed: (_selectedImage != null && !_isUploading) 
                            ? _handleContinue 
                            : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFE53E3E),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isUploading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                l10n.navigation_next,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showImagePickerDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Fotoğraf Seç',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImagePickerOption(
                  icon: Icons.camera_alt,
                  title: 'Kamera',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                _buildImagePickerOption(
                  icon: Icons.photo_library,
                  title: 'Galeri',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFE53E3E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image != null && mounted) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        _showErrorMessage(context, 'Fotoğraf seçilirken hata oluştu: $e');
      }
    }
  }

  void _handleContinue() async {
    if (_selectedImage == null) return;

    try {
      final authBloc = context.read<AuthBloc>();
      final result = await authBloc.uploadProfilePhoto(_selectedImage!);
      
      if (mounted) {
        result.fold(
          (failure) {
            _showErrorMessage(context, 'Fotoğraf yüklenirken hata oluştu: ${failure.message}');
          },
          (photoUrl) {
            // Başarılı olduğunda BlocListener otomatik olarak ana sayfaya yönlendirecek
          },
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorMessage(context, 'Fotoğraf yüklenirken hata oluştu: $e');
      }
    }
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
} 