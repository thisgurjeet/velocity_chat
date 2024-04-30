import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_time_chat_app_riverpod/components/helpers/error.dart';
import 'package:real_time_chat_app_riverpod/components/helpers/loader.dart';
import 'package:real_time_chat_app_riverpod/routes.dart';
import 'package:real_time_chat_app_riverpod/view/features/home_screen.dart';
import 'package:real_time_chat_app_riverpod/view/landing_screen.dart';
import 'package:real_time_chat_app_riverpod/view_model/controller/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyBxCsBadBiRZPoFYPq4eOTBfh7AvOas954',
              appId: '1:351163824931:android:704e5702b248fb47a8ea96',
              messagingSenderId: '351163824931',
              projectId: 'velocity-chat-face0',
              storageBucket: 'velocity-chat-face0.appspot.com'))
      : await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: ref.watch(userDataAuthProvider).when(
            data: (user) {
              if (user == null) {
                return const LandingScreen();
              }
              return const HomeScreen();
            },
            error: (err, trace) {
              return ErrorScreen(
                error: err.toString(),
              );
            },
            loading: () => const Loader(),
          ),
    );
  }
}
