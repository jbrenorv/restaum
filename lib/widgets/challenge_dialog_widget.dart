import 'package:flutter/material.dart';

import '../utils/constants.dart';
import 'elevated_button_widget.dart';

AlertDialog challengeDialogWidget({
  required VoidCallback accept,
  required String firstPlayer,
  required String secondPlayer,
  required bool newGame,
  required String enemy,
}) {
  return AlertDialog(
    actionsAlignment: MainAxisAlignment.center,
    actions: [
      ElevatedButtonWidget(
        onPressed: accept,
        text: 'Aceitar',
      ),
    ],
    content: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(newGame ? '$enemy quer jogar novamente' : 'Você foi desafiado'),
          const SizedBox(height: 32.0),
          Text(firstPlayer),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(Constants.swordsImagePath),
          ),
          Text(secondPlayer),
        ],
      ),
    ),
  );
}
