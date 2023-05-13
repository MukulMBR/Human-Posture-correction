import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartposture/Pages/home_page.dart';
import 'login_or_register.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});
  

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          //if user logged in
          if (snapshot.hasData){
            return HomePage();
          }
          else {
            return const LoginOrRegisterPage();
          }
        },
    ),
    );
  }
}