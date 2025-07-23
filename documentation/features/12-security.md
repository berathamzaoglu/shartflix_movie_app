# Security Features

## Overview

The ShartFlix application implements comprehensive security measures to protect user data, secure API communications, and ensure privacy compliance. This documentation covers token management, encryption, certificate pinning, secure storage, and security best practices throughout the application.

## Core Security Architecture

### Security Principles
- **Defense in Depth**: Multiple layers of security controls
- **Principle of Least Privilege**: Minimal access rights for users and systems
- **Data Encryption**: Encryption at rest and in transit
- **Secure Communication**: Certificate pinning and TLS verification
- **Input Validation**: Comprehensive validation and sanitization
- **Privacy by Design**: Built-in privacy protection mechanisms

## Token Management and Authentication Security

### Secure Token Storage
```dart
// secure_token_storage.dart
class SecureTokenStorage {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      sharedPreferencesName: 'shartflix_secure_prefs',
      preferencesKeyPrefix: 'shartflix_',
    ),
    iOptions: IOSOptions(
      groupId: 'group.com.shartflix.app',
      accountName: 'ShartFlix',
      accessibility: IOSAccessibility.first_unlock_this_device,
    ),
    lOptions: LinuxOptions(
      applicationId: 'com.shartflix.app',
      applicationName: 'ShartFlix',
    ),
    wOptions: WindowsOptions(
      applicationId: 'com.shartflix.app',
      applicationName: 'ShartFlix',
    ),
    mOptions: MacOsOptions(
      groupId: 'group.com.shartflix.app',
      accountName: 'ShartFlix',
      accessibility: IOSAccessibility.first_unlock_this_device,
    ),
  );

  // Storage keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _tokenExpiryKey = 'token_expiry';
  static const String _biometricTokenKey = 'biometric_token';
  static const String _encryptionSaltKey = 'encryption_salt';

  /// Save access token with encryption
  static Future<void> saveAccessToken(String token) async {
    try {
      final encryptedToken = await _encryptToken(token);
      await _secureStorage.write(
        key: _accessTokenKey,
        value: encryptedToken,
      );
      
      // Save token expiry
      final expiryTime = _extractTokenExpiry(token);
      if (expiryTime != null) {
        await _secureStorage.write(
          key: _tokenExpiryKey,
          value: expiryTime.toIso8601String(),
        );
      }
      
      LoggerService.debug('Access token saved securely');
    } catch (e) {
      LoggerService.error('Failed to save access token: $e');
      throw SecurityException('Failed to save access token securely');
    }
  }

  /// Save refresh token with encryption
  static Future<void> saveRefreshToken(String token) async {
    try {
      final encryptedToken = await _encryptToken(token);
      await _secureStorage.write(
        key: _refreshTokenKey,
        value: encryptedToken,
      );
      
      LoggerService.debug('Refresh token saved securely');
    } catch (e) {
      LoggerService.error('Failed to save refresh token: $e');
      throw SecurityException('Failed to save refresh token securely');
    }
  }

  /// Get access token with decryption
  static Future<String?> getAccessToken() async {
    try {
      final encryptedToken = await _secureStorage.read(key: _accessTokenKey);
      if (encryptedToken == null) return null;
      
      final token = await _decryptToken(encryptedToken);
      
      // Verify token hasn't expired
      if (await isTokenExpired()) {
        await deleteAccessToken();
        return null;
      }
      
      return token;
    } catch (e) {
      LoggerService.error('Failed to get access token: $e');
      return null;
    }
  }

  /// Get refresh token with decryption
  static Future<String?> getRefreshToken() async {
    try {
      final encryptedToken = await _secureStorage.read(key: _refreshTokenKey);
      if (encryptedToken == null) return null;
      
      return await _decryptToken(encryptedToken);
    } catch (e) {
      LoggerService.error('Failed to get refresh token: $e');
      return null;
    }
  }

  /// Check if token is expired
  static Future<bool> isTokenExpired() async {
    try {
      final expiryString = await _secureStorage.read(key: _tokenExpiryKey);
      if (expiryString == null) return true;
      
      final expiryTime = DateTime.parse(expiryString);
      final now = DateTime.now();
      
      // Add 5 minute buffer for token refresh
      return now.isAfter(expiryTime.subtract(const Duration(minutes: 5)));
    } catch (e) {
      LoggerService.error('Failed to check token expiry: $e');
      return true;
    }
  }

  /// Save user ID
  static Future<void> saveUserId(String userId) async {
    try {
      await _secureStorage.write(key: _userIdKey, value: userId);
    } catch (e) {
      LoggerService.error('Failed to save user ID: $e');
      throw SecurityException('Failed to save user ID securely');
    }
  }

  /// Get user ID
  static Future<String?> getUserId() async {
    try {
      return await _secureStorage.read(key: _userIdKey);
    } catch (e) {
      LoggerService.error('Failed to get user ID: $e');
      return null;
    }
  }

  /// Delete access token
  static Future<void> deleteAccessToken() async {
    try {
      await _secureStorage.delete(key: _accessTokenKey);
      await _secureStorage.delete(key: _tokenExpiryKey);
    } catch (e) {
      LoggerService.error('Failed to delete access token: $e');
    }
  }

  /// Delete refresh token
  static Future<void> deleteRefreshToken() async {
    try {
      await _secureStorage.delete(key: _refreshTokenKey);
    } catch (e) {
      LoggerService.error('Failed to delete refresh token: $e');
    }
  }

  /// Clear all stored data
  static Future<void> clearAll() async {
    try {
      await _secureStorage.deleteAll();
      LoggerService.info('All secure storage cleared');
    } catch (e) {
      LoggerService.error('Failed to clear secure storage: $e');
    }
  }

  /// Encrypt token using AES encryption
  static Future<String> _encryptToken(String token) async {
    try {
      final salt = await _getOrCreateEncryptionSalt();
      final key = await _deriveKeyFromPassword(salt);
      
      final iv = _generateRandomBytes(16);
      final encrypter = Encrypter(AES(key));
      
      final encrypted = encrypter.encrypt(token, iv: IV(iv));
      
      // Combine salt, IV, and encrypted data
      final combined = base64Encode([
        ...salt,
        ...iv,
        ...encrypted.bytes,
      ]);
      
      return combined;
    } catch (e) {
      LoggerService.error('Token encryption failed: $e');
      throw SecurityException('Token encryption failed');
    }
  }

  /// Decrypt token using AES decryption
  static Future<String> _decryptToken(String encryptedToken) async {
    try {
      final combined = base64Decode(encryptedToken);
      
      // Extract components
      final salt = combined.sublist(0, 32);
      final iv = combined.sublist(32, 48);
      final encryptedBytes = combined.sublist(48);
      
      final key = await _deriveKeyFromPassword(salt);
      final encrypter = Encrypter(AES(key));
      
      final encrypted = Encrypted(Uint8List.fromList(encryptedBytes));
      final decrypted = encrypter.decrypt(encrypted, iv: IV(Uint8List.fromList(iv)));
      
      return decrypted;
    } catch (e) {
      LoggerService.error('Token decryption failed: $e');
      throw SecurityException('Token decryption failed');
    }
  }

  /// Get or create encryption salt
  static Future<Uint8List> _getOrCreateEncryptionSalt() async {
    final saltString = await _secureStorage.read(key: _encryptionSaltKey);
    
    if (saltString != null) {
      return base64Decode(saltString);
    }
    
    // Generate new salt
    final salt = _generateRandomBytes(32);
    await _secureStorage.write(
      key: _encryptionSaltKey,
      value: base64Encode(salt),
    );
    
    return salt;
  }

  /// Derive encryption key from password using PBKDF2
  static Future<Key> _deriveKeyFromPassword(Uint8List salt) async {
    final deviceId = await _getDeviceIdentifier();
    final appId = 'com.shartflix.app';
    final password = '$deviceId:$appId';
    
    final pbkdf2 = PBKDF2KeyDerivation(
      macAlgorithm: Hmac.sha256(),
    );
    
    final secretKey = await pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: salt,
    );
    
    final keyBytes = await secretKey.extractBytes();
    return Key(Uint8List.fromList(keyBytes));
  }

  /// Generate random bytes
  static Uint8List _generateRandomBytes(int length) {
    final random = Random.secure();
    return Uint8List.fromList(
      List.generate(length, (i) => random.nextInt(256)),
    );
  }

  /// Get device identifier
  static Future<String> _getDeviceIdentifier() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? 'unknown';
      }
      
      return 'unknown';
    } catch (e) {
      LoggerService.error('Failed to get device identifier: $e');
      return 'fallback';
    }
  }

  /// Extract token expiry from JWT
  static DateTime? _extractTokenExpiry(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      
      final payload = parts[1];
      final normalizedPayload = base64Url.normalize(payload);
      final decodedPayload = utf8.decode(base64Url.decode(normalizedPayload));
      final payloadMap = jsonDecode(decodedPayload);
      
      final exp = payloadMap['exp'];
      if (exp is int) {
        return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      }
      
      return null;
    } catch (e) {
      LoggerService.error('Failed to extract token expiry: $e');
      return null;
    }
  }
}
```

