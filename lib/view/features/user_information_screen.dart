import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_time_chat_app_riverpod/colors.dart';

import 'package:real_time_chat_app_riverpod/utils/utils.dart';

import '../../view_model/controller/auth_controller.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const String routeName = '/user-information';
  const UserInformationScreen({super.key});

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  File? image;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

// function to store user data written in authController
  void storeUserData() async {
    String name = nameController.text.trim();
    if (name.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .saveUserDataToFirebase(context, name, image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Center(
        child: Column(children: [
          SizedBox(
            height: size.height * 0.04,
          ),
          Stack(
            children: [
              image == null
                  ? const CircleAvatar(
                      // backgroundColor: Colors.white60,
                      radius: 60,
                      backgroundImage:
                          AssetImage('assets/images/user_profile.png'),
                    )
                  : CircleAvatar(
                      backgroundColor: Colors.white60,
                      radius: 60,
                      backgroundImage: FileImage(image!)),
              Positioned(
                  left: 80,
                  bottom: -10,
                  child: IconButton(
                      onPressed: selectImage,
                      icon: Icon(
                          size: 25,
                          Icons.add_a_photo,
                          color: AppColors().color1)))
            ],
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Row(
            children: [
              Container(
                width: size.width * 0.85,
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors().color1),
                      ),
                      hintText: 'Enter your name',
                      hintStyle: TextStyle(
                          color: AppColors().color1,
                          fontWeight: FontWeight.w400,
                          fontSize: 17)),
                ),
              ),
              IconButton(
                  onPressed: storeUserData,
                  icon: Icon(
                    Icons.done,
                    size: 28,
                    color: AppColors().color1,
                  ))
            ],
          )
        ]),
      )),
    );
  }
}
