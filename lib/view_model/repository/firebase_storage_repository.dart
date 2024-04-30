import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// it will help us to use this class anywhere in our project
// we dont create controller for this common storage repo
final commonFirebaseStorageRepositoryProvider =
    Provider((ref) => CommonFirebaseStorageRepository(
      firebaseStorage: FirebaseStorage.instance
    ));

// this class contains a function to upload any file on firebase database
class CommonFirebaseStorageRepository {
  final FirebaseStorage firebaseStorage;
  CommonFirebaseStorageRepository({
    required this.firebaseStorage,
  });

// this function is used to store multiple files like profilePic, audio, video, photo
  Future<String> storeFileToFirebase(String ref, File file) async {
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
