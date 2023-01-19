// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delicious_vendor/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../model/global_helper.dart';

class ProcessOrdersScreen extends StatefulWidget {
  static String routeName = '/CancelledorderScrn';
  const ProcessOrdersScreen({Key? key}) : super(key: key);

  @override
  State<ProcessOrdersScreen> createState() => _ProcessOrdersScreenState();
}

class _ProcessOrdersScreenState extends State<ProcessOrdersScreen> {
  bool isOpen = false;
  bool isReadMore = false;
  var itemTotal;
  var totalPrice;
  num? itemCount = 0;

  @override
  void initState() {
    itemTotal;
    totalPrice;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: white,
          foregroundColor: black,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BackButton(),
              // const SizedBox(
              //   width: 79,
              // ),
              Text("Process", style: bodyText20w700(color: black)),
              Icon(
                Icons.search,
                color: primary,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("Orders")
              .where("vendorId",
                  isEqualTo:
                      FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
              .where("orderProcess", isEqualTo: true)
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
              final docs = snapshot.data!.docs;
              // Scancelled = '0';
              log(docs.toString());

              return SizedBox(
                  height: height(context) * 0.86,
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
                                            style: bodytext12Bold(color: black),
                                          ),
                                          Container(
                                            height: 33,
                                            width: width(context) * 0.24,
                                            decoration: myFillBoxDecoration(
                                                0, Colors.orange, 10),
                                            child: Center(
                                              child: Text(
                                                'Processing',
                                                style: bodyText14w600(
                                                    color: white),
                                              ),
                                            ),
                                          )
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
                                                      color: black),
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
                                                height: height(context) * 0.21,
                                                child: ListView.builder(
                                                    itemCount:
                                                        data['items'].length,
                                                    itemBuilder: (ctx, i) {
                                                      itemTotal = data['items']
                                                              [i]['price'] *
                                                          data['items'].length;
                                                      totalPrice = itemTotal;
                                                      return Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                decoration:
                                                                    shadowDecoration(
                                                                        15, 0),
                                                                height: height(
                                                                        context) *
                                                                    0.08,
                                                                width: width(
                                                                        context) *
                                                                    0.18,
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                  child: Image
                                                                      .network(
                                                                    data['items']
                                                                            [i][
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
                                                                      data['items']
                                                                              [
                                                                              i]
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
                                                                          'Rs.${data['items'][i]['vendorPrice'] * data['items'][i]['productQty']}',
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
                                                                    child: Text(
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
                                                        ((data['items'] as List)
                                                                    .map((e) =>
                                                                        (e['vendorPrice'] *
                                                                            e[
                                                                                'productQty']))
                                                                    .toList()
                                                                    .reduce((value,
                                                                            element) =>
                                                                        value +
                                                                        element) +
                                                                data[
                                                                    'deliveryFees'])
                                                            .toString(),
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
        /*Column(
        children: [
          Readybody(
            text: "Ready", 
            color: Color(0xfffFF9C06))
        ],
      ),*/

        );
  }
}
