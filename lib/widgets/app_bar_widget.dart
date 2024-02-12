import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/game_bloc.dart';
import '../bloc/game_state.dart';
import '../utils/constants.dart';
import 'open_chat_button_widget.dart';

AppBar appBarWidget({
  required GameBloc bloc,
  required VoidCallback openChat,
  required VoidCallback toogleSound,
}) {
  return AppBar(
    toolbarHeight: 76.0,
    titleSpacing: 0.0,
    automaticallyImplyLeading: false,
    title: BlocBuilder<GameBloc, GameState>(
      bloc: bloc,
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  OpenChatButtonWidget(
                    openChat: openChat,
                    unreadMessagesCount: state.unreadMessagesCount,
                  ),
                  Expanded(
                    child: Text(
                      state.firstPlayer,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Image.asset(Constants.swordsImagePath),
                  ),
                  Expanded(child: Text(state.secondPlayer)),
                  IconButton(
                    tooltip:
                        '${state.soundEnable ? 'Desabilitar' : 'Habilitar'} som',
                    onPressed: toogleSound,
                    icon: Icon(
                      state.soundEnable ? Icons.volume_up : Icons.volume_off,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
          ],
        );
      },
    ),
  );
}