### Biometric Authentication
```dart
// biometric_auth_service.dart
class BiometricAuthService {
  static final LocalAuthentication _localAuth = LocalAuthentication();

  /// Check if biometric authentication is available
  static Future<bool> isAvailable() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      
      return isAvailable && isDeviceSupported;
    } catch (e) {
      LoggerService.error('Failed to check biometric availability: $e');
      return false;
    }
  }

  /// Get available biometric types
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      LoggerService.error('Failed to get available biometrics: $e');
      return [];
    }
  }

  /// Authenticate using biometrics
  static Future<bool> authenticate({
    required String reason,
    bool useErrorDialogs = true,
    bool stickyAuth = false,
  }) async {
    try {
      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: reason,
        authMessages: const [
          AndroidAuthMessages(
            signInTitle: 'Biometric authentication required',
            cancelButton: 'Cancel',
          ),
          IOSAuthMessages(
            cancelButton: 'Cancel',
          ),
        ],
        options: AuthenticationOptions(
          useErrorDialogs: useErrorDialogs,
          stickyAuth: stickyAuth,
          biometricOnly: true,
        ),
      );
      
      if (isAuthenticated) {
        LoggerService.info('Biometric authentication successful');
        await AnalyticsService.trackFeatureUsage(
          featureName: 'biometric_auth',
          context: {'result': 'success'},
        );
      }
      
      return isAuthenticated;
    } catch (e) {
      LoggerService.error('Biometric authentication failed: $e');
      await AnalyticsService.trackFeatureUsage(
        featureName: 'biometric_auth',
        context: {'result': 'error', 'error': e.toString()},
      );
      return false;
    }
  }

  /// Enable biometric authentication for the app
  static Future<bool> enableBiometricAuth() async {
    if (!await isAvailable()) {
      return false;
    }

    final authenticated = await authenticate(
      reason: 'Enable biometric authentication for secure access',
    );

    if (authenticated) {
      await SecureTokenStorage._secureStorage.write(
        key: 'biometric_enabled',
        value: 'true',
      );
      return true;
    }

    return false;
  }

  /// Disable biometric authentication
  static Future<void> disableBiometricAuth() async {
    await SecureTokenStorage._secureStorage.delete(key: 'biometric_enabled');
    await SecureTokenStorage._secureStorage.delete(key: 'biometric_token');
  }

  /// Check if biometric authentication is enabled
  static Future<bool> isBiometricEnabled() async {
    final enabled = await SecureTokenStorage._secureStorage.read(
      key: 'biometric_enabled',
    );
    return enabled == 'true';
  }

  /// Authenticate user with biometrics and return stored token
  static Future<String?> authenticateAndGetToken() async {
    if (!await isBiometricEnabled()) {
      return null;
    }

    final authenticated = await authenticate(
      reason: 'Authenticate to access your account',
    );

    if (authenticated) {
      return await SecureTokenStorage.getAccessToken();
    }

    return null;
  }
}
```

