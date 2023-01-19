import 'package:flutter/material.dart';

import '../utils/constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({required this.buttonName, required this.onClick});
  final String buttonName;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        height: height(context) * 0.06,
        width: width(context) * 0.9,
        decoration: BoxDecoration(
            gradient: redGradient(), borderRadius: BorderRadius.circular(30)),
        child: Center(
          child: Text(
            buttonName,
            style: bodyText16w600(color: white),
          ),
        ),
      ),
    );
  }
}
