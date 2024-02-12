import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'pages/user_identification_page.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    windowManager.ensureInitialized();
    windowManager.setMinimumSize(const Size.square(500.0));
    windowManager.setTitle('Resta um');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFDDDDDD),
        fontFamily: Constants.pressStartFontFamily,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFDDDDDD),
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: const UserIdentificationPage(),
    );
  }
}
