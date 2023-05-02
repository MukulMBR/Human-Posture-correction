import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GetUserDetails extends StatefulWidget {
  final String documentId;
  GetUserDetails({required this.documentId});
  @override
  _GetUserDetailsState createState() => _GetUserDetailsState();
}
class _GetUserDetailsState extends State<GetUserDetails> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _ageController;
  late TextEditingController _emailController;
  late TextEditingController _sensorController;
  late String _dropdownValue;

  final List<String> _dropdownItems = ['Smart Chair', 'Smart Posture', 'Both'];
  

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _ageController = TextEditingController();
    _emailController = TextEditingController();
    _sensorController = TextEditingController();
    _dropdownValue = '';
  }
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _sensorController.dispose();
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
          _dropdownValue = data['sensor'];
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

                DropdownButtonFormField(
  value: _dropdownValue,
  decoration: InputDecoration(
    labelText: 'Sensor',
  ),
  items: [
    DropdownMenuItem(
      value: 'Smart Chair',
      child: Text('Smart Chair'),
    ),
    DropdownMenuItem(
      value: 'Smart Posture',
      child: Text('Smart Posture'),
    ),
    DropdownMenuItem(
      value: 'Both',
      child: Text('Both'),
    ),
  ],
  onChanged: (value) {
    setState(() {
      _dropdownValue = value.toString();
    });
  },
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please select a sensor';
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