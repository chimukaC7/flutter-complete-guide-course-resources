import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:chat_app/screens/splash.dart';
import 'package:chat_app/screens/chat.dart';
import 'firebase_options.dart';
import 'package:chat_app/screens/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 63, 17, 177)),
      ),
      //StreamBuilder widget provided by Flutter.it is quite similar to the future builder widget
      // future builder was used to listen to a future and then render different widgets
      // based on the state of their future.

      //the difference between a future and a stream
      // is that a future, in the end, will be done once it resolved.
      //So it will only ever produce one value or error,

      // whereas a stream on the other hand is capable of producing multiple values over time.
      home: StreamBuilder(
        //we set up a listener that's in the end managed by the Firebase SDK under the hood.
        // And Firebase will emit a new value whenever anything auth related changes.
        // So for example, if a token becomes available or if a token is removed
        // because the user was logged out, for example.
        // So authStateChanges will give us such a stream and snapshot therefore then in the end
        // will be a user data package, you could say, created and emitted by Firebase.
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              //the idea behind that screen simply is to use it
              // as a loading screen whilst Firebase is figuring
              // out whether we have a token or not.
              return const SplashScreen();
            }

            //if we have some user data,
            //because Firebase will not emit any data
            // if we don't have a logged in user, so if we don't have a token.
            if (snapshot.hasData) {
              return const ChatScreen();
            }

            return const AuthScreen();
          }),
    );
  }
}

//it's not just about reacting to the user logging in or signing up.
// But it also means that if we start the app and the user logged in before,
// when they used the app before, maybe a couple of minutes ago,

// we also wanna start on a different screen and not the auth screen again.
// So if a user logged in in the past,
// we wanna keep the user logged in and not always restart at the auth screen.
