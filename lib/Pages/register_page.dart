import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartposture/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:smartposture/components/my_button.dart';
import 'package:smartposture/components/my_textfield.dart';
import 'package:smartposture/components/square_title.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key,required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
    // text editing controllers
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmpasswordController = TextEditingController();
    final firstnameController = TextEditingController();
    final lastnameController =TextEditingController();
    final ageController = TextEditingController();
    final dropdownController = TextEditingController();

    String? dropdownValue;
    
    SnackBar snackBar = SnackBar(
    content: Text('Please fill in all required fields.'),
    backgroundColor: Colors.red,
    );

    @override
    void dispose() {
      emailController.dispose();
      passwordController.dispose();
      confirmpasswordController.dispose();
      firstnameController.dispose();
      lastnameController.dispose();
      ageController.dispose();
      dropdownController.dispose();
      super.dispose();
    }

    // sign user Up method
    Future<void> signUserUp() async{
      if ([firstnameController, lastnameController, emailController, ageController, passwordController, confirmpasswordController].any((controller) => controller.text.isEmpty)){
      // show an error message using a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);    
      }
      else {  
        if((passwordConfirmed())){
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, 
            password: passwordController.text,
            );

            addUserDetails(
            firstnameController.text.trim(),
            lastnameController.text.trim(),
            emailController.text.trim(),
            int.parse(ageController.text.trim()),
            dropdownController.text.trim()
          );
        }
      }
    }

    Future addUserDetails(
    String firstname, String lastname, String email, int age, String dropdownValue) async{
    await FirebaseFirestore.instance.collection('users').add({
        'first name': firstname,
        'last name': lastname,
        'email': email,
        'age': age,
        'sensor': dropdownController.text,
      });
    }

    bool passwordConfirmed(){
      if(passwordController.text.trim() ==confirmpasswordController.text.trim()){
        return true;
      }
      else 
      {
        return false;
      }
    }
    //try creating the user   

    //wrong email message popup
    void showErrorMessage(String message){
      showDialog(
        context: context, 
        builder: (context){
          return  AlertDialog(
            title: Center(
              child: Text(
                message,
                style:const TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      );
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child:SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 25),

              CircleAvatar(
                radius: 80.0,
                child: ClipOval(
                  child: Image.asset(
                    'lib/imports/images/mb.jpg',
                    fit: BoxFit.cover,
                    width: 160.0,
                    height: 160.0,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              MyTextField(
                controller: firstnameController,
                hintText: 'First Name',
                obscureText: false,
                requiredField: true,
              ),


              const SizedBox(height: 10),

              MyTextField(
                controller: lastnameController,
                hintText: 'Last Name',
                obscureText: false,
                requiredField: true,
              ),

              const SizedBox(height: 10),

               // username textfield
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
                requiredField: true,
              ),

              const SizedBox(height: 10),

              MyTextField(
                controller: ageController,
                hintText: 'Age',
                obscureText: false,
                requiredField: true,
              ),

              const SizedBox(height: 10),

              // password textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
                requiredField: true,
              ),

              const SizedBox(height: 10),

              // confirm password textfield
              MyTextField(
                controller: confirmpasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
                requiredField: true,
              ),

              const SizedBox(height: 10),

              

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select an option',
                  border: OutlineInputBorder(),
                ),
                value: dropdownValue,
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue = value;
                    dropdownController.text = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an option';
                  }
                  return null;
                },
                items: <String>['Smart Chair', 'Smart Posture', 'Smart C P']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),


              // sign in button
              MyButton(
                text: "Sign Up",
                onTap: signUserUp,
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
                    imagePath: 'lib/imports/images/google.jpg'),

                  SizedBox(width: 25),

                  // apple button
                  SquareTile(
                    onTap: () {},
                    imagePath: 'lib/imports/images/apple.jpg')
                ],
              ),

              const SizedBox(height: 50),

              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child:const Text(
                      'Login now',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          )),
        ),
      ),
    );
  }
}