import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../../widget/custom_appbar.dart';

class MyOrdersDetails extends StatefulWidget {
  const MyOrdersDetails({
    required this.status,
    required this.appbarTitle,
    required this.reasonTocancel,
    required this.statusColor,
    // required this.showDetailAndTrackButton,

    required this.returnWidget,
  });

  final String status;
  final String appbarTitle;
  final String reasonTocancel;
  final Color statusColor;
  // final Widget showDetailAndTrackButton;
  final Widget returnWidget;

  @override
  State<MyOrdersDetails> createState() => _MyOrdersDetailsState();
}

class _MyOrdersDetailsState extends State<MyOrdersDetails> {
  bool isOpen = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: CustomAppbar(
              title: widget.appbarTitle,
            )),
        body: SizedBox(
          height: height(context) * 0.89,
          child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: 8,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.all(10),
                      height: !isOpen
                          ? height(context) * 0.18
                          : height(context) * 0.68,
                      width: width(context) * 0.93,
                      decoration: shadowDecoration(10, 2),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Order ID- 998070',
                                    style: bodyText14w600(color: black),
                                  ),
                                  Container(
                                    height: 33,
                                    width: width(context) * 0.3,
                                    decoration: myFillBoxDecoration(
                                        0, widget.statusColor, 10),
                                    child: Center(
                                      child: Text(
                                        widget.status,
                                        style: bodyText14w600(color: white),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                '2 Item(s) Order Placed',
                                style: bodyText14w600(color: black),
                              ),
                              Text(
                                widget.reasonTocancel,
                                style: bodyText13normal(color: black),
                              ),
                              const Divider(
                                thickness: 1,
                              ),
                              if (isOpen)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Date & Time',
                                          style: bodyText12Small(
                                              color: black.withOpacity(0.5)),
                                        ),
                                        Text(
                                          'Dec 18,2021 I 14:27 Pm',
                                          style: bodytext12Bold(color: black),
                                        ),
                                      ],
                                    ),
                                    addVerticalSpace(10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Your Order',
                                          style: bodyText16w600(color: black),
                                        ),
                                        widget.returnWidget
                                      ],
                                    ),
                                    addVerticalSpace(10),
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
                                                      decoration:
                                                          shadowDecoration(
                                                              15, 0),
                                                      height: height(context) *
                                                          0.08,
                                                      width:
                                                          width(context) * 0.18,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        child: Image.asset(
                                                          'assets/images/meat.png',
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    ),
                                                    addHorizontalySpace(10),
                                                    SizedBox(
                                                      height: height(context) *
                                                          0.08,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Polutry Chicken',
                                                            style:
                                                                bodyText14w600(
                                                                    color:
                                                                        black),
                                                          ),
                                                          Text(
                                                            '900gms I Net: 450gms',
                                                            style: bodyText11Small(
                                                                color: black
                                                                    .withOpacity(
                                                                        0.5)),
                                                          ),
                                                          addVerticalSpace(5),
                                                          Row(
                                                            children: [
                                                              const Text(
                                                                'Rs.250',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .lineThrough,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black26),
                                                              ),
                                                              addHorizontalySpace(
                                                                  5),
                                                              Text(
                                                                'Rs.200',
                                                                style: bodyText14w600(
                                                                    color:
                                                                        primary),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    addHorizontalySpace(30),
                                                    Container(
                                                      height: 30,
                                                      width:
                                                          width(context) * 0.2,
                                                      decoration:
                                                          shadowDecoration(
                                                              7, 1),
                                                      child: Center(
                                                          child: Text(
                                                        'Qty-1',
                                                        style: bodytext12Bold(
                                                            color: black),
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
                                    addVerticalSpace(20),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.all(1),
                                      height: height(context) * 0.16,
                                      width: width(context) * 0.93,
                                      decoration: shadowDecoration(10, 2),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Item Total',
                                                style: bodyText14w600(
                                                    color: black),
                                              ),
                                              Text(
                                                'Rs.400',
                                                style: bodyText14w600(
                                                    color: black),
                                              )
                                            ],
                                          ),
                                          const Divider(
                                            thickness: 1,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Delivery',
                                                style: bodyText14w600(
                                                    color: black),
                                              ),
                                              Text(
                                                'Rs.40',
                                                style: bodyText14w600(
                                                    color: black),
                                              )
                                            ],
                                          ),
                                          const Divider(
                                            thickness: 1,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Total',
                                                style: bodyText16w600(
                                                    color: black),
                                              ),
                                              Text(
                                                'Rs.440',
                                                style: bodyText16w600(
                                                    color: primary),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    addVerticalSpace(15),
                                    Center(
                                      child: InkWell(
                                          onTap: () {
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             OrderStatusScreen()));
                                          },
                                          child: Text(
                                            'Show full details',
                                            style:
                                                bodyText14w600(color: primary),
                                          )),
                                    ),
                                  ],
                                ),
                              Center(
                                child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        isOpen = !isOpen;
                                      });
                                    },
                                    child: Icon(
                                      isOpen
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                      size: 40,
                                      color: black.withOpacity(0.6),
                                    )),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
        ));
  }
}
