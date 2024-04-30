import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_time_chat_app_riverpod/colors.dart';
import 'package:real_time_chat_app_riverpod/view_model/controller/auth_controller.dart';

class OtpScreen extends ConsumerWidget {
  static const String routeName = '/otp-screen';
  final String verificationId; // firebase will send this id as otp
  const OtpScreen({
    super.key,
    required this.verificationId,
  });

// fucntion to verifyOtp: this function is already written in auth-controller.dart
  void verifyOTP(WidgetRef ref, BuildContext context, String userOTP) {
    ref
        .read(authControllerProvider)
        .verifyOTP(context, verificationId, userOTP);
  }

  @override
  // Since we are using consumer widget we need widget ref
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          centerTitle: true,
          backgroundColor: AppColors().color1,
          title: const Text(
            'Verifying your number',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Text(
                'We have sent an SMS with a code.',
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
              SizedBox(
                width: size.width * 0.5,
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      hintText: '- - - - - -',
                      hintStyle:
                          TextStyle(fontSize: 35, color: AppColors().color1)),
                  keyboardType: TextInputType.number,
                  // checking the value of otp
                  onChanged: (val) {
                    if (val.length == 6) {
                      verifyOTP(ref, context, val.trim());
                    }
                  },
                ),
              )
            ],
          ),
        ));
  }
}
