import 'package:flutter/material.dart';

import '../utils/constants.dart';
import 'elevated_button_widget.dart';

Widget challengeDialogWidget({
  required VoidCallback accept,
  required VoidCallback decline,
  required String firstPlayer,
  required String secondPlayer,
  required bool newGame,
  required String enemy,
}) {
  return WillPopScope(
    onWillPop: () async => false,
    child: AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actionsOverflowButtonSpacing: 16.0,
      actions: [
        ElevatedButtonWidget(
          onPressed: decline,
          text: 'Recusar',
          color: Colors.orange,
        ),
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
            Text(
              newGame ? '$enemy quer jogar novamente' : 'Você foi desafiado',
              textAlign: TextAlign.center,
            ),
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
    ),
  );
}
