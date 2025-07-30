import 'package:connect_to_go_server_flutter/constants/theme.dart';
import 'package:connect_to_go_server_flutter/screens/all_notes_screen.dart';
import 'package:flutter/material.dart';

class LessonsPage extends StatelessWidget {
  const LessonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Scaffold(
      backgroundColor: AppTheme.getThemeBackgroundColor(brightness),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.9,
          children: [
            lessonCard(context, "All Notes", "all_notes.png", screenWidth, Icons.music_note, brightness),
            lessonCard(context, "Chord Mastery", "chord_mastery.png", screenWidth, Icons.queue_music, brightness),
            lessonCard(context, "Pitch Perfect", "pitch_perfect.png", screenWidth, Icons.hearing, brightness),
          ],
        ),
      ),
    );
  }

  Widget lessonCard(BuildContext context, String title, String imageName, double screenWidth, IconData icon, Brightness brightness) {
    return Card(
      color: AppTheme.getThemeColor(brightness),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AllNotesScreen(),));
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Image.asset(
                  'assets/images/$imageName',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppTheme.getThemeTextColor(brightness),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    icon,
                    color: AppTheme.getThemeTextColor(brightness),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
