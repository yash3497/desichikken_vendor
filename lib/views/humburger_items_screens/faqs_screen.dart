import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../utils/constants.dart';
import '../../widget/custom_appbar.dart';

class FAQsScreen extends StatelessWidget {
  const FAQsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppbar(
          title: 'FAQs',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(left: 50.0),
            child: Text(
              'We are happy to help...',
              style: bodyText20w700(color: black),
            ),
          ),
          addVerticalSpace(20),
          Text(
            'FAQs',
            style: bodyText16w600(color: black),
          ),
          addVerticalSpace(15),
          Expanded(
              child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (ctx, i) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'The lorem ipsum is a placeholder text?',
                          style: bodyText14w600(color: black),
                        ),
                        addVerticalSpace(10),
                        Text(
                          'The lorem ipsum is a placeholder text used in publishing and graphic design. This filler text is a short paragraph that contains all the letters of the alphabet. The characters are spread out evenly so that the readers attention is focused on the layout of the text instead of its content.The lorem ipsum is a placeholder text used in publishing and graphic design. This filler text is a short paragraph that contains all the letters of the alphabet. ',
                          style: bodyText13normal(color: black),
                        ),
                        Divider(
                          thickness: 1,
                        )
                      ],
                    );
                  }))
        ]),
      ),
    );
  }
}
