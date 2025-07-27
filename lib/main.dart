import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/router/app_router.dart';
import 'core/injection_container.dart';
import 'core/services/firebase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  debugPrint('🚀 Starting application...');
  
  // Firebase'i başlat
  await FirebaseService.initialize();
  
  // Setup dependencies (includes Dio setup)
  await configureDependencies();
  
  // Wait a bit to ensure all dependencies are properly registered
  await Future.delayed(const Duration(milliseconds: 100));
  
  // Initialize router after dependencies are ready
  AppRouter.initialize();
  
  debugPrint('✅ All initialization completed, starting app...');
  
  runApp(const App());
}
