import 'package:flutter/material.dart';
import 'package:connect_to_go_server_flutter/core/theme/app_theme.dart';
import 'package:connect_to_go_server_flutter/core/constants/app_constants.dart';
import 'package:connect_to_go_server_flutter/shared/widgets/app_navigation.dart';
import 'package:connect_to_go_server_flutter/features/home/presentation/screens/home_screen.dart';
import 'package:connect_to_go_server_flutter/features/lessons/presentation/screens/lessons_screen.dart';
import 'package:connect_to_go_server_flutter/features/settings/presentation/screens/settings_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> with TickerProviderStateMixin {
  AnimationController? _headerAnimationController;
  AnimationController? _footerAnimationController;
  Animation<double>? _headerAnimation;
  Animation<double>? _footerAnimation;

  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const HomeScreen(),
    const LessonsScreen(),
    const SettingsScreen(),
  ];

  final List<String> _titles = ['Home', 'Lessons', 'Settings'];

  @override
  void initState() {
    super.initState();
    _headerAnimationController = AnimationController(
      duration: AppConstants.headerAnimationDuration,
      vsync: this,
    );
    _footerAnimationController = AnimationController(
      duration: AppConstants.footerAnimationDuration,
      vsync: this,
    );
    
    _headerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController!,
      curve: Curves.easeInOut,
    ));
    
    _footerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _footerAnimationController!,
      curve: Curves.easeOutBack,
    ));
    
    _headerAnimationController!.forward();
    _footerAnimationController!.forward();
  }

  @override
  void dispose() {
    _headerAnimationController?.dispose();
    _footerAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    
    return Scaffold(
      backgroundColor: AppTheme.getThemeBackgroundColor(brightness),
      appBar: _buildAppBar(brightness),
      body: _pages[_selectedIndex],
      bottomNavigationBar: AppNavigation(
        currentIndex: _selectedIndex,
        onTap: _onNavigationTap,
        animation: _footerAnimation,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(Brightness brightness) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      title: _headerAnimation != null ? AnimatedBuilder(
        animation: _headerAnimation!,
        builder: (_, __) {
          return Transform.translate(
            offset: Offset(0, 20 * (1 - _headerAnimation!.value)),
            child: Opacity(
              opacity: _headerAnimation!.value,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.getThemeSelectedTextColor(brightness).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getPageIcon(_selectedIndex),
                      color: AppTheme.getThemeSelectedTextColor(brightness),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${_titles[_selectedIndex]} Page',
                          style: TextStyle(
                            color: AppTheme.getThemeTextColor(brightness),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          _getPageSubtitle(_selectedIndex),
                          style: TextStyle(
                            color: AppTheme.getThemeTextColor(brightness).withValues(alpha: 0.7),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ) : Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.getThemeSelectedTextColor(brightness).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getPageIcon(_selectedIndex),
              color: AppTheme.getThemeSelectedTextColor(brightness),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${_titles[_selectedIndex]} Page',
                  style: TextStyle(
                    color: AppTheme.getThemeTextColor(brightness),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  _getPageSubtitle(_selectedIndex),
                  style: TextStyle(
                    color: AppTheme.getThemeTextColor(brightness).withValues(alpha: 0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: AppTheme.getThemeColor(brightness),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.getThemeColor(brightness),
              AppTheme.getThemeColor(brightness).withValues(alpha: 0.9),
              AppTheme.getThemeColor(brightness).withValues(alpha: 0.8),
            ],
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
            backgroundColor: AppTheme.getThemeSelectedTextColor(brightness).withValues(alpha: 0.1),
            child: Icon(
              Icons.person,
              color: AppTheme.getThemeSelectedTextColor(brightness),
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  IconData _getPageIcon(int index) {
    switch (index) {
      case 0:
        return Icons.home;
      case 1:
        return Icons.piano;
      case 2:
        return Icons.settings;
      default:
        return Icons.home;
    }
  }

  String _getPageSubtitle(int index) {
    switch (index) {
      case 0:
        return "Welcome to Piano Pro";
      case 1:
        return "Choose your lesson";
      case 2:
        return "Customize your experience";
      default:
        return "Welcome to Piano Pro";
    }
  }

  void _onNavigationTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
} 