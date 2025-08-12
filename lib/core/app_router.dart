import 'package:flutter/material.dart';
import 'package:connect_to_go_server_flutter/features/auth/presentation/screens/welcome_screen.dart';
import 'package:connect_to_go_server_flutter/shared/widgets/main_navigation.dart';

class AppRouter {
  static const String welcome = '/';
  static const String home = '/home';
  static const String lessons = '/lessons';
  static const String allNotes = '/all-notes';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    if (settings.name == welcome) {
      return MaterialPageRoute(builder: (_) => const WelcomeScreen());
    } else if (settings.name == home ||
        settings.name == lessons ||
        settings.name == AppRouter.settings) {
      return MaterialPageRoute(builder: (_) => const MainNavigation());
    }
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('No route defined for ${settings.name}'),
        ),
      ),
    );
  }
}
