import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/game_bloc.dart';
import '../bloc/game_events.dart';
import '../bloc/game_state.dart';
import '../entities/chat_message_entity.dart';
import '../utils/constants.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({
    super.key,
    required this.bloc,
    required this.closeChat,
    required this.controller,
  });

  final GameBloc bloc;
  final VoidCallback closeChat;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GameBloc, GameState>(
        bloc: bloc,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox.fromSize(
                size: const Size.fromHeight(96.0),
                child: DrawerHeader(
                  padding: EdgeInsets.zero,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ListTile(
                      leading: IconButton(
                        tooltip: 'Fechar',
                        onPressed: closeChat,
                        icon: const Icon(Icons.close),
                      ),
                      title: const Text('Chat'),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: const MaterialScrollBehavior().copyWith(
                    dragDevices: {
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.touch,
                    },
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: state.messages.length,
                    reverse: true,
                    itemBuilder: (context, index) => _buildMessageWidget(
                      state.messages[state.messages.length - index - 1],
                    ),
                  ),
                ),
              ),
              _buildInput(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessageWidget(ChatMessageEntity message) {
    var alignment = Alignment.centerLeft;
    var padding = const EdgeInsets.fromLTRB(0.0, 4.0, 32.0, 4.0);
    var color = const Color(0xFFFFCCCC);

    if (message.isMine) {
      alignment = Alignment.centerRight;
      padding = const EdgeInsets.fromLTRB(32.0, 4.0, 0.0, 4.0);
      color = const Color(0xFFCCCCFF);
    }

    return Align(
      alignment: alignment,
      child: Padding(
        padding: padding,
        child: Card(
          color: color,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message.text,
              style: const TextStyle(
                fontFamily: Constants.robotoFontFamily,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput() {
    return Theme(
      data: ThemeData(
        useMaterial3: true,
        fontFamily: Constants.robotoFontFamily,
      ),
      child: SizedBox.fromSize(
        size: const Size.fromHeight(96.0),
        child: Column(
          children: [
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.done,
                onEditingComplete: _sendMessage,
                decoration: InputDecoration(
                  hintText: 'Mensagem',
                  suffixIcon: IconButton(
                    tooltip: 'Enviar',
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (controller.text.isNotEmpty) {
      bloc.add(
        SendMessageEvent(
          ChatMessageEntity(
            text: controller.text,
            isMine: true,
          ),
        ),
      );
      controller.clear();
    }
  }
}
