# Profile Management System

## Overview

The profile management system provides comprehensive user account features including profile information display, favorite movies management, and profile photo upload functionality. All operations are integrated with Dio HTTP client for seamless backend communication and real-time updates.

## Core Features

### 1. Profile Screen Layout

#### User Interface Components
- **Header Section**:
  - Profile photo display with edit capability
  - User name: "Ayça Aydoğan"
  - User ID: "ID: 245677"
  - "Fotoğraf Ekle" (Add Photo) button
  - "Sınırlı Teklif" (Limited Offer) promotional button

- **Content Section**:
  - "Beğendiğim Filmler" (Favorite Movies) title
  - Grid layout of favorite movies (2 columns)
  - Movie cards with poster images and titles
  - Studio/producer information

- **Navigation**:
  - Bottom navigation with "Anasayfa" and "Profil" tabs
  - Back navigation to home screen

#### Technical Layout Structure
```dart
// Profile Screen Widget Structure
class ProfileScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBar(
        title: 'Profil Detayı',
        actions: [LimitedOfferButton()],
      ),
      body: Column(
        children: [
          ProfileHeader(),
          FavoriteMoviesSection(),
        ],
      ),
      bottomNavigationBar: MainBottomNavigation(),
    );
  }
}

// Profile Header Component
class ProfileHeader extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          ProfilePhotoWidget(),
          SizedBox(height: 16),
          UserInfoWidget(),
          SizedBox(height: 12),
          AddPhotoButton(),
        ],
      ),
    );
  }
}
```

### 2. User Profile Information Display

#### Data Model
```dart
class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? profilePhotoUrl;
  final DateTime createdAt;
  final DateTime lastLogin;
  final int favoriteMoviesCount;
  final String membershipType;
  final Map<String, dynamic> preferences;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.profilePhotoUrl,
    required this.createdAt,
    required this.lastLogin,
    required this.favoriteMoviesCount,
    required this.membershipType,
    required this.preferences,
  });
}
```

#### API Integration
```dart
// Get User Profile API
GET /user/profile
Authorization: Bearer {token}

Response:
{
  "success": true,
  "data": {
    "user": {
      "id": "245677",
      "name": "Ayça Aydoğan",
      "email": "ayca.aydogan@example.com",
      "profile_photo_url": "https://api.shartflix.com/uploads/profiles/245677.jpg",
      "created_at": "2023-01-15T10:30:00Z",
      "last_login": "2024-01-20T14:45:00Z",
      "favorite_movies_count": 12,
      "membership_type": "premium",
      "preferences": {
        "theme": "dark",
        "language": "tr",
        "notifications": true
      }
    }
  }
}
```

#### State Management
```dart
// Profile BLoC States
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfile user;
  final List<Movie> favoriteMovies;
  
  ProfileLoaded({
    required this.user,
    required this.favoriteMovies,
  });
}

class ProfileError extends ProfileState {
  final String message;
}

// Profile BLoC Events
abstract class ProfileEvent {}

class ProfileLoadRequested extends ProfileEvent {}

class ProfilePhotoUpdateRequested extends ProfileEvent {
  final File imageFile;
}

class ProfileInfoUpdateRequested extends ProfileEvent {
  final Map<String, dynamic> updates;
}
```

### 3. Favorite Movies Management

#### Favorite Movies Grid
- **Layout**: 2-column responsive grid
- **Movie Cards**: Compact version with poster and basic info
- **Actions**: Remove from favorites, view details
- **Pagination**: Load more favorites if count exceeds display limit

#### Movie Card Components
```dart
class FavoriteMovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster with Remove Button
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: movie.posterUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => SkeletonLoader(),
                  errorWidget: (context, url, error) => DefaultPoster(),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: RemoveFavoriteButton(onPressed: onRemove),
                ),
              ],
            ),
            // Movie Information
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    movie.studio,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

#### API Integration for Favorites
```dart
// Get User's Favorite Movies
GET /user/favorites?page={page}&limit={limit}
Authorization: Bearer {token}

Response:
{
  "success": true,
  "data": {
    "favorites": [
      {
        "id": "fav_001",
        "movie": {
          "id": "movie_001",
          "title": "Aşk, Ekmek, Hayaller",
          "poster_url": "https://api.shartflix.com/posters/movie_001.jpg",
          "studio": "Adam Yapım",
          "rating": 8.5,
          "year": 2023
        },
        "added_at": "2024-01-15T12:30:00Z"
      }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 3,
      "total_items": 12
    }
  }
}

// Remove from Favorites
DELETE /user/favorites/{movieId}
Authorization: Bearer {token}

Response:
{
  "success": true,
  "message": "Movie removed from favorites",
  "data": {
    "movie_id": "movie_001",
    "removed_at": "2024-01-20T14:45:00Z"
  }
}
```

### 4. Profile Photo Upload Feature

#### Upload Implementation
- **Source Options**: Camera capture or gallery selection
- **Image Processing**: Resize and compress before upload
- **Progress Indicator**: Upload progress display
- **Error Handling**: Network and server error management

#### Technical Implementation
```dart
class ProfilePhotoUploadService {
  static final dio = Dio();

