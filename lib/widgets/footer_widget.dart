import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/game_bloc.dart';
import '../bloc/game_state.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key, required this.bloc});

  final GameBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      bloc: bloc,
      buildWhen: (p, c) => p.gameOver != c.gameOver || p.myTurn != c.myTurn,
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                state.gameOver
                    ? 'Game over!'
                    : state.myTurn
                        ? 'Sua vez!'
                        : 'Aguardando oponente...',
              ),
            ),
          ],
        );
      },
    );
  }
}
