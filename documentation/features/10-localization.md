# Localization Service

## Overview

The ShartFlix application implements a comprehensive localization system supporting Turkish and English languages with dynamic language switching, RTL support consideration, and context-aware translations. The system is built using Flutter's internationalization framework with custom extensions for enhanced functionality.

## Core Architecture

### Localization Setup
```dart
// app_localizations.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('tr', 'TR'), // Turkish
    Locale('en', 'US'), // English
  ];

  // Static method to get translations
  static Map<String, Map<String, String>> get _localizedValues => {
    'en': _enTranslations,
    'tr': _trTranslations,
  };

  String translate(String key, {List<String>? args}) {
    final translations = _localizedValues[locale.languageCode] ?? _localizedValues['en']!;
    String translation = translations[key] ?? key;
    
    // Handle pluralization if needed
    if (args != null) {
      for (int i = 0; i < args.length; i++) {
        translation = translation.replaceAll('{$i}', args[i]);
      }
    }
    
    return translation;
  }

  // Quick access getters for common translations
  String get appName => translate('app_name');
  String get welcome => translate('welcome');
  String get login => translate('login');
  String get register => translate('register');
  String get email => translate('email');
  String get password => translate('password');
  String get confirmPassword => translate('confirm_password');
  String get forgotPassword => translate('forgot_password');
  String get rememberMe => translate('remember_me');
  String get loginButton => translate('login_button');
  String get registerButton => translate('register_button');
  String get home => translate('home');
  String get profile => translate('profile');
  String get settings => translate('settings');
  String get logout => translate('logout');
  String get favoriteMovies => translate('favorite_movies');
  String get addPhoto => translate('add_photo');
  String get limitedOffer => translate('limited_offer');
  String get viewAllTokens => translate('view_all_tokens');
  String get bonuses => translate('bonuses');
  String get premiumAccount => translate('premium_account');
  String get moreMatches => translate('more_matches');
  String get highlight => translate('highlight');
  String get moreLikes => translate('more_likes');
  String get tokens => translate('tokens');
  String get perWeek => translate('per_week');
  String get loading => translate('loading');
  String get error => translate('error');
  String get retry => translate('retry');
  String get cancel => translate('cancel');
  String get save => translate('save');
  String get delete => translate('delete');
  String get edit => translate('edit');
  String get search => translate('search');
  String get filter => translate('filter');
  String get sortBy => translate('sort_by');
  String get genres => translate('genres');
  String get year => translate('year');
  String get rating => translate('rating');
  String get duration => translate('duration');
  String get director => translate('director');
  String get cast => translate('cast');
  String get synopsis => translate('synopsis');
  String get watchTrailer => translate('watch_trailer');
  String get addToFavorites => translate('add_to_favorites');
  String get removeFromFavorites => translate('remove_from_favorites');
  String get share => translate('share');
  String get reviews => translate('reviews');
  String get writeReview => translate('write_review');
  String get noInternetConnection => translate('no_internet_connection');
  String get connectionTimeout => translate('connection_timeout');
  String get serverError => translate('server_error');
  String get sessionExpired => translate('session_expired');
  String get accessForbidden => translate('access_forbidden');
  String get notFound => translate('not_found');
  String get tooManyRequests => translate('too_many_requests');
  String get unknownError => translate('unknown_error');
  String get validationErrors => translate('validation_errors');
  String get emailRequired => translate('email_required');
  String get emailInvalid => translate('email_invalid');
  String get passwordRequired => translate('password_required');
  String get passwordTooShort => translate('password_too_short');
  String get passwordsDoNotMatch => translate('passwords_do_not_match');
  String get loginSuccessful => translate('login_successful');
  String get loginFailed => translate('login_failed');
  String get registrationSuccessful => translate('registration_successful');
  String get registrationFailed => translate('registration_failed');
  String get profileUpdated => translate('profile_updated');
  String get photoUploaded => translate('photo_uploaded');
  String get photoUploadFailed => translate('photo_upload_failed');
  String get favoriteAdded => translate('favorite_added');
  String get favoriteRemoved => translate('favorite_removed');
  String get purchaseSuccessful => translate('purchase_successful');
  String get purchaseFailed => translate('purchase_failed');
  String get languageSettings => translate('language_settings');
  String get turkish => translate('turkish');
  String get english => translate('english');
  String get darkMode => translate('dark_mode');
  String get lightMode => translate('light_mode');
  String get systemTheme => translate('system_theme');
  String get notifications => translate('notifications');
  String get privacy => translate('privacy');
  String get termsOfService => translate('terms_of_service');
  String get aboutApp => translate('about_app');
  String get version => translate('version');
  String get contactSupport => translate('contact_support');
  String get rateApp => translate('rate_app');
  String get shareApp => translate('share_app');

  // Methods with parameters
  String welcomeUser(String name) => translate('welcome_user', args: [name]);
  String movieCount(int count) => translate('movie_count', args: [count.toString()]);
  String timeAgo(String time) => translate('time_ago', args: [time]);
  String pricePerWeek(String price) => translate('price_per_week', args: [price]);
  String tokensAmount(int amount) => translate('tokens_amount', args: [amount.toString()]);
  String discountPercentage(int percentage) => translate('discount_percentage', args: [percentage.toString()]);
  String moviesFound(int count) => translate('movies_found', args: [count.toString()]);
  String pageOfTotal(int current, int total) => translate('page_of_total', args: [current.toString(), total.toString()]);

  // Date and time formatting
  String formatDate(DateTime date) {
    final formatter = DateFormat.yMMMd(locale.languageCode);
    return formatter.format(date);
  }

  String formatTime(DateTime time) {
    final formatter = DateFormat.Hm(locale.languageCode);
    return formatter.format(time);
  }

  String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat.yMMMd(locale.languageCode).add_Hm();
    return formatter.format(dateTime);
  }

  String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return formatDate(dateTime);
    } else if (difference.inDays > 0) {
      return translate('days_ago', args: [difference.inDays.toString()]);
    } else if (difference.inHours > 0) {
      return translate('hours_ago', args: [difference.inHours.toString()]);
    } else if (difference.inMinutes > 0) {
      return translate('minutes_ago', args: [difference.inMinutes.toString()]);
    } else {
      return translate('just_now');
    }
  }

  // Number formatting
  String formatNumber(num number) {
    final formatter = NumberFormat.compact(locale: locale.languageCode);
    return formatter.format(number);
  }

  String formatCurrency(num amount, {String? currency}) {
    final formatter = NumberFormat.currency(
      locale: locale.languageCode,
      symbol: currency ?? (locale.languageCode == 'tr' ? '₺' : '\$'),
    );
    return formatter.format(amount);
  }

  String formatPercentage(num percentage) {
    final formatter = NumberFormat.percentPattern(locale.languageCode);
    return formatter.format(percentage / 100);
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales
        .any((supportedLocale) => supportedLocale.languageCode == locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
```

