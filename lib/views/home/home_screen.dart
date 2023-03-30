import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delicious_vendor/model/firebaseOperation.dart';
import 'package:delicious_vendor/model/home_model.dart';
import 'package:delicious_vendor/utils/constants.dart';
import 'package:delicious_vendor/views/auth/fill_your_profile.dart';
import 'package:delicious_vendor/views/home/rating_screen.dart';
import 'package:delicious_vendor/views/home/todays_balanace_screen.dart';
import 'package:delicious_vendor/views/home/todays_orders.dart';
import 'package:delicious_vendor/views/home/wallet_tab_screen.dart';
import 'package:delicious_vendor/views/orders/orders_screen.dart';
import 'package:delicious_vendor/views/products/low_stock_products_screen.dart';
import 'package:delicious_vendor/views/products/out_of_stocks_screen.dart';
import 'package:delicious_vendor/views/products/products_in_stock.dart';
import 'package:delicious_vendor/widget/my_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../model/global_helper.dart';
import '../../widget/custom_gradient_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  toggleOnline(BuildContext context, bool val) async {
    await Provider.of<FirebaseOperations>(context, listen: false)
        .changeOnlineStatus(val);

    Provider.of<GlobalHelper>(context, listen: false).isOnline = val;
  }

  List orderList = [];

  Future<void> fetchOrders() async {
    FirebaseFirestore.instance
        .collection("Orders")
        // .orderBy("createdAt", descending: true)
        .get()
        .then((value) {
      orderList.clear();
      // orderDocList.clear();
      for (var doc in value.docs) {
        // orderDocList.add(doc.id);
        orderList.add(doc.data());
        // riderDocId = doc.id;
        // orderList.add(OrderModel.fromMap(doc.data()));
        // log(doc.data()["items"].toString());

        // log(doc.id.toString());

        setState(() {});
      }

      // notifyListeners();
    });
  }

  Map<String, dynamic> vendorData = {};
  bool? isvendorOnline;
  List paymentList = [];
  double dataSum = 0.0;

  Future<void> _getPamentsCalculation() async {
    await FirebaseFirestore.instance
        .collection("Orders")
        .where('vendorId',
            isEqualTo: FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
        .where('orderCompleted', isEqualTo: true)
        .get()
        .then((value) {
      paymentList.clear();
      // paymentDocId.clear();

      for (var doc in value.docs) {
        // log(DateFormat('dd-MM-yyyy').format(doc.data()["time"].toDate()));
        // log(DateFormat('dd-MM-yyyy').format(DateTime.now()));
        // log(DateFormat('dd-MM-yyyy').format(doc['createdAt'].toDate()));

        if (DateFormat('dd-MM-yyyy').format(doc.data()["createdAt"].toDate()) ==
            DateFormat('dd-MM-yyyy').format(DateTime.now())) {
          for (int i = 0; i < doc['items'].length; i++) {
            dataSum += doc.data()['items'][i]['vendorPrice'] *
                doc.data()['items'][i]['productQty'];
          }
        }
      }

      setState(() {});
      // }

      // notifyListeners();
    });
  }

  bool isLoaded = false;
  Map? VendorIncomeData = {};

  Future<void> getVendorIncome() async {
    await FirebaseFirestore.instance
        .collection('VendorTotalAmount')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          VendorIncomeData = value.data()!;
          isLoaded = true;
          // totalAmount = vendorData!['walletAmount'];
          // ignore: avoid_print

          log(VendorIncomeData!['amount'].toString());
        });
      }
    });
  }

  _getProfileData() async {
    await FirebaseFirestore.instance
        .collection('vendors')
        .doc(FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          vendorData = value.data()!.cast<String, dynamic>();
          // ignore: avoid_print
          log(vendorData.toString());
        });
      }
    });
  }

  _getNewOrder() async {
    FirebaseFirestore.instance
        .collection("Orders")
        .where('vendorId',
            isEqualTo: FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
        .where('orderAccept', isEqualTo: false)
        .where('orderDenied', isEqualTo: false)
        .snapshots()
        .listen((event) {
      if (event.docs.isNotEmpty) {
        for (var doc in event.docs) {
          // double distance = calculateDistanceKM(lat, long,
          //     doc['customerLatlong']['lat'], doc['customerLatlong']['long']);
          // print(distance);
          List dd = doc['items'];
          bool presents = false;
          for (var g in dd) {
            if (catList.contains(g['catId'])) {
              presents = true;
            }
          }

          if (doc.data()["orderAccept"] == false /*&& distance <= 5*/ &&
              presents) {
            print("bajna");
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

  Future<void> getProductQty(String doc) async {
    await FirebaseFirestore.instance
        .collection("Products")
        .doc(doc)
        .get()
        .then((value) {
      currentQty = double.parse(value.data()!["quantity"].toString());
      log(currentQty.toString());
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

  List sellingProgress = ['Fast selling products', 'Slow selling products'];
  bool isToggle = false;
  @override
  void initState() {
    // Future.delayed(Duration(seconds: 2), () {
    //   showRatingDeliveryBoy(context);
    // });
    getVendorIncome();
    getAllCat();
    _getPamentsCalculation();
    _getProfileData();
    super.initState();
  }

  num total = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _globalKey,
        drawer: MyDrawer(),
        appBar: AppBar(
          backgroundColor: white,
          leading: InkWell(
              onTap: () {
                _globalKey.currentState!.openDrawer();
              },
              child: Icon(
                Icons.menu,
                color: black,
                size: 30,
              )),
          actions: [
            // Padding(
            //   padding: const EdgeInsets.only(right: 8.0),
            //   child: Icon(
            //     Icons.search,
            //     color: primary,
            //     size: 30,
            //   ),
            // ),
            vendorData == null
                ? const Center(child: CircularProgressIndicator())
                : IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FillyourProfile()));
                    },
                    icon: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(vendorData['image'] == ""
                          ? "https://firebasestorage.googleapis.com/v0/b/"
                              "fresh4app-8c91e.appspot.com/o/other-image%2FSample_User_Icon.png?alt=media&token="
                              "ccbdab95-9976-47e8-8a55-06accddf97d0"
                          : vendorData['image'].toString()),
                    ))
          ],
          title: Padding(
            padding: EdgeInsets.only(right: width(context) * 0.35),
            child: FlutterSwitch(
              padding: 1,
              width: 70,
              height: 25,
              toggleSize: 26,
              activeText: 'Online',
              inactiveText: 'Offline',
              valueFontSize: 10,
              activeToggleColor: Colors.white,
              inactiveToggleColor: Colors.white,
              activeTextFontWeight: FontWeight.w700,
              inactiveTextFontWeight: FontWeight.w700,
              showOnOff: true,
              activeColor: Colors.green,
              activeTextColor: Colors.white,
              inactiveTextColor: Colors.white,
              inactiveColor: Colors.red,
              onToggle: (val) {
                toggleOnline(context, val);
                setState(() {});
              },
              value: Provider.of<GlobalHelper>(context, listen: true).isOnline,
            ),
          ),
        ),
        body: Provider.of<GlobalHelper>(context, listen: false).isOnline
            ? onlineWidget(context)
            : offlineWidget(context));
  }

  Widget offlineWidget(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Expanded(
          child: Image.asset(
            "assets/images/offline_scrn.png",
            width: 700,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Your outlet is temporarily closed',
          style: bodyText16w600(color: primary),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'You will go on ${DateTime.now().toString()}',
          style: bodyText14normal(color: black),
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: primary),
            onPressed: () async {
              await Provider.of<GlobalHelper>(context, listen: false)
                  .toggleOnline(context, true);
              setState(() {});
            },
            icon: const Icon(
              Icons.power_settings_new_outlined,
              color: Colors.white,
            ),
            label: Text(
              'Go online now',
              style: bodyText14w600(color: Colors.white),
            )),
        const Spacer(),
      ],
    );
  }

  Widget onlineWidget(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      addVerticalSpace(40),
      Row(
        children: [
          addHorizontalySpace(10),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('Orders')
                  .where('vendorId',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid
                          .substring(0, 20))
                  .snapshots(),
              builder: (ctx, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data!;

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TodaysOrders()));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      height: height(context) * 0.1,
                      width: width(context) * 0.22,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          // border: Border.all(
                          //     color: Color.fromARGB(255, 189, 184, 184), width: 2),

                          boxShadow: [
                            BoxShadow(
                              color: black.withOpacity(0.3),
                              blurRadius: 8.0,
                            ),
                          ],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/homecat3.png',
                            scale: 1.6,
                          ),
                          Text(
                            "Today's Orders",
                            style: bodyText14normal(
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Spacer(),
                          StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('Orders')
                                  .where('vendorId',
                                      isEqualTo: FirebaseAuth
                                          .instance.currentUser!.uid
                                          .substring(0, 20))
                                  // .where('time',
                                  //     isEqualTo: date)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Text(
                                    '0',
                                    style: bodyText12Small(color: black),
                                    textAlign: TextAlign.center,
                                  );
                                } else {
                                  final temp = snapshot.data!.docs;
                                  final data = temp
                                      .where((element) =>
                                          DateFormat('dd-MM-yyyy').format(
                                              element['createdAt'].toDate()) ==
                                          DateFormat('dd-MM-yyyy')
                                              .format(DateTime.now()))
                                      .toList();
                                  return Text(
                                    data.length.toString(),
                                    style: bodyText12Small(color: black),
                                    textAlign: TextAlign.center,
                                  );
                                }
                              }),
                        ],
                      ),
                    ),
                  );
                }
                return CircularProgressIndicator();
              }),
          addHorizontalySpace(8),
          CustomCard(
              image: 'assets/images/homecat1.png',
              text: 'Orders',
              text2: '',
              height: height(context) * 0.1,
              width: width(context) * 0.22,
              ontap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OrdersScreen()));
              }),
          addHorizontalySpace(8),
          CustomCard(
              image: 'assets/images/homecat2.png',
              text: 'Balance',
              text2:
                  VendorIncomeData!.isEmpty ? '0' : VendorIncomeData!['amount'],
              height: height(context) * 0.1,
              width: width(context) * 0.22,
              ontap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WalletScreen()));
              }),
          addHorizontalySpace(8),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('Products')
                  .where('vendorId',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid
                          .substring(0, 20))
                  .snapshots(),
              builder: (ctx, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data!;

                  return CustomCard(
                      image: 'assets/images/homecat3.png',
                      text: 'Products',
                      text2: data.size.toString(),
                      height: height(context) * 0.1,
                      width: width(context) * 0.22,
                      ontap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ProductInStockScreen(
                                      appBarName: ' Products in Stock',
                                      heading: ' Products in Stock',
                                    )));
                      });
                }
                return CircularProgressIndicator();
              })
        ],
      ),
      addVerticalSpace(15),
      Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          height: height(context) * 0.32,
          child: GridView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: mainGridview.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1.5,
                  mainAxisSpacing: 22,
                  crossAxisSpacing: 22,
                  crossAxisCount: 2),
              itemBuilder: (ctx, index) {
                return InkWell(
                  onTap: () {
                    if (index == 0) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TodaysBalanceWalletScreen()));
                    } else if (index == 1) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RatingScreen()));
                    } else if (index == 2) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductoutScrn()));
                    } else if (index == 3) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductlowScrn()));
                    }
                  },
                  child: Container(
                    height: height(context) * 0.10,
                    decoration: shadowDecoration(10, 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(mainGridview[index]['img']),
                        Text(
                          mainGridview[index]['title'],
                          style: bodyText14w600(color: black),
                        ),
                        Text(
                          index == 0
                              ? 'Rs $dataSum'
                              : mainGridview[index]['total'],
                          style: bodyText16w600(color: black),
                        ),
                      ],
                    ),
                  ),
                );
              })),
      Column(
        children: [
          Text(
            'New Orders',
            style: bodyText20w700(color: primary),
          ),
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
                print(FirebaseAuth.instance.currentUser!.uid.substring(0, 20));
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
                  print('-----------');
                  print(data.length);
                  _getNewOrder();
                  log(data.length.toString());
                  return SizedBox(
                    height: height(context) * 0.56,
                    child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (ctx, i) {
                          final timeStamp = DateFormat('dd-MM-yyyy hh:mm a')
                              .format(data[i]['createdAt'].toDate());
                          final docs = data[i].data();
                          List dd = data[i]['items'];
                          // bool presents = false;
                          // for (var g in dd) {
                          //   if (catList.contains(g['catId'])) {
                          //     presents = true;
                          //   }
                          // }

                          // final orderPrice =
                          //     double.parse(data[i]['orderPrice'].toString());

                          // final orderQuantity = data[i]["orderQuantity"];

                          // final itemTotal = orderPrice * orderQuantity;
                          // final orderPrice=double.parse(data[i]["orderPrice"])
                          print(lat);
                          print(long);
                          // double distance = calculateDistanceKM(
                          //     lat,
                          //     long,
                          //     docs['customerLatlong']['lat'],
                          //     docs['customerLatlong']['long']);
                          // print(distance);
                          // log(distance.toString());
                          // log(presents.toString());
                          // if (presents) {
                          // log(distance.toString());
                          return Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Container(
                              margin:
                                  const EdgeInsets.only(left: 12, right: 12),
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
                                          style: bodytext12Bold(color: black),
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
                                              color: const Color(0xfff0066ff),
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: Text("New",
                                              style: bodyText12Small(
                                                  color: white)),
                                        ),
                                        Text(
                                          timeStamp.toString(),
                                          style: bodytext12Bold(color: black),
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

                                          total +=
                                              docs['items'][i]['vendorPrice'];

                                          return Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Row(
                                              //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      height: height(context) *
                                                          0.06,
                                                      width:
                                                          width(context) * 0.15,
                                                      child: Image.network(
                                                          docs['items'][i]
                                                              ['image']),
                                                    ),
                                                    addHorizontalySpace(5),
                                                    SizedBox(
                                                      width:
                                                          width(context) * .37,
                                                      child: Flexible(
                                                        child: Text(
                                                          "${docs['items'][i]["name"]} ",
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      docs['items'][i]
                                                              ['productQty']
                                                          .toString(),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    addHorizontalySpace(10),
                                                    Text(
                                                      "Net Weight-${orderWeight}",
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "₹ ${docs['items'][i]['vendorPrice'] * docs['items'][i]['productQty']}",
                                                  style: bodyText14w600(
                                                      color: black),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  ),
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
                                          style: bodytext12Bold(color: black),
                                        ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                          ((docs['items'] as List)
                                              .map((e) => (e['vendorPrice'] *
                                                  e['productQty']))
                                              .toList()
                                              .reduce((value, element) =>
                                                  value + element)).toString(),
                                          style: bodytext12Bold(color: black),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 6),
                                          padding: EdgeInsets.all(2),
                                          alignment: Alignment.center,
                                          height: 20,
                                          // width: 29,
                                          decoration: BoxDecoration(
                                              border:
                                                  Border.all(color: primary),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Text(
                                            // data[i]['isPaid'] ? 'PAID' : 'UNPAID',
                                            data[i]['paymentMethod'],
                                            style:
                                                bodyText11Small(color: primary),
                                          ),
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                      // height: 10,
                                      ),
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
                                                    BorderRadius.circular(4)),
                                            child: const Text("Reject",
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 192, 107, 107))),
                                          ),
                                        ),
                                        MaterialButton(
                                          height: height(context) / 27,
                                          minWidth: width(context) * 0.4,
                                          onPressed: () async {
                                            Slocation =
                                                vendorData['marketLocation'];
                                            Slong = vendorData['longitude'];
                                            Slat = vendorData['latitude'];
                                            // _getNewOrder();
                                            _addNotificationData(data[i]['uid'],
                                                'Order Accepted\nOrder Id: ${data[i].id}');
                                            sendPushMessage(
                                                'Order Id: ${data[i].id}',
                                                'Order Accepted',
                                                await Provider.of<
                                                            FirebaseOperations>(
                                                        context,
                                                        listen: false)
                                                    .getToken(data[i]['uid']));
                                            getProductQty(docs['items'][i]
                                                    ['productID'])
                                                .then((value) {
                                              FirebaseFirestore.instance
                                                  .collection("Products")
                                                  .doc(docs['items'][i]
                                                      ['productID'])
                                                  .update({
                                                'quantity': currentQty -
                                                    docs['items'][i]
                                                        ['productQty']
                                              });
                                            });
                                            log('${docs['items'][i]['productQty']}');

                                            await Provider.of<
                                                        FirebaseOperations>(
                                                    context,
                                                    listen: false)
                                                .updadatePayment(
                                                    data[i]['orderId']);
                                            await Provider.of<
                                                        FirebaseOperations>(
                                                    context,
                                                    listen: false)
                                                .acceptOrder(
                                                  data[i].id,
                                                  vendorData['marketLocation'],
                                                  vendorData['latitude'],
                                                  vendorData['longitude'],
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
                                              style:
                                                  bodytext12Bold(color: white)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              })
        ],
      )

      //   Container(
      //     height: height(context) * 0.5,
      //     width: width(context) * 0.95,
      //     padding: EdgeInsets.all(1),
      //     decoration: shadowDecoration(10, 6),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         addVerticalSpace(6),
      //         Text(
      //           'Fast selling products ',
      //           style: bodyText16w600(color: primary),
      //         ),
      //         addVerticalSpace(6),
      //         Container(
      //           height: height(context) * 0.06,
      //           width: width(context),
      //           color: black.withOpacity(0.1),
      //           padding: EdgeInsets.all(7),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               Text(
      //                 'Menu Items',
      //                 style: bodyText14w600(color: black),
      //               ),
      //               Text(
      //                 'Revenue \ncontributions',
      //                 style: bodyText14w600(color: black),
      //               ),
      //               Text(
      //                 'Quantity \nsold',
      //                 style: bodyText14w600(color: black),
      //               ),
      //             ],
      //           ),
      //         ),
      //         StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      //             stream: FirebaseFirestore.instance
      //                 .collection('Orders')
      //                 .where('vendorId',
      //                     isEqualTo: FirebaseAuth.instance.currentUser!.uid
      //                         .substring(0, 20))
      //                 .snapshots(),
      //             builder: (ctx, snapshot) {
      //               if (snapshot.connectionState == ConnectionState.waiting) {
      //                 const Center(
      //                   child: CircularProgressIndicator(),
      //                 );
      //               } else if (snapshot.hasData) {
      //                 final data = snapshot.data!.docs;
      //                 return SizedBox(
      //                   height: height(context) * 0.39,
      //                   child: ListView.builder(
      //                       itemCount: data.length,
      //                       itemBuilder: (ctx, index) {
      //                         final docs = data[index].data();
      //                         return SizedBox(
      //                             height: height(context) * 0.39,
      //                             child: ListView.builder(
      //                                 itemCount: docs['items'].length,
      //                                 itemBuilder: (ctx, i) {
      //                                   final map = snapshot.data!.docs[i];
      //                                   final items = map['items'];
      //                                   return Padding(
      //                                     padding: const EdgeInsets.all(8.0),
      //                                     child: Row(
      //                                       mainAxisAlignment:
      //                                           MainAxisAlignment.spaceBetween,
      //                                       children: [
      //                                         Text(
      //                                           docs['items'][i]['name'],
      //                                           style:
      //                                               bodyText12Small(color: black),
      //                                         ),
      //                                         Text(
      //                                           '78%',
      //                                           style:
      //                                               bodyText12Small(color: black),
      //                                         ),
      //                                         Text(
      //                                           docs['items'][i]['productQty']
      //                                               .toString(),
      //                                           style:
      //                                               bodyText12Small(color: black),
      //                                         ),
      //                                       ],
      //                                     ),
      //                                   );
      //                                 }));
      //                       }),
      //                 );
      //               }
      //               return Center(child: Text('Loading...'));
      //             })
      //       ],
      //     ),
      //   )
    ]));
  }
}
