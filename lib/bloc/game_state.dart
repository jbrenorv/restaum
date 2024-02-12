import '../entities/cell_entity.dart';
import '../entities/chat_message_entity.dart';
import '../entities/destination_entity.dart';

class GameState {
  final int selectedIndex;
  final bool soundEnable;
  final List<CellEntity> board;
  final List<DestinationEntity> availableDestinations;
  final List<ChatMessageEntity> messages;
  final int unreadMessagesCount;
  final bool myTurn;
  final bool gameOver;
  final bool? whiteFlag;
  final String firstPlayer;
  final String secondPlayer;

  GameState({
    required this.selectedIndex,
    required this.soundEnable,
    required this.board,
    required this.availableDestinations,
    required this.messages,
    required this.unreadMessagesCount,
    required this.myTurn,
    required this.gameOver,
    required this.whiteFlag,
    required this.firstPlayer,
    required this.secondPlayer,
  });

  factory GameState.initial(
    bool myTurn,
    String firstPlayer,
    String secondPlayer,
  ) {
    return GameState(
      selectedIndex: -1,
      soundEnable: true,
      board: List<CellEntity>.generate(77, CellEntity.initial),
      availableDestinations: [],
      messages: [],
      unreadMessagesCount: 0,
      myTurn: myTurn,
      gameOver: false,
      whiteFlag: null,
      firstPlayer: firstPlayer,
      secondPlayer: secondPlayer,
    );
  }

  GameState copyWith({
    int? selectedIndex,
    bool? soundEnable,
    List<CellEntity>? board,
    List<DestinationEntity>? availableDestinations,
    List<ChatMessageEntity>? messages,
    int? unreadMessagesCount,
    bool? myTurn,
    bool? gameOver,
    bool? whiteFlag,
    String? firstPlayer,
    String? secondPlayer,
  }) {
    return GameState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      soundEnable: soundEnable ?? this.soundEnable,
      board: board ?? this.board,
      availableDestinations:
          availableDestinations ?? this.availableDestinations,
      messages: messages ?? this.messages,
      unreadMessagesCount: unreadMessagesCount ?? this.unreadMessagesCount,
      myTurn: myTurn ?? this.myTurn,
      gameOver: gameOver ?? this.gameOver,
      whiteFlag: whiteFlag,
      firstPlayer: firstPlayer ?? this.firstPlayer,
      secondPlayer: secondPlayer ?? this.secondPlayer,
    );
  }
}
