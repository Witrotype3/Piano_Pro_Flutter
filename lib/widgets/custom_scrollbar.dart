import 'package:flutter/material.dart';

class CustomScrollbar extends StatelessWidget {
  final Widget child;
  final ScrollController controller;
  final bool thumbVisibility;
  final bool trackVisibility;
  final double thickness;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  const CustomScrollbar({
    super.key,
    required this.child,
    required this.controller,
    this.thumbVisibility = true,
    this.trackVisibility = true,
    this.thickness = 12.0,
    this.radius = 6.0,
    this.padding,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      child: Scrollbar(
        controller: controller,
        thumbVisibility: thumbVisibility,
        trackVisibility: trackVisibility,
        thickness: thickness,
        radius: Radius.circular(radius),
        child: child,
      ),
    );
  }


}

// Predefined scrollbar styles
class ScrollbarStyles {
  // Grey scrollbar
  static CustomScrollbar grey({
    required Widget child,
    required ScrollController controller,
    double thickness = 12.0,
    double radius = 6.0,
    EdgeInsetsGeometry? padding,
    double? width,
    double? height,
  }) {
    return CustomScrollbar(
      controller: controller,
      thickness: thickness,
      radius: radius,
      padding: padding,
      width: width,
      height: height,
      child: child,
    );
  }

  // Blue scrollbar
  static CustomScrollbar blue({
    required Widget child,
    required ScrollController controller,
    double thickness = 12.0,
    double radius = 6.0,
    EdgeInsetsGeometry? padding,
    double? width,
    double? height,
  }) {
    return CustomScrollbar(
      controller: controller,
      thickness: thickness,
      radius: radius,
      padding: padding,
      width: width,
      height: height,
      child: child,
    );
  }

  // Green scrollbar
  static CustomScrollbar green({
    required Widget child,
    required ScrollController controller,
    double thickness = 12.0,
    double radius = 6.0,
    EdgeInsetsGeometry? padding,
    double? width,
    double? height,
  }) {
    return CustomScrollbar(
      controller: controller,
      thickness: thickness,
      radius: radius,
      padding: padding,
      width: width,
      height: height,
      child: child,
    );
  }

  // Orange scrollbar
  static CustomScrollbar orange({
    required Widget child,
    required ScrollController controller,
    double thickness = 12.0,
    double radius = 6.0,
    EdgeInsetsGeometry? padding,
    double? width,
    double? height,
  }) {
    return CustomScrollbar(
      controller: controller,
      thickness: thickness,
      radius: radius,
      padding: padding,
      width: width,
      height: height,
      child: child,
    );
  }

  // Purple scrollbar
  static CustomScrollbar purple({
    required Widget child,
    required ScrollController controller,
    double thickness = 12.0,
    double radius = 6.0,
    EdgeInsetsGeometry? padding,
    double? width,
    double? height,
  }) {
    return CustomScrollbar(
      controller: controller,
      thickness: thickness,
      radius: radius,
      padding: padding,
      width: width,
      height: height,
      child: child,
    );
  }

  // Red scrollbar
  static CustomScrollbar red({
    required Widget child,
    required ScrollController controller,
    double thickness = 12.0,
    double radius = 6.0,
    EdgeInsetsGeometry? padding,
    double? width,
    double? height,
  }) {
    return CustomScrollbar(
      controller: controller,
      thickness: thickness,
      radius: radius,
      padding: padding,
      width: width,
      height: height,
      child: child,
    );
  }

  // Teal scrollbar
  static CustomScrollbar teal({
    required Widget child,
    required ScrollController controller,
    double thickness = 12.0,
    double radius = 6.0,
    EdgeInsetsGeometry? padding,
    double? width,
    double? height,
  }) {
    return CustomScrollbar(
      controller: controller,
      thickness: thickness,
      radius: radius,
      padding: padding,
      width: width,
      height: height,
      child: child,
    );
  }
}

// Example usage widget
class CustomScrollbarExample extends StatefulWidget {
  const CustomScrollbarExample({super.key});

  @override
  State<CustomScrollbarExample> createState() => _CustomScrollbarExampleState();
}

class _CustomScrollbarExampleState extends State<CustomScrollbarExample> {
  final ScrollController _scrollController = ScrollController();
  String _selectedStyle = 'grey';

  final Map<String, CustomScrollbar Function(Widget, ScrollController)> _styles = {
    'grey': (child, controller) => ScrollbarStyles.grey(child: child, controller: controller),
    'blue': (child, controller) => ScrollbarStyles.blue(child: child, controller: controller),
    'green': (child, controller) => ScrollbarStyles.green(child: child, controller: controller),
    'orange': (child, controller) => ScrollbarStyles.orange(child: child, controller: controller),
    'purple': (child, controller) => ScrollbarStyles.purple(child: child, controller: controller),
    'red': (child, controller) => ScrollbarStyles.red(child: child, controller: controller),
    'teal': (child, controller) => ScrollbarStyles.teal(child: child, controller: controller),
  };

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Scrollbar Examples'),
      ),
      body: Column(
        children: [
          // Style selector
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 8.0,
              children: _styles.keys.map((style) {
                return ChoiceChip(
                  label: Text(style.toUpperCase()),
                  selected: _selectedStyle == style,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedStyle = style;
                      });
                    }
                  },
                );
              }).toList(),
            ),
          ),
          
          // Scrollable content with custom scrollbar
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _styles[_selectedStyle]!(
                SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: List.generate(50, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          'Item ${index + 1}',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      );
                    }),
                  ),
                ),
                _scrollController,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
