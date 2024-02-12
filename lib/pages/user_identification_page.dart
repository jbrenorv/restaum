import 'package:flutter/material.dart';

import '../socket/game_sockets_controller.dart';
import '../widgets/elevated_button_widget.dart';
import 'home_page.dart';

class UserIdentificationPage extends StatefulWidget {
  const UserIdentificationPage({super.key});

  @override
  State<UserIdentificationPage> createState() => _UserIdentificationPageState();
}

class _UserIdentificationPageState extends State<UserIdentificationPage> {
  final _userNameInputController = TextEditingController();

  bool _loading = false;
  bool get isValid => _userNameInputController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints.loose(const Size.fromWidth(400.0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _userNameInputController,
                textAlign: TextAlign.center,
                textInputAction: TextInputAction.done,
                onEditingComplete: _initialize,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(hintText: 'Informe seu nome'),
              ),
              const SizedBox(height: 32.0),
              ElevatedButtonWidget(
                onPressed: !isValid ? null : _initialize,
                text: 'Encontrar adversário',
                loading: _loading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _initialize() async {
    if (!isValid) return;

    setState(() => _loading = true);

    final userName = _userNameInputController.text;
    await GameSocketsController.instance.initialize(userName);

    _navigateToHomePage();
  }

  void _navigateToHomePage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false,
    );
  }
}
