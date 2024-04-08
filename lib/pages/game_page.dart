import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/game_bloc.dart';
import '../bloc/game_events.dart';
import '../bloc/game_state.dart';
import '../core/client_base.dart';
import '../entities/cell_entity.dart';
import '../core/dto/data_type.dart';
import '../core/dto/dto.dart';
import '../utils/utils.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/cell_widget.dart';
import '../widgets/challenge_dialog_widget.dart';
import '../widgets/chat_widget.dart';
import '../widgets/disconnected_pair_dialog_widget.dart';
import '../widgets/floating_action_buttons_widget.dart';
import '../widgets/footer_widget.dart';
import '../widgets/game_over_dialog.dart';
import 'home_page.dart';

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
  late final ClientBase _client;
  late final StreamSubscription _streamSubscription;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _chatInputController = TextEditingController();
  bool _isChatOpen = false;

  @override
  void initState() {
    _client = context.read<ClientBase>();
    _streamSubscription = _client.dataStream.listen(_onSocketData);
    _bloc = GameBloc(
      AudioPlayer(),
      _client,
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
        exit: _exit,
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
              constraints: BoxConstraints.loose(const Size.fromWidth(400.0)),
              child: GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
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

  void _onSocketData(Dto data) {
    if (data.type.equals(DataType.disconnectedPair)) {
      _onDisconnectedPairSocketData(data);
      return;
    }

    if (data.type.equals(DataType.start)) {
      _onReceiveNewGameSocketData(data);
      return;
    }

    _bloc.add(
      SocketDataEvent(
        data: data,
        chatOpen:
            _isChatOpen || (_scaffoldKey.currentState?.isDrawerOpen ?? false),
      ),
    );
  }

  void _whiteFlag() => _bloc.add(WhiteFlagEvent());

  void _openChat() {
    _bloc.add(OpenChatEvent());
    if (isPlatformDesktop) {
      _scaffoldKey.currentState?.openDrawer();
    } else {
      _isChatOpen = true;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChatWidget(
            bloc: _bloc,
            controller: _chatInputController,
            closeChat: () {
              _isChatOpen = false;
              Navigator.of(context).pop();
            },
          ),
        ),
      );
    }
  }

  void _newGame() => _client.startGame();

  void _onReceiveNewGameSocketData(Dto data) {
    if (data.ack) {
      if (data.accept) {
        _startNewGame(data);
      } else {
        showSnackbar(context, 'Desafio recusado');
      }
    } else {
      _showChallengeDialog(data);
    }
  }

  void _onDisconnectedPairSocketData(Dto data) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => disconnectedPairDialog(
        goHome: _goHome,
        enemyName: widget.enemyName,
      ),
    );
  }

  void _showChallengeDialog(Dto data) {
    var (firstPlayer, secondPlayer) = getMatchDisplayOrder(
      data,
      widget.myUserName,
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => challengeDialogWidget(
        accept: () => _acceptChallenge(data),
        decline: () => _declineChallenge(data),
        firstPlayer: firstPlayer,
        secondPlayer: secondPlayer,
        newGame: true,
        enemy: widget.enemyName,
      ),
    );
  }

  void _acceptChallenge(Dto data) {
    _client.accept(data);
    _startNewGame(data);
    Navigator.of(context).pop();
  }

  void _declineChallenge(Dto data) {
    _client.decline(data);
    Navigator.of(context).pop();
  }

  void _startNewGame(Dto data) {
    var (firstPlayer, secondPlayer) = getMatchDisplayOrder(
      data,
      widget.myUserName,
    );
    _bloc.add(NewGameEvent(data.start, firstPlayer, secondPlayer));
  }

  void _exit() {
    _client.exit();
    _goHome();
  }

  void _goHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false,
    );
  }
}
