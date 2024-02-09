import 'dart:ui';

import 'package:flutter/material.dart';

import '../entities/chat_message_entity.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({
    super.key,
    required this.closeChat,
    required this.messages,
    required this.sendMessage,
    required this.controller,
  });

  final List<ChatMessageEntity> messages;
  final VoidCallback closeChat;
  final void Function(ChatMessageEntity) sendMessage;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
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
              itemCount: messages.length,
              reverse: true,
              itemBuilder: (context, index) => _buildMessageWidget(
                messages[messages.length - index - 1],
              ),
            ),
          ),
        ),
        _buildInput(),
      ],
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
                fontFamily: 'Roboto Mono',
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
        fontFamily: 'Roboto Mono',
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
      sendMessage(ChatMessageEntity(text: controller.text, isMine: true));
      controller.clear();
    }
  }
}
