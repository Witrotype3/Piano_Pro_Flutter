import 'package:flutter/material.dart';
import 'package:connect_to_go_server_flutter/core/theme/app_theme.dart';
import 'package:connect_to_go_server_flutter/core/constants/app_constants.dart';

class AppNavigation extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final Animation<double>? animation;

  const AppNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.animation,
  });

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  final List<NavigationItem> _navigationItems = [
    const NavigationItem(title: 'Home', icon: Icons.home, subtitle: 'Welcome to Piano Pro'),
    const NavigationItem(title: 'Lessons', icon: Icons.piano, subtitle: 'Choose your lesson'),
    const NavigationItem(title: 'Settings', icon: Icons.settings, subtitle: 'Customize your experience'),
  ];

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    
    return widget.animation != null 
      ? AnimatedBuilder(
          animation: widget.animation!,
          builder: (_, __) {
            return Transform.translate(
              offset: Offset(0, 50 * (1 - widget.animation!.value)),
              child: Opacity(
                opacity: widget.animation!.value.clamp(0.0, 1.0),
                child: _buildNavigationBar(brightness),
              ),
            );
          },
        )
      : _buildNavigationBar(brightness);
  }

  Widget _buildNavigationBar(Brightness brightness) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.getThemeColor(brightness),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: AppConstants.navigationBarHeight,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _buildNavigationItems(brightness),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNavigationItems(Brightness brightness) {
    return List.generate(_navigationItems.length, (index) {
      final item = _navigationItems[index];
      final isSelected = widget.currentIndex == index;
      
      return Expanded(
        child: GestureDetector(
          onTap: () => widget.onTap(index),
          child: AnimatedContainer(
            duration: AppConstants.navigationAnimationDuration,
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected 
                ? AppTheme.getThemeSelectedTextColor(brightness).withValues(alpha: 0.1)
                : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: AppConstants.navigationAnimationDuration,
                  child: Icon(
                    item.icon,
                    color: isSelected 
                      ? AppTheme.getThemeSelectedTextColor(brightness)
                      : AppTheme.getThemeTextColor(brightness).withValues(alpha: 0.7),
                    size: isSelected ? 24 : 20,
                  ),
                ),
                const SizedBox(height: 2),
                AnimatedDefaultTextStyle(
                  duration: AppConstants.navigationAnimationDuration,
                  style: TextStyle(
                    color: isSelected 
                      ? AppTheme.getThemeSelectedTextColor(brightness)
                      : AppTheme.getThemeTextColor(brightness).withValues(alpha: 0.7),
                    fontSize: isSelected ? 10 : 9,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  child: Text(
                    item.title,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class NavigationItem {
  final String title;
  final IconData icon;
  final String subtitle;

  const NavigationItem({
    required this.title,
    required this.icon,
    required this.subtitle,
  });
} 