class AppConstants {
  // App Information
  static const String appName = 'Piano Pro';
  static const String appVersion = '1.0.0';
  
  // Navigation
  static const int maxNavigationItems = 3;
  static const double navigationBarHeight = 70.0;
  
  // Lessons
  static const List<String> lessonTitles = ['All Notes', 'Chord Mastery', 'Pitch Perfect'];
  static const List<String> lessonImages = ['all_notes.png', 'chord_mastery.png', 'pitch_perfect.png'];
  
  // Layout
  static const double maxCardWidth = 800.0;
  static const double cardAspectRatio = 1.0;
  static const double cardSpacing = 16.0;
  static const double screenPadding = 32.0;
  
  // Animation
  static const Duration headerAnimationDuration = Duration(milliseconds: 800);
  static const Duration footerAnimationDuration = Duration(milliseconds: 600);
  static const Duration navigationAnimationDuration = Duration(milliseconds: 200);
} 