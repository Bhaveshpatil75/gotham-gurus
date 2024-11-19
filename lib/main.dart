

import 'package:flutter/material.dart';
import 'package:gotham_gurus/pages/splash_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashPage(),
      routes: {
      },
    );
  }
}

class RoutePage extends StatelessWidget {
  const RoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) { //snapshots are like real time states from the future of FutureBuilder
          switch(snapshot.connectionState) {  //switching cases a/c to state of connection of snapshot
            case ConnectionState.done: //in case if connection is established
              final curUser=AuthService.firebase().currentUser;
              if (curUser != null) {
                if (curUser.isEmailVerified) {
                  return HomePage();
                } else {
                  return const VerifyPage();
                }
              }
              else{
                return const LoginPage();
                //return const DoorPage();
              }
            default:  //all other cases such as none and so on
              return Loading();
          }
        },
      ),
    );
  }
}








