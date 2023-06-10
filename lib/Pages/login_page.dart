import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartposture/services/forgot_password_page.dart';
import 'package:smartposture/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:smartposture/components/my_button.dart';
import 'package:smartposture/components/my_textfield.dart';
import 'package:smartposture/components/square_title.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key,required this.onTap});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String animationURL='login.riv';
  Artboard? artboard;
  SMITrigger? successTrigger, failTrigger;
  SMIBool? isHandsUp, isChecking;
  SMINumber? lookNum;
  // text editing controllers
  final EmailController = TextEditingController();
  final passwordController = TextEditingController();

  StateMachineController? stateMachineController;

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initArtboard();//start animation
  }
  
  void handsOnTheEyes() {
    isHandsUp?.change(true);
  }
    initArtboard(){
    rootBundle.load(animationURL).then((value){
      final file=RiveFile.import(value);
      final art=file.mainArtboard;
      stateMachineController=StateMachineController.fromArtboard(art, "Login Machine")!;
      if(stateMachineController!=null){
        art.addController(stateMachineController!);
        for(var element in stateMachineController!.inputs){

         if(element.name=="isChecking"){
           isChecking=element as SMIBool;
         }
         else if(element.name=="isHandsUp"){
           isHandsUp=element as SMIBool;
         }
         else if(element.name=="trigSuccess"){
           successTrigger=element as SMITrigger;
         }
         else if(element.name=="trigFail"){
           failTrigger=element as SMITrigger;
         }
         else if(element.name=='lookNum'){
           lookNum=element as SMINumber;
         }
        }
      }
      setState(() {
        artboard=art;
      });
    });
  }

  void lookOnTheTextField() {
    isHandsUp?.change(false);
    isChecking?.change(true);
    lookNum?.change(0);
  }

  void moveEyeBalls(val) {
    lookNum?.change(val.length.toDouble());
  }

  // sign user in method
  void signUserIn() async{
    //show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    //try sign in

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: EmailController.text, 
      password: passwordController.text
      );
      successTrigger?.fire();
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      failTrigger?.fire();
      Navigator.pop(context);
      //show error message
      showErrorMessage(e.code);
    }
  }

  //wrong email message popup
  void showErrorMessage(String message){
    failTrigger?.fire();
    showDialog(
      context: context, 
      builder: (context){
        return  AlertDialog(
          title: Center(
            child: Text(
              message,
              style:const TextStyle(color: Color.fromRGBO(255, 0, 0, 0.8)),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd6e2ea),
      body: SafeArea(
        child: Center(
          child:SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (artboard != null)
              SizedBox(
                width: 400,
                height: 300,
                child: Rive(
                  artboard: artboard!,
                  fit: BoxFit.fitWidth,
                ),
              ),
              const SizedBox(height: 50),
              Container(
                alignment: Alignment.center,
                width: 400,
                padding: const EdgeInsets.only(bottom: 15),
                margin: const EdgeInsets.only(bottom: 15 * 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        const SizedBox(height: 15 * 2),
                    // Email textfield
                    TextField(
                      onTap: lookOnTheTextField,
                      onChanged: moveEyeBalls,
                      controller: EmailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(fontSize: 14),
                      obscureText: false,
                      decoration: const InputDecoration(
                        hintText: "Email",
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                        ),
                        focusColor: Color(0xffb04863),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffb04863),
                          ),
                          borderRadius:
                          BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // password textfield
                    TextField(
                      onTap: handsOnTheEyes,
                      controller: passwordController,
                      obscureText: true,
                      style: const TextStyle(fontSize: 14),
                      cursorColor: const Color(0xffb04863),
                      decoration: const InputDecoration(
                        hintText: "Password",
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                        ),
                        focusColor: Color(0xffb04863),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffb04863),
                          ),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // forgot password?
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context, 
                                MaterialPageRoute(
                                  builder: (context){
                                    return ForgotPasswordPage();
                                  },
                                ),
                              );
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // sign in button
                    MyButton(
                      text: 'Sign In',
                      onTap: signUserIn,
                    ),
                    const SizedBox(height: 50),

                    // or continue with
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Or continue with',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 50),

                    // google + apple sign in buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        // google button
                        SquareTile(
                          onTap: () => AuthService().signInWithGoogle(),
                          imagePath: 'lib/imports/images/google.jpg'
                        ),

                        SizedBox(width: 25),

                        // apple button
                        SquareTile(
                          onTap: (){},
                          imagePath: 'lib/imports/images/apple.jpg')
                      ],
                    ),

                    const SizedBox(height: 50),

                    // not a member? register now
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Not a member?',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: widget.onTap,
                          child:const Text(
                            'Register now',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                    ],
                    ),
                  ),
                  ],
                ),
              ),
            ],
          ),
        )
    )),
    );
  }
}
