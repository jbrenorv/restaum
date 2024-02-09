import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/game_bloc.dart';
import '../bloc/game_events.dart';
import '../bloc/game_state.dart';
import '../entities/cell_entity.dart';
import '../entities/chat_message_entity.dart';
import '../widgets/cell_widget.dart';
import '../widgets/chat_widget.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final GameBloc _bloc;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _chatInputController = TextEditingController();

  @override
  void initState() {
    _bloc = GameBloc(AudioPlayer());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          tooltip: 'Abrir chat',
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: const Icon(Icons.chat),
        ),
        actions: [
          BlocBuilder<GameBloc, GameState>(
            bloc: _bloc,
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton(
                  tooltip:
                      '${state.soundEnable ? 'Desabilitar' : 'Habilitar'} som',
                  onPressed: () => _bloc.add(ToogleSoundEvent()),
                  icon: Icon(
                    state.soundEnable ? Icons.volume_up : Icons.volume_off,
                  ),
                ),
              );
            },
          ),
        ],
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Expanded(
              child: Text(
                'João Breno',
                textAlign: TextAlign.right,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Image.asset('assets/images/swords.png'),
            ),
            const Expanded(
              child: Text('Maressa'),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: BlocBuilder<GameBloc, GameState>(
          bloc: _bloc,
          builder: (context, state) {
            return ChatWidget(
              controller: _chatInputController,
              closeChat: () => _scaffoldKey.currentState?.closeDrawer(),
              sendMessage: _sendMessage,
              messages: state.messages,
            );
          },
        ),
      ),
      body: BlocBuilder<GameBloc, GameState>(
        bloc: _bloc,
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

  void _onCellTapped(CellEntity cell) => _bloc.add(CellTappedEvent(cell));

  void _onCellDropped(CellEntity cell, CellEntity destination) =>
      _bloc.add(CellDroppedEvent(cell, destination));

  void _sendMessage(ChatMessageEntity message) =>
      _bloc.add(SendMessageEvent(message));
}
