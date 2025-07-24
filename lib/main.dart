import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/router/app_router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'injection/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🚀 Starting application...');
  
  // Setup dependencies (includes Dio setup)
  await configureDependencies();
  
  // Wait a bit to ensure all dependencies are properly registered
  await Future.delayed(const Duration(milliseconds: 100));
  
  // Initialize router after dependencies are ready
  AppRouter.initialize();
  
  print('✅ All initialization completed, starting app...');
  
  runApp(const App());
}
