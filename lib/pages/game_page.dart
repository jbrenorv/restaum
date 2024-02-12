import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/game_bloc.dart';
import '../bloc/game_events.dart';
import '../bloc/game_state.dart';
import '../entities/cell_entity.dart';
import '../socket/dto/data_type.dart';
import '../socket/dto/socket_dto.dart';
import '../socket/game_sockets_controller.dart';
import '../utils/utils.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/cell_widget.dart';
import '../widgets/challenge_dialog_widget.dart';
import '../widgets/chat_widget.dart';
import '../widgets/floating_action_buttons_widget.dart';
import '../widgets/footer_widget.dart';
import '../widgets/game_over_dialog.dart';

class GamePage extends StatefulWidget {
  const GamePage({
    super.key,
    required this.myTurn,
    required this.firstPlayer,
    required this.secondPlayer,
  });

  final bool myTurn;
  final String firstPlayer;
  final String secondPlayer;

  String get myUserName => myTurn ? firstPlayer : secondPlayer;
  String get enemyName => myTurn ? secondPlayer : firstPlayer;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final GameBloc _bloc;
  late final GameSocketsController _socketsController;
  late final StreamSubscription _streamSubscription;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _chatInputController = TextEditingController();

  @override
  void initState() {
    _socketsController = GameSocketsController.instance;
    _streamSubscription = _socketsController.dataStream.listen(_onSocketData);
    _bloc = GameBloc(
      AudioPlayer(),
      _socketsController,
      widget.myTurn,
      widget.firstPlayer,
      widget.secondPlayer,
    );
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
      key: _scaffoldKey,
      appBar: appBarWidget(
        bloc: _bloc,
        openChat: _openChat,
        toogleSound: () => _bloc.add(ToogleSoundEvent()),
      ),
      drawer: Drawer(
        child: ChatWidget(
          bloc: _bloc,
          controller: _chatInputController,
          closeChat: () => _scaffoldKey.currentState?.closeDrawer(),
        ),
      ),
      floatingActionButton: FloatingActionButtonsWidget(
        bloc: _bloc,
        exit: () {},
        newGame: _newGame,
        whiteFlag: _whiteFlag,
      ),
      bottomNavigationBar: FooterWidget(bloc: _bloc),
      body: BlocConsumer<GameBloc, GameState>(
        bloc: _bloc,
        listenWhen: _listenToGameStateChangeWhen,
        listener: _onGameOver,
        builder: (context, state) {
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints.loose(const Size.square(400.0)),
              child: GridView(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                ),
                children: List.of(
                  state.board
                      .where((e) =>
                          !CellEntity.isAnAuxiliaryHorizontalCell(e.index))
                      .map(
                        (cell) => CellWidget(
                          cell: cell,
                          selectedIndex: state.selectedIndex,
                          destinations: state.availableDestinations,
                          onTap: _onCellTapped,
                          onCellDropped: _onCellDropped,
                          myTurn: state.myTurn,
                          gameOver: state.gameOver,
                        ),
                      ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  bool _listenToGameStateChangeWhen(GameState previous, GameState current) {
    final gameOver = current.gameOver && !previous.gameOver;

    return gameOver;
  }

  void _onGameOver(BuildContext context, GameState state) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: gameOverDialog(
          context: context,
          state: state,
        ),
      ),
    );
  }

  void _onCellTapped(CellEntity cell) => _bloc.add(CellTappedEvent(cell));

  void _onCellDropped(CellEntity cell, CellEntity destination) =>
      _bloc.add(CellDroppedEvent(cell, destination));

  void _onSocketData(SocketDto data) {
    if (data.type.equals(DataType.start)) {
      _onReceiveNewGameSocketData(data);
      return;
    }

    _bloc.add(
      SocketDataEvent(
        data: data,
        chatOpen: _scaffoldKey.currentState?.isDrawerOpen ?? false,
      ),
    );
  }

  void _whiteFlag() => _bloc.add(WhiteFlagEvent());

  void _openChat() {
    _scaffoldKey.currentState?.openDrawer();
    _bloc.add(OpenChatEvent());
  }

  void _newGame() => _socketsController.startGame();

  void _onReceiveNewGameSocketData(SocketDto data) {
    if (data.ack) {
      _startNewGame(data);
    } else {
      _showChallengeDialog(data);
    }
  }

  void _showChallengeDialog(SocketDto data) {
    var (firstPlayer, secondPlayer) = getMatchDisplayOrder(
      data,
      widget.myUserName,
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => challengeDialogWidget(
        accept: () => _acceptChallenge(data),
        firstPlayer: firstPlayer,
        secondPlayer: secondPlayer,
        newGame: true,
        enemy: widget.enemyName,
      ),
    );
  }

  void _acceptChallenge(SocketDto data) {
    _socketsController.sendMessage(
      SocketDto.start(
        start: !data.start,
        ack: true,
        enemy: widget.myUserName,
      ),
    );
    _startNewGame(data);
    Navigator.of(context).pop();
  }

  void _startNewGame(SocketDto data) {
    var (firstPlayer, secondPlayer) = getMatchDisplayOrder(
      data,
      widget.myUserName,
    );
    _bloc.add(NewGameEvent(data.start, firstPlayer, secondPlayer));
  }
}
