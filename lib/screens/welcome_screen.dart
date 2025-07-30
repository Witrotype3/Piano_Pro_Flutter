import 'package:connect_to_go_server_flutter/constants/theme.dart';
import 'package:connect_to_go_server_flutter/widgets/widget_tree.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    
    return Scaffold(
      backgroundColor: AppTheme.getThemeBackgroundColor(brightness),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/lotties/welcome.json', width: 524),
            FittedBox(
              child: Text(
                "Piano Pro",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50.0,
                  letterSpacing: 50.0,
                  color: AppTheme.getThemeTextColor(brightness),
                ),
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return WidgetTree();
                  },
                ));
              },
              child: Text(
                "Login",
                style: TextStyle(color: AppTheme.getThemeTextColor(brightness)),
              ),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(AppTheme.getThemeColor(brightness))),
            ),
          ],
        ),
      ),
    );
  }
}
