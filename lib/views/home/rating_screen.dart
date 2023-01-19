import 'package:delicious_vendor/utils/constants.dart';
import 'package:delicious_vendor/widget/custom_appbar.dart';
import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int reviews = 80;
  int reviews2 = 60;
  int reviews3 = 45;
  int reviews4 = 30;
  int reviews5 = 10;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: CustomAppbar(title: 'Rating'),
          preferredSize: Size.fromHeight(50)),
      body: SizedBox(
        width: width(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            addVerticalSpace(height(context) * 0.09),
            Text(
              'Customer Reviews',
              style: bodyText16w600(color: black),
            ),
            addVerticalSpace(15),
            Text(
              '4.20/5',
              style: bodyText30W600(color: black),
            ),
            addVerticalSpace(15),
            Container(
              height: 50,
              width: width(context) * 0.7,
              decoration: myFillBoxDecoration(0, Colors.grey.shade200, 30),
              child: Center(
                child: RatingBar.builder(
                  initialRating: 4.5,
                  minRating: 1,
                  itemSize: 40,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  unratedColor: Colors.grey.shade300,
                  itemBuilder: (context, _) => Icon(
                    Icons.star_rate_rounded,
                    color: Color.fromRGBO(253, 204, 75, 1),
                  ),
                  onRatingUpdate: (rating) {},
                ),
              ),
            ),
            addVerticalSpace(10),
            Text(
              '2,133 Ratings',
              style: bodyText14w600(color: black),
            ),
            addVerticalSpace(height(context) * 0.06),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('5 Star'),
                      SizedBox(
                        width: width(context) * 0.65,
                        height: 35,
                        child: Slider(
                          activeColor: Color.fromRGBO(253, 204, 75, 1),
                          value: reviews.toDouble(),
                          onChanged: (value) {
                            reviews = value.toInt();
                          },
                          min: 1,
                          max: 100,
                        ),
                      ),
                      Text('80%'),
                    ],
                  ),
                  Row(
                    children: [
                      Text('4 Star'),
                      SizedBox(
                        width: width(context) * 0.65,
                        height: 35,
                        child: Slider(
                          activeColor: Color.fromRGBO(253, 204, 75, 1),
                          value: reviews2.toDouble(),
                          onChanged: (value) {
                            reviews2 = value.toInt();
                          },
                          min: 1,
                          max: 100,
                        ),
                      ),
                      Text('60%'),
                    ],
                  ),
                  Row(
                    children: [
                      Text('3 Star'),
                      SizedBox(
                        width: width(context) * 0.65,
                        height: 35,
                        child: Slider(
                          activeColor: Color.fromRGBO(253, 204, 75, 1),
                          value: reviews3.toDouble(),
                          onChanged: (value) {
                            reviews3 = value.toInt();
                          },
                          min: 1,
                          max: 100,
                        ),
                      ),
                      Text('45%'),
                    ],
                  ),
                  Row(
                    children: [
                      Text('2 Star'),
                      SizedBox(
                        width: width(context) * 0.65,
                        height: 35,
                        child: Slider(
                          activeColor: Color.fromRGBO(253, 204, 75, 1),
                          value: reviews4.toDouble(),
                          onChanged: (value) {
                            reviews4 = value.toInt();
                          },
                          min: 1,
                          max: 100,
                        ),
                      ),
                      Text('30%'),
                    ],
                  ),
                  Row(
                    children: [
                      Text('1 Star'),
                      SizedBox(
                        width: width(context) * 0.65,
                        height: 35,
                        child: Slider(
                          activeColor: Color.fromRGBO(253, 204, 75, 1),
                          value: reviews5.toDouble(),
                          onChanged: (value) {
                            reviews5 = value.toInt();
                          },
                          min: 1,
                          max: 100,
                        ),
                      ),
                      Text('10%'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
