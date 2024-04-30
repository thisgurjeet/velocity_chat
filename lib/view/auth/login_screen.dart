import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:real_time_chat_app_riverpod/colors.dart';
import 'package:real_time_chat_app_riverpod/components/widgets/custom_button.dart';
import 'package:real_time_chat_app_riverpod/utils/utils.dart';
import 'package:real_time_chat_app_riverpod/view_model/controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  Country? country;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  // function to pick country
  void pickCountry() {
    showCountryPicker(
      context: context,
      onSelect: (Country _country) {
        setState(() {
          country = _country;
        });
      },
    );
  }

  // sending phone number to otpscreen
  void sendPhoneNumber() {
    String phoneNumber = phoneController.text.trim();
    // calling authControllerProvider for phone authentication
    if (country != null && phoneNumber.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .signInWithPhone(context, '+${country!.phoneCode}$phoneNumber');
    } else {
      showSnackBar(context: context, content: 'Fill out all the details');
    }
  }

  @override
  Widget build(BuildContext context) {
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
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors().color1,
        title: const Text(
          'Enter your mobile number',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 25),
                Transform.scale(
                  scale: 1,
                  child: const Image(
                    image: AssetImage('assets/images/phone_icon_2.png'),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'VelocityChat will need to verify your phone number',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 17),
                TextButton(
                  onPressed: pickCountry,
                  child: Text(
                    'Pick a country',
                    style: TextStyle(
                      color: AppColors().color1,
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    country != null
                        ? Text(
                            '+${country!.phoneCode}',
                          )
                        : const Text('   '),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          hintText: 'Enter your phone number',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors().color1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors().color1,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // button
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: CustomButton(
                color: AppColors().color1,
                text: 'VERIFY',
                textColor: Colors.white,
                fontWeight: FontWeight.bold,
                height: MediaQuery.of(context).size.height * 0.055,
                width: MediaQuery.of(context).size.width * 0.50,
                onPressed: sendPhoneNumber,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