### Translation Files

#### English Translations
```dart
// translations/en_translations.dart
const Map<String, String> _enTranslations = {
  // App basics
  'app_name': 'ShartFlix',
  'welcome': 'Welcome',
  'welcome_user': 'Welcome, {0}!',
  
  // Authentication
  'login': 'Login',
  'register': 'Register',
  'email': 'Email',
  'password': 'Password',
  'confirm_password': 'Confirm Password',
  'forgot_password': 'Forgot Password?',
  'remember_me': 'Remember me',
  'login_button': 'Sign In Now',
  'register_button': 'Sign Up Now',
  'already_have_account': 'Already have an account? Sign In!',
  'no_account': 'Don\'t have an account? Sign Up!',
  
  // Navigation
  'home': 'Home',
  'profile': 'Profile',
  'settings': 'Settings',
  'logout': 'Logout',
  
  // Profile
  'profile_details': 'Profile Details',
  'favorite_movies': 'Favorite Movies',
  'add_photo': 'Add Photo',
  'edit_profile': 'Edit Profile',
  'user_id': 'ID: {0}',
  
  // Limited Offer
  'limited_offer': 'Limited Offer',
  'limited_offer_subtitle': 'Choose a token package to earn bonus and unlock new episodes!',
  'view_all_tokens': 'View All Tokens',
  'bonuses_you_will_receive': 'Bonuses You\'ll Receive',
  'premium_account': 'Premium Account',
  'more_matches': 'More Matches',
  'highlight': 'Highlight',
  'more_likes': 'More Likes',
  'tokens': 'Tokens',
  'per_week': 'Per week',
  'weekly_starting': 'Weekly starting',
  'choose_token_package': 'Choose a token package to unlock features',
  
  // Movie related
  'movies': 'Movies',
  'movie_count': '{0} movies',
  'discover': 'Discover',
  'trending': 'Trending',
  'new_releases': 'New Releases',
  'top_rated': 'Top Rated',
  'genres': 'Genres',
  'search': 'Search',
  'search_movies': 'Search movies...',
  'filter': 'Filter',
  'sort_by': 'Sort by',
  'year': 'Year',
  'rating': 'Rating',
  'duration': 'Duration',
  'director': 'Director',
  'cast': 'Cast',
  'synopsis': 'Synopsis',
  'watch_trailer': 'Watch Trailer',
  'add_to_favorites': 'Add to Favorites',
  'remove_from_favorites': 'Remove from Favorites',
  'share': 'Share',
  'reviews': 'Reviews',
  'write_review': 'Write a Review',
  'movies_found': '{0} movies found',
  'no_movies_found': 'No movies found',
  'load_more': 'Load More',
  'pull_to_refresh': 'Pull to refresh',
  
  // Common actions
  'loading': 'Loading...',
  'error': 'Error',
  'retry': 'Retry',
  'cancel': 'Cancel',
  'save': 'Save',
  'delete': 'Delete',
  'edit': 'Edit',
  'confirm': 'Confirm',
  'yes': 'Yes',
  'no': 'No',
  'ok': 'OK',
  'done': 'Done',
  'close': 'Close',
  'back': 'Back',
  'next': 'Next',
  'previous': 'Previous',
  'skip': 'Skip',
  'continue': 'Continue',
  
  // Pagination
  'page_of_total': 'Page {0} of {1}',
  'showing_results': 'Showing {0} of {1} results',
  
  // Error messages
  'no_internet_connection': 'No internet connection. Please check your network.',
  'connection_timeout': 'Connection timeout. Please try again.',
  'server_error': 'Server error. Please try again later.',
  'session_expired': 'Your session has expired. Please log in again.',
  'access_forbidden': 'You don\'t have permission for this action.',
  'not_found': 'The requested resource was not found.',
  'too_many_requests': 'Too many requests. Please wait and try again.',
  'unknown_error': 'An unknown error occurred.',
  'validation_errors': 'Please check your input and try again.',
  
  // Validation messages
  'email_required': 'Email is required',
  'email_invalid': 'Please enter a valid email address',
  'password_required': 'Password is required',
  'password_too_short': 'Password must be at least 8 characters',
  'passwords_do_not_match': 'Passwords do not match',
  'field_required': 'This field is required',
  'invalid_format': 'Invalid format',
  
  // Success messages
  'login_successful': 'Login successful',
  'registration_successful': 'Registration successful. Please verify your email.',
  'profile_updated': 'Profile updated successfully',
  'photo_uploaded': 'Photo uploaded successfully',
  'favorite_added': 'Added to favorites',
  'favorite_removed': 'Removed from favorites',
  'purchase_successful': 'Purchase completed successfully',
  'email_sent': 'Email sent successfully',
  'changes_saved': 'Changes saved successfully',
  
  // Failure messages
  'login_failed': 'Login failed. Please check your credentials.',
  'registration_failed': 'Registration failed. Please try again.',
  'photo_upload_failed': 'Photo upload failed. Please try again.',
  'purchase_failed': 'Purchase failed. Please try again.',
  'operation_failed': 'Operation failed. Please try again.',
  
  // Settings
  'language_settings': 'Language Settings',
  'turkish': 'Türkçe',
  'english': 'English',
  'theme_settings': 'Theme Settings',
  'dark_mode': 'Dark Mode',
  'light_mode': 'Light Mode',
  'system_theme': 'Follow System Theme',
  'notifications': 'Notifications',
  'privacy': 'Privacy',
  'terms_of_service': 'Terms of Service',
  'about_app': 'About App',
  'version': 'Version',
  'contact_support': 'Contact Support',
  'rate_app': 'Rate App',
  'share_app': 'Share App',
  'clear_cache': 'Clear Cache',
  'reset_settings': 'Reset Settings',
  
  // Time related
  'time_ago': '{0} ago',
  'just_now': 'Just now',
  'minutes_ago': '{0} minutes ago',
  'hours_ago': '{0} hours ago',
  'days_ago': '{0} days ago',
  'weeks_ago': '{0} weeks ago',
  'months_ago': '{0} months ago',
  'years_ago': '{0} years ago',
  
  // Payment related
  'payment': 'Payment',
  'credit_card': 'Credit Card',
  'apple_pay': 'Apple Pay',
  'google_pay': 'Google Pay',
  'paypal': 'PayPal',
  'payment_method': 'Payment Method',
  'billing_address': 'Billing Address',
  'card_number': 'Card Number',
  'expiry_date': 'Expiry Date',
  'cvv': 'CVV',
  'cardholder_name': 'Cardholder Name',
  'total_amount': 'Total Amount',
  'discount': 'Discount',
  'tax': 'Tax',
  'subtotal': 'Subtotal',
  'price_per_week': '{0} per week',
  'tokens_amount': '{0} tokens',
  'discount_percentage': '{0}% discount',
  'bonus_tokens': 'Bonus: +{0} tokens',
  
  // Social features
  'share_movie': 'Share this movie',
  'recommend_to_friend': 'Recommend to a friend',
  'write_review': 'Write a review',
  'rate_movie': 'Rate this movie',
  'follow': 'Follow',
  'unfollow': 'Unfollow',
  'followers': 'Followers',
  'following': 'Following',
  
  // Accessibility
  'accessibility_movie_poster': 'Movie poster for {0}',
  'accessibility_favorite_button': 'Add to favorites',
  'accessibility_play_button': 'Play movie',
  'accessibility_back_button': 'Go back',
  'accessibility_menu_button': 'Open menu',
  'accessibility_search_button': 'Search movies',
  'accessibility_filter_button': 'Filter results',
  'accessibility_sort_button': 'Sort results',
  
  // Offline
  'offline_mode': 'Offline Mode',
  'no_internet_cached_content': 'No internet connection. Showing cached content.',
  'sync_when_online': 'Content will sync when you\'re back online',
  
  // Premium features
  'premium_features': 'Premium Features',
  'unlock_premium': 'Unlock Premium',
  'premium_only': 'Premium Only',
  'upgrade_to_premium': 'Upgrade to Premium',
  'premium_benefits': 'Premium Benefits',
  'ad_free_experience': 'Ad-free experience',
  'exclusive_content': 'Exclusive content',
  'early_access': 'Early access to new releases',
  'high_quality_streaming': 'High quality streaming',
  'offline_downloads': 'Offline downloads',
  
  // Genre names
  'action': 'Action',
  'adventure': 'Adventure',
  'animation': 'Animation',
  'biography': 'Biography',
  'comedy': 'Comedy',
  'crime': 'Crime',
  'documentary': 'Documentary',
  'drama': 'Drama',
  'family': 'Family',
  'fantasy': 'Fantasy',
  'history': 'History',
  'horror': 'Horror',
  'music': 'Music',
  'mystery': 'Mystery',
  'romance': 'Romance',
  'science_fiction': 'Science Fiction',
  'thriller': 'Thriller',
  'war': 'War',
  'western': 'Western',
};
```

