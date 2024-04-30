import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_time_chat_app_riverpod/model/user_model.dart';
import 'package:real_time_chat_app_riverpod/utils/utils.dart';
import 'package:real_time_chat_app_riverpod/view/features/mobile_chat_screen.dart';

final selectContactRepositoryProvider = Provider(
    (ref) => SelectContactRepository(firestore: FirebaseFirestore.instance));

class SelectContactRepository {
  final FirebaseFirestore firestore;

  SelectContactRepository({required this.firestore});

  // to get the list of contacts from device
  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  // to select the contact from the list that appears on device
  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      // first check if the selected contact is registered in database or not
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;

      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String selectedPhoneNum =
            selectedContact.phones[0].number.replaceAll(' ', '');

        if (selectedPhoneNum == userData.phoneNumber) {
          isFound = true;
          Navigator.pushNamed(context, MobileChatScreen.routeName,
              arguments: {'name': userData.name, 'uid': userData.uid});
        }
      }
      if (!isFound) {
        showSnackBar(
            context: context,
            content: 'This number does not exist on this app');
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
