import 'package:flutter/material.dart';
import 'package:connect_to_go_server_flutter/core/theme/app_theme.dart';
import 'package:connect_to_go_server_flutter/core/constants/app_constants.dart';
import 'package:connect_to_go_server_flutter/features/lessons/presentation/screens/all_notes_screen.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

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
              constraints: const BoxConstraints(maxWidth: AppConstants.maxCardWidth),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = (constraints.maxWidth / 250).floor();
                  crossAxisCount = crossAxisCount.clamp(1, 3);
                  
                  double availableWidth = constraints.maxWidth - (AppConstants.cardSpacing * (crossAxisCount - 1));
                  double cardWidth = (availableWidth / crossAxisCount).clamp(0.0, 250.0);
                  
                  double totalCardsWidth = (cardWidth * crossAxisCount) + (AppConstants.cardSpacing * (crossAxisCount - 1));
                  
                  double horizontalPadding = (constraints.maxWidth - totalCardsWidth) / 2;

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: AppConstants.cardAspectRatio,
                        crossAxisSpacing: AppConstants.cardSpacing,
                        mainAxisSpacing: AppConstants.cardSpacing,
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
                    ),
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
                    builder: (context) => const AllNotesScreen(),
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