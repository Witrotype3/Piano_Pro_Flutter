import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connect_to_go_server_flutter/core/app.dart';
import 'package:connect_to_go_server_flutter/core/state/theme_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const App(),
    ),
  );
}