#### Turkish Translations
```dart
// translations/tr_translations.dart
const Map<String, String> _trTranslations = {
  // App basics
  'app_name': 'ShartFlix',
  'welcome': 'Hoşgeldiniz',
  'welcome_user': 'Hoş geldin, {0}!',
  
  // Authentication
  'login': 'Giriş',
  'register': 'Kayıt',
  'email': 'E-Posta',
  'password': 'Şifre',
  'confirm_password': 'Şifre Tekrar',
  'forgot_password': 'Şifremi Unuttum',
  'remember_me': 'Kullanıcı sözleşmesini okudum ve kabul ediyorum',
  'login_button': 'Şimdi Kaydol',
  'register_button': 'Giriş Yap',
  'already_have_account': 'Zaten bir hesabın var mı? Giriş Yap!',
  'no_account': 'Bir hesabın yok mu? Kayıt Ol!',
  
  // Navigation
  'home': 'Anasayfa',
  'profile': 'Profil',
  'settings': 'Ayarlar',
  'logout': 'Çıkış',
  
  // Profile
  'profile_details': 'Profil Detayı',
  'favorite_movies': 'Beğendiğim Filmler',
  'add_photo': 'Fotoğraf Ekle',
  'edit_profile': 'Profili Düzenle',
  'user_id': 'ID: {0}',
  
  // Limited Offer
  'limited_offer': 'Sınırlı Teklif',
  'limited_offer_subtitle': 'Jeton paketini seçerek bonus kazanın ve yeni bölümlerin kilidini açın!',
  'view_all_tokens': 'Tüm Jetonları Gör',
  'bonuses_you_will_receive': 'Alacağınız Bonuslar',
  'premium_account': 'Premium Hesap',
  'more_matches': 'Daha Fazla Eşleşme',
  'highlight': 'Öne Çıkarma',
  'more_likes': 'Daha Fazla Beğeni',
  'tokens': 'Jeton',
  'per_week': 'Başına haftalık',
  'weekly_starting': 'Haftalık başlangıç',
  'choose_token_package': 'Özelliklerin kilidini açmak için jeton paketi seç',
  
  // Movie related
  'movies': 'Filmler',
  'movie_count': '{0} film',
  'discover': 'Keşfet',
  'trending': 'Popüler',
  'new_releases': 'Yeni Çıkanlar',
  'top_rated': 'En İyi Puanlayanlar',
  'genres': 'Türler',
  'search': 'Ara',
  'search_movies': 'Film ara...',
  'filter': 'Filtrele',
  'sort_by': 'Sırala',
  'year': 'Yıl',
  'rating': 'Puan',
  'duration': 'Süre',
  'director': 'Yönetmen',
  'cast': 'Oyuncular',
  'synopsis': 'Özet',
  'watch_trailer': 'Fragman İzle',
  'add_to_favorites': 'Favorilere Ekle',
  'remove_from_favorites': 'Favorilerden Çıkar',
  'share': 'Paylaş',
  'reviews': 'Yorumlar',
  'write_review': 'Yorum Yaz',
  'movies_found': '{0} film bulundu',
  'no_movies_found': 'Film bulunamadı',
  'load_more': 'Daha Fazla Yükle',
  'pull_to_refresh': 'Yenilemek için çek',
  
  // Common actions
  'loading': 'Yükleniyor...',
  'error': 'Hata',
  'retry': 'Tekrar Dene',
  'cancel': 'İptal',
  'save': 'Kaydet',
  'delete': 'Sil',
  'edit': 'Düzenle',
  'confirm': 'Onayla',
  'yes': 'Evet',
  'no': 'Hayır',
  'ok': 'Tamam',
  'done': 'Bitti',
  'close': 'Kapat',
  'back': 'Geri',
  'next': 'İleri',
  'previous': 'Önceki',
  'skip': 'Geç',
  'continue': 'Devam Et',
  
  // Pagination
  'page_of_total': 'Sayfa {0} / {1}',
  'showing_results': '{0} / {1} sonuç gösteriliyor',
  
  // Error messages
  'no_internet_connection': 'İnternet bağlantınızı kontrol edin',
  'connection_timeout': 'İşlem zaman aşımına uğradı, tekrar deneyin',
  'server_error': 'Sunucu hatası, lütfen daha sonra tekrar deneyin',
  'session_expired': 'Oturum süreniz dolmuş, tekrar giriş yapın',
  'access_forbidden': 'Bu işlem için yetkiniz bulunmuyor',
  'not_found': 'İstenen kaynak bulunamadı',
  'too_many_requests': 'Çok fazla istek gönderdiniz, lütfen bekleyin',
  'unknown_error': 'Bilinmeyen bir hata oluştu',
  'validation_errors': 'Lütfen girişlerinizi kontrol edin',
  
  // Validation messages
  'email_required': 'E-posta gereklidir',
  'email_invalid': 'Geçerli bir e-posta adresi girin',
  'password_required': 'Şifre gereklidir',
  'password_too_short': 'Şifre en az 8 karakter olmalıdır',
  'passwords_do_not_match': 'Şifreler eşleşmiyor',
  'field_required': 'Bu alan gereklidir',
  'invalid_format': 'Geçersiz format',
  
  // Success messages
  'login_successful': 'Giriş başarılı',
  'registration_successful': 'Kayıt başarılı. Lütfen e-postanızı doğrulayın.',
  'profile_updated': 'Profil başarıyla güncellendi',
  'photo_uploaded': 'Fotoğraf başarıyla yüklendi',
  'favorite_added': 'Favorilere eklendi',
  'favorite_removed': 'Favorilerden çıkarıldı',
  'purchase_successful': 'Satın alma başarıyla tamamlandı',
  'email_sent': 'E-posta başarıyla gönderildi',
  'changes_saved': 'Değişiklikler başarıyla kaydedildi',
  
  // Failure messages
  'login_failed': 'Giriş başarısız. Bilgilerinizi kontrol edin.',
  'registration_failed': 'Kayıt başarısız. Tekrar deneyin.',
  'photo_upload_failed': 'Fotoğraf yükleme başarısız. Tekrar deneyin.',
  'purchase_failed': 'Satın alma başarısız. Tekrar deneyin.',
  'operation_failed': 'İşlem başarısız. Tekrar deneyin.',
  
  // Settings
  'language_settings': 'Dil Ayarları',
  'turkish': 'Türkçe',
  'english': 'English',
  'theme_settings': 'Tema Ayarları',
  'dark_mode': 'Koyu Tema',
  'light_mode': 'Açık Tema',
  'system_theme': 'Sistem Teması Kullan',
  'notifications': 'Bildirimler',
  'privacy': 'Gizlilik',
  'terms_of_service': 'Kullanım Şartları',
  'about_app': 'Uygulama Hakkında',
  'version': 'Sürüm',
  'contact_support': 'Destek İletişim',
  'rate_app': 'Uygulamayı Değerlendir',
  'share_app': 'Uygulamayı Paylaş',
  'clear_cache': 'Önbelleği Temizle',
  'reset_settings': 'Ayarları Sıfırla',
  
  // Time related
  'time_ago': '{0} önce',
  'just_now': 'Şimdi',
  'minutes_ago': '{0} dakika önce',
  'hours_ago': '{0} saat önce',
  'days_ago': '{0} gün önce',
  'weeks_ago': '{0} hafta önce',
  'months_ago': '{0} ay önce',
  'years_ago': '{0} yıl önce',
  
  // Payment related
  'payment': 'Ödeme',
  'credit_card': 'Kredi Kartı',
  'apple_pay': 'Apple Pay',
  'google_pay': 'Google Pay',
  'paypal': 'PayPal',
  'payment_method': 'Ödeme Yöntemi',
  'billing_address': 'Fatura Adresi',
  'card_number': 'Kart Numarası',
  'expiry_date': 'Son Kullanma Tarihi',
  'cvv': 'CVV',
  'cardholder_name': 'Kart Sahibi Adı',
  'total_amount': 'Toplam Tutar',
  'discount': 'İndirim',
  'tax': 'Vergi',
  'subtotal': 'Ara Toplam',
  'price_per_week': 'Haftalık {0}',
  'tokens_amount': '{0} jeton',
  'discount_percentage': '%{0} indirim',
  'bonus_tokens': 'Bonus: +{0} jeton',
  
  // Social features
  'share_movie': 'Bu filmi paylaş',
  'recommend_to_friend': 'Arkadaşa öner',
  'write_review': 'Yorum yaz',
  'rate_movie': 'Bu filmi puanla',
  'follow': 'Takip Et',
  'unfollow': 'Takibi Bırak',
  'followers': 'Takipçiler',
  'following': 'Takip Edilen',
  
  // Accessibility
  'accessibility_movie_poster': '{0} film posteri',
  'accessibility_favorite_button': 'Favorilere ekle',
  'accessibility_play_button': 'Filmi oynat',
  'accessibility_back_button': 'Geri git',
  'accessibility_menu_button': 'Menüyü aç',
  'accessibility_search_button': 'Film ara',
  'accessibility_filter_button': 'Sonuçları filtrele',
  'accessibility_sort_button': 'Sonuçları sırala',
  
  // Offline
  'offline_mode': 'Çevrimdışı Mod',
  'no_internet_cached_content': 'İnternet bağlantısı yok. Önbellekteki içerik gösteriliyor.',
  'sync_when_online': 'İnternet bağlantısı olduğunda içerik senkronize edilecek',
  
  // Premium features
  'premium_features': 'Premium Özellikler',
  'unlock_premium': 'Premium\'u Aç',
  'premium_only': 'Sadece Premium',
  'upgrade_to_premium': 'Premium\'a Yükselt',
  'premium_benefits': 'Premium Avantajları',
  'ad_free_experience': 'Reklamsız deneyim',
  'exclusive_content': 'Özel içerik',
  'early_access': 'Yeni çıkanlara erken erişim',
  'high_quality_streaming': 'Yüksek kaliteli yayın',
  'offline_downloads': 'Çevrimdışı indirmeler',
  
  // Genre names
  'action': 'Aksiyon',
  'adventure': 'Macera',
  'animation': 'Animasyon',
  'biography': 'Biyografi',
  'comedy': 'Komedi',
  'crime': 'Suç',
  'documentary': 'Belgesel',
  'drama': 'Drama',
  'family': 'Aile',
  'fantasy': 'Fantastik',
  'history': 'Tarih',
  'horror': 'Korku',
  'music': 'Müzik',
  'mystery': 'Gizem',
  'romance': 'Romantik',
  'science_fiction': 'Bilim Kurgu',
  'thriller': 'Gerilim',
  'war': 'Savaş',
  'western': 'Western',
};
```

