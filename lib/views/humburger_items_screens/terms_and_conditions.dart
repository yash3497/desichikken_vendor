import 'package:delicious_vendor/utils/constants.dart';
import 'package:flutter/material.dart';

import '../../widget/custom_appbar.dart';

class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppbar(
          title: 'Privacy Policy',
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 10),
            child: Text(
              'Terms & Conditions',
              style: bodyText20w700(color: black),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: 6,
                  itemBuilder: (ctx, i) {
                    return Container(
                      margin: EdgeInsets.all(15),
                      child: const Text(
                          "The lorem ipsum is a placeholder text used in publishing and graphic design. The lorem ipsum is a placeholder text used in publishing and graphic design. This filler text is a short paragraph that contains all the letters of the alphabet. The characters are spread out evenly so that the reader's attention is focused on the layout of the text instead of its content.The lorem ipsum is a placeholder text used in publishing and graphic design. This filler text is a short paragraph that contains all the letters of the alphabet. The characters are spread out evenly so that the reader's attention is focused on the layout of the text instead of its content."),
                    );
                  }))
        ],
      ),
    );
  }
}
