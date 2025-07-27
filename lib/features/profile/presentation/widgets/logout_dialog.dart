import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/auth_feature.dart';
import '../../../../core/services/analytics_helper.dart';
import '../../../../core/services/crashlytics_helper.dart';

class LogoutDialog {
  static void show(BuildContext context) {
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

  static void _performLogout(BuildContext context) {
    try {
      final authBloc = context.read<AuthBloc>();
      
      // Logout event'ini AuthBloc'a ekle
      authBloc.add(const AuthEvent.logoutRequested());
      debugPrint('Logout event added to AuthBloc');
      
      // Analytics: Logout event
      AnalyticsHelper.logCustomEvent(
        name: 'user_logout',
        parameters: {'source': 'profile_page'},
      );
      
      // Crashlytics: Log logout
      CrashlyticsHelper.log('User logged out from profile page');
    } catch (e) {
      debugPrint('Error during logout: $e');
      // Hata durumunda doğrudan login sayfasına yönlendir
      if (context.mounted) {
        context.go('/login');
      }
    }
  }
} 