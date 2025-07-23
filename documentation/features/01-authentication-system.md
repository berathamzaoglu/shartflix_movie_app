# Authentication System

## Overview

The authentication system provides secure user login and registration functionality with comprehensive token management and session handling. All authentication-related network operations are handled through Dio HTTP client with proper error handling and security measures.

## Features

### 1. Login Screen (Giriş Ekranı)

#### User Interface Elements
- **Welcome Message**: "Hoşgeldiniz" title with subtitle text
- **Email Input Field**: 
  - Label: "E-Posta" 
  - Validation: Email format validation
  - Error states for invalid input
- **Password Input Field**:
  - Label: "Şifre"
  - Secure text entry with toggle visibility option
  - Password strength indicators
- **Remember Me Checkbox**: "Kullanıcı sözleşmesini okudum ve kabul ediyorum"
- **Login Button**: "Şimdi Kaydol" - Primary action button
- **Social Login Options**: Google, Apple, Facebook integration
- **Registration Link**: "Zaten bir hesabın var mı? Giriş Yap!" navigation

#### Technical Implementation
```dart
// BLoC State Classes
abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final User user;
  final String token;
}
class AuthFailure extends AuthState {
  final String error;
}

// BLoC Events
abstract class AuthEvent {}
class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  final bool rememberMe;
}
```

#### API Integration with Dio
```dart
// Login API Request
POST /auth/login
Content-Type: application/json

Request Body:
{
  "email": "user@example.com",
  "password": "securePassword123",
  "remember_me": true
}

Response:
{
  "success": true,
  "data": {
    "user": {
      "id": "245677",
      "name": "Ayça Aydoğan",
      "email": "user@example.com",
      "profile_photo": "https://example.com/photo.jpg"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expires_in": 3600
  }
}
```

#### Validation Rules
- **Email**: Valid email format, not empty
- **Password**: Minimum 8 characters, at least one uppercase, lowercase, and number
- **Network**: Handle connection timeouts and server errors

#### Error Handling
- Invalid credentials
- Network connectivity issues
- Server maintenance
- Account locked/suspended
- Email not verified

### 2. Register Screen (Kayıt Ekranı)

#### User Interface Elements
- **Title**: "Merhabalar" with welcome message
- **Email Input**: Registration email with validation
- **Password Input**: Password creation with strength meter
- **Confirm Password**: Password confirmation field
- **Terms Agreement**: "Şifremi unuttum" link
- **Register Button**: "Giriş Yap" - Primary action
- **Login Link**: "Bir hesabın yok mu? Kayıt Ol!" navigation

#### Technical Implementation
```dart
// Registration BLoC Events
class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String confirmPassword;
  final bool acceptTerms;
}

// Validation Logic
class RegistrationValidator {
  static String? validateEmail(String email) {
    if (email.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Invalid email format';
    }
    return null;
  }
  
  static String? validatePassword(String password) {
    if (password.length < 8) return 'Password must be at least 8 characters';
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(password)) {
      return 'Password must contain uppercase, lowercase and number';
    }
    return null;
  }
}
```

#### API Integration
```dart
// Registration API Request
POST /auth/register
Content-Type: application/json

Request Body:
{
  "email": "newuser@example.com",
  "password": "SecurePass123",
  "confirm_password": "SecurePass123",
  "accept_terms": true
}

Response:
{
  "success": true,
  "message": "Registration successful. Please verify your email.",
  "data": {
    "user_id": "new_user_id",
    "verification_required": true
  }
}
```

## Security Implementation

### Token Management
- **Storage**: Secure token storage using Flutter Secure Storage
- **Encryption**: AES-256 encryption for sensitive data
- **Expiration**: Automatic token refresh before expiration
- **Logout**: Secure token invalidation

### Dio Interceptors
```dart
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add authorization header
    final token = TokenStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Handle token expiration
      AuthService.refreshToken();
    }
    super.onError(err, handler);
  }
}
```

### Security Headers
```dart
// Dio Configuration
final dio = Dio(BaseOptions(
  baseUrl: 'https://api.shartflix.com',
  connectTimeout: 30000,
  receiveTimeout: 30000,
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': 'ShartFlix-Mobile/1.0',
  },
));
```

## State Management Flow

### Login Flow
1. User enters credentials
2. Form validation triggers
3. LoginRequested event dispatched
4. AuthBloc validates input
5. API call through Dio
6. Token stored securely
7. Navigation to home screen
8. UI updates with user data

### Registration Flow
1. User fills registration form
2. Client-side validation
3. RegisterRequested event
4. API call with Dio
5. Email verification sent
6. Success message displayed
7. Redirect to login screen

## Error Handling Strategy

### Network Errors
- Connection timeout: Retry mechanism
- Server errors (5xx): Display maintenance message
- Client errors (4xx): Show specific error messages

### Validation Errors
- Real-time field validation
- Clear error messaging
- Form state preservation

### User Experience
- Loading indicators during requests
- Smooth transitions between states
- Accessibility support
- Keyboard navigation

## Testing Strategy

### Unit Tests
- Validation logic testing
- BLoC state transitions
- API response parsing
- Token management functions

### Widget Tests
- Form input validation
- Button state changes
- Error message display
- Navigation behavior

### Integration Tests
- Complete login flow
- Registration process
- Token refresh mechanism
- Social login integration

## Performance Considerations

- Debounced input validation
- Efficient state updates
- Memory leak prevention
- Smooth animations
- Fast authentication checks

## Accessibility Features

- Screen reader support
- High contrast mode
- Large text support
- Voice control compatibility
- Keyboard navigation 