import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../utils/constants.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/custom_gradient_button.dart';

class OrderStatusScreen extends StatefulWidget {
  const OrderStatusScreen({super.key});

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  // void initState() {
  //   Future.delayed(Duration(seconds: 2), () {
  //     showRatingDeliveryBoy(context);
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppbar(
          title: 'Order Full Details',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Order',
                style: bodyText16w600(color: black),
              ),
              addVerticalSpace(15),
              SizedBox(
                height: height(context) * 0.2,
                child: ListView.builder(
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: shadowDecoration(15, 0),
                                height: height(context) * 0.08,
                                width: width(context) * 0.2,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.asset(
                                    'assets/images/meat.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              addHorizontalySpace(10),
                              SizedBox(
                                height: height(context) * 0.08,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Polutry Chicken',
                                      style: bodyText14w600(color: black),
                                    ),
                                    Text(
                                      '900gms I Net: 450gms',
                                      style: bodyText11Small(
                                          color: black.withOpacity(0.5)),
                                    ),
                                    addVerticalSpace(5),
                                    Row(
                                      children: [
                                        const Text(
                                          'Rs.250',
                                          style: TextStyle(
                                              fontSize: 12,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black26),
                                        ),
                                        addHorizontalySpace(5),
                                        Text(
                                          'Rs.200',
                                          style: bodyText14w600(color: primary),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              addHorizontalySpace(40),
                              Container(
                                height: 30,
                                width: width(context) * 0.2,
                                decoration: shadowDecoration(7, 1),
                                child: Center(
                                    child: Text(
                                  'Qty-1',
                                  style: bodytext12Bold(color: black),
                                )),
                              )
                            ],
                          ),
                          const Divider(
                            thickness: 1,
                            height: 30,
                          )
                        ],
                      );
                    }),
              ),
              addVerticalSpace(25),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(1),
                height: height(context) * 0.16,
                width: width(context) * 0.93,
                decoration: shadowDecoration(10, 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Item Total',
                          style: bodyText14w600(color: black),
                        ),
                        Text(
                          'Rs.400',
                          style: bodyText14w600(color: black),
                        )
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delivery',
                          style: bodyText14w600(color: black),
                        ),
                        Text(
                          'Rs.40',
                          style: bodyText14w600(color: black),
                        )
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: bodyText16w600(color: black),
                        ),
                        Text(
                          'Rs.440',
                          style: bodyText16w600(color: primary),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              addVerticalSpace(15),
              StepperProgressWidget(),
              addVerticalSpace(15),
              Container(
                margin: EdgeInsets.all(1),
                padding: EdgeInsets.all(8),
                height: height(context) * 0.15,
                width: width(context) * 0.93,
                decoration: shadowDecoration(10, 2),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/rajesh.png'),
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Rajesh Kumar ',
                                style: bodyText14w600(color: black)),
                            TextSpan(
                                text:
                                    'is your delivery boy \ncontact him and get details of your order',
                                style: bodyText13normal(color: black))
                          ])),
                          Icon(
                            Icons.call,
                            color: primary,
                          )
                        ]),
                    const Divider(
                      thickness: 1,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/rahul.png'),
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Rahul',
                                style: bodyText14w600(color: black)),
                            TextSpan(
                                text:
                                    'is your customer contact him\n if you have query about order                  ',
                                style: bodyText13normal(color: black))
                          ])),
                          Icon(
                            Icons.call,
                            color: primary,
                          )
                        ]),
                  ],
                ),
              ),
              addVerticalSpace(15),
            ],
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class StepperProgressWidget extends StatefulWidget {
  const StepperProgressWidget({super.key});

  @override
  State<StepperProgressWidget> createState() => _StepperProgressWidgetState();
}

class _StepperProgressWidgetState extends State<StepperProgressWidget> {
  int current_step = 0;

  List<Step> steps = [
    Step(
      state: StepState.complete,
      title: Row(
        children: [
          RichText(
              text: TextSpan(children: [
            TextSpan(text: 'Order Confirmed', style: TextStyle(color: black)),
            const TextSpan(
                text: '\nCancel order',
                style: TextStyle(fontSize: 12, color: Colors.orange))
          ])),
          addHorizontalySpace(20),
          RichText(
              text: TextSpan(children: [
            TextSpan(text: 'Wed, 07 Aug', style: TextStyle(color: black)),
            const TextSpan(
                text: '\n2:35 AM',
                style: TextStyle(fontSize: 12, color: Colors.black54))
          ])),
        ],
      ),
      content: const Text(''),
      isActive: true,
    ),
    Step(
      state: StepState.complete,
      title: Row(
        children: [
          RichText(
              text: TextSpan(children: [
            TextSpan(text: 'Shipped  ', style: TextStyle(color: black)),
            TextSpan(
                text: '\nTrack your order',
                style: TextStyle(fontSize: 12, color: Colors.black54))
          ])),
          addHorizontalySpace(20),
          RichText(
              text: TextSpan(children: [
            TextSpan(text: 'Thu, 09 Aug', style: TextStyle(color: black)),
            const TextSpan(
                text: '\n1:35 AM',
                style: TextStyle(fontSize: 12, color: Colors.black54))
          ])),
        ],
      ),
      content: const Text(''),
      isActive: true,
    ),
    Step(
      title: Row(
        children: [
          RichText(
              text: TextSpan(children: [
            TextSpan(text: 'Delivered    ', style: TextStyle(color: black)),
            TextSpan(
                text: '\nItem delivered',
                style: TextStyle(fontSize: 12, color: Colors.black54))
          ])),
          addHorizontalySpace(25),
          RichText(
              text: TextSpan(children: [
            TextSpan(text: 'Friday, 10 Aug', style: TextStyle(color: black)),
            const TextSpan(
                text: '\nExpected',
                style: TextStyle(fontSize: 12, color: Colors.black54))
          ])),
        ],
      ),
      content: const Text(''),
      state: StepState.complete,
      isActive: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(1),
      padding: EdgeInsets.all(10),
      height: height(context) * 0.35,
      width: width(context) * 0.93,
      decoration: shadowDecoration(10, 2),
      child: Theme(
        data: ThemeData(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: Color.fromRGBO(42, 217, 87, 1),
              ),
        ),
        child: Stepper(
          physics: NeverScrollableScrollPhysics(),
          controlsBuilder: (context, details) {
            return Container();
          },
          currentStep: this.current_step,
          steps: steps,
          type: StepperType.vertical,
          onStepTapped: (step) {
            setState(() {
              current_step = step;
            });
          },
          onStepContinue: () {
            setState(() {
              if (current_step < steps.length - 1) {
                current_step = current_step + 1;
              } else {
                current_step = 0;
              }
            });
          },
          onStepCancel: () {
            setState(() {
              if (current_step > 0) {
                current_step = current_step - 1;
              } else {
                current_step = 0;
              }
            });
          },
        ),
      ),
    );
  }
}