  static Future<String> uploadProfilePhoto(File imageFile) async {
    try {
      // Compress image before upload
      final compressedImage = await compressImage(imageFile);
      
      // Create multipart form data
      final formData = FormData.fromMap({
        'profile_photo': await MultipartFile.fromFile(
          compressedImage.path,
          filename: 'profile_photo.jpg',
          contentType: MediaType('image', 'jpeg'),
        ),
      });

      // Upload with progress tracking
      final response = await dio.post(
        '/user/profile/photo',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${TokenStorage.getToken()}',
            'Content-Type': 'multipart/form-data',
          },
        ),
        onSendProgress: (sent, total) {
          final progress = sent / total;
          // Update progress indicator
        },
      );

      return response.data['data']['photo_url'];
    } catch (e) {
      throw ProfilePhotoUploadException(e.toString());
    }
  }

  static Future<File> compressImage(File imageFile) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      '${Directory.systemTemp.path}/compressed_profile.jpg',
      quality: 80,
      minWidth: 400,
      minHeight: 400,
    );
    return result!;
  }
}
```

#### Photo Selection UI
```dart
class PhotoSelectionBottomSheet extends StatelessWidget {
  final Function(File) onPhotoSelected;

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Fotoğraf Seç',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              PhotoSourceOption(
                icon: Icons.camera_alt,
                label: 'Kamera',
                onTap: () => _pickFromCamera(),
              ),
              PhotoSourceOption(
                icon: Icons.photo_library,
                label: 'Galeri',
                onTap: () => _pickFromGallery(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickFromCamera() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );
    
    if (image != null) {
      onPhotoSelected(File(image.path));
    }
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );
    
    if (image != null) {
      onPhotoSelected(File(image.path));
    }
  }
}
```

#### API Specification for Photo Upload
```dart
// Profile Photo Upload API
POST /user/profile/photo
Authorization: Bearer {token}
Content-Type: multipart/form-data

Form Data:
- profile_photo: [image file]

Response:
{
  "success": true,
  "message": "Profile photo updated successfully",
  "data": {
    "photo_url": "https://api.shartflix.com/uploads/profiles/245677.jpg",
    "uploaded_at": "2024-01-20T15:30:00Z"
  }
}

// Profile Photo Delete API
DELETE /user/profile/photo
Authorization: Bearer {token}

Response:
{
  "success": true,
  "message": "Profile photo deleted successfully",
  "data": {
    "deleted_at": "2024-01-20T15:35:00Z"
  }
}
```

## User Experience Features

### Loading States
- **Profile Loading**: Skeleton placeholders for user info
- **Photo Upload**: Progress indicator with percentage
- **Favorites Loading**: Shimmer effect for movie cards
- **Refresh**: Pull-to-refresh for profile data

### Error Handling
- **Network Errors**: Offline mode with cached data
- **Upload Errors**: Retry mechanism with user feedback
- **Permission Errors**: Camera/gallery access handling
- **Validation Errors**: Form validation with clear messages

### Animations
- **Profile Photo**: Smooth transition during upload
- **Favorite Movies**: Staggered animation for grid items
- **State Changes**: Fade transitions between loading states
- **Remove Actions**: Slide-out animation for removed items

## Performance Optimizations

### Image Handling
```dart
class ProfileImageCache {
  static final Map<String, ImageProvider> _cache = {};
  
  static ImageProvider getCachedImage(String url) {
    if (_cache.containsKey(url)) {
      return _cache[url]!;
    }
    
    final provider = CachedNetworkImageProvider(url);
    _cache[url] = provider;
    return provider;
  }
  
  static void clearCache() {
    _cache.clear();
  }
}
```

### Memory Management
- Dispose image resources properly
- Compress images before upload
- Cache profile data locally
- Lazy load favorite movies

### Network Optimization
- Batch API requests when possible
- Implement proper retry logic
- Use appropriate timeouts
- Handle rate limiting

## Security Considerations

### Data Protection
- Secure token storage for API requests
- Image upload validation
- File type and size restrictions
- User data encryption

### Privacy
- Profile photo access controls
- Favorite movies privacy settings
- Data retention policies
- User consent management

## Testing Strategy

### Unit Tests
```dart
// Example unit test for profile service
group('ProfileService Tests', () {
  test('should upload profile photo successfully', () async {
    // Arrange
    final mockFile = File('test_image.jpg');
    final mockResponse = {'data': {'photo_url': 'test_url'}};
    
    // Act
    final result = await ProfilePhotoUploadService.uploadProfilePhoto(mockFile);
    
    // Assert
    expect(result, equals('test_url'));
  });
  
  test('should handle upload errors gracefully', () async {
    // Test error scenarios
  });
});
```

### Widget Tests
- Profile screen rendering
- Photo upload button functionality
- Favorite movies grid display
- Error state handling

### Integration Tests
- Complete profile flow
- Photo upload process
- Favorite movies management
- Cross-screen navigation

## Accessibility Features

- **Screen Reader**: Proper semantic labels for all elements
- **High Contrast**: Support for high contrast themes
- **Large Text**: Dynamic type scaling support
- **Voice Control**: Voice-over navigation support
- **Keyboard Navigation**: Tab-based navigation for all interactive elements

## Analytics and Monitoring

### User Events
- Profile views
- Photo uploads
- Favorite movie interactions
- Settings changes

### Performance Metrics
- Photo upload success rates
- Load times for profile data
- Memory usage during image operations
- Network efficiency

### Error Tracking
- Upload failures
- API response errors
- Image processing errors
- User experience issues 