## Localization BLoC

### Language Management
```dart
// localization_bloc.dart
class LocalizationBloc extends Bloc<LocalizationEvent, LocalizationState> {
  final LocalizationRepository localizationRepository;

  LocalizationBloc({required this.localizationRepository}) 
      : super(LocalizationInitial()) {
    on<LocalizationLoadRequested>(_onLocalizationLoadRequested);
    on<LanguageChanged>(_onLanguageChanged);
    on<SystemLanguageChanged>(_onSystemLanguageChanged);
  }

  Future<void> _onLocalizationLoadRequested(
    LocalizationLoadRequested event,
    Emitter<LocalizationState> emit,
  ) async {
    try {
      final savedLanguage = await localizationRepository.getSavedLanguage();
      final useSystemLanguage = await localizationRepository.getUseSystemLanguage();
      
      Locale currentLocale;
      if (useSystemLanguage) {
        final systemLocale = await localizationRepository.getSystemLanguage();
        currentLocale = _getSupportedLocale(systemLocale);
      } else {
        currentLocale = _getSupportedLocale(savedLanguage);
      }
      
      emit(LocalizationLoaded(
        currentLocale: currentLocale,
        useSystemLanguage: useSystemLanguage,
      ));
    } catch (e) {
      emit(LocalizationLoaded(
        currentLocale: const Locale('tr', 'TR'),
        useSystemLanguage: true,
      ));
    }
  }

  Future<void> _onLanguageChanged(
    LanguageChanged event,
    Emitter<LocalizationState> emit,
  ) async {
    final currentState = state;
    if (currentState is LocalizationLoaded) {
      emit(currentState.copyWith(
        currentLocale: event.locale,
        useSystemLanguage: event.useSystemLanguage,
      ));

      // Persist language preference
      await localizationRepository.saveLanguage(event.locale);
      await localizationRepository.saveUseSystemLanguage(event.useSystemLanguage);

      // Track language change
      AnalyticsService.trackLanguageChange(
        languageCode: event.locale.languageCode,
        useSystemLanguage: event.useSystemLanguage,
      );
    }
  }

  Future<void> _onSystemLanguageChanged(
    SystemLanguageChanged event,
    Emitter<LocalizationState> emit,
  ) async {
    final currentState = state;
    if (currentState is LocalizationLoaded && currentState.useSystemLanguage) {
      final supportedLocale = _getSupportedLocale(event.systemLocale);
      emit(currentState.copyWith(currentLocale: supportedLocale));
    }
  }

  Locale _getSupportedLocale(Locale? locale) {
    if (locale == null) return const Locale('tr', 'TR');
    
    // Check if exact locale is supported
    for (final supportedLocale in AppLocalizations.supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode &&
          supportedLocale.countryCode == locale.countryCode) {
        return supportedLocale;
      }
    }
    
    // Check if language is supported (ignore country)
    for (final supportedLocale in AppLocalizations.supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return supportedLocale;
      }
    }
    
    // Default to Turkish
    return const Locale('tr', 'TR');
  }
}

// Localization States
abstract class LocalizationState {}

class LocalizationInitial extends LocalizationState {}

class LocalizationLoaded extends LocalizationState {
  final Locale currentLocale;
  final bool useSystemLanguage;

  LocalizationLoaded({
    required this.currentLocale,
    required this.useSystemLanguage,
  });

  LocalizationLoaded copyWith({
    Locale? currentLocale,
    bool? useSystemLanguage,
  }) {
    return LocalizationLoaded(
      currentLocale: currentLocale ?? this.currentLocale,
      useSystemLanguage: useSystemLanguage ?? this.useSystemLanguage,
    );
  }
}

// Localization Events
abstract class LocalizationEvent {}

class LocalizationLoadRequested extends LocalizationEvent {}

class LanguageChanged extends LocalizationEvent {
  final Locale locale;
  final bool useSystemLanguage;

  LanguageChanged({
    required this.locale,
    required this.useSystemLanguage,
  });
}

class SystemLanguageChanged extends LocalizationEvent {
  final Locale systemLocale;

  SystemLanguageChanged({required this.systemLocale});
}
```

