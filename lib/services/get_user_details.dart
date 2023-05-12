import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetUserDetails extends StatefulWidget {
  final String documentId;
  GetUserDetails({required this.documentId,});
  @override
  _GetUserDetailsState createState() => _GetUserDetailsState();
}
class _GetUserDetailsState extends State<GetUserDetails> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _ageController;
  late TextEditingController _emailController;
  late TextEditingController _sensorController;
  late TextEditingController _userIdController;
  

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _ageController = TextEditingController();
    _emailController = TextEditingController();
    _sensorController = TextEditingController();
    _userIdController = TextEditingController();
  }
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _sensorController.dispose();
    _userIdController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.documentId)
          .get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          _firstNameController.text = data['first name'];
          _lastNameController.text = data['last name'];
          _ageController.text = data['age'].toString();
          _emailController.text = data['email'];
          _sensorController.text = data['sensor'];
          _userIdController.text = snapshot.data!.id;
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              //Text("User ID: ${widget.documentId}"),
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Age',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your age';
                    }
                    int age = int.tryParse(value) ?? -1;
                    if (age < 0 || age > 120) {
                      return 'Please enter a valid age';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Please enter a valid email';
                    }
                    RegExp emailRegExp = RegExp(r'^[a-zA-Z0-9_.+-]+@(gmail\.com|yahoo\.com)$');

                    if (!emailRegExp.hasMatch(value)) {
                      return 
                      'Please enter a valid email address (gmail.com, yahoo, or outlook only)';
                    }
                    if (!value.contains('@gmail.com') && !value.contains('@yahoo')
                     && !value.contains('@amrita.edu')) {
                      return 'Please enter an email with @gmail.com, @yahoo, or Amrita domain';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _sensorController,
                  decoration: InputDecoration(
                    labelText: 'Sensor',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a sensor value';
                    } else if (value != 'Smart Chair' && value != 'Smart Posture' && value != 'Smart C P') {
                      return 'Please enter one of the following values: Smart Chair, Smart Posture, Smart C P';
                    }
                    return null;
                  },
                ),

                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.documentId)
                          .update({
                        'first name': _firstNameController.text,
                        'last name': _lastNameController.text,
                        'age': int.tryParse(_ageController.text) ?? 0,
                        'email': _emailController.text,
                        'sensor': _sensorController.text,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('User details updated.'),
                        ),
                      );
                    }
                  },
                  child: Text('Update'),
                ),
              ],
            ),
          );
        }
        return Text('Loading...');
      }),
    );
  }
}