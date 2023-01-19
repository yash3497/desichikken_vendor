import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delicious_vendor/widget/custom_appbar.dart';
import 'package:delicious_vendor/widget/custom_gradient_button.dart';
import 'package:delicious_vendor/widget/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../model/global_helper.dart';
import '../../utils/constants.dart';

enum orderFilter { all, today, last30days, last6month, last1year }

class TodaysOrders extends StatefulWidget {
  TodaysOrders({super.key});

  @override
  State<TodaysOrders> createState() => _TodaysOrdersState();
}

class _TodaysOrdersState extends State<TodaysOrders> {
  List orderStatus = [
    {'status': 'Processing', 'color': Colors.orange},
    {'status': 'Confirmed', 'color': Colors.green},
    {'status': 'Confirmed', 'color': Colors.green},
    {'status': 'Confirmed', 'color': Colors.green},
    {'status': 'Confirmed', 'color': Colors.green},
    {'status': 'Confirmed', 'color': Colors.green}
  ];

  List productList = [
    {
      'name': 'Polutry Chicken',
      'weight': '1 KG',
      'price': '250',
    },
    {
      'name': 'Eggs',
      'weight': '6 Pcs',
      'price': '80',
    },
  ];

  bool isOpen = false;
  orderFilter _value = orderFilter.today;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CustomAppbar(title: 'Orders')),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(10.0),
          //   child: Row(
          //     children: [
          //       SizedBox(
          //           width: width(context) * 0.7,
          //           child: CustomTextField(hintText: 'Search in orders')),
          //       Spacer(),
          //       InkWell(
          //         onTap: () {
          //           showFiltersOrders(context);
          //         },
          //         child: Container(
          //           height: 40,
          //           width: width(context) * 0.22,
          //           decoration:
          //               myOutlineBoxDecoration(1, black.withOpacity(0.3), 10),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Text(
          //                 'Filters',
          //                 style: bodyText14w600(color: black),
          //               ),
          //               const Icon(
          //                 Icons.filter_alt_outlined,
          //                 size: 20,
          //               )
          //             ],
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection("Orders")
                .where("vendorId",
                    isEqualTo:
                        FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
                .snapshots(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data!.docs.isEmpty) {
                return Provider.of<GlobalHelper>(context, listen: false)
                    .nodatta();
              }
              if (snapshot.hasData) {
                // final docs = snapshot.data!.docs;
                final temp = snapshot.data!.docs;
                final docs = temp
                    .where((element) =>
                        DateFormat('dd-MM-yyyy')
                            .format(element['createdAt'].toDate()) ==
                        DateFormat('dd-MM-yyyy').format(DateTime.now()))
                    .toList();
                // Scancelled = '0';
                log(docs.toString());

                return SizedBox(
                    height: height(context) * 0.87,
                    child: ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (ctx, i) {
                          final data = docs[i].data();

                          final timeStamp = DateFormat('dd-MM-yyyy')
                              .format(data['createdAt'].toDate());
                          // log(data['orderId'].toString());
                          // final itemPrice =
                          //     data['orderPrice'] * data['orderQuantity'];
                          // final totalPrice = itemPrice + data['deliveryFees'];
                          return Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.all(10),
                                height: !isOpen
                                    ? height(context) * 0.16
                                    : height(context) * 0.65,
                                width: width(context) * 0.93,
                                decoration: shadowDecoration(10, 2),
                                child: Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Order ID- ${data['orderId']}',
                                              style:
                                                  bodytext12Bold(color: black),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 7),
                                              decoration: BoxDecoration(
                                                  color: data['orderCancelled'] ==
                                                          true
                                                      ? Colors.red
                                                      : data['orderCompleted'] ==
                                                              true
                                                          ? const Color(
                                                              0xFF4AAF57)
                                                          : data['orderAccept'] ==
                                                                  true
                                                              ? Colors.blue
                                                              : Colors
                                                                  .blueAccent,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Text(
                                                data['orderCancelled'] == true
                                                    ? 'Cancelled'
                                                    : data['orderCompleted'] ==
                                                            true
                                                        ? 'Completed'
                                                        : data['orderAccept'] ==
                                                                true
                                                            ? 'Receive'
                                                            : 'New',
                                                style: bodytext12Bold(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '${data['items'].length} Item(s) Order Placed',
                                          style: bodyText14w600(color: black),
                                        ),
                                        const Divider(
                                          thickness: 1,
                                        ),
                                        if (isOpen)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Date & Time',
                                                    style: bodyText12Small(
                                                        color: black
                                                            .withOpacity(0.5)),
                                                  ),
                                                  Text(
                                                    '${timeStamp}',
                                                    style: bodytext12Bold(
                                                        color: black
                                                            .withOpacity(0.5)),
                                                  ),
                                                ],
                                              ),
                                              addVerticalSpace(10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Your Order',
                                                    style: bodyText16w600(
                                                        color: black),
                                                  ),
                                                ],
                                              ),
                                              addVerticalSpace(10),
                                              SizedBox(
                                                  height:
                                                      height(context) * 0.21,
                                                  child: ListView.builder(
                                                      itemCount:
                                                          data['items'].length,
                                                      itemBuilder: (ctx, i) {
                                                        return Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  decoration:
                                                                      shadowDecoration(
                                                                          15,
                                                                          0),
                                                                  height: height(
                                                                          context) *
                                                                      0.08,
                                                                  width: width(
                                                                          context) *
                                                                      0.18,
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15),
                                                                    child: Image
                                                                        .network(
                                                                      data['items']
                                                                              [
                                                                              i]
                                                                          [
                                                                          'image'],
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    ),
                                                                  ),
                                                                ),
                                                                addHorizontalySpace(
                                                                    10),
                                                                SizedBox(
                                                                  height: height(
                                                                          context) *
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
                                                                        data['items'][i]
                                                                            [
                                                                            'name'],
                                                                        style: bodyText14w600(
                                                                            color:
                                                                                black),
                                                                      ),
                                                                      Text(
                                                                        "Net wt: ${data['items'][i]['netWeight']} gms",
                                                                        style: bodyText11Small(
                                                                            color:
                                                                                black.withOpacity(0.5)),
                                                                      ),
                                                                      addVerticalSpace(
                                                                          5),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            'Rs.${data['items'][i]['price']}',
                                                                            style:
                                                                                bodyText14w600(color: primary),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                addHorizontalySpace(
                                                                    30),
                                                                Container(
                                                                  height: 30,
                                                                  width: width(
                                                                          context) *
                                                                      0.2,
                                                                  decoration:
                                                                      shadowDecoration(
                                                                          7, 1),
                                                                  child: Center(
                                                                      child:
                                                                          Text(
                                                                    'Qty-${data['items'][i]['productQty']}',
                                                                    style: bodytext12Bold(
                                                                        color:
                                                                            black),
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
                                                      })),

                                              addVerticalSpace(20),
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                margin: EdgeInsets.all(1),
                                                height: height(context) * 0.16,
                                                width: width(context) * 0.93,
                                                decoration:
                                                    shadowDecoration(10, 2),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Coupon Applied %',
                                                          style: bodyText14w600(
                                                              color: black),
                                                        ),
                                                        Text(
                                                          '${data['discount']} %',
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
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Delivery',
                                                          style: bodyText14w600(
                                                              color: black),
                                                        ),
                                                        Text(
                                                          'Rs.${data['deliveryFees']}',
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
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Total',
                                                              style:
                                                                  bodyText16w600(
                                                                      color:
                                                                          black),
                                                            ),
                                                            Text(
                                                              '(Using Coupon + Delivery Fees)',
                                                              style: bodyText11Small(
                                                                  color: black
                                                                      .withOpacity(
                                                                          0.5)),
                                                            )
                                                          ],
                                                        ),
                                                        Text(
                                                          'Rs.${data['totalAmount']}',
                                                          style: bodyText16w600(
                                                              color: primary),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              addVerticalSpace(15),
                                              // Center(child: widget.showDetailAndTrackButton),
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
                        }));
              } else {
                Scancelled = snapshot.data!.docs.length.toString();
              }
              if (snapshot.data!.docs.isEmpty) {
                return Provider.of<GlobalHelper>(context, listen: false)
                    .nodatta();
              }
              log(snapshot.data!.docs.toString());
              return CircularProgressIndicator();

              // return ListView(
              //   shrinkWrap: true,
              //   children: snapshot.data!.docs.map((e) {
              //     return Readybody(
              //       snapshot: e,
              //       index: 1,
              //     );
              //   }).toList(),
              // );
            },
          )
        ],
      ),
    );
  }

  Future<dynamic> showFiltersOrders(BuildContext context) {
    return showModalBottomSheet(
      context: context,

      backgroundColor: Colors.white,
      //elevates modal bottom screen
      elevation: 10,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
              padding: EdgeInsets.all(12),
              height: height(context) * 0.55,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filters Orders',
                        style: bodyText16w600(color: black),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close))
                    ],
                  ),
                  Text(
                    'Time',
                    style: bodyText14w600(color: black),
                  ),
                  RadioListTile(
                      value: orderFilter.all,
                      activeColor: primary,
                      title: Text('All orders'),
                      groupValue: _value,
                      onChanged: (newValue) {
                        setState(() {
                          _value = newValue as orderFilter;
                        });
                      }),
                  RadioListTile(
                      value: orderFilter.today,
                      activeColor: primary,
                      title: Text('Today orders'),
                      groupValue: _value,
                      onChanged: (newValue) {
                        setState(() {
                          _value = newValue as orderFilter;
                        });
                      }),
                  RadioListTile(
                      value: orderFilter.last30days,
                      activeColor: primary,
                      title: Text('Last 30 days'),
                      groupValue: _value,
                      onChanged: (newValue) {
                        setState(() {
                          _value = newValue as orderFilter;
                        });
                      }),
                  RadioListTile(
                      value: orderFilter.last6month,
                      activeColor: primary,
                      title: Text('Last 6 months'),
                      groupValue: _value,
                      onChanged: (newValue) {
                        setState(() {
                          _value = newValue as orderFilter;
                        });
                      }),
                  RadioListTile(
                      value: orderFilter.last1year,
                      activeColor: primary,
                      title: Text('Last 1 Year'),
                      groupValue: _value,
                      onChanged: (newValue) {
                        setState(() {
                          _value = newValue as orderFilter;
                        });
                      }),
                  addVerticalSpace(8),
                  CustomButton(buttonName: 'Apply', onClick: () {})
                ],
              ));
        });
      },
    );
  }
}
