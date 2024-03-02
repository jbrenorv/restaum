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
              FloatingActionButton.small(
                tooltip: 'Novo jogo',
                heroTag: 'new-game',
                backgroundColor: Colors.white,
                onPressed: newGame,
                child: Image.asset(Constants.swordsImagePath),
              ),
              const SizedBox(height: 12.0),
            ],
            if (!state.gameOver) ...[
              FloatingActionButton.small(
                tooltip: 'Desistir',
                heroTag: 'flag',
                backgroundColor: Colors.white,
                onPressed: whiteFlag,
                child: const Icon(Icons.flag),
              ),
              const SizedBox(height: 12.0),
            ],
            if (state.gameOver) ...[
              FloatingActionButton.small(
                tooltip: 'Sair',
                heroTag: 'exit',
                backgroundColor: Colors.white,
                onPressed: exit,
                child: const Icon(Icons.exit_to_app),
              ),
            ],
          ],
        );
      },
    );
  }
}
