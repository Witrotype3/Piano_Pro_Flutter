import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connect_to_go_server_flutter/core/theme/app_theme.dart';
import 'package:connect_to_go_server_flutter/core/state/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      backgroundColor: AppTheme.getThemeBackgroundColor(brightness),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.getThemeTextColor(brightness),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: AppTheme.getThemeColor(brightness),
              child: ListTile(
                title: Text(
                  'Theme',
                  style: TextStyle(
                    color: AppTheme.getThemeTextColor(brightness),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'Choose your preferred theme',
                  style: TextStyle(
                    color: AppTheme.getThemeTextColor(brightness).withValues(alpha: 0.7),
                  ),
                ),
                trailing: DropdownButton<ThemeMode>(
                  value: themeProvider.themeMode,
                  onChanged: (ThemeMode? newValue) {
                    if (newValue != null) {
                      themeProvider.setThemeMode(newValue);
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text('System'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text('Light'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text('Dark'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 