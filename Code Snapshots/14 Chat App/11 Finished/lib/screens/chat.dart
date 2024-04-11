import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:chat_app/widgets/chat_messages.dart';
import 'package:chat_app/widgets/new_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;

    //you should call this method first. requestPermission, as the name suggests,
    // asks the user for permission to receive and handle push notifications.
    await fcm.requestPermission();

    final token  = await fcm.getToken();
    // yields is the address of the device on which your app is running
    // And it's this address which you would need to target this specific device.

    //So if you have push notifications, that should target individual devices by address.
    // This here yields the address of the different devices. you could then send this address with an HTTP request
    // to your backend and store it in a database to connect it to other metadata of your user, for example.


    //I don't wanna target individual devices.
    // Instead, I'd like to have like a channel to which every app installation subscribe
    // and I want to be able to send a push notification to all subscribed devices in one step
    // without targeting the individual addresses.
    fcm.subscribeToTopic('chat');
  }

  @override
  void initState() {
    super.initState();

    setupPushNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterChat'),
        actions: [
          IconButton(
            onPressed: () {
              //Because since we're then listening
              // to events being emitted by a Firebase here, in our Main Dart file,
              // we'll automatically switch back to the off screen as the user gets logged out
              // because Firebase will indeed emit a new event when the user logs out.

              //It will emit a new event without data because no authentication token will exist anymore
              // because Firebase will clear that token when you call sign out,
              // it will erase it from the device and from its memory.
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: Column(
        children: const [
          //I'll wrap chat messages with expanded
          //to make sure that this chat messages widget indeed does take up as much space as it can get
          Expanded(
            child: ChatMessages(),
          ),
          NewMessage(),
        ],
      ),
    );
  }
}
/*
*-It will basically kind of reset your Flutter project,of course, without losing your packages or your code.
* flutter clean
*
* -to reinstall all those third party packages.
* flutter pub get
*
* -to make sure your Android and iOS Flutterfire based configuration is up to date.
* flutterfire configure
* */