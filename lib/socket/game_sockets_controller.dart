import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:network_info_plus/network_info_plus.dart';

import 'dto/socket_dto.dart';

enum ConnectionInitiator { i, other }

class GameSocketsController {
  GameSocketsController._();

  static final GameSocketsController _instance = GameSocketsController._();

  static GameSocketsController get instance => _instance;

  late final String serverIp;
  late final String publicIp;
  late final int serverPort;
  late final String userName;

  late final StreamController<SocketDto> _dataStreamCotroller;
  late final ServerSocket _server;
  late final Socket _socket;

  Stream<SocketDto> get dataStream => _dataStreamCotroller.stream;

  Future<void> initialize(String userName) async {
    dynamic address = await NetworkInfo().getWifiIP();
    address ??= InternetAddress.anyIPv4;

    _server = await ServerSocket.bind(address, 1024);
    _dataStreamCotroller = StreamController<SocketDto>.broadcast();

    this.userName = userName;
    serverPort = _server.port;
    serverIp = _server.address.address;
    publicIp = await Ipify.ipv4();

    _server.listen(
      (socket) => _onConnectionEstablished(
        socket,
        ConnectionInitiator.other,
      ),
    );
  }

  void connectToRemoteServer(
    String ip,
    int port, {
    void Function(dynamic)? onError,
  }) {
    Socket.connect(ip, port, timeout: const Duration(seconds: 10))
        .then(
          (socket) => _onConnectionEstablished(
            socket,
            ConnectionInitiator.i,
          ),
        )
        .catchError((e) => onError?.call(e));
  }

  void _onConnectionEstablished(Socket socket, ConnectionInitiator initiator) {
    _socket = socket;
    _socket.encoding = utf8;
    _socket.listen(_onReceiveData,
    onError: 
    );

    if (initiator == ConnectionInitiator.i) startGame();
  }

  void _onReceiveData(Uint8List rawData) {
    final json = utf8.decode(rawData);
    final data = SocketDto.fromJson(json);
    _dataStreamCotroller.add(data);
  }

  void startGame() {
    // randomly select who will make the first move
    final enemyStarts = Random().nextInt(2).isEven;

    sendMessage(
      SocketDto.start(
        start: enemyStarts,
        ack: false,
        enemy: userName,
      ),
    );
  }

  void sendMessage(SocketDto dto) async {
    await _socket.flush();
    _socket.write(dto.toJson());
  }

  void dispose() {
    _server.close();
    _socket.close();
  }
}
