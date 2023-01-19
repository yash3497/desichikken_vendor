import 'package:delicious_vendor/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../widget/custom_appbar.dart';

class ProductUpdateScreen extends StatelessWidget {
  ProductUpdateScreen({super.key});

  final List productUpdateList = [
    {
      'img': 'assets/images/meat1.png',
      'color': Colors.red,
      'updateStatus': 'Send Update'
    },
    {
      'img': 'assets/images/meat2.png',
      'color': Colors.green,
      'updateStatus': 'Sent'
    },
    {
      'img': 'assets/images/meat3.png',
      'color': Colors.red,
      'updateStatus': 'Send Update'
    },
    {
      'img': 'assets/images/meat4.png',
      'color': Colors.green,
      'updateStatus': 'Sent'
    },
    {
      'img': 'assets/images/meat2.png',
      'color': Colors.red,
      'updateStatus': 'Send Update'
    },
    {
      'img': 'assets/images/meat3.png',
      'color': Colors.red,
      'updateStatus': 'Send Upadte'
    },
    {
      'img': 'assets/images/meat4.png',
      'color': Colors.green,
      'updateStatus': 'Sent'
    },
    {
      'img': 'assets/images/meat1.png',
      'color': Colors.green,
      'updateStatus': 'Sent'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppbar(
          title: 'Product Update',
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Product Update',
              style: bodyText20w700(color: black),
            ),
          ),
          addVerticalSpace(8),
          Expanded(
              child: GridView.builder(
                  itemCount: productUpdateList.length,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.8,
                      crossAxisCount: 2,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2),
                  itemBuilder: (ctx, i) {
                    return Container(
                      margin: EdgeInsets.all(8),
                      height: height(context) * 0.26,
                      width: width(context) * 0.48,
                      decoration: shadowDecoration(15, 10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                                child:
                                    Image.asset(productUpdateList[i]['img'])),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: width(context) * 0.23,
                                    child: Text(
                                      'Goat Curry Cut',
                                      style: bodyText16w600(color: black),
                                    ),
                                  ),
                                  Text(
                                    '1 Kg',
                                    style: bodytext12Bold(color: black),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              height: 40,
                              width: width(context) * 0.43,
                              decoration: myFillBoxDecoration(
                                  0, productUpdateList[i]['color'], 8),
                              child: Center(
                                child: Text(
                                  productUpdateList[i]['updateStatus'],
                                  style: bodyText14w600(color: white),
                                ),
                              ),
                            )
                          ]),
                    );
                  }))
        ],
      ),
    );
  }
}