## Localization Repository

### Language Persistence
```dart
// localization_repository.dart
class LocalizationRepository {
  final LocalStorageService localStorageService;
  
  static const String _languageCodeKey = 'language_code';
  static const String _countryCodeKey = 'country_code';
  static const String _useSystemLanguageKey = 'use_system_language';

  LocalizationRepository({required this.localStorageService});

  Future<Locale?> getSavedLanguage() async {
    final languageCode = await localStorageService.getString(_languageCodeKey);
    final countryCode = await localStorageService.getString(_countryCodeKey);
    
    if (languageCode != null) {
      return Locale(languageCode, countryCode);
    }
    return null;
  }

  Future<void> saveLanguage(Locale locale) async {
    await localStorageService.set(_languageCodeKey, locale.languageCode);
    if (locale.countryCode != null) {
      await localStorageService.set(_countryCodeKey, locale.countryCode!);
    }
  }

  Future<bool> getUseSystemLanguage() async {
    final useSystemLanguage = await localStorageService.getBool(_useSystemLanguageKey);
    return useSystemLanguage ?? true;
  }

  Future<void> saveUseSystemLanguage(bool useSystemLanguage) async {
    await localStorageService.set(_useSystemLanguageKey, useSystemLanguage);
  }

  Future<Locale> getSystemLanguage() async {
    final platformLocale = Platform.localeName.split('_');
    final languageCode = platformLocale.first;
    final countryCode = platformLocale.length > 1 ? platformLocale[1] : null;
    
    return Locale(languageCode, countryCode);
  }
}
```

