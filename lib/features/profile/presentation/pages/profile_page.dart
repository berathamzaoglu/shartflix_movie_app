import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/auth_feature.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/limited_offer_bottom_sheet.dart';
import '../widgets/profile_info_widget.dart';
import '../widgets/liked_movies_section.dart';
import '../widgets/logout_dialog.dart';

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
              onTap: () => LogoutDialog.show(context),
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
        body: const SafeArea(
          child: Column(
            children: [
              // Profile Info
              ProfileInfoWidget(),
              
              // Liked Movies Section
              Expanded(
                child: LikedMoviesSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 