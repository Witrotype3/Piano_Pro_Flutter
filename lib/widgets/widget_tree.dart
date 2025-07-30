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

class _WidgetTreeState extends State<WidgetTree> {

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

  AppBar appBar(Brightness brightness) {
    return AppBar(
      title: Text(
        pageTitle.data ?? "Home Page",
        style: TextStyle(
          color: AppTheme.getThemeTextColor(brightness),
          fontWeight: FontWeight.bold
        ),
      ),
      backgroundColor: AppTheme.getThemeColor(brightness),
    );
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

  Container bottomNav(Brightness brightness) {
    return Container(
      color: AppTheme.getThemeColor(brightness),
      child: BottomNavigationBar(
        selectedItemColor: AppTheme.getThemeSelectedTextColor(brightness),
        selectedIconTheme: IconThemeData(color: AppTheme.getThemeSelectedTextColor(brightness)),
        unselectedItemColor: AppTheme.getThemeTextColor(brightness),
        unselectedIconTheme: IconThemeData(color: AppTheme.getThemeTextColor(brightness)),
        
        backgroundColor: AppTheme.getThemeColor(brightness),
        currentIndex: _selectedIndex,
        items: [
          labelIcon("Home", Icons.home),
          labelIcon("Lessons", Icons.piano),
          labelIcon("Settings", Icons.settings),
        ],
        onTap: (int index) {
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
        },
      ),
    );
  }

  BottomNavigationBarItem labelIcon(String text, IconData icon) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: text,
    );
  }
}