## Localization Extensions

### Context Extensions
```dart
// localization_extensions.dart
extension LocalizationExtensions on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  
  Locale get locale => Localizations.localeOf(this);
  
  bool get isRTL => Directionality.of(this) == TextDirection.rtl;
  
  String get languageCode => locale.languageCode;
  
  bool get isTurkish => languageCode == 'tr';
  bool get isEnglish => languageCode == 'en';
}

extension StringLocalizationExtensions on String {
  String tr(BuildContext context, {List<String>? args}) {
    return AppLocalizations.of(context)!.translate(this, args: args);
  }
}

// Localized Widget wrapper
class LocalizedWidget extends StatelessWidget {
  final Widget Function(BuildContext context, AppLocalizations l10n) builder;

  const LocalizedWidget({
    required this.builder,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return builder(context, context.l10n);
  }
}

// Localized Text Widget
class LocalizedText extends StatelessWidget {
  final String translationKey;
  final List<String>? args;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const LocalizedText(
    this.translationKey, {
    this.args,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.translate(translationKey, args: args),
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
```

## Language Selector Widget

### Language Selection UI
```dart
// language_selector_widget.dart
class LanguageSelectorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalizationBloc, LocalizationState>(
      builder: (context, state) {
        if (state is! LocalizationLoaded) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.languageSettings,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            
            // System Language Toggle
            SwitchListTile(
              title: Text(context.l10n.systemTheme),
              subtitle: Text('Cihazınızın dil ayarını takip eder'),
              value: state.useSystemLanguage,
              onChanged: (value) {
                if (value) {
                  context.read<LocalizationBloc>().add(LanguageChanged(
                    locale: state.currentLocale,
                    useSystemLanguage: true,
                  ));
                } else {
                  context.read<LocalizationBloc>().add(LanguageChanged(
                    locale: state.currentLocale,
                    useSystemLanguage: false,
                  ));
                }
              },
            ),
            
            // Manual Language Selection
            if (!state.useSystemLanguage) ...[
              const SizedBox(height: 8),
              _buildLanguageOptions(context, state.currentLocale),
            ],
          ],
        );
      },
    );
  }

  Widget _buildLanguageOptions(BuildContext context, Locale currentLocale) {
    return Column(
      children: AppLocalizations.supportedLocales.map((locale) {
        return RadioListTile<Locale>(
          title: Text(_getLanguageName(locale)),
          subtitle: Text(_getLanguageNativeName(locale)),
          value: locale,
          groupValue: currentLocale,
          onChanged: (selectedLocale) {
            if (selectedLocale != null) {
              context.read<LocalizationBloc>().add(LanguageChanged(
                locale: selectedLocale,
                useSystemLanguage: false,
              ));
            }
          },
        );
      }).toList(),
    );
  }

  String _getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'tr':
        return 'Türkçe';
      case 'en':
        return 'English';
      default:
        return locale.languageCode.toUpperCase();
    }
  }

  String _getLanguageNativeName(Locale locale) {
    switch (locale.languageCode) {
      case 'tr':
        return 'Turkish';
      case 'en':
        return 'English';
      default:
        return locale.languageCode;
    }
  }
}
```

