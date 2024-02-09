import 'package:restaum/entities/chat_message_entity.dart';

import '../entities/cell_entity.dart';
import '../entities/destination_entity.dart';

class GameState {
  final int selectedIndex;
  final bool soundEnable;
  final List<CellEntity> board;
  final List<DestinationEntity> availableDestinations;
  final List<ChatMessageEntity> messages;

  GameState({
    required this.selectedIndex,
    required this.soundEnable,
    required this.board,
    required this.availableDestinations,
    required this.messages,
  });

  factory GameState.initial() {
    return GameState(
      selectedIndex: -1,
      soundEnable: true,
      board: List<CellEntity>.generate(77, CellEntity.initial),
      availableDestinations: [],
      messages: [],
    );
  }

  GameState copyWith({
    int? selectedIndex,
    bool? soundEnable,
    List<CellEntity>? board,
    List<DestinationEntity>? availableDestinations,
    List<ChatMessageEntity>? messages,
  }) {
    return GameState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      soundEnable: soundEnable ?? this.soundEnable,
      board: board ?? this.board,
      availableDestinations:
          availableDestinations ?? this.availableDestinations,
      messages: messages ?? this.messages,
    );
  }
}
