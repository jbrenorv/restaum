import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/client_base.dart';
import '../widgets/elevated_button_widget.dart';
import 'home_page.dart';

class UserIdentificationPage extends StatefulWidget {
  const UserIdentificationPage({super.key});

  @override
  State<UserIdentificationPage> createState() => _UserIdentificationPageState();
}

class _UserIdentificationPageState extends State<UserIdentificationPage> {
  late final ClientBase _client;
  final _userNameInputController = TextEditingController();

  bool _loading = false;
  bool get isValid => _userNameInputController.text.isNotEmpty;

  @override
  void initState() {
    _client = context.read<ClientBase>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
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
                  decoration: const InputDecoration(
                    hintText: 'Informe seu nome',
                  ),
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
      ),
    );
  }

  Future<void> _initialize() async {
    if (!isValid) return;

    setState(() => _loading = true);

    final userName = _userNameInputController.text;
    await _client.initialize(userName);

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