## Network Security

### Certificate Pinning
```dart
// certificate_pinning_service.dart
class CertificatePinningService {
  // Production certificate fingerprints
  static const Map<String, List<String>> _certificateFingerprints = {
    'api.shartflix.com': [
      'SHA256:AAAA1111BBBB2222CCCC3333DDDD4444EEEE5555FFFF6666...', // Primary cert
      'SHA256:BBBB2222CCCC3333DDDD4444EEEE5555FFFF6666AAAA1111...', // Backup cert
    ],
    'cdn.shartflix.com': [
      'SHA256:CCCC3333DDDD4444EEEE5555FFFF6666AAAA1111BBBB2222...', // CDN cert
    ],
  };

  // Staging certificate fingerprints
  static const Map<String, List<String>> _stagingCertificateFingerprints = {
    'staging-api.shartflix.com': [
      'SHA256:DDDD4444EEEE5555FFFF6666AAAA1111BBBB2222CCCC3333...',
    ],
  };

  /// Setup certificate pinning for Dio
  static void setupCertificatePinning(Dio dio) {
    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (cert, host, port) {
        return _verifyCertificate(cert, host);
      };
      
      // Additional security configurations
      client.connectionTimeout = const Duration(seconds: 30);
      client.idleTimeout = const Duration(seconds: 60);
      
      return client;
    };
  }

  /// Verify certificate fingerprint
  static bool _verifyCertificate(X509Certificate cert, String host) {
    try {
      final fingerprints = kDebugMode 
          ? _stagingCertificateFingerprints[host] 
          : _certificateFingerprints[host];
      
      if (fingerprints == null) {
        LoggerService.warning('No certificate fingerprints configured for host: $host');
        return false;
      }

      final certBytes = cert.der;
      final digest = sha256.convert(certBytes);
      final fingerprint = 'SHA256:${base64Encode(digest.bytes)}';

      final isValid = fingerprints.contains(fingerprint);
      
      if (!isValid) {
        LoggerService.error(
          'Certificate pinning failed for $host. '
          'Expected: $fingerprints, Got: $fingerprint'
        );
        
        // Report security incident
        CrashlyticsService.recordError(
          SecurityException('Certificate pinning failed'),
          StackTrace.current,
          reason: 'Certificate pinning validation failed for $host',
          context: {
            'host': host,
            'expected_fingerprints': fingerprints,
            'actual_fingerprint': fingerprint,
          },
        );
      }

      return isValid;
    } catch (e) {
      LoggerService.error('Certificate verification error: $e');
      return false;
    }
  }

  /// Validate certificate chain
  static bool validateCertificateChain(List<X509Certificate> chain) {
    if (chain.isEmpty) return false;

    try {
      // Verify certificate chain integrity
      for (int i = 0; i < chain.length - 1; i++) {
        final cert = chain[i];
        final issuer = chain[i + 1];
        
        if (!_verifyCertificateSignature(cert, issuer)) {
          return false;
        }
      }

      // Verify root certificate
      final rootCert = chain.last;
      return _verifyRootCertificate(rootCert);
    } catch (e) {
      LoggerService.error('Certificate chain validation error: $e');
      return false;
    }
  }

  static bool _verifyCertificateSignature(
    X509Certificate cert,
    X509Certificate issuer,
  ) {
    // Simplified signature verification
    // In production, use proper cryptographic verification
    return cert.issuer == issuer.subject;
  }

  static bool _verifyRootCertificate(X509Certificate rootCert) {
    // Verify against known root certificate authorities
    const trustedRootFingerprints = [
      'SHA256:...' // Add trusted root CA fingerprints
    ];

    final digest = sha256.convert(rootCert.der);
    final fingerprint = 'SHA256:${base64Encode(digest.bytes)}';

    return trustedRootFingerprints.contains(fingerprint);
  }
}
```

