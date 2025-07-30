import 'package:connect_to_go_server_flutter/constants/theme.dart';
import 'package:connect_to_go_server_flutter/data/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        // Get the actual brightness considering system mode
        final actualBrightness = themeProvider.getBrightness(context);
        
        return Container(
          color: AppTheme.getThemeBackgroundColor(actualBrightness),
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.dark_mode, color: AppTheme.getThemeTextColor(actualBrightness)),
                title: Text('Dark Mode', style: TextStyle(color: AppTheme.getThemeTextColor(actualBrightness))),
                subtitle: Text(
                  themeProvider.themeMode == ThemeMode.system 
                    ? 'Follows system setting' 
                    : themeProvider.themeMode == ThemeMode.dark 
                      ? 'Dark mode enabled' 
                      : 'Light mode enabled',
                  style: TextStyle(color: AppTheme.getThemeTextColor(actualBrightness).withValues(alpha: 0.7)),
                ),
                trailing: Switch(
                  value: themeProvider.themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    themeProvider.setDarkMode(value);
                  },
                ),
              ),
              ListTile(
                leading: Icon(Icons.settings_system_daydream, color: AppTheme.getThemeTextColor(actualBrightness)),
                title: Text('System Theme', style: TextStyle(color: AppTheme.getThemeTextColor(actualBrightness))),
                subtitle: Text(
                  'Follow system dark/light mode',
                  style: TextStyle(color: AppTheme.getThemeTextColor(actualBrightness).withValues(alpha: 0.7)),
                ),
                trailing: Radio<ThemeMode>(
                  value: ThemeMode.system,
                  groupValue: themeProvider.themeMode,
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      themeProvider.setThemeMode(value);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
