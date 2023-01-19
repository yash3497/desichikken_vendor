import 'package:flutter/material.dart';

import '../utils/constants.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({required this.hintText, this.controller, this.suffixIcon});

  final String hintText;
  TextEditingController? controller;
  Icon? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: width(context) * 0.91,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            suffixIcon: suffixIcon,
            border: const OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              borderSide: BorderSide.none,
            ),
            hintStyle: const TextStyle(
              color: Colors.black38,
            ),
            contentPadding: const EdgeInsets.all(10),
            filled: true,
            fillColor: black.withOpacity(0.05),
            hintText: hintText),
      ),
    );
  }
}
