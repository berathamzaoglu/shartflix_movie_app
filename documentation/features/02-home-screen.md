# Home Screen - Movie Discovery

## Overview

The home screen serves as the primary movie discovery interface, featuring an infinite scroll grid layout that loads 5 movies per page. It provides users with a seamless browsing experience through auto-loading indicators, pull-to-refresh functionality, and real-time favorite movie operations using Dio HTTP client.

## Core Features

### 1. Movie Discovery Interface

#### Grid Layout Specifications
- **Layout**: 2-column responsive grid
- **Movie Cards**: Poster image with overlay information
- **Card Dimensions**: Aspect ratio 2:3 (movie poster standard)
- **Spacing**: 16px between cards, 20px margin from screen edges
- **Content**: Movie poster, title, studio/producer, favorite button

#### Movie Card Components
```dart
// Movie Card Data Model
class Movie {
  final String id;
  final String title;
  final String posterUrl;
  final String studio;
  final bool isFavorite;
  final double rating;
  final String genre;
  final int year;
}

// UI Component Structure
MovieCard {
  - Cached Network Image (poster)
  - Gradient Overlay
  - Movie Title
  - Studio Name
  - Favorite Heart Icon (animated)
  - Tap Gesture Handler
}
```

### 2. Infinite Scroll Implementation

#### Pagination Strategy
- **Page Size**: 5 movies per page
- **Threshold**: Load next page when 2 items from bottom
- **Loading Strategy**: Progressive loading with smooth animations
- **Memory Management**: Dispose off-screen items efficiently

#### Technical Implementation
```dart
// BLoC State Management
abstract class MovieState {}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<Movie> movies;
  final bool hasReachedMax;
  final int currentPage;
  
  MovieLoaded({
    required this.movies,
    required this.hasReachedMax,
    required this.currentPage,
  });
}

class MovieError extends MovieState {
  final String message;
}

// BLoC Events
abstract class MovieEvent {}

class MovieFetch extends MovieEvent {}

class MovieRefresh extends MovieEvent {}

class MovieToggleFavorite extends MovieEvent {
  final String movieId;
}
```

#### API Integration with Dio
```dart
// Movies List API Request
GET /movies?page={page}&limit=5
Authorization: Bearer {token}

Query Parameters:
- page: Page number (starting from 1)
- limit: Number of movies per page (fixed at 5)
- genre: Optional genre filter
- year: Optional year filter
- search: Optional search query

Response:
{
  "success": true,
  "data": {
    "movies": [
      {
        "id": "movie_001",
        "title": "Aşk, Ekmek, Hayaller",
        "poster_url": "https://api.shartflix.com/posters/movie_001.jpg",
        "studio": "Adam Yapım",
        "is_favorite": false,
        "rating": 8.5,
        "genre": "Romance",
        "year": 2023,
        "description": "Movie description..."
      }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 25,
      "total_items": 123,
      "has_next": true
    }
  }
}
```

### 3. Pull-to-Refresh Functionality

#### Implementation Details
- **Trigger**: Pull down gesture from top of screen
- **Visual Feedback**: Custom refresh indicator with app branding
- **Behavior**: Clear current data and reload from page 1
- **State Management**: Reset pagination and movie list

```dart
// Refresh Implementation
class RefreshHandler {
  static Future<void> handleRefresh(MovieBloc bloc) async {
    bloc.add(MovieRefresh());
    // Dio request to refresh data
    await bloc.refreshMovies();
  }
}

// Custom Refresh Indicator
RefreshIndicator(
  onRefresh: () => RefreshHandler.handleRefresh(context.read<MovieBloc>()),
  color: AppColors.primary,
  backgroundColor: AppColors.surface,
  child: MovieGridView(),
)
```

### 4. Loading States and Indicators

#### Loading Types
- **Initial Load**: Full-screen loading with skeleton cards
- **Pagination Load**: Bottom loading indicator
- **Refresh Load**: Pull-to-refresh indicator
- **Favorite Toggle**: Individual card loading state

#### Skeleton Loading
```dart
// Skeleton Movie Card
class SkeletonMovieCard extends StatelessWidget {
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // Skeleton poster
            Container(height: 200, color: Colors.white),
            // Skeleton text lines
            Container(height: 16, margin: EdgeInsets.all(8), color: Colors.white),
          ],
        ),
      ),
    );
  }
}
```

### 5. Favorite Movie Operations

#### Real-time UI Updates
- **Immediate Feedback**: Instant heart icon animation
- **Optimistic Updates**: Update UI before API confirmation
- **Rollback**: Revert changes if API call fails
- **Synchronization**: Sync with backend state

