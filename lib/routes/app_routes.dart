// routes/app_routes.dart
import 'package:flutter/material.dart';
import '../screens/main_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/highlights_screen.dart';
import '../screens/list_screen.dart';

class AppRoutes {
  static final routes = {
    '/': (context) => const SplashScreen(),
    '/main': (context) => const MainScreen(),
    '/highlights': (context) {
      final media = ModalRoute.of(context)?.settings.arguments;
      return HighlightsScreen(media: media);
    },
    '/listall': (context) {
      final mediaType = ModalRoute.of(context)?.settings.arguments as String;
      return ListScreen(mediaType: mediaType);
    },
  };
}
