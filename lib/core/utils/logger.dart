import 'dart:developer' as developer;

class Logger {
  static const String _tag = 'ShartFlix';

  static void info(String message) {
    developer.log(
      '💡 $message',
      name: _tag,
      level: 800,
    );
  }

  static void warning(String message) {
    developer.log(
      '⚠️ $message',
      name: _tag,
      level: 900,
    );
  }

  static void error(String message) {
    developer.log(
      '❌ $message',
      name: _tag,
      level: 1000,
    );
  }

  static void debug(String message) {
    developer.log(
      '🐛 $message',
      name: _tag,
      level: 700,
    );
  }

  static void network(String message) {
    developer.log(
      '🌐 $message',
      name: _tag,
      level: 800,
    );
  }
} 