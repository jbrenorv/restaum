import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../socket/dto/data_type.dart';
import '../socket/dto/socket_dto.dart';
import '../socket/game_sockets_controller.dart';
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
  late final String _publicIp;
  late final String _userName;
  late final StreamSubscription _streamSubscription;
  late final GameSocketsController _controller;

  final _enemyIpInput = TextEditingController();
  final _enemyPortInput = TextEditingController();

  bool _connecting = false;
  bool get _isValid =>
      _enemyIpInput.text.isNotEmpty && _enemyPortInput.text.isNotEmpty;

  @override
  void initState() {
    _controller = GameSocketsController.instance;
    _serverIp = _controller.serverIp;
    _serverPort = _controller.serverPort.toString();
    _publicIp = _controller.publicIp;
    _userName = _controller.userName;
    _streamSubscription = _controller.dataStream.listen(_onReceiveData);
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Bem vindo(a), $_userName!'),
              const SizedBox(height: 64.0),
              const Text('Inicie uma partida conectando-se com um amigo:'),
              const SizedBox(height: 16.0),
              ConstrainedBox(
                constraints: BoxConstraints.loose(const Size.fromWidth(600.0)),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _enemyIpInput,
                        onChanged: _onInputChange,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          hintText: 'IP',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          right: 32.0,
                        ),
                        child: TextField(
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
                        ),
                      ),
                    ),
                    ElevatedButtonWidget(
                      onPressed: _isValid ? _connect : null,
                      text: 'Jogar',
                      loading: _connecting,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 64.0),
              const Text('Ou compartilhando seu código:'),
              const SizedBox(height: 16.0),
              Text('IP: $_serverIp'),
              const SizedBox(height: 16.0),
              Text('Porta: $_serverPort'),
              const SizedBox(height: 16.0),
              Text('IP público: $_publicIp'),
            ],
          ),
        ),
      ),
    );
  }

  void _onInputChange(String _) => setState(() {});

  void _onReceiveData(SocketDto data) {
    if (data.type.equals(DataType.start)) {
      if (data.ack) {
        _navigateToGamePage(data);
      } else {
        _showChallengeDialog(data);
      }
    }
  }

  void _connect() {
    setState(() => _connecting = true);
    final ip = _enemyIpInput.text;
    final port = int.parse(_enemyPortInput.text);
    _controller.connectToRemoteServer(ip, port, onError: _onConnectError);
  }

  void _showChallengeDialog(SocketDto data) {
    var (firstPlayer, secondPlayer) = getMatchDisplayOrder(data, _userName);
    showDialog(
      context: context,
      builder: (context) => challengeDialogWidget(
        accept: () => _acceptChallenge(data),
        firstPlayer: firstPlayer,
        secondPlayer: secondPlayer,
        newGame: false,
        enemy: '',
      ),
    );
  }

  void _acceptChallenge(SocketDto data) {
    _controller.sendMessage(
      SocketDto.start(
        start: !data.start,
        ack: true,
        enemy: _userName,
      ),
    );
    _navigateToGamePage(data);
  }

  void _onConnectError(dynamic error) {
    setState(() => _connecting = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        width: 600.0,
        content: Text(
          'Não foi possível se conectar',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _navigateToGamePage(SocketDto data) {
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
}
