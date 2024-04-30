import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_time_chat_app_riverpod/colors.dart';
import 'package:real_time_chat_app_riverpod/view/contact_list/contact_list.dart';
import 'package:real_time_chat_app_riverpod/view/contact_list/select_contact_screen.dart';
import 'package:real_time_chat_app_riverpod/view/features/create_group_screen.dart';
import 'package:real_time_chat_app_riverpod/view_model/controller/auth_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

// to know the current state of app
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setUserState(false);
        break;
      case AppLifecycleState.hidden:
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors().color1,
            title: const Text(
              'VelocityChat',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  )),
              PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: AppColors().color1,
                  ),
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          child: const Text('Create Group'),
                          onTap: () {
                            Future(() => Navigator.pushNamed(
                                context, CreateGroupScreen.routeName));
                          },
                        )
                      ])
            ],
            bottom: TabBar(
                indicatorColor: AppColors().color1,
                indicatorWeight: 4,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: const Color.fromARGB(255, 211, 190, 232),
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(
                    text: 'CHATS',
                  ),
                  Tab(
                    text: 'STATUS',
                  ),
                  Tab(
                    text: 'CALLS',
                  ),
                ]),
          ),
          body: const ContactsList(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, SelectContactsScreen.routeName);
            },
            backgroundColor: AppColors().color1,
            child: const Icon(
              Icons.comment,
              color: Colors.white,
            ),
          ),
        ));
  }
}
