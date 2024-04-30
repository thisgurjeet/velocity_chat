import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:real_time_chat_app_riverpod/colors.dart';
import 'package:real_time_chat_app_riverpod/components/helpers/loader.dart';
import 'package:real_time_chat_app_riverpod/components/widgets/bottom_chat_field.dart';
import 'package:real_time_chat_app_riverpod/model/user_model.dart';

import 'package:real_time_chat_app_riverpod/utils/chat_list.dart';
import 'package:real_time_chat_app_riverpod/view_model/controller/auth_controller.dart';

class MobileChatScreen extends ConsumerWidget {
  static const routeName = '/mobile-chat-screen';
  // ignore: use_super_parameters
  const MobileChatScreen({
    Key? key,
    required this.name,
    required this.uid,
  }) : super(key: key);
  final String name;
  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 21,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors().color1,
        title: StreamBuilder<UserModel>(
          stream: ref.read(authControllerProvider).userDataById(uid),
          builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(color: Colors.white, fontSize: 19),
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  Text(
                    snapshot.data!.isOnline ? 'online' : 'offline',
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  )
                ]);
          },
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.video_call,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.call,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(
              receiverUserId: uid,
            ),
          ),
          BottomChatField(
            receiverUserId: uid,
          ),
        ],
      ),
    );
  }
}
