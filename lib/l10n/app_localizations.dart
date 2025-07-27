import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr')
  ];

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'ShartFlix'**
  String get app_title;

  /// No description provided for @auth_login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get auth_login;

  /// No description provided for @auth_register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get auth_register;

  /// No description provided for @auth_logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get auth_logout;

  /// No description provided for @auth_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get auth_email;

  /// No description provided for @auth_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get auth_password;

  /// No description provided for @auth_confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get auth_confirm_password;

  /// No description provided for @auth_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get auth_name;

  /// No description provided for @auth_remember_me.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get auth_remember_me;

  /// No description provided for @auth_forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get auth_forgot_password;

  /// No description provided for @auth_dont_have_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get auth_dont_have_account;

  /// No description provided for @auth_already_have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get auth_already_have_account;

  /// No description provided for @auth_sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get auth_sign_up;

  /// No description provided for @auth_sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get auth_sign_in;

  /// No description provided for @auth_login_failed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get auth_login_failed;

  /// No description provided for @auth_registration_failed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get auth_registration_failed;

  /// No description provided for @auth_logout_failed.
  ///
  /// In en, this message translates to:
  /// **'Logout failed'**
  String get auth_logout_failed;

  /// No description provided for @auth_upload_photo.
  ///
  /// In en, this message translates to:
  /// **'Upload Photo'**
  String get auth_upload_photo;

  /// No description provided for @auth_photo_uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading photo...'**
  String get auth_photo_uploading;

  /// No description provided for @auth_photo_upload_success.
  ///
  /// In en, this message translates to:
  /// **'Profile photo updated successfully!'**
  String get auth_photo_upload_success;

  /// No description provided for @auth_photo_upload_error.
  ///
  /// In en, this message translates to:
  /// **'Error uploading photo'**
  String get auth_photo_upload_error;

  /// No description provided for @auth_photo_pick_error.
  ///
  /// In en, this message translates to:
  /// **'Error picking photo'**
  String get auth_photo_pick_error;

  /// No description provided for @auth_select_photo.
  ///
  /// In en, this message translates to:
  /// **'Select Photo'**
  String get auth_select_photo;

  /// No description provided for @auth_take_photo.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get auth_take_photo;

  /// No description provided for @auth_choose_from_gallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get auth_choose_from_gallery;

  /// No description provided for @auth_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get auth_cancel;

  /// No description provided for @auth_how_change_photo.
  ///
  /// In en, this message translates to:
  /// **'How would you like to change your profile photo?'**
  String get auth_how_change_photo;

  /// No description provided for @home_popular_movies.
  ///
  /// In en, this message translates to:
  /// **'Popular Movies'**
  String get home_popular_movies;

  /// No description provided for @home_search_movies.
  ///
  /// In en, this message translates to:
  /// **'Search Movies'**
  String get home_search_movies;

  /// No description provided for @home_no_movies_found.
  ///
  /// In en, this message translates to:
  /// **'No movies found'**
  String get home_no_movies_found;

  /// No description provided for @home_load_more.
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get home_load_more;

  /// No description provided for @home_refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get home_refresh;

  /// No description provided for @home_favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get home_favorite;

  /// No description provided for @home_unfavorite.
  ///
  /// In en, this message translates to:
  /// **'Unfavorite'**
  String get home_unfavorite;

  /// No description provided for @home_movie_details.
  ///
  /// In en, this message translates to:
  /// **'Movie Details'**
  String get home_movie_details;

  /// No description provided for @home_release_date.
  ///
  /// In en, this message translates to:
  /// **'Release Date'**
  String get home_release_date;

  /// No description provided for @home_rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get home_rating;

  /// No description provided for @home_overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get home_overview;

  /// No description provided for @home_genres.
  ///
  /// In en, this message translates to:
  /// **'Genres'**
  String get home_genres;

  /// No description provided for @home_production_company.
  ///
  /// In en, this message translates to:
  /// **'Production Company'**
  String get home_production_company;

  /// No description provided for @profile_profile_details.
  ///
  /// In en, this message translates to:
  /// **'Profile Details'**
  String get profile_profile_details;

  /// No description provided for @profile_favorite_movies.
  ///
  /// In en, this message translates to:
  /// **'My Favorite Movies'**
  String get profile_favorite_movies;

  /// No description provided for @profile_no_favorite_movies.
  ///
  /// In en, this message translates to:
  /// **'No favorite movies yet'**
  String get profile_no_favorite_movies;

  /// No description provided for @profile_favorite_movies_hint.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart icon to like movies'**
  String get profile_favorite_movies_hint;

  /// No description provided for @profile_add_photo.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get profile_add_photo;

  /// No description provided for @profile_user_id.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get profile_user_id;

  /// No description provided for @profile_not_logged_in.
  ///
  /// In en, this message translates to:
  /// **'Not Logged In'**
  String get profile_not_logged_in;

  /// No description provided for @profile_please_login.
  ///
  /// In en, this message translates to:
  /// **'Please login'**
  String get profile_please_login;

  /// No description provided for @profile_login_button.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get profile_login_button;

  /// No description provided for @profile_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get profile_retry;

  /// No description provided for @profile_error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get profile_error;

  /// No description provided for @profile_id_copied.
  ///
  /// In en, this message translates to:
  /// **'User ID copied to clipboard'**
  String get profile_id_copied;

  /// No description provided for @movie_show_more.
  ///
  /// In en, this message translates to:
  /// **'Show More'**
  String get movie_show_more;

  /// No description provided for @movie_show_less.
  ///
  /// In en, this message translates to:
  /// **'Show Less'**
  String get movie_show_less;

  /// No description provided for @profile_logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profile_logout;

  /// No description provided for @profile_logout_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get profile_logout_confirmation;

  /// No description provided for @profile_logout_confirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, Logout'**
  String get profile_logout_confirm;

  /// No description provided for @profile_logout_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profile_logout_cancel;

  /// No description provided for @register_terms_read.
  ///
  /// In en, this message translates to:
  /// **'I have read and accept the '**
  String get register_terms_read;

  /// No description provided for @register_terms_accept.
  ///
  /// In en, this message translates to:
  /// **'user agreement'**
  String get register_terms_accept;

  /// No description provided for @register_terms_continue.
  ///
  /// In en, this message translates to:
  /// **'. Please read this agreement to continue.'**
  String get register_terms_continue;

  /// No description provided for @navigation_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navigation_home;

  /// No description provided for @limited_offer_title.
  ///
  /// In en, this message translates to:
  /// **'Limited Offer'**
  String get limited_offer_title;

  /// No description provided for @limited_offer_description.
  ///
  /// In en, this message translates to:
  /// **'Choose a token package to earn bonuses and unlock new episodes!'**
  String get limited_offer_description;

  /// No description provided for @limited_offer_bonuses_title.
  ///
  /// In en, this message translates to:
  /// **'Bonuses You\'ll Get'**
  String get limited_offer_bonuses_title;

  /// No description provided for @limited_offer_premium_account.
  ///
  /// In en, this message translates to:
  /// **'Premium\nAccount'**
  String get limited_offer_premium_account;

  /// No description provided for @limited_offer_more_matches.
  ///
  /// In en, this message translates to:
  /// **'More\nMatches'**
  String get limited_offer_more_matches;

  /// No description provided for @limited_offer_featured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get limited_offer_featured;

  /// No description provided for @limited_offer_more_likes.
  ///
  /// In en, this message translates to:
  /// **'More\nLikes'**
  String get limited_offer_more_likes;

  /// No description provided for @limited_offer_select_package.
  ///
  /// In en, this message translates to:
  /// **'Select a token package to unlock'**
  String get limited_offer_select_package;

  /// No description provided for @limited_offer_weekly.
  ///
  /// In en, this message translates to:
  /// **'per week'**
  String get limited_offer_weekly;

  /// No description provided for @limited_offer_view_all_tokens.
  ///
  /// In en, this message translates to:
  /// **'View All Tokens'**
  String get limited_offer_view_all_tokens;

  /// No description provided for @navigation_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navigation_profile;

  /// No description provided for @navigation_back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get navigation_back;

  /// No description provided for @navigation_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get navigation_next;

  /// No description provided for @navigation_previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get navigation_previous;

  /// No description provided for @limited_offer_limited_offer.
  ///
  /// In en, this message translates to:
  /// **'Limited Offer'**
  String get limited_offer_limited_offer;

  /// No description provided for @limited_offer_special_discount.
  ///
  /// In en, this message translates to:
  /// **'Special Discount'**
  String get limited_offer_special_discount;

  /// No description provided for @limited_offer_premium_features.
  ///
  /// In en, this message translates to:
  /// **'Premium Features'**
  String get limited_offer_premium_features;

  /// No description provided for @limited_offer_unlock_all.
  ///
  /// In en, this message translates to:
  /// **'Unlock All'**
  String get limited_offer_unlock_all;

  /// No description provided for @limited_offer_get_premium.
  ///
  /// In en, this message translates to:
  /// **'Get Premium'**
  String get limited_offer_get_premium;

  /// No description provided for @limited_offer_offer_expires.
  ///
  /// In en, this message translates to:
  /// **'Offer expires in'**
  String get limited_offer_offer_expires;

  /// No description provided for @limited_offer_days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get limited_offer_days;

  /// No description provided for @limited_offer_hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get limited_offer_hours;

  /// No description provided for @limited_offer_minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get limited_offer_minutes;

  /// No description provided for @limited_offer_seconds.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get limited_offer_seconds;

  /// No description provided for @errors_general_error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errors_general_error;

  /// No description provided for @errors_network_error.
  ///
  /// In en, this message translates to:
  /// **'Network error'**
  String get errors_network_error;

  /// No description provided for @errors_server_error.
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get errors_server_error;

  /// No description provided for @errors_unknown_error.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get errors_unknown_error;

  /// No description provided for @errors_try_again.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get errors_try_again;

  /// No description provided for @errors_page_not_found.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get errors_page_not_found;

  /// No description provided for @errors_go_home.
  ///
  /// In en, this message translates to:
  /// **'Go Home'**
  String get errors_go_home;

  /// No description provided for @loading_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading_loading;

  /// No description provided for @loading_please_wait.
  ///
  /// In en, this message translates to:
  /// **'Please wait'**
  String get loading_please_wait;

  /// No description provided for @common_yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get common_yes;

  /// No description provided for @common_no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get common_no;

  /// No description provided for @common_ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get common_ok;

  /// No description provided for @common_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get common_save;

  /// No description provided for @common_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get common_delete;

  /// No description provided for @common_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get common_edit;

  /// No description provided for @common_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get common_close;

  /// No description provided for @common_open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get common_open;

  /// No description provided for @common_search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get common_search;

  /// No description provided for @common_filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get common_filter;

  /// No description provided for @common_sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get common_sort;

  /// No description provided for @common_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get common_all;

  /// No description provided for @common_none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get common_none;

  /// No description provided for @common_unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get common_unknown;

  /// No description provided for @common_na.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get common_na;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
