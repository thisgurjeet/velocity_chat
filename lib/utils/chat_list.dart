import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:real_time_chat_app_riverpod/components/helpers/loader.dart';
import 'package:real_time_chat_app_riverpod/components/widgets/my_message_card.dart';
import 'package:real_time_chat_app_riverpod/components/widgets/sender_message_card.dart';
import 'package:real_time_chat_app_riverpod/model/message.dart';
import 'package:real_time_chat_app_riverpod/view_model/chat/controller/chat_controller.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverUserId;

  const ChatList({
    super.key,
    required this.receiverUserId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream:
          ref.watch(chatControllerProvider).chatStream(widget.receiverUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No Messages'),
          );
        }
        SchedulerBinding.instance.addPostFrameCallback((_) {
          messageController.jumpTo(messageController.position.maxScrollExtent);
        });
        return ListView.builder(
          controller: messageController,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final messageData = snapshot.data![index];
            var timeSent = DateFormat.Hm().format(messageData.timeSent);

            if (!messageData.isSeen &&
                messageData.recieverid ==
                    FirebaseAuth.instance.currentUser!.uid) {
              ref.read(chatControllerProvider).setChatMessageSeen(
                  context, widget.receiverUserId, messageData.messageId);
            }

            if (messageData.senderId ==
                FirebaseAuth.instance.currentUser!.uid) {
              return MyMessageCard(
                message: messageData.text,
                date: timeSent,
                type: messageData.type,
                isSeen: messageData.isSeen,
              );
            }
            return SenderMessageCard(
              message: messageData.text,
              date: timeSent,
              type: messageData.type,
            );
          },
        );
      },
    );
  }
}
