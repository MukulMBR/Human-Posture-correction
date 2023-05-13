import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartposture/components/my_textfield.dart';

class ForgotPasswordPage extends StatefulWidget{
  const ForgotPasswordPage({ Key? key}) : super(key: key);
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>{
  final _EmailController=TextEditingController();

  @override
  void dispose(){
    _EmailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: _EmailController.text.trim());
    showDialog(
        context: context,
         builder: (context){
          return AlertDialog(
            content: Text('Pass reset link sent! Check your email'),
          );
         });
    } on FirebaseAuthException catch(e){
      print(e);
      showDialog(
        context: context,
         builder: (context){
          return AlertDialog(
            content: Text((e).message.toString()),
          );
         });
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[200],
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Enter Your Email to Reset your password ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
              ),
          ),
          SizedBox(height: 10),

          MyTextField(
                controller: _EmailController,
                hintText: 'Email',
                obscureText: false, requiredField: true,
              ),

              SizedBox(height: 10),

              MaterialButton(onPressed: passwordReset,
              child: Text('Reset Password'),
              color: Colors.green,
              )
        ],
      ),
    );
  }
}