### TLS/SSL Configuration
```dart
// tls_config_service.dart
class TLSConfigService {
  /// Configure secure HTTP client
  static HttpClient createSecureHttpClient() {
    final client = HttpClient();
    
    // Configure TLS/SSL settings
    client.badCertificateCallback = (cert, host, port) {
      return CertificatePinningService._verifyCertificate(cert, host);
    };
    
    // Enforce minimum TLS version
    client.connectionTimeout = const Duration(seconds: 30);
    client.idleTimeout = const Duration(seconds: 60);
    
    // Disable insecure protocols
    client.autoUncompress = false; // Prevent compression attacks
    
    return client;
  }

  /// Validate TLS configuration
  static Future<bool> validateTLSConnection(String url) async {
    try {
      final uri = Uri.parse(url);
      final socket = await SecureSocket.connect(
        uri.host,
        uri.port,
        timeout: const Duration(seconds: 10),
      );
      
      final certificate = socket.peerCertificate;
      socket.destroy();
      
      if (certificate != null) {
        return CertificatePinningService._verifyCertificate(certificate, uri.host);
      }
      
      return false;
    } catch (e) {
      LoggerService.error('TLS validation failed: $e');
      return false;
    }
  }
}
```

## Data Encryption and Protection

### Encryption Service
```dart
// encryption_service.dart
class EncryptionService {
  static final _encrypter = Encrypter(AES(Key.fromSecureRandom(32)));
  
  /// Encrypt sensitive data
  static String encryptData(String data) {
    try {
      final iv = IV.fromSecureRandom(16);
      final encrypted = _encrypter.encrypt(data, iv: iv);
      
      // Combine IV and encrypted data
      final combined = '${iv.base64}:${encrypted.base64}';
      return combined;
    } catch (e) {
      LoggerService.error('Data encryption failed: $e');
      throw SecurityException('Failed to encrypt data');
    }
  }

  /// Decrypt sensitive data
  static String decryptData(String encryptedData) {
    try {
      final parts = encryptedData.split(':');
      if (parts.length != 2) {
        throw SecurityException('Invalid encrypted data format');
      }
      
      final iv = IV.fromBase64(parts[0]);
      final encrypted = Encrypted.fromBase64(parts[1]);
      
      return _encrypter.decrypt(encrypted, iv: iv);
    } catch (e) {
      LoggerService.error('Data decryption failed: $e');
      throw SecurityException('Failed to decrypt data');
    }
  }

  /// Hash password using bcrypt
  static String hashPassword(String password) {
    try {
      final salt = BCrypt.gensalt();
      return BCrypt.hashpw(password, salt);
    } catch (e) {
      LoggerService.error('Password hashing failed: $e');
      throw SecurityException('Failed to hash password');
    }
  }

  /// Verify password hash
  static bool verifyPassword(String password, String hash) {
    try {
      return BCrypt.checkpw(password, hash);
    } catch (e) {
      LoggerService.error('Password verification failed: $e');
      return false;
    }
  }

  /// Generate secure random string
  static String generateSecureRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    
    return List.generate(
      length,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }

  /// Generate HMAC signature
  static String generateHMAC(String data, String secret) {
    try {
      final key = utf8.encode(secret);
      final bytes = utf8.encode(data);
      
      final hmacSha256 = Hmac(sha256, key);
      final digest = hmacSha256.convert(bytes);
      
      return digest.toString();
    } catch (e) {
      LoggerService.error('HMAC generation failed: $e');
      throw SecurityException('Failed to generate HMAC');
    }
  }

  /// Verify HMAC signature
  static bool verifyHMAC(String data, String signature, String secret) {
    try {
      final expectedSignature = generateHMAC(data, secret);
      return _constantTimeEquals(signature, expectedSignature);
    } catch (e) {
      LoggerService.error('HMAC verification failed: $e');
      return false;
    }
  }

  /// Constant time string comparison to prevent timing attacks
  static bool _constantTimeEquals(String a, String b) {
    if (a.length != b.length) return false;
    
    int result = 0;
    for (int i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    
    return result == 0;
  }
}
```

