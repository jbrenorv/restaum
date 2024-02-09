import 'package:restaum/entities/chat_message_entity.dart';

import '../entities/cell_entity.dart';

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
