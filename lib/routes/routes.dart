import 'package:flutter/material.dart';
import 'package:particle_music/pages/view_entry.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const ViewEntry());
      default:
        return MaterialPageRoute(builder: (_) => const ViewEntry());
    }
  }
}