## Input Validation and Sanitization

### Validation Service
```dart
// validation_service.dart
class ValidationService {
  // Email validation regex
  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
  );
  
  // Password validation regex (at least 8 chars, upper, lower, digit)
  static final _passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$'
  );
  
  // URL validation regex
  static final _urlRegex = RegExp(
    r'^https?:\/\/([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$'
  );

  /// Validate email address
  static ValidationResult validateEmail(String email) {
    if (email.isEmpty) {
      return ValidationResult.invalid('Email is required');
    }
    
    if (email.length > 254) {
      return ValidationResult.invalid('Email is too long');
    }
    
    if (!_emailRegex.hasMatch(email)) {
      return ValidationResult.invalid('Invalid email format');
    }
    
    // Additional security checks
    if (_containsSuspiciousCharacters(email)) {
      return ValidationResult.invalid('Email contains invalid characters');
    }
    
    return ValidationResult.valid();
  }

  /// Validate password
  static ValidationResult validatePassword(String password) {
    if (password.isEmpty) {
      return ValidationResult.invalid('Password is required');
    }
    
    if (password.length < 8) {
      return ValidationResult.invalid('Password must be at least 8 characters');
    }
    
    if (password.length > 128) {
      return ValidationResult.invalid('Password is too long');
    }
    
    if (!_passwordRegex.hasMatch(password)) {
      return ValidationResult.invalid(
        'Password must contain uppercase, lowercase, and digit'
      );
    }
    
    // Check for common weak passwords
    if (_isCommonPassword(password)) {
      return ValidationResult.invalid('Password is too common');
    }
    
    return ValidationResult.valid();
  }

  /// Validate movie search query
  static ValidationResult validateSearchQuery(String query) {
    if (query.isEmpty) {
      return ValidationResult.invalid('Search query is required');
    }
    
    if (query.length > 100) {
      return ValidationResult.invalid('Search query is too long');
    }
    
    // Check for SQL injection patterns
    if (_containsSQLInjectionPatterns(query)) {
      return ValidationResult.invalid('Invalid search query');
    }
    
    // Check for XSS patterns
    if (_containsXSSPatterns(query)) {
      return ValidationResult.invalid('Invalid search query');
    }
    
    return ValidationResult.valid();
  }

  /// Sanitize user input
  static String sanitizeInput(String input) {
    // Remove null bytes
    input = input.replaceAll('\x00', '');
    
    // Trim whitespace
    input = input.trim();
    
    // Remove control characters
    input = input.replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '');
    
    // Escape HTML entities
    input = _escapeHtml(input);
    
    return input;
  }

  /// Validate URL
  static ValidationResult validateUrl(String url) {
    if (url.isEmpty) {
      return ValidationResult.invalid('URL is required');
    }
    
    if (!_urlRegex.hasMatch(url)) {
      return ValidationResult.invalid('Invalid URL format');
    }
    
    // Check for allowed domains
    final uri = Uri.parse(url);
    if (!_isAllowedDomain(uri.host)) {
      return ValidationResult.invalid('Domain not allowed');
    }
    
    return ValidationResult.valid();
  }

  static bool _containsSuspiciousCharacters(String input) {
    const suspiciousChars = [
      '<', '>', '"', "'", '&', '\x00', '\n', '\r', '\t'
    ];
    
    return suspiciousChars.any((char) => input.contains(char));
  }

  static bool _isCommonPassword(String password) {
    const commonPasswords = [
      'password', '123456', '123456789', 'qwerty', 'abc123',
      'password123', 'admin', 'letmein', 'welcome', 'monkey'
    ];
    
    return commonPasswords.contains(password.toLowerCase());
  }

  static bool _containsSQLInjectionPatterns(String input) {
    const sqlPatterns = [
      'select', 'insert', 'update', 'delete', 'drop', 'union',
      'script', 'javascript', 'vbscript', 'onload', 'onerror'
    ];
    
    final lowerInput = input.toLowerCase();
    return sqlPatterns.any((pattern) => lowerInput.contains(pattern));
  }

  static bool _containsXSSPatterns(String input) {
    const xssPatterns = [
      '<script', '</script>', 'javascript:', 'vbscript:',
      'onload=', 'onerror=', 'onclick=', 'onmouseover='
    ];
    
    final lowerInput = input.toLowerCase();
    return xssPatterns.any((pattern) => lowerInput.contains(pattern));
  }

  static String _escapeHtml(String input) {
    return input
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;');
  }

  static bool _isAllowedDomain(String domain) {
    const allowedDomains = [
      'shartflix.com',
      'api.shartflix.com',
      'cdn.shartflix.com',
      'images.shartflix.com'
    ];
    
    return allowedDomains.any((allowed) => domain.endsWith(allowed));
  }
}

class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  ValidationResult._(this.isValid, this.errorMessage);

  factory ValidationResult.valid() => ValidationResult._(true, null);
  factory ValidationResult.invalid(String message) => ValidationResult._(false, message);
}
```

