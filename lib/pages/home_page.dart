import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/client_base.dart';
import '../core/dto/data_type.dart';
import '../core/dto/dto.dart';
import '../utils/utils.dart';
import '../widgets/challenge_dialog_widget.dart';
import '../widgets/elevated_button_widget.dart';
import 'game_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final String _serverIp;
  late final String _serverPort;
  late final String _userName;
  late final StreamSubscription _streamSubscription;
  late final ClientBase _client;

  final _enemyIpInput = TextEditingController();
  final _enemyPortInput = TextEditingController();

  bool _connecting = false;
  bool get _isValid =>
      _enemyIpInput.text.isNotEmpty && _enemyPortInput.text.isNotEmpty;

  @override
  void initState() {
    _client = context.read<ClientBase>();
    _serverIp = _client.serverIp;
    _serverPort = _client.serverPort.toString();
    _userName = _client.userName;
    _streamSubscription = _client.dataStream.listen(_onReceiveData);
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ipTextField = TextField(
      controller: _enemyIpInput,
      onChanged: _onInputChange,
      textAlign: TextAlign.center,
      decoration: const InputDecoration(
        hintText: 'IP',
      ),
    );
    final portTextField = TextField(
      controller: _enemyPortInput,
      onChanged: _onInputChange,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: const InputDecoration(
        hintText: 'Porta',
      ),
    );
    final playButton = ElevatedButtonWidget(
      onPressed: _isValid ? _connect : null,
      text: 'Jogar',
      loading: _connecting,
    );
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Bem vindo(a), $_userName!'),
              const SizedBox(height: 64.0),
              const Text(
                'Inicie uma partida conectando-se com um amigo:',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              ConstrainedBox(
                constraints: BoxConstraints.loose(const Size.fromWidth(600.0)),
                child: Builder(
                  builder: (context) {
                    if (isPlatformDesktop) {
                      return Row(
                        children: [
                          Expanded(child: ipTextField),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 16.0,
                                right: 32.0,
                              ),
                              child: portTextField,
                            ),
                          ),
                          playButton,
                        ],
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ipTextField,
                        const SizedBox(height: 16.0),
                        portTextField,
                        const SizedBox(height: 32.0),
                        playButton,
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 64.0),
              const Text(
                'Ou compartilhe seu código:',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              Text('IP: $_serverIp'),
              const SizedBox(height: 16.0),
              Text('Porta: $_serverPort'),
            ],
          ),
        ),
      ),
    );
  }

  void _onInputChange(String _) => setState(() {});

  void _onReceiveData(Dto data) {
    if (data.type.equals(DataType.start)) {
      if (data.ack) {
        if (data.accept) {
          _navigateToGamePage(data);
        } else {
          setState(() => _connecting = false);
          showSnackbar(context, 'Desafio recusado');
        }
      } else {
        _showChallengeDialog(data);
      }
    }
  }

  void _connect() {
    if (!_validateIp()) return;
    setState(() => _connecting = true);
    final ip = _enemyIpInput.text;
    final port = int.parse(_enemyPortInput.text);
    _client.connectToRemoteServer(ip, port, onError: _onConnectError);
  }

  void _showChallengeDialog(Dto data) {
    var (firstPlayer, secondPlayer) = getMatchDisplayOrder(data, _userName);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => challengeDialogWidget(
        accept: () => _acceptChallenge(data),
        decline: () => _declineChallenge(data),
        firstPlayer: firstPlayer,
        secondPlayer: secondPlayer,
        newGame: false,
        enemy: '',
      ),
    );
  }

  void _acceptChallenge(Dto data) {
    _client.accept(!data.start);
    _navigateToGamePage(data);
  }

  void _declineChallenge(Dto data) {
    _client.decline(!data.start);
    Navigator.of(context).pop();
  }

  void _onConnectError(dynamic error) {
    setState(() => _connecting = false);
    showSnackbar(context, 'Não foi possível se conectar');
  }

  void _navigateToGamePage(Dto data) {
    var (firstPlayer, secondPlayer) = getMatchDisplayOrder(data, _userName);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => GamePage(
          firstPlayer: firstPlayer,
          secondPlayer: secondPlayer,
          myTurn: data.start,
        ),
      ),
      (route) => false,
    );
  }

  bool _validateIp() {
    if (_enemyIpInput.text.trim().replaceAll('.', '') !=
            _serverIp.trim().replaceAll('.', '') &&
        _enemyIpInput.text.trim().toLowerCase() != 'localhost') {
      return true;
    }
    showSnackbar(context, 'Este IP não é permitido');
    return false;
  }
}
