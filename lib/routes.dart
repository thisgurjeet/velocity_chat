import 'package:flutter/material.dart';
import 'package:real_time_chat_app_riverpod/components/helpers/error.dart';
import 'package:real_time_chat_app_riverpod/view/auth/otp_screen.dart';
import 'package:real_time_chat_app_riverpod/view/contact_list/select_contact_screen.dart';
import 'package:real_time_chat_app_riverpod/view/features/create_group_screen.dart';
import 'package:real_time_chat_app_riverpod/view/features/mobile_chat_screen.dart';
import 'package:real_time_chat_app_riverpod/view/features/user_information_screen.dart';

import 'view/auth/login_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    case OtpScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => OtpScreen(
                verificationId: verificationId,
              ));
    case UserInformationScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const UserInformationScreen());
    case SelectContactsScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const SelectContactsScreen());
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      return MaterialPageRoute(
          builder: (context) => MobileChatScreen(
                name: name,
                uid: uid,
              ));
    case CreateGroupScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const CreateGroupScreen());          
    default:
      return MaterialPageRoute(
          builder: (context) => const Scaffold(
                body: ErrorScreen(error: 'This page doesn\'t exist'),
              ));
  }
}