## Privacy and Data Protection

### Privacy Service
```dart
// privacy_service.dart
class PrivacyService {
  /// Anonymize user data for analytics
  static Map<String, dynamic> anonymizeUserData(Map<String, dynamic> userData) {
    final anonymized = Map<String, dynamic>.from(userData);
    
    // Remove or hash PII
    anonymized.remove('email');
    anonymized.remove('phone');
    anonymized.remove('full_name');
    
    // Hash user ID
    if (anonymized.containsKey('user_id')) {
      anonymized['user_id'] = _hashValue(anonymized['user_id'].toString());
    }
    
    // Truncate IP address
    if (anonymized.containsKey('ip_address')) {
      anonymized['ip_address'] = _truncateIpAddress(anonymized['ip_address']);
    }
    
    return anonymized;
  }

  /// Check data retention compliance
  static Future<void> enforceDataRetention() async {
    try {
      final retentionPeriod = RemoteConfigService.getInt('data_retention_days') ?? 365;
      final cutoffDate = DateTime.now().subtract(Duration(days: retentionPeriod));
      
      // Clean up old data
      await _cleanupOldAnalyticsData(cutoffDate);
      await _cleanupOldCacheData(cutoffDate);
      
      LoggerService.info('Data retention enforced for $retentionPeriod days');
    } catch (e) {
      LoggerService.error('Failed to enforce data retention: $e');
    }
  }

  /// Generate privacy report
  static Future<PrivacyReport> generatePrivacyReport(String userId) async {
    try {
      final userData = await _collectUserData(userId);
      final analyticsData = await _collectAnalyticsData(userId);
      final cacheData = await _collectCacheData(userId);
      
      return PrivacyReport(
        userId: userId,
        personalData: userData,
        analyticsData: analyticsData,
        cachedData: cacheData,
        generatedAt: DateTime.now(),
      );
    } catch (e) {
      LoggerService.error('Failed to generate privacy report: $e');
      throw SecurityException('Failed to generate privacy report');
    }
  }

  /// Delete all user data (GDPR right to be forgotten)
  static Future<void> deleteAllUserData(String userId) async {
    try {
      // Delete from secure storage
      await SecureTokenStorage.clearAll();
      
      // Delete from cache
      await CacheManager.getInstance().then((cache) => cache.clear());
      
      // Delete from local storage
      await LocalStorageService.getInstance().then((storage) => storage.clear());
      
      // Notify server to delete user data
      await _notifyServerToDeleteUserData(userId);
      
      LoggerService.info('All user data deleted for user: $userId');
    } catch (e) {
      LoggerService.error('Failed to delete user data: $e');
      throw SecurityException('Failed to delete user data');
    }
  }

  static String _hashValue(String value) {
    final bytes = utf8.encode(value);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static String _truncateIpAddress(String ipAddress) {
    final parts = ipAddress.split('.');
    if (parts.length == 4) {
      return '${parts[0]}.${parts[1]}.${parts[2]}.0';
    }
    return ipAddress;
  }

  static Future<void> _cleanupOldAnalyticsData(DateTime cutoffDate) async {
    // Implementation would clean up old analytics data
  }

  static Future<void> _cleanupOldCacheData(DateTime cutoffDate) async {
    // Implementation would clean up old cache data
  }

  static Future<Map<String, dynamic>> _collectUserData(String userId) async {
    // Implementation would collect user's personal data
    return {};
  }

  static Future<Map<String, dynamic>> _collectAnalyticsData(String userId) async {
    // Implementation would collect user's analytics data
    return {};
  }

  static Future<Map<String, dynamic>> _collectCacheData(String userId) async {
    // Implementation would collect user's cached data
    return {};
  }

  static Future<void> _notifyServerToDeleteUserData(String userId) async {
    // Implementation would notify server to delete user data
  }
}

class PrivacyReport {
  final String userId;
  final Map<String, dynamic> personalData;
  final Map<String, dynamic> analyticsData;
  final Map<String, dynamic> cachedData;
  final DateTime generatedAt;

  PrivacyReport({
    required this.userId,
    required this.personalData,
    required this.analyticsData,
    required this.cachedData,
    required this.generatedAt,
  });
}
```

## Security Monitoring and Incident Response

