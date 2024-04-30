import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:real_time_chat_app_riverpod/components/helpers/loader.dart';

import 'package:real_time_chat_app_riverpod/model/chat_contact.dart';
import 'package:real_time_chat_app_riverpod/view/features/mobile_chat_screen.dart';
import 'package:real_time_chat_app_riverpod/view_model/chat/controller/chat_controller.dart';

class ContactsList extends ConsumerWidget {
  // ignore: use_super_parameters
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: StreamBuilder<List<ChatContact>>(
            stream: ref.watch(chatControllerProvider).chatContacts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var chatContactsData = snapshot.data![index];

                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, MobileChatScreen.routeName, arguments: {
                            'name': chatContactsData.name,
                            'uid': chatContactsData.contactId
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 2.0),
                          child: ListTile(
                            title: Text(
                              chatContactsData.name,
                              style: const TextStyle(
                                fontSize: 17,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(
                                chatContactsData.lastMessage,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(chatContactsData.profilePic),
                              radius: 26,
                            ),
                            trailing: Text(
                              DateFormat.Hm().format(chatContactsData.timeSent),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }));
  }
}
