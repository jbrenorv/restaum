import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/game_bloc.dart';
import '../bloc/game_state.dart';
import '../utils/constants.dart';

class FloatingActionButtonsWidget extends StatelessWidget {
  const FloatingActionButtonsWidget({
    super.key,
    required this.bloc,
    required this.newGame,
    required this.whiteFlag,
    required this.exit,
  });

  final GameBloc bloc;
  final VoidCallback newGame;
  final VoidCallback whiteFlag;
  final VoidCallback exit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      bloc: bloc,
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (state.gameOver) ...[
              FloatingActionButton(
                tooltip: 'Novo jogo',
                heroTag: 'new-game',
                backgroundColor: Colors.white,
                onPressed: state.gameOver ? newGame : null,
                child: Image.asset(Constants.swordsImagePath),
              ),
              const SizedBox(height: 16.0),
            ],
            FloatingActionButton(
              tooltip: 'Desistir',
              heroTag: 'flag',
              backgroundColor: Colors.white,
              onPressed: state.gameOver ? null : whiteFlag,
              child: const Icon(Icons.flag),
            ),
            const SizedBox(height: 16.0),
            FloatingActionButton(
              tooltip: 'Sair',
              heroTag: 'exit',
              backgroundColor: Colors.white,
              onPressed: state.gameOver ? exit : null,
              child: const Icon(Icons.exit_to_app),
            ),
          ],
        );
      },
    );
  }
}
