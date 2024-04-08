import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:grpc/grpc.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../../core/client_base.dart';
import '../../core/dto/dto.dart';
import 'grpc/generated/grpc_service.pbgrpc.dart';

class RpcClientImpl extends GrpcServiceBase implements ClientBase {
  @override
  late final String serverIp;

  @override
  late final int serverPort;

  @override
  late final String userName;

  late final StreamController<Dto> _dataStreamCotroller;
  late final Server _server;
  late GrpcServiceClient _client;

  @override
  Stream<Dto> get dataStream => _dataStreamCotroller.stream;

  @override
  Future<void> initialize(String userName) async {
    dynamic address = await NetworkInfo().getWifiIP();
    address ??= InternetAddress.anyIPv4;

    _server = Server.create(
      services: [this],
      codecRegistry: CodecRegistry(codecs: const [
        GzipCodec(),
        IdentityCodec(),
      ]),
    );

    await _server.serve(address: address, port: 1024);
    _dataStreamCotroller = StreamController<Dto>.broadcast();

    this.userName = userName;
    serverPort = _server.port!;
    if (address is String) {
      serverIp = address;
    } else if (address is InternetAddress) {
      serverIp = address.address;
    }
  }

  @override
  void connectToRemoteServer(
    String ip,
    int port, {
    bool initGame = true,
    void Function(dynamic)? onError,
  }) {
    try {
      final channel = ClientChannel(
        ip,
        port: port,
        options: const ChannelOptions(
          credentials: ChannelCredentials.insecure(),
        ),
      );

      _client = GrpcServiceClient(channel);

      if (initGame) startGame();

      // ignore: empty_catches
    } catch (e) {}
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
    connectToRemoteServer(dto.ip, dto.port, initGame: false);
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
    try {
      await _client.runCommand(CommandMessage(command: dto.toJson()));
    } catch (e) {
      _dataStreamCotroller.add(Dto.disconnectedPair());
    }
  }

  @override
  Future<ResponseMessage> runCommand(
    ServiceCall call,
    CommandMessage request,
  ) {
    final data = Dto.fromJson(request.command);
    _dataStreamCotroller.add(data);

    return Future.value(ResponseMessage());
  }
}
