import 'package:flutter/material.dart';
import '../Pages/login_page.dart';
import '../Pages/register_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();

}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {

  //initally show login page
  bool showLoginPage= true;

  // toggle between login and register page
  void togglePage(){ 
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context){
    if(showLoginPage){
      return LoginPage(
        onTap: togglePage,
      );
    }
    else{
      return RegisterPage(
        onTap: togglePage,
      );
    }
  }
}