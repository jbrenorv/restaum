import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_single_instance/windows_single_instance.dart';

import 'core/client_base.dart';
import 'pages/user_identification_page.dart';
import 'services/socket/client_socket_impl.dart';
import 'utils/constants.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows) {
    await WindowsSingleInstance.ensureSingleInstance(args, "resta_um");
  }

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
    return RepositoryProvider<ClientBase>(
      create: (context) => SocketClientImpl(),
      child: MaterialApp(
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
      ),
    );
  }
}
