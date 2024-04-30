import 'package:flutter/material.dart';

import 'package:real_time_chat_app_riverpod/colors.dart';
import 'package:real_time_chat_app_riverpod/components/widgets/custom_button.dart';
import 'package:real_time_chat_app_riverpod/view/auth/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  void navigatorToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().color1,
      body: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.1,
            bottom: MediaQuery.of(context).size.height * 0.03),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // TEXT
            const Text(
              'VelocityChat!',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 31,
                  fontWeight: FontWeight.bold),
            ),

            // Stuff
            Column(
              children: [
                Center(
                    child: Transform.scale(
                  scale: 1.3,
                  child: const Image(
                      // Adjust the height as needed
                      image: AssetImage(
                    'assets/images/main_logo.png',
                  )),
                )),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Laugh Faster, Chat',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                const Text('Smarter!',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 10,
                ),
                const Text('Warp-speed Wit, One Message',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16)),
                const Text('at a Time!',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16))
              ],
            ),
            // Agree and continue button

            CustomButton(
              color: Colors.white,
              height: MediaQuery.of(context).size.height * 0.065,
              width: MediaQuery.of(context).size.width * 0.85,
              text: 'Let\'s get started',
              fontWeight: FontWeight.bold,
              textColor: AppColors().color1,
              onPressed: () {
                navigatorToLoginScreen(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
