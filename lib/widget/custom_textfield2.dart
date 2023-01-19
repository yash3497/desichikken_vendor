import 'package:flutter/material.dart';

import '../utils/constants.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield(
      {required this.hintext,
      this.prefixIcon,
      this.suffixIcon,
      this.controller,
      required this.keyBoardtype});

  final String hintext;
  final Icon? suffixIcon;
  final Icon? prefixIcon;
  final TextInputType keyBoardtype;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width(context) * 0.9,
      height: height(context) * 0.06,
      decoration: BoxDecoration(
          color: white,
          boxShadow: [
            BoxShadow(
                blurRadius: 10,
                color: Colors.black.withOpacity(0.1),
                offset: Offset(-6, 10)),
          ],
          borderRadius: BorderRadius.circular(15)),
      child: TextField(
        controller: controller,
        keyboardType: keyBoardtype,
        decoration: InputDecoration(
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.only(top: 12, left: 20),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black38, width: 0.0),
              borderRadius: BorderRadius.circular(15.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black38, width: 0.0),
              borderRadius: BorderRadius.circular(15.0),
            ),
            filled: true,
            hintStyle: const TextStyle(color: Colors.black38),
            hintText: hintext,
            fillColor: Colors.white70),
      ),
    );
  }
}
