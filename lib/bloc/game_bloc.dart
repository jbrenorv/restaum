import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';

import '../entities/cell_entity.dart';
import '../entities/destination_entity.dart';
import '../utils/utils.dart';
import 'game_events.dart';
import 'game_state.dart';

const alertSoundPath = 'sounds/alert.wav';
const bonusSoundPath = 'sounds/bonus.wav';
const tapSoundPath = 'sounds/tap.wav';

class GameBloc extends Bloc<GameEvent, GameState> {
  final AudioPlayer _audioPlayer;

  GameBloc(this._audioPlayer) : super(GameState.initial()) {
    on<CellTappedEvent>(_onCellTapped);
    on<CellDroppedEvent>(_onCellDropped);
    on<ToogleSoundEvent>(_onToogleSound);
    on<SendMessageEvent>(_sendMessage);
  }

  void _onCellTapped(CellTappedEvent event, Emitter emit) {
    final cell = event.cell;

    if (isDestination(state.availableDestinations, cell)) {
      emit(_makeMovement(state.board[state.selectedIndex], cell));
      return;
    }

    if (cell.empty) {
      _playSoundEffect(alertSoundPath);
      return;
    }

    _playSoundEffect(tapSoundPath);

    int selectIndex = -1;
    List<DestinationEntity> destinations = [];

    if (cell.index != state.selectedIndex) {
      selectIndex = cell.index;
      destinations = getAvailableDestinations(cell.index, state.board);
    }

    emit(state.copyWith(
      selectedIndex: selectIndex,
      availableDestinations: destinations,
    ));
  }

  void _onCellDropped(CellDroppedEvent event, Emitter emit) {
    emit(_makeMovement(event.droppedCell, event.destinationCell));
  }

  void _onToogleSound(ToogleSoundEvent event, Emitter emit) {
    emit(state.copyWith(soundEnable: !state.soundEnable));
  }

  void _sendMessage(SendMessageEvent event, Emitter emit) {
    emit(state.copyWith(messages: state.messages..add(event.message)));
  }

  GameState _makeMovement(CellEntity from, CellEntity to) {
    _playSoundEffect(bonusSoundPath);

    final enemyIndex = state.availableDestinations
        .firstWhere((d) => d.destination == to.index)
        .enemy;

    state.board[from.index] = from.switchEmpty();
    state.board[to.index] = to.switchEmpty();
    state.board[enemyIndex] = state.board[enemyIndex].switchEmpty();

    return GameState(
      selectedIndex: -1,
      soundEnable: state.soundEnable,
      board: state.board,
      availableDestinations: [],
      messages: state.messages,
    );
  }

  void _playSoundEffect(String path) {
    if (state.soundEnable) {
      _audioPlayer.play(AssetSource(path));
    }
  }
}