## Pluralization Support

### Pluralization Helper
```dart
// pluralization_helper.dart
class PluralizationHelper {
  static String pluralize(
    BuildContext context,
    int count,
    String singularKey,
    String pluralKey, {
    List<String>? args,
  }) {
    final l10n = AppLocalizations.of(context)!;
    
    if (context.isTurkish) {
      // Turkish doesn't have plural forms, use singular
      return l10n.translate(singularKey, args: args);
    } else {
      // English pluralization
      if (count == 1) {
        return l10n.translate(singularKey, args: args);
      } else {
        return l10n.translate(pluralKey, args: args);
      }
    }
  }

  static String formatCount(
    BuildContext context,
    int count,
    String baseKey, {
    bool showCount = true,
  }) {
    final l10n = AppLocalizations.of(context)!;
    
    if (showCount) {
      return l10n.translate(baseKey, args: [count.toString()]);
    } else {
      return pluralize(
        context,
        count,
        '${baseKey}_singular',
        '${baseKey}_plural',
      );
    }
  }
}

// Usage examples:
// PluralizationHelper.pluralize(context, movieCount, 'movie', 'movies');
// PluralizationHelper.formatCount(context, favoriteCount, 'favorite_count');
```

## Testing Localization

### Localization Testing Utilities
```dart
// localization_test_helper.dart
class LocalizationTestHelper {
  static Widget createLocalizedTestWidget({
    required Widget child,
    Locale locale = const Locale('en', 'US'),
  }) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );
  }

  static void testTranslations() {
    // Test that all keys exist in both languages
    final enKeys = _enTranslations.keys.toSet();
    final trKeys = _trTranslations.keys.toSet();
    
    final missingInTurkish = enKeys.difference(trKeys);
    final missingInEnglish = trKeys.difference(enKeys);
    
    if (missingInTurkish.isNotEmpty) {
      print('Missing in Turkish: $missingInTurkish');
    }
    
    if (missingInEnglish.isNotEmpty) {
      print('Missing in English: $missingInEnglish');
    }
    
    assert(missingInTurkish.isEmpty, 'Missing translations in Turkish');
    assert(missingInEnglish.isEmpty, 'Missing translations in English');
  }
}

// Example localization test
group('Localization Tests', () {
  testWidgets('should display Turkish text correctly', (tester) async {
    await tester.pumpWidget(
      LocalizationTestHelper.createLocalizedTestWidget(
        child: const Scaffold(
          body: LocalizedText('welcome'),
        ),
        locale: const Locale('tr', 'TR'),
      ),
    );

    expect(find.text('Hoşgeldiniz'), findsOneWidget);
  });

  testWidgets('should display English text correctly', (tester) async {
    await tester.pumpWidget(
      LocalizationTestHelper.createLocalizedTestWidget(
        child: const Scaffold(
          body: LocalizedText('welcome'),
        ),
        locale: const Locale('en', 'US'),
      ),
    );

    expect(find.text('Welcome'), findsOneWidget);
  });

  test('should have complete translations', () {
    LocalizationTestHelper.testTranslations();
  });
});
```

Bu kapsamlı lokalizasyon dokümantasyonu, ShartFlix uygulaması boyunca Türkçe ve İngilizce dil desteği, dinamik dil değiştirme ve context-aware çeviriler için sağlam bir temel sağlar. 