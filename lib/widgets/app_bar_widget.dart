import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/game_bloc.dart';
import '../bloc/game_state.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';
import 'open_chat_button_widget.dart';

AppBar appBarWidget({
  required GameBloc bloc,
  required VoidCallback openChat,
  required VoidCallback toogleSound,
}) {
  TextStyle? playerNameTextStyle;
  double? swordsImageSize;
  double swordsHorizontalPadding = 32.0;

  if (!isPlatformDesktop) {
    playerNameTextStyle = const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
    );
    swordsImageSize = 16.0;
    swordsHorizontalPadding = 8.0;
  }

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
                      style: playerNameTextStyle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: swordsHorizontalPadding,
                    ),
                    child: Image.asset(
                      Constants.swordsImagePath,
                      height: swordsImageSize,
                      width: swordsImageSize,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      state.secondPlayer,
                      style: playerNameTextStyle,
                    ),
                  ),
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
