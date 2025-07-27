import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/auth_feature.dart';
import 'loading_profile_view.dart';
import 'unauthenticated_view.dart';
import 'error_profile_view.dart';

class ProfileInfoWidget extends StatelessWidget {
  const ProfileInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        return authState.when(
          initial: () => const LoadingProfileView(),
          loading: () => const LoadingProfileView(),
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
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.4), 
                        child: Row(
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
                            IconButton(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: user.id));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.profile_id_copied),
                                    backgroundColor: Colors.green,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }, 
                              icon: const Icon(
                                Icons.copy,
                                color: Color(0xFF94A3B8),
                                size: 16,
                              ),
                            ),
                          ],
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
          unauthenticated: () => const UnauthenticatedView(),
          error: (message) => ErrorProfileView(message: message),
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
} 