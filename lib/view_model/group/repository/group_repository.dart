import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_time_chat_app_riverpod/model/group.dart' as model;
import 'package:real_time_chat_app_riverpod/utils/utils.dart';
import 'package:real_time_chat_app_riverpod/view_model/repository/firebase_storage_repository.dart';
import 'package:uuid/uuid.dart';

final groupRepositoryProvider = Provider(
  (ref) => GroupRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class GroupRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;
  GroupRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void createGroup(BuildContext context, String name, File profilePic,
      List<Contact> selectedContact) async {
    try {
      List<String> uids = [];
      for (int i = 0; i < selectedContact.length; i++) {
        var userCollection = await firestore
            .collection('users')
            .where(
              'phoneNumber',
              isEqualTo: selectedContact[i].phones[0].number.replaceAll(
                    ' ',
                    '',
                  ),
            )
            .get();

        if (userCollection.docs.isNotEmpty && userCollection.docs[0].exists) {
          uids.add(userCollection.docs[0].data()['uid']);
        }
      }
      var groupId = const Uuid().v1();

      String profileUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            'group/$groupId',
            profilePic,
          );
      model.Group group = model.Group(
        senderId: auth.currentUser!.uid,
        name: name,
        groupId: groupId,
        lastMessage: '',
        groupPic: profileUrl,
        membersUid: [auth.currentUser!.uid, ...uids],
        timeSent: DateTime.now(),
      );

      await firestore.collection('groups').doc(groupId).set(group.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}