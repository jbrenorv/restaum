import 'package:flutter/material.dart';

import 'elevated_button_widget.dart';

Widget disconnectedPairDialog({
  required VoidCallback goHome,
  required String enemyName,
}) {
  return WillPopScope(
    onWillPop: () async => false,
    child: AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButtonWidget(
          onPressed: goHome,
          text: 'Sair',
        ),
      ],
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Ops..'),
            const SizedBox(height: 32.0),
            Text.rich(
              TextSpan(
                text: 'Perdemos a conexão com ',
                children: [
                  TextSpan(
                    text: enemyName,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}
