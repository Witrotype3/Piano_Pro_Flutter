import 'package:flutter/material.dart';
import 'package:connect_to_go_server_flutter/core/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    
    return Scaffold(
      backgroundColor: AppTheme.getThemeBackgroundColor(brightness),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Complete some lessons to see your progress.",
              style: TextStyle(
                color: AppTheme.getThemeTextColor(brightness),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 