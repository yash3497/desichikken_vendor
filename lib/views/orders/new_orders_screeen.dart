import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delicious_vendor/model/firebaseOperation.dart';
import 'package:delicious_vendor/widget/custom_appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../model/global_helper.dart';
import '../../utils/constants.dart';
import '../../widget/custom_gradient_button.dart';

class NewOrdersScreen extends StatefulWidget {
  const NewOrdersScreen({super.key});

  @override
  State<NewOrdersScreen> createState() => _NewOrdersScreenState();
}

class _NewOrdersScreenState extends State<NewOrdersScreen> {
  _getNewOrder() async {
    FirebaseFirestore.instance
        .collection("Orders")
        .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((event) {
      print(lat);
      print(long);
      if (event.docs.isNotEmpty) {
        for (var doc in event.docs) {
          double distance = calculateDistanceKM(lat, long,
              doc['customerLatlong']['lat'], doc['customerLatlong']['long']);
          print(distance);
          List dd = doc['items'];
          bool presents = false;
          for (var g in dd) {
            if (catList.contains(g['catId'])) {
              presents = true;
            }
          }
          if (doc.data()["orderAccept"] == false && distance <= 5 && presents) {
            FlutterRingtonePlayer.play(
              fromAsset: 'assets/images/Buzzerrr.mp3',
              looping: true,
            );
          } else if (doc.data()['orderAccept'] == true) {
            FlutterRingtonePlayer.stop();
          }
        }
      }
    });
  }

