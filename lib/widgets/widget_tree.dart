import 'package:connect_to_go_server_flutter/constants/theme.dart';
import 'package:connect_to_go_server_flutter/screens/home_screen.dart';
import 'package:connect_to_go_server_flutter/screens/lessons_screen.dart';
import 'package:connect_to_go_server_flutter/screens/settings_screen.dart';
import 'package:flutter/material.dart';

Widget pageNavigation = HomePage();
Text pageTitle = Text("Home Page", style: TextStyle(fontWeight: FontWeight.bold),);
final _titles = ["Home", "Lessons", "Settings"];
final _pages = [HomePage(), LessonsPage(), SettingsPage()];
int _selectedIndex = 0;

final Map<int, dynamic> pagesMap = {
  10: "image",
};

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> with TickerProviderStateMixin {
  AnimationController? _headerAnimationController;
  AnimationController? _footerAnimationController;
  Animation<double>? _headerAnimation;
  Animation<double>? _footerAnimation;

  @override
  void initState() {
    super.initState();
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _footerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
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
    double screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    
    return Scaffold(
      backgroundColor: AppTheme.getThemeBackgroundColor(brightness),
      appBar: appBar(brightness),
      body: body(screenWidth),
      bottomNavigationBar: bottomNav(brightness),
    );
  }

  PreferredSizeWidget appBar(Brightness brightness) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 8,
      shadowColor: Colors.black.withOpacity(0.1),
      title: _headerAnimation != null ? AnimatedBuilder(
        animation: _headerAnimation!,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 20 * (1 - _headerAnimation!.value)),
            child: Opacity(
              opacity: _headerAnimation!.value,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.getThemeSelectedTextColor(brightness).withOpacity(0.1),
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
                          pageTitle.data ?? "Home Page",
                          style: TextStyle(
                            color: AppTheme.getThemeTextColor(brightness),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          _getPageSubtitle(_selectedIndex),
                          style: TextStyle(
                            color: AppTheme.getThemeTextColor(brightness).withOpacity(0.7),
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
              color: AppTheme.getThemeSelectedTextColor(brightness).withOpacity(0.1),
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
                  pageTitle.data ?? "Home Page",
                  style: TextStyle(
                    color: AppTheme.getThemeTextColor(brightness),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  _getPageSubtitle(_selectedIndex),
                  style: TextStyle(
                    color: AppTheme.getThemeTextColor(brightness).withOpacity(0.7),
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
              AppTheme.getThemeColor(brightness).withOpacity(0.9),
              AppTheme.getThemeColor(brightness).withOpacity(0.8),
            ],
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
            backgroundColor: AppTheme.getThemeSelectedTextColor(brightness).withOpacity(0.1),
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

  Widget body(double screenWidth) {
    return pageNavigation;
  }

  Card imageCard(String image, double screenWidth) {
    return Card(
      child: Image.asset(
        'assets/images/' + image,
        width: screenWidth * 0.3,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget bottomNav(Brightness brightness) {
    return _footerAnimation != null ? AnimatedBuilder(
      animation: _footerAnimation!,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _footerAnimation!.value)),
          child: Opacity(
            opacity: _footerAnimation!.value,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.getThemeColor(brightness),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
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
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _buildNavigationItems(brightness),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ) : Container(
      decoration: BoxDecoration(
        color: AppTheme.getThemeColor(brightness),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
          height: 70,
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
    return List.generate(_titles.length, (index) {
      bool isSelected = _selectedIndex == index;
      return Expanded(
        child: GestureDetector(
          onTap: () => _onNavigationTap(index, brightness),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
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
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    _getPageIcon(index),
                    color: isSelected 
                      ? AppTheme.getThemeSelectedTextColor(brightness)
                      : AppTheme.getThemeTextColor(brightness).withValues(alpha: 0.7),
                    size: isSelected ? 24 : 20,
                  ),
                ),
                const SizedBox(height: 2),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    color: isSelected 
                      ? AppTheme.getThemeSelectedTextColor(brightness)
                      : AppTheme.getThemeTextColor(brightness).withValues(alpha: 0.7),
                    fontSize: isSelected ? 10 : 9,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  child: Text(
                    _titles[index],
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

  void _onNavigationTap(int index, Brightness brightness) {
    setState(() {
      _selectedIndex = index;
      pageNavigation = _pages[index];
      pageTitle = Text(
        '${_titles[index]} Page',
        style: TextStyle(
          color: AppTheme.getThemeTextColor(brightness),
          fontWeight: FontWeight.bold
        ),
      );
    });
  }

  BottomNavigationBarItem labelIcon(String text, IconData icon) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: text,
    );
  }
}
