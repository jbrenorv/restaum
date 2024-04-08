import 'dto/dto.dart';

abstract class ClientBase {
  late final String serverIp;
  late final int serverPort;
  late final String userName;

  Stream<Dto> get dataStream;

  Future<void> initialize(String userName);

  void connectToRemoteServer(
    String ip,
    int port, {
    void Function(dynamic)? onError,
  });

  void startGame();

  void exit();

  void accept(bool start);

  void decline(bool start);

  void chat(String message);

  void whiteFlag();

  void movement({
    required int sourceIndex,
    required int captureIndex,
    required int destinationIndex,
  });
}
