import 'package:delicious_vendor/utils/constants.dart';
import 'package:delicious_vendor/widget/custom_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../widget/custom_appbar.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppbar(
          title: 'Contact Us',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            addVerticalSpace(15),
            Container(
              margin: EdgeInsets.all(12),
              padding: EdgeInsets.all(12),
              height: height(context) * 0.63,
              width: width(context) * 0.93,
              decoration: shadowDecoration(1, 8),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.call,
                          color: primary,
                        ),
                        suffixIcon: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: black,
                        ),
                        hintText: '+91 00000 00000'),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 2,
                  ),
                  addVerticalSpace(6),
                  TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.mail,
                          color: primary,
                        ),
                        hintText: 'tabcdfg@gmail.com'),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 2,
                  ),
                  addVerticalSpace(20),
                  Container(
                    decoration:
                        myFillBoxDecoration(1, black.withOpacity(0.08), 10),
                    child: const TextField(
                      maxLines: 10,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Tell us how we can help',
                          contentPadding: EdgeInsets.all(10)),
                    ),
                  ),
                  addVerticalSpace(height(context) * 0.1),
                  CustomButton(buttonName: 'Send', onClick: () {})
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
