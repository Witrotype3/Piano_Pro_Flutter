import 'package:flutter/material.dart';
import 'package:connect_to_go_server_flutter/core/theme/app_theme.dart';
import 'package:connect_to_go_server_flutter/widgets/piano_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? currentNote;
  List<String> highlightedKeys = [];
  double _currentKeyWidth = 20; // Track current key width for dynamic height

  // Calculate container height based on current piano size
  double get _containerHeight {
    // Base height for controls (zoom controls + spacing)
    const double controlsHeight = 60;
    // Piano height based on key width and aspect ratio (4:1)
    double pianoHeight = _currentKeyWidth * 4.0;
    // Scroll bar height and spacing
    const double scrollBarHeight = 20;
    const double scrollBarSpacing = 12; // 8px + 4px spacing
    const double debugTextHeight = 14; // Height for debug text
    // Add minimal padding
    const double padding = 8;
    return controlsHeight + pianoHeight + scrollBarHeight + scrollBarSpacing + debugTextHeight + padding;
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    
    return Scaffold(
      backgroundColor: AppTheme.getThemeBackgroundColor(brightness),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome to Music Learning!",
              style: TextStyle(
                color: AppTheme.getThemeTextColor(brightness),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            const SizedBox(height: 16),
            Text(
              "Test the 88-Key Piano Widget:",
              style: TextStyle(
                color: AppTheme.getThemeTextColor(brightness),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            
            const SizedBox(height: 16),
            
            // Piano Widget with dynamic height container
            AnimatedContainer(
              duration: const Duration(milliseconds: 300), // Smooth height transitions
              height: _containerHeight,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 2), // Red border for debugging
                borderRadius: BorderRadius.circular(8),
              ),
              child: PianoWidget(
                keyHeight: 100, // This will be overridden by the aspect ratio
                keyWidth: _currentKeyWidth,
                minKeyWidth: 12,
                maxKeyWidth: 35,
                showNoteLabels: true,
                showControls: true, // Show controls
                keyAspectRatio: 4.0, // Maintain 4:1 aspect ratio
                enableAudio: true, // Enable audio playback
                audioVolume: 0.7, // Set volume to 70%
                highlightedKeys: highlightedKeys,
                onKeyWidthChanged: (keyWidth) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      _currentKeyWidth = keyWidth;
                    });
                  });
                },
                onNotePressed: (note) {
                  setState(() {
                    currentNote = note;
                    highlightedKeys = [note];
                  });
                },
                onNoteReleased: (note) {
                  setState(() {
                    currentNote = null;
                    highlightedKeys = [];
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            // Navigation to full piano example
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PianoExample(),
                    ),
                  );
                },
                icon: const Icon(Icons.piano),
                label: const Text('Open Full Piano Example'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 20),
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