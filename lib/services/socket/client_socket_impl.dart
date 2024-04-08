import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:network_info_plus/network_info_plus.dart';

import '../../core/client_base.dart';
import '../../core/dto/dto.dart';

class SocketClientImpl implements ClientBase {
  @override
  late final String serverIp;

  @override
  late final int serverPort;

  @override
  late final String userName;

  late final StreamController<Dto> _dataStreamCotroller;
  late final ServerSocket _server;
  late Socket _socket;

  @override
  Stream<Dto> get dataStream => _dataStreamCotroller.stream;

  @override
  Future<void> initialize(String userName) async {
    dynamic address = await NetworkInfo().getWifiIP();
    address ??= InternetAddress.anyIPv4;

    _server = await ServerSocket.bind(address, 1024);
    _dataStreamCotroller = StreamController<Dto>.broadcast();

    this.userName = userName;
    serverPort = _server.port;
    serverIp = _server.address.address;

    _server.listen((socket) => _onConnectionEstablished(socket, false));
  }

  @override
  void connectToRemoteServer(
    String ip,
    int port, {
    bool initGame = true,
    void Function(dynamic)? onError,
  }) {
    Socket.connect(ip, port, timeout: const Duration(seconds: 10))
        .then((socket) => _onConnectionEstablished(socket, initGame))
        .catchError((e) => onError?.call(e));
  }

  void _onConnectionEstablished(Socket socket, bool initGame) {
    _socket = socket;
    _socket.encoding = utf8;
    _socket.listen(
      _onReceiveData,
      cancelOnError: true,
      onError: (_) => _onErrorOrDone(),
      onDone: _onErrorOrDone,
    );

    if (initGame) startGame();
  }

  void _onReceiveData(Uint8List rawData) {
    final json = utf8.decode(rawData);
    final data = Dto.fromJson(json);
    _dataStreamCotroller.add(data);
  }

  void _onErrorOrDone() {
    _dataStreamCotroller.add(Dto.disconnectedPair());
  }

  @override
  void startGame() {
    // randomly select who will make the first move
    final enemyStarts = Random().nextInt(2).isEven;

    _sendMessage(
      Dto.start(
        start: enemyStarts,
        ack: false,
        accept: false,
        enemy: userName,
        ip: serverIp,
        port: serverPort,
      ),
    );
  }

  @override
  void exit() {
    _sendMessage(Dto.disconnectedPair());
  }

  @override
  void accept(Dto dto) {
    _sendMessage(
      Dto.start(
        start: !dto.start,
        ack: true,
        accept: true,
        enemy: userName,
        ip: serverIp,
        port: serverPort,
      ),
    );
  }

  @override
  void decline(Dto dto) {
    _sendMessage(
      Dto.start(
        start: !dto.start,
        ack: true,
        accept: false,
        enemy: userName,
        ip: serverIp,
        port: serverPort,
      ),
    );
  }

  @override
  void chat(String message) {
    _sendMessage(Dto.chat(message: message));
  }

  @override
  void whiteFlag() {
    _sendMessage(Dto.whiteFlag());
  }

  @override
  void movement({
    required int sourceIndex,
    required int captureIndex,
    required int destinationIndex,
  }) {
    _sendMessage(
      Dto.movement(
        sourceIndex: sourceIndex,
        captureIndex: captureIndex,
        destinationIndex: destinationIndex,
      ),
    );
  }

  void _sendMessage(Dto dto) async {
    await _socket.flush();
    _socket.write(dto.toJson());
  }
}
