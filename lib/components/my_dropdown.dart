import 'package:flutter/material.dart';

class CustomDropdownFormField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final List<String> options;
  final ValueChanged<String> onChanged;
  final String? errorText;
  final bool requiredField;

  CustomDropdownFormField({
    required this.labelText,
    required this.hintText,
    required this.options,
    required this.onChanged,
    this.errorText,
    this.requiredField = false,
  });

  @override
  _CustomDropdownFormFieldState createState() =>
      _CustomDropdownFormFieldState();
}

class _CustomDropdownFormFieldState extends State<CustomDropdownFormField> {
  late String dropdownValue;
  late TextEditingController dropdownController;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.options.first;
    dropdownController = TextEditingController(text: dropdownValue);
  }

  @override
  void dispose() {
    dropdownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: dropdownController,
        decoration: InputDecoration(
          labelText: widget.labelText,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: widget.hintText,
          errorText: widget.errorText,
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
        onChanged: (text) {
          if (widget.requiredField && text.isEmpty) {
            dropdownController.clear();
          } else {
            widget.onChanged(text);
          }
        },
        validator: (text) {
          if (widget.requiredField && text?.isEmpty == true) {
            return 'Please select an option';
          }
          return null;
        },
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext builder) {
              return Container(
                height: MediaQuery.of(context).copyWith().size.height / 3,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.options.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(widget.options[index]),
                            onTap: () {
                              setState(() {
                                dropdownValue = widget.options[index];
                                dropdownController.text = dropdownValue;
                              });
                              widget.onChanged(dropdownValue);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