#### API Integration
```dart
// Toggle Favorite API
POST /movies/{movieId}/favorite
Authorization: Bearer {token}

Request Body:
{
  "is_favorite": true
}

Response:
{
  "success": true,
  "data": {
    "movie_id": "movie_001",
    "is_favorite": true,
    "favorite_count": 1234
  }
}

// Remove Favorite API
DELETE /movies/{movieId}/favorite
Authorization: Bearer {token}

Response:
{
  "success": true,
  "data": {
    "movie_id": "movie_001",
    "is_favorite": false,
    "favorite_count": 1233
  }
}
```

#### State Management for Favorites
```dart
// Favorite Toggle BLoC Logic
class MovieBloc extends Bloc<MovieEvent, MovieState> {
  Future<void> _onToggleFavorite(
    MovieToggleFavorite event,
    Emitter<MovieState> emit,
  ) async {
    final currentState = state;
    if (currentState is MovieLoaded) {
      // Optimistic update
      final updatedMovies = currentState.movies.map((movie) {
        if (movie.id == event.movieId) {
          return movie.copyWith(isFavorite: !movie.isFavorite);
        }
        return movie;
      }).toList();
      
      emit(currentState.copyWith(movies: updatedMovies));
      
      try {
        // API call through Dio
        await movieRepository.toggleFavorite(event.movieId);
      } catch (e) {
        // Rollback on error
        emit(currentState);
        // Show error message
      }
    }
  }
}
```

## Navigation Integration

### Movie Detail Navigation
- **Trigger**: Tap on movie card
- **Transition**: Hero animation with movie poster
- **Data**: Pass movie object to detail screen
- **Back Navigation**: Preserve scroll position

### Search Integration
- **Search Bar**: Collapsible search input in app bar
- **Filter Options**: Genre, year, rating filters
- **Search Results**: Replace grid with search results
- **Clear Search**: Return to discovery mode

## Performance Optimizations

### Image Loading
- **Caching**: Cached network images with disk cache
- **Placeholder**: Progressive image loading with blur effect
- **Error Handling**: Fallback images for failed loads
- **Memory**: Efficient memory usage with proper disposal

### Scroll Performance
- **Lazy Loading**: Build widgets only when visible
- **Physics**: Custom scroll physics for smooth experience
- **Memory**: Recycle off-screen widgets
- **FPS**: Maintain 60fps during scrolling

### Network Optimization
```dart
// Dio Configuration for Movies
class MovieApiClient {
  static final dio = Dio(BaseOptions(
    baseUrl: 'https://api.shartflix.com',
    connectTimeout: 15000,
    receiveTimeout: 15000,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));
  
  static Future<List<Movie>> fetchMovies({
    required int page,
    int limit = 5,
    String? genre,
    String? search,
  }) async {
    final response = await dio.get('/movies', queryParameters: {
      'page': page,
      'limit': limit,
      if (genre != null) 'genre': genre,
      if (search != null) 'search': search,
    });
    
    return (response.data['data']['movies'] as List)
        .map((json) => Movie.fromJson(json))
        .toList();
  }
}
```

## Error Handling

### Network Errors
- **No Internet**: Show offline mode with cached data
- **Server Error**: Display retry option with error message
- **Timeout**: Automatic retry with exponential backoff
- **Rate Limiting**: Handle 429 responses gracefully

### UI Error States
- **Empty State**: "No movies found" with illustration
- **Error State**: Error message with retry button
- **Network State**: Connection status indicator
- **Loading Error**: Failed to load more items indicator

## User Experience Features

### Animations
- **Card Entrance**: Staggered fade-in animation
- **Favorite Toggle**: Heart scale and color animation
- **Loading States**: Smooth transition between states
- **Pull Refresh**: Custom spring animation

### Accessibility
- **Screen Reader**: Proper semantic labels
- **Contrast**: High contrast mode support
- **Text Scaling**: Dynamic type support
- **Focus**: Keyboard navigation support

### Gestures
- **Tap**: Movie detail navigation
- **Long Press**: Quick favorite toggle
- **Pull**: Refresh gesture
- **Scroll**: Infinite scroll loading

## Testing Strategy

### Unit Tests
- Pagination logic
- Favorite toggle functionality
- State management
- API response parsing

### Widget Tests
- Movie card rendering
- Loading state display
- Error state handling
- Refresh functionality

### Integration Tests
- Complete movie discovery flow
- Infinite scroll behavior
- Favorite synchronization
- Network error recovery

## Analytics and Monitoring

### User Events
- Movie card views
- Favorite actions
- Scroll behavior
- Search usage

### Performance Metrics
- Page load times
- Scroll performance
- Memory usage
- Network efficiency

### Error Tracking
- API failures
- Image load errors
- State management issues
- User action failures 