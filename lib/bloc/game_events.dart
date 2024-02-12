import '../entities/cell_entity.dart';
import '../entities/chat_message_entity.dart';
import '../socket/dto/socket_dto.dart';

abstract class GameEvent {}

class CellTappedEvent extends GameEvent {
  final CellEntity cell;

  CellTappedEvent(this.cell);
}

class CellDroppedEvent extends GameEvent {
  final CellEntity droppedCell;
  final CellEntity destinationCell;

  CellDroppedEvent(this.droppedCell, this.destinationCell);
}

class ToogleSoundEvent extends GameEvent {}

class SendMessageEvent extends GameEvent {
  final ChatMessageEntity message;

  SendMessageEvent(this.message);
}

class SocketDataEvent extends GameEvent {
  final SocketDto data;
  final bool chatOpen;

  SocketDataEvent({
    required this.data,
    required this.chatOpen,
  });
}

class OpenChatEvent extends GameEvent {}

class WhiteFlagEvent extends GameEvent {}

class NewGameEvent extends GameEvent {
  final bool start;
  final String firstPlayer;
  final String secondPlayer;

  NewGameEvent(this.start, this.firstPlayer, this.secondPlayer);
}
