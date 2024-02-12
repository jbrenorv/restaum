import 'package:flutter/material.dart';

import '../utils/constants.dart';
import 'circle_widget.dart';

class OpenChatButtonWidget extends StatelessWidget {
  const OpenChatButtonWidget({
    super.key,
    required this.unreadMessagesCount,
    required this.openChat,
  });

  final int unreadMessagesCount;
  final VoidCallback openChat;

  @override
  Widget build(BuildContext context) {
    var text = unreadMessagesCount.toString();
    var fontSize = 10.0;

    if (unreadMessagesCount > 9) {
      text = '9+';
      fontSize = 9.0;
    }

    return Stack(
      fit: StackFit.passthrough,
      children: [
        IconButton(
          tooltip: 'Abrir chat',
          onPressed: openChat,
          icon: const Icon(Icons.chat),
        ),
        if (unreadMessagesCount > 0) ...[
          Positioned(
            top: 0.0,
            right: 0.0,
            child: CircleWidget(
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  text,
                  style: TextStyle(
                    fontFamily: Constants.robotoFontFamily,
                    color: Colors.white,
                    fontSize: fontSize,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
