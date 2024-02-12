import 'package:flutter/material.dart';

import '../bloc/game_state.dart';
import 'elevated_button_widget.dart';

AlertDialog gameOverDialog({
  required BuildContext context,
  required GameState state,
}) {
  var gameOverMessage = 'Você ganhou!';

  if (state.whiteFlag == true) {
    gameOverMessage = 'Você ganhou por desistência!';
  } else if (state.whiteFlag == false) {
    gameOverMessage = 'Você perdeu por desistência!';
  } else if (state.myTurn) {
    gameOverMessage = 'Você perdeu!';
  }

  return AlertDialog(
    actionsAlignment: MainAxisAlignment.center,
    actions: [
      ElevatedButtonWidget(
        onPressed: Navigator.of(context).pop,
        text: 'Ok',
      ),
    ],
    title: const Text(
      'Game over',
      textAlign: TextAlign.center,
    ),
    content: Text(
      gameOverMessage,
      textAlign: TextAlign.center,
    ),
  );
}