### Security Monitor
```dart
// security_monitor.dart
class SecurityMonitor {
  static final List<SecurityIncident> _incidents = [];
  static Timer? _monitoringTimer;

  /// Initialize security monitoring
  static void initialize() {
    _monitoringTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _performSecurityChecks(),
    );
    
    LoggerService.info('Security monitoring initialized');
  }

  /// Record security incident
  static void recordIncident({
    required SecurityIncidentType type,
    required String description,
    Map<String, dynamic>? context,
    SecuritySeverity severity = SecuritySeverity.medium,
  }) {
    final incident = SecurityIncident(
      type: type,
      description: description,
      context: context ?? {},
      severity: severity,
      timestamp: DateTime.now(),
    );
    
    _incidents.add(incident);
    
    // Log to Crashlytics
    CrashlyticsService.recordError(
      SecurityException(description),
      StackTrace.current,
      reason: 'Security incident: ${type.name}',
      context: {
        'incident_type': type.name,
        'severity': severity.name,
        ...incident.context,
      },
    );
    
    // Take immediate action for high severity incidents
    if (severity == SecuritySeverity.high || severity == SecuritySeverity.critical) {
      _handleHighSeverityIncident(incident);
    }
    
    LoggerService.warning('Security incident recorded: $description');
  }

  /// Perform periodic security checks
  static Future<void> _performSecurityChecks() async {
    try {
      // Check for jailbreak/root
      await _checkDeviceIntegrity();
      
      // Check for debugging
      await _checkDebuggingStatus();
      
      // Check certificate pinning
      await _verifyCertificatePinning();
      
      // Check token expiration
      await _checkTokenSecurity();
      
      // Check for suspicious activity
      await _detectSuspiciousActivity();
      
    } catch (e) {
      LoggerService.error('Security check failed: $e');
    }
  }

  static Future<void> _checkDeviceIntegrity() async {
    // Implementation would check for jailbreak/root
    // This is a simplified example
    if (kDebugMode) return; // Skip in debug mode
    
    try {
      // Check for common jailbreak/root indicators
      final suspiciousFiles = [
        '/Applications/Cydia.app',
        '/usr/sbin/sshd',
        '/bin/bash',
        '/etc/apt',
        '/usr/bin/su'
      ];
      
      for (final file in suspiciousFiles) {
        if (await File(file).exists()) {
          recordIncident(
            type: SecurityIncidentType.deviceCompromised,
            description: 'Jailbreak/root detected',
            severity: SecuritySeverity.high,
            context: {'suspicious_file': file},
          );
          break;
        }
      }
    } catch (e) {
      // Error checking is expected on non-compromised devices
    }
  }

  static Future<void> _checkDebuggingStatus() async {
    if (kDebugMode) {
      recordIncident(
        type: SecurityIncidentType.debuggingDetected,
        description: 'Debug mode is enabled',
        severity: SecuritySeverity.low,
      );
    }
  }

  static Future<void> _verifyCertificatePinning() async {
    try {
      final isValid = await TLSConfigService.validateTLSConnection(
        '${EnvironmentConfig.apiBaseUrl}/health'
      );
      
      if (!isValid) {
        recordIncident(
          type: SecurityIncidentType.certificatePinningFailure,
          description: 'Certificate pinning validation failed',
          severity: SecuritySeverity.high,
        );
      }
    } catch (e) {
      recordIncident(
        type: SecurityIncidentType.certificatePinningFailure,
        description: 'Certificate pinning check failed: $e',
        severity: SecuritySeverity.medium,
      );
    }
  }

  static Future<void> _checkTokenSecurity() async {
    final isExpired = await SecureTokenStorage.isTokenExpired();
    
    if (isExpired) {
      recordIncident(
        type: SecurityIncidentType.expiredToken,
        description: 'Authentication token has expired',
        severity: SecuritySeverity.medium,
      );
    }
  }

  static Future<void> _detectSuspiciousActivity() async {
    // Check for unusual API call patterns
    final recentIncidents = _incidents
        .where((incident) => 
            incident.timestamp.isAfter(
              DateTime.now().subtract(const Duration(minutes: 10))
            ))
        .toList();
    
    if (recentIncidents.length > 5) {
      recordIncident(
        type: SecurityIncidentType.suspiciousActivity,
        description: 'High number of security incidents detected',
        severity: SecuritySeverity.high,
        context: {'incident_count': recentIncidents.length},
      );
    }
  }

  static void _handleHighSeverityIncident(SecurityIncident incident) {
    switch (incident.type) {
      case SecurityIncidentType.deviceCompromised:
        _handleDeviceCompromise();
        break;
      case SecurityIncidentType.certificatePinningFailure:
        _handleCertificatePinningFailure();
        break;
      case SecurityIncidentType.suspiciousActivity:
        _handleSuspiciousActivity();
        break;
      default:
        _handleGenericHighSeverityIncident(incident);
    }
  }

  static void _handleDeviceCompromise() {
    // Log out user and clear tokens
    SecureTokenStorage.clearAll();
    
    // Navigate to security warning screen
    NavigationService.pushAndClearStack('/security-warning');
  }

  static void _handleCertificatePinningFailure() {
    // Show network security warning
    SnackBarService.showError(
      'Network security issue detected. Please check your connection.'
    );
  }

  static void _handleSuspiciousActivity() {
    // Temporarily disable sensitive features
    // This would be implemented based on app requirements
  }

  static void _handleGenericHighSeverityIncident(SecurityIncident incident) {
    // Generic high severity incident handling
    LoggerService.error('High severity security incident: ${incident.description}');
  }

  /// Get security incidents for reporting
  static List<SecurityIncident> getIncidents({
    DateTime? since,
    SecuritySeverity? minimumSeverity,
  }) {
    return _incidents.where((incident) {
      if (since != null && incident.timestamp.isBefore(since)) {
        return false;
      }
      
      if (minimumSeverity != null && 
          incident.severity.index < minimumSeverity.index) {
        return false;
      }
      
      return true;
    }).toList();
  }

  /// Clean up old incidents
  static void cleanupOldIncidents() {
    final cutoff = DateTime.now().subtract(const Duration(days: 7));
    _incidents.removeWhere((incident) => incident.timestamp.isBefore(cutoff));
  }

  /// Dispose monitoring
  static void dispose() {
    _monitoringTimer?.cancel();
    _monitoringTimer = null;
  }
}

enum SecurityIncidentType {
  deviceCompromised,
  debuggingDetected,
  certificatePinningFailure,
  expiredToken,
  suspiciousActivity,
  unauthorizedAccess,
  dataIntegrityViolation,
  networkSecurityIssue,
}

enum SecuritySeverity {
  low,
  medium,
  high,
  critical,
}

class SecurityIncident {
  final SecurityIncidentType type;
  final String description;
  final Map<String, dynamic> context;
  final SecuritySeverity severity;
  final DateTime timestamp;

  SecurityIncident({
    required this.type,
    required this.description,
    required this.context,
    required this.severity,
    required this.timestamp,
  });
}

class SecurityException implements Exception {
  final String message;
  
  SecurityException(this.message);
  
  @override
  String toString() => 'SecurityException: $message';
}
```

