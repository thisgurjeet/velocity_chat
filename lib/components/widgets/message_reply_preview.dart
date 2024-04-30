import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_time_chat_app_riverpod/components/providers/message_reply_provider.dart';

class MessageReplypreview extends ConsumerWidget {
  const MessageReplypreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);
    return Container(
      width: 350,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                messageReply!.isMe ? 'Me' : 'Opposite',
                style: const TextStyle(fontWeight: FontWeight.bold),
              )),
              GestureDetector(
                child: const Icon(Icons.close, size: 16),
                onTap: () {},
              )
            ],
          ),
        ],
      ),
    );
  }
}
