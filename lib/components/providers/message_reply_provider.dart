import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_time_chat_app_riverpod/components/helpers/message_enum.dart';

class MessageReply {
  final String message;
  final bool isMe;
  final MessageEnum messageEnum;

  MessageReply(
      {required this.message, required this.isMe, required this.messageEnum});
}

final messageReplyProvider = StateProvider<MessageReply?>((ref) => null);