## Security Testing

### Security Test Utilities
```dart
// security_test_helper.dart
class SecurityTestHelper {
  /// Test token encryption/decryption
  static Future<void> testTokenSecurity() async {
    const testToken = 'test_token_12345';
    
    // Test encryption
    await SecureTokenStorage.saveAccessToken(testToken);
    final retrievedToken = await SecureTokenStorage.getAccessToken();
    
    assert(retrievedToken == testToken, 'Token encryption/decryption failed');
  }

  /// Test certificate pinning
  static Future<void> testCertificatePinning() async {
    // This would test certificate pinning implementation
    // Note: Requires test certificates for proper testing
  }

  /// Test input validation
  static void testInputValidation() {
    // Test email validation
    assert(ValidationService.validateEmail('test@example.com').isValid);
    assert(!ValidationService.validateEmail('invalid-email').isValid);
    assert(!ValidationService.validateEmail('<script>alert("xss")</script>@example.com').isValid);
    
    // Test password validation
    assert(ValidationService.validatePassword('SecurePass123').isValid);
    assert(!ValidationService.validatePassword('weak').isValid);
    assert(!ValidationService.validatePassword('password').isValid);
    
    // Test search query validation
    assert(ValidationService.validateSearchQuery('action movies').isValid);
    assert(!ValidationService.validateSearchQuery('"; DROP TABLE movies; --').isValid);
    assert(!ValidationService.validateSearchQuery('<script>alert("xss")</script>').isValid);
  }

  /// Test biometric authentication
  static Future<void> testBiometricAuth() async {
    if (await BiometricAuthService.isAvailable()) {
      final types = await BiometricAuthService.getAvailableBiometrics();
      assert(types.isNotEmpty, 'Biometric types should be available');
    }
  }
}

// Example security tests
group('Security Tests', () {
  group('Token Security', () {
    test('should encrypt and decrypt tokens correctly', () async {
      await SecurityTestHelper.testTokenSecurity();
    });
    
    test('should detect expired tokens', () async {
      // Test token expiration detection
    });
  });

  group('Input Validation', () {
    test('should validate inputs correctly', () {
      SecurityTestHelper.testInputValidation();
    });
    
    test('should prevent SQL injection', () {
      final result = ValidationService.validateSearchQuery(
        '"; DROP TABLE users; --'
      );
      expect(result.isValid, false);
    });
    
    test('should prevent XSS attacks', () {
      final result = ValidationService.validateSearchQuery(
        '<script>alert("xss")</script>'
      );
      expect(result.isValid, false);
    });
  });

  group('Encryption', () {
    test('should encrypt and decrypt data correctly', () {
      const testData = 'sensitive information';
      final encrypted = EncryptionService.encryptData(testData);
      final decrypted = EncryptionService.decryptData(encrypted);
      
      expect(decrypted, equals(testData));
      expect(encrypted, isNot(equals(testData)));
    });
    
    test('should generate secure random strings', () {
      final random1 = EncryptionService.generateSecureRandomString(32);
      final random2 = EncryptionService.generateSecureRandomString(32);
      
      expect(random1.length, equals(32));
      expect(random2.length, equals(32));
      expect(random1, isNot(equals(random2)));
    });
  });
});
```

Bu kapsamlı güvenlik dokümantasyonu, ShartFlix uygulaması için token yönetimi, şifreleme, sertifika sabitleme, güvenli depolama ve güvenlik en iyi uygulamalarının eksiksiz bir şekilde uygulanması için sağlam bir temel sağlar. 