  List catList = [];
  getAllCat() async {
    catList.clear();
    var a = await FirebaseFirestore.instance
        .collection("vendors")
        .doc(FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
        .get();

    catList = a.data()!['cats'] ?? [];
    setState(() {});
  }

  Map vendorData = {};
  _getProfileData() async {
    await FirebaseFirestore.instance
        .collection('vendors')
        .doc(FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          vendorData = value.data()!;
          // ignore: avoid_print
          // log(vendorData.toString());
        });
      }
    });
  }

  List productsData = [];

  _getProductsData() async {
    await FirebaseFirestore.instance.collection('Orders').get().then((value) {
      // log(value.docs.toString());
      for (var doc in value.docs) {
        productsData.add(doc.data());
        log("sumitApatil${doc.data()['items']}");
      }
    });
  }

  _addNotificationData(String userId, String title) async {
    await FirebaseFirestore.instance.collection('userNotification').doc().set({
      'content': title,
      'createdAt': Timestamp.now(),
      'uid': userId,
    });
  }

  void sendPushMessage(String body, String title, String token) async {
    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAGl6VFKY:APA91bHLSjT-_c5cG3wkr8Gop-bhV6_Y0gyRW29s7SZHLyxh8l9LgedxUKOTOd-NGXNBmZIhEtNyMsfTYJWxC39bQaB_OahvZwbWKFptvnshLKRz7cguBbPcIccd9pgVIoa2LCmubAWJ',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
      print(response.statusCode);
      print(response.body);
      print('done');
    } catch (e) {
      print("error push notification");
    }
  }

  double currentQty = 0;
  num total = 0;

  Future<void> getProductQty(String doc) async {
    print(doc);
    await FirebaseFirestore.instance
        .collection("Products")
        .doc(doc)
        .get()
        .then((value) {
      currentQty = double.parse(value.data()!["quantity"].toString());
      log(currentQty.toString());
    });
  }

  @override
  void initState() {
    getAllCat();
    _getProfileData();
    _getProductsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: CustomAppbar(title: 'New Orders')),
        body: Column(
          children: [
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('Orders')
                    .where('vendorId',
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid
                            .substring(0, 20))
                    .where('orderAccept', isEqualTo: false)
                    .where('orderDenied', isEqualTo: false)
                    .snapshots(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    FlutterRingtonePlayer.stop();

                    Sneworder = '0';
                  } else {
                    FlutterRingtonePlayer.stop();
                    Sneworder = snapshot.data!.docs.length.toString();
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return Provider.of<GlobalHelper>(context, listen: false)
                        .nodatta();
                  }

                  if (snapshot.hasData) {
                    final data = snapshot.data!.docs;
                    _getNewOrder();
                    return SizedBox(
                      height: height(context) * 0.87,
                      child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (ctx, i) {
                            final timeStamp = DateFormat('dd-MM-yyyy')
                                .format(data[i]['createdAt'].toDate());
                            final docs = data[i].data();
                            // final orderPrice =
                            //     double.parse(data[i]['orderPrice'].toString());

                            // final orderQuantity = data[i]["orderQuantity"];

                            // final itemTotal = orderPrice * orderQuantity;
                            // final orderPrice=double.parse(data[i]["orderPrice"])
                            double distance = calculateDistanceKM(
                                lat,
                                long,
                                docs['customerLatlong']['lat'],
                                docs['customerLatlong']['long']);
                            print(distance);
                            List dd = data[i]['items'];
                            bool presents = false;
                            for (var g in dd) {
                              if (catList.contains(g['catId'])) {
                                presents = true;
                              }
                            }
                            if (distance <= 5 && presents) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 12, right: 12),
                                  width: width(context),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.4)),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: const Offset(0, 10),
                                            blurRadius: 33,
                                            color: const Color(0xffd3d3d3)
                                                .withOpacity(.90))
                                      ]),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "ID: ${data[i]['orderId']}",
                                              style:
                                                  bodytext12Bold(color: black),
                                            ),
                                            /* Text(
                      Provider.of<GlobalHelper>(context, listen: false).gettime(
                          widget.snapshot.data()["orderingTime"].round()),
                      style: bodyText1Bd(context: context),
                  ) */
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              height: 21,
                                              width: 66,
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xfff0066ff),
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              child: Text("New",
                                                  style: bodyText12Small(
                                                      color: white)),
                                            ),
                                            Text(
                                              timeStamp.toString(),
                                              style:
                                                  bodytext12Bold(color: black),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(
                                        thickness: 1,
                                        endIndent: 10,
                                        indent: 10,
                                      ),
                                      SizedBox(
                                        height: height(context) * 0.2,
                                        child: ListView.builder(
                                            itemCount: docs['items'].length,
                                            itemBuilder: (ctx, i) {
                                              // final docs = data[i]['items'];s
                                              var orderWeight =
                                                  docs['items'][i]['netWeight'];

                                              total += docs['items'][i]
                                                  ['vendorPrice'];

                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Row(
                                                  //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          height:
                                                              height(context) *
                                                                  0.06,
                                                          width:
                                                              width(context) *
                                                                  0.15,
                                                          child: Image.network(
                                                              docs['items'][i]
                                                                  ['image']),
                                                        ),
                                                        addHorizontalySpace(5),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "${docs['items'][i]["name"]} ",
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          docs['items'][i]
                                                                  ['productQty']
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        addHorizontalySpace(10),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Text(
                                                              "Net-",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                            Text(
                                                              "Weight-${orderWeight}",
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    const Spacer(),
                                                    Text(
                                                      "₹ ${docs['items'][i]['vendorPrice'] * docs['items'][i]['productQty']}",
                                                      style: bodyText14w600(
                                                          color: black),
                                                    )
                                                  ],
                                                ),
                                              );
                                            }),
                                      )
                                      // Padding(
                                      //   padding: const EdgeInsets.all(8.0),
                                      //   child: Row(
                                      //     //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //     children: [
                                      //       Container(
                                      //         height: 7,
                                      //         width: 7,
                                      //         decoration: BoxDecoration(
                                      //             image: DecorationImage(
                                      //                 image: AssetImage(
                                      //                     "assets/images/veg.png"))),
                                      //       ),
                                      //       SizedBox(
                                      //         width: 2,
                                      //       ),
                                      //       Text(
                                      //         "Melting Cheese x 2 Spaghetti Shrimp x1",
                                      //         style: bodyText14normal(color: black),
                                      //       ),
                                      //       Spacer(),
                                      //       Text(
                                      //         "₹ 400",
                                      //         style: bodyText14normal(color: black),
                                      //       )
                                      //     ],
                                      //   ),
                                      // ),
                                      ,
                                      const Divider(
                                        thickness: 1,
                                        endIndent: 10,
                                        indent: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Item Total: ",
                                              style:
                                                  bodytext12Bold(color: black),
                                            ),
                                            const SizedBox(
                                              width: 2,
                                            ),
                                            Text(
                                              ((docs['items'] as List)
                                                      .map((e) =>
                                                          (e['vendorPrice'] *
                                                              e['productQty']))
                                                      .toList()
                                                      .reduce(
                                                          (value, element) =>
                                                              value + element))
                                                  .toString(),
                                              style:
                                                  bodytext12Bold(color: black),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 6),
                                              padding: EdgeInsets.all(2),
                                              alignment: Alignment.center,
                                              height: 20,
                                              // width: 29,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: primary),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Text(
                                                // data[i]['isPaid'] ? 'PAID' : 'UNPAID',
                                                data[i]['paymentMethod'],
                                                style: bodyText11Small(
                                                    color: primary),
                                              ),
                                            ),
                                            const Spacer(),
                                            /* Text(
                      "₹ ${widget.snapshot.data()["totalAmount"]}",
                      style: black14SemiBoldTextStyle,
                  ) */
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                          // height: 10,
                                          ),
                                      /* Container(
              margin: EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              height: 30,
              width: 315,
              decoration: BoxDecoration(
                border: Border.all(color: greyColor.withOpacity(0.4)),
                color: whiteColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: [
                  Container(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(),
                          child: Icon(
                            Icons.remove,
                            color: buttoncolors,
                          ),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text("7 mins", style: black13BoldTextStyle),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.add,
                          color: buttoncolors,
                        )
                      ],
                  ),
                ],
              ),
            ),*/
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Container(
                                              height: 30,
                                              width: 114,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xffffb0707))),
                                              child: MaterialButton(
                                                height: height(context) / 25,
                                                minWidth: width(context) * 0.3,
                                                onPressed: () async {
                                                  // FlutterRingtonePlayer.stop();

                                                  _addNotificationData(
                                                      data[i]['uid'],
                                                      'Order Rejected\nOrder Id: ${data[i].id}');
                                                  sendPushMessage(
                                                      'Order Id: ${data[i].id}',
                                                      'Order Rejected',
                                                      await Provider.of<
                                                                  FirebaseOperations>(
                                                              context,
                                                              listen: false)
                                                          .getToken(
                                                              data[i]['uid']));
                                                  await Provider.of<
                                                              FirebaseOperations>(
                                                          context,
                                                          listen: false)
                                                      .rejectOrder(data[i].id)
                                                      .then((value) =>
                                                          FlutterRingtonePlayer
                                                              .stop());
                                                },
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                child: const Text("Reject",
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255,
                                                            192,
                                                            107,
                                                            107))),
                                              ),
                                            ),
                                            MaterialButton(
                                              height: height(context) / 27,
                                              minWidth: width(context) * 0.4,
                                              onPressed: () async {
                                                Slocation = vendorData[
                                                    'marketLocation'];
                                                Slong = vendorData['longitude'];
                                                Slat = vendorData['latitude'];
                                                // _getNewOrder();
                                                _addNotificationData(
                                                    data[i]['uid'],
                                                    'Order Accepted\nOrder Id: ${data[i].id}');
                                                sendPushMessage(
                                                    'Order Id: ${data[i].id}',
                                                    'Order Accepted',
                                                    await Provider.of<
                                                                FirebaseOperations>(
                                                            context,
                                                            listen: false)
                                                        .getToken(
                                                            data[i]['uid']));

                                                for (int j = 0;
                                                    j < docs['items'].length;
                                                    j++) {
                                                  getProductQty(docs['items'][j]
                                                          ['productID'])
                                                      .then((value) {
                                                    FirebaseFirestore.instance
                                                        .collection("Products")
                                                        .doc(docs['items'][j]
                                                            ['productID'])
                                                        .update({
                                                      'quantity': currentQty -
                                                          docs['items'][j]
                                                              ['productQty']
                                                    });
                                                  });
                                                }

                                                log('${docs['items'][i]['productQty']}');

                                                await Provider.of<
                                                            FirebaseOperations>(
                                                        context,
                                                        listen: false)
                                                    .acceptOrder(
                                                      data[i].id,
                                                      vendorData[
                                                          'marketLocation'],
                                                      vendorData['longitude'],
                                                      vendorData['latitude'],
                                                    )
                                                    .then((value) =>
                                                        FlutterRingtonePlayer
                                                            .stop());
                                              },
                                              color: primary,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              child: Text("Accept",
                                                  style: bodytext12Bold(
                                                      color: white)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox();
                            }
                          }),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                })
          ],
        ));
  }
}
