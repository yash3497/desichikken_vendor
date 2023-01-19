import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delicious_vendor/utils/constants.dart';
import 'package:delicious_vendor/views/orders/Recieved_Orders_screen.dart';
import 'package:delicious_vendor/views/orders/cancelled_order_screen.dart';
import 'package:delicious_vendor/views/orders/delivered_orders_screen.dart';
import 'package:delicious_vendor/views/orders/new_orders_screeen.dart';
import 'package:delicious_vendor/views/orders/orders_details.dart';
import 'package:delicious_vendor/views/orders/process_orders_screen.dart';
import 'package:delicious_vendor/views/orders/returned_orders_screen.dart';
import 'package:delicious_vendor/views/orders/shipped_orders_screen.dart';
import 'package:delicious_vendor/widget/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

import '../../widget/custom_appbar.dart';
import 'my_orders_widget.dart';

class OrdersScreen extends StatelessWidget {
  OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: CustomAppbar(
            title: 'Orders',
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            addVerticalSpace(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Orders')
                        .where("vendorId",
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid
                                .substring(0, 20))
                        .where('orderAccept', isEqualTo: false)
                        .where('ordderDenied', isEqualTo: false)
                        .snapshots(),
                    builder: (ctx, snapshot) {
                      final data = snapshot.data;
                      if (snapshot.hasData) {
                        return CustomCard(
                            image: 'assets/images/ordercat1.png',
                            text: 'New ',
                            text2: data!.size.toString(),
                            height: height(context) * 0.09,
                            width: width(context) * 0.2,
                            ontap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => NewOrdersScreen()));
                            });
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('Orders')
                        .where("vendorId",
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid
                                .substring(0, 20))
                        .where('orderAccept', isEqualTo: true)
                        .snapshots(),
                    builder: (ctx, snapshot) {
                      final data = snapshot.data;
                      if (snapshot.hasData) {
                        return CustomCard(
                            image: 'assets/images/ordercat1.png',
                            text: 'Received',
                            text2: data!.size.toString(),
                            height: height(context) * 0.09,
                            width: width(context) * 0.2,
                            ontap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) =>
                                          RecievedOrdersScreen()));
                            });
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('Orders')
                        .where("vendorId",
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid
                                .substring(0, 20))
                        .where('orderProcess', isEqualTo: true)
                        .snapshots(),
                    builder: (ctx, snapshot) {
                      final data = snapshot.data;
                      if (snapshot.hasData) {
                        return CustomCard(
                            image: 'assets/images/ordercat2.png',
                            text: 'Process',
                            text2: data!.size.toString(),
                            height: height(context) * 0.09,
                            width: width(context) * 0.2,
                            ontap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => ProcessOrdersScreen()));
                            });
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('Orders')
                        .where("vendorId",
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid
                                .substring(0, 20))
                        .where('orderShipped', isEqualTo: true)
                        .snapshots(),
                    builder: (ctx, snapshot) {
                      final data = snapshot.data;
                      if (snapshot.hasData) {
                        return CustomCard(
                            image: 'assets/images/ordercaat3.png',
                            text: 'Shipped',
                            text2: data!.size.toString(),
                            height: height(context) * 0.09,
                            width: width(context) * 0.2,
                            ontap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => ShippedOrders()));
                            });
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
              ],
            ),
            Row(
              children: [
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('Orders')
                        .where("vendorId",
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid
                                .substring(0, 20))
                        .where('orderCompleted', isEqualTo: true)
                        .snapshots(),
                    builder: (ctx, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data;
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => DeliveredOrdersScreen()));
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 14, top: 20),
                            height: height(context) * 0.13,
                            width: width(context) * 0.28,
                            decoration: shadowDecoration(10, 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset('assets/images/ordermain1.png'),
                                Text(
                                  'Delivered',
                                  style: bodyText12Small(color: black),
                                ),
                                Text(
                                  data!.size.toString(),
                                  style: bodyText14w600(color: black),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('Orders')
                        .where("vendorId",
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid
                                .substring(0, 20))
                        .where('orderCancelled', isEqualTo: true)
                        .snapshots(),
                    builder: (ctx, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data;
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => CancelledorderScrn()));
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 14, top: 20),
                            height: height(context) * 0.13,
                            width: width(context) * 0.28,
                            decoration: shadowDecoration(10, 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset('assets/images/ordermain2.png'),
                                Text(
                                  'Cancelled',
                                  style: bodyText12Small(color: black),
                                ),
                                Text(
                                  data!.size.toString(),
                                  style: bodyText14w600(color: black),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('Orders')
                        .where("vendorId",
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid
                                .substring(0, 20))
                        .where('orderReturn', isEqualTo: true)
                        .snapshots(),
                    builder: (ctx, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data;
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => ReturnedOrdersScreen()));
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 14, top: 20),
                            height: height(context) * 0.13,
                            width: width(context) * 0.28,
                            decoration: shadowDecoration(10, 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset('assets/images/ordermain3.png'),
                                Text(
                                  'Returned',
                                  style: bodyText12Small(color: black),
                                ),
                                Text(
                                  data!.size.toString(),
                                  style: bodyText14w600(color: black),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
              ],
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection("Orders")
                  .where("vendorId",
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid
                          .substring(0, 20))
                  .snapshots(),
              // .where("orderCompleted", isEqualTo: true)

              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  Text(snapshot.error.toString());
                }
                if (snapshot.hasData) {
                  final data = snapshot.data!.docs;

                  return SizedBox(
                    height: height(context) * 0.62,
                    child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (ctx, i) {
                          final timeStamp = DateFormat('dd-MM-yyyy')
                              .format(data[i]['createdAt'].toDate());
                          // DateFormat('dd-MM-yyyy')
                          //     .format(data[i]['createdAt'].toDate());
                          return Container(
                            margin: EdgeInsets.all(12),
                            padding: const EdgeInsets.only(
                              top: 10,
                              left: 10,
                              right: 10,
                            ),
                            height: 170,
                            width: 370,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: black.withOpacity(0.3),
                                    blurRadius: 8.0,
                                  ),
                                ],
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Order ID- ${data[i].data()['orderId']}',
                                      style: bodyText14normal(color: black),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 7),
                                      decoration: BoxDecoration(
                                          color: data[i].data()[
                                                      'orderCancelled'] ==
                                                  true
                                              ? Colors.red
                                              : data[i].data()[
                                                          'orderCompleted'] ==
                                                      true
                                                  ? const Color(0xFF4AAF57)
                                                  : data[i].data()[
                                                              'orderAccept'] ==
                                                          true
                                                      ? Colors.blue
                                                      : Colors.blueAccent,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Text(
                                        data[i].data()['orderCancelled'] == true
                                            ? 'Cancelled'
                                            : data[i].data()[
                                                        'orderCompleted'] ==
                                                    true
                                                ? 'Completed'
                                                : data[i].data()[
                                                            'orderAccept'] ==
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
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      //  ?? '',
                                      data[i].data()['customerName'].toString(),
                                      style: bodyText14w600(color: black),
                                    ),
                                    Text(
                                      // snapshot.data()['userMobile'] ?? '',
                                      data[i]
                                          .data()['customerPhone']
                                          .toString(),
                                      style: bodyText14normal(color: black),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                          text: data[i]
                                              .data()['customerName']
                                              .toString(),
                                          style: bodyText14normal(
                                            color: Colors.grey,
                                          ),
                                          children: [
                                            TextSpan(
                                                text:
                                                    "  Rs ${((data[i]['items'] as List).map((e) => (e['vendorPrice'] * e['productQty'])).toList().reduce((value, element) => value + element)).toString()}",
                                                style: bodyText14w600(
                                                    color: black))
                                          ]),
                                    ),
                                    Text(
                                      data[i].data()['paymentMethod'],
                                      style: bodyText14w600(color: black),
                                    )
                                  ],
                                ),
                                RichText(
                                  text: TextSpan(
                                      text: "Order Date:    ",
                                      style: bodyText14normal(
                                        color: Colors.grey,
                                      ),
                                      children: [
                                        TextSpan(
                                            text: timeStamp.toString(),

                                            /* '${_numberToMonthMap[date.month]} ${date.day} ${date.year}' */
                                            style: bodyText14w600(color: black))
                                      ]),
                                ),
                              ],
                            ),
                          );
                        }),
                  );
                }
                // if (snapshot.data!.docs.length == 0) {
                //   return Provider.of<GlobalHelper>(context, listen: false)
                //       .nodatta();
                // }

                // return ListView(
                //   shrinkWrap: true,
                //   children: snapshot.data!.docs.map((e) {
                //     return OrderPlaced(
                //       snapshot: e,
                //       index: 1,
                //     );
                //   }).toList(),
                // );
                return CircularProgressIndicator();
              },
            )
          ],
        ),
      ),
    );
  }
}
