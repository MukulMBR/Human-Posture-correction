import 'package:flutter/material.dart';
class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool requiredField;
  final String? errorText;

  final GestureTapCallback? onTap;
  final ValueChanged<String>? onChanged;

  const MyTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.requiredField,
    this.onTap,
    this.onChanged,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText,
          errorText: errorText,
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
        onChanged: (text) {
          if (requiredField && text.isEmpty) {
            controller.clear();
          }
        },
      ),
    );
  }
}
