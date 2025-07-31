import 'package:connect_to_go_server_flutter/constants/theme.dart';
import 'package:connect_to_go_server_flutter/screens/all_notes_screen.dart';
import 'package:flutter/material.dart';

class LessonsPage extends StatelessWidget {
  const LessonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    // Define lesson data
    final List<Map<String, dynamic>> lessons = [
      {
        'title': 'All Notes',
        'image': 'all_notes.png',
        'icon': Icons.music_note
      },
      {
        'title': 'Chord Mastery',
        'image': 'chord_mastery.png',
        'icon': Icons.queue_music
      },
      {
        'title': 'Pitch Perfect',
        'image': 'pitch_perfect.png',
        'icon': Icons.hearing
      },
    ];

    return Scaffold(
      backgroundColor: AppTheme.getThemeBackgroundColor(brightness),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 800),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = (constraints.maxWidth / 250).floor();
                  crossAxisCount = crossAxisCount.clamp(1, 3);

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: lessons.length,
                    itemBuilder: (context, index) {
                      final lesson = lessons[index];
                      return lessonCard(
                          context,
                          lesson['title']!,
                          lesson['image']!,
                          lesson['icon'] as IconData,
                          brightness);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

    Widget lessonCard(BuildContext context, String title, String imageName,
      IconData icon, Brightness brightness) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = constraints.maxWidth;
        double fontSize = (cardWidth * 0.08).clamp(12.0, 18.0);
        double iconSize = (cardWidth * 0.06).clamp(16.0, 24.0);
        
        return Card(
          color: AppTheme.getThemeColor(brightness),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllNotesScreen(),
                  ));
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/$imageName',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: AppTheme.getThemeTextColor(brightness),
                            fontWeight: FontWeight.bold,
                            fontSize: fontSize,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        icon,
                        color: AppTheme.getThemeTextColor(brightness),
                        size: iconSize,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
