import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../model/global_helper.dart';
import '../../utils/constants.dart';
import '../../widget/custom_appbar.dart';

class WalletScreen extends StatefulWidget {
  WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;

  List paymentList = [];
  double dataSum = 0;

  dynamic totalAmnt = 0;
  double disPer = 0;
  Future<void> _getPamentsCalculation() async {
    var a = await FirebaseFirestore.instance
        .collection("commission")
        .doc("percent")
        .get();
    double percent = a['percent'].toDouble();
    disPer = percent;
    await FirebaseFirestore.instance
        .collection("Orders")
        .where('vendorId',
            isEqualTo: FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
        .where('orderCompleted', isEqualTo: true)
        .snapshots()
        .listen((value) {
      paymentList.clear();

      for (var doc in value.docs) {
        for (int i = 0; i < doc.data()['items'].length; i++) {
          dataSum += doc.data()['items'][i]['vendorPrice'] *
              doc.data()['items'][i]['productQty'];
        }
      }

      // setState(() {});
    });
    // .orderBy("createdAt", descending: true)
    //     .get()
    //     .then((value) {

    //   // }

    //   // notifyListeners();
    // });
    _getProfileData().then((value) {
      updateVendorBalance().then((value) {
        getVendorIncome();
      });
    });
    if (mounted) {
      setState(() {});
    }
  }

  var totalAmount = 0;
  Map? vendorData = {};
  Future<void> _getProfileData() async {
    await FirebaseFirestore.instance
        .collection('vendors')
        .doc(FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          vendorData = value.data()!;
          // totalAmount = vendorData!['walletAmount'];
          // ignore: avoid_print

          log(vendorData!['marketName'].toString());
        });
      }
    });
  }

  double withdrawalAmount = 0.0;
  List<dynamic> dataSum2 = <dynamic>[];

  List<dynamic> withdrawalAmountList = [];
  Future<void> _getWithdrawalAmount() async {
    await FirebaseFirestore.instance
        .collection("VendorWithdrawRequest")
        .where('vendorId',
            isEqualTo: FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
        .get()
        .then((value) {
      withdrawalAmountList.clear();
      for (var doc in value.docs) {
        withdrawalAmountList.add(doc.data()['amount']);
        log('sssss${doc.data()}');

        if (mounted) {
          setState(() {});
        }

        int numLists = withdrawalAmountList.length;

        double sum;
        for (var i = 0; i < numLists; i++) {
          sum = 0.0;
          for (var j = 0; j < numLists; j++) {
            sum += withdrawalAmountList[j];
          }
          dataSum2.add(sum);
        }

        withdrawalAmount = dataSum2.last;

        // var riderAmnt = 0.0;
        // for (var element in withdrawalAmountList) {
        //   log('mmmmm${element}');

        //   riderAmnt += element;
        //   if (mounted) {
        //     setState(() {});
        //   }
        // }

        log('mmmmm$withdrawalAmount');
      }
    });
  }

  Future<void> updateVendorBalance() async {
    await FirebaseFirestore.instance
        .collection('VendorTotalAmount')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "amount": dataSum.toStringAsFixed(2),
      "vendorName": vendorData!['marketName'],
      "date": Timestamp.now(),
      'vendorId': FirebaseAuth.instance.currentUser!.uid.substring(0, 20)
    }).then((value) {
      log(vendorData!['marketName'].toString());
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

  // @override
  // void initState() {
  //   _getPamentsCalculation();
  //   _tabController = TabController(length: 2, vsync: this);
  //   super.initState();
  // }

  List _tabList = ['Pending', 'settlement'];

  @override
  void didChangeDependencies() {
    _getPamentsCalculation();
    _tabController = TabController(length: 2, vsync: this);
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: CustomAppbar(
              title: 'Wallet',
            )),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            height: height(context) * 0.12,
            width: width(context) * 0.95,
            decoration: BoxDecoration(
                gradient: redGradient(),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 2,
                      offset: const Offset(1, 5)),
                ],
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Your Balance',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    dataSum == 0.0
                        ? const Text('0.0',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600))
                        : VendorIncomeData!.isEmpty
                            ? CircularProgressIndicator()
                            : Text('Rs ${VendorIncomeData!['amount']}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600)),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     // Navigator.push(
                    //     //     context,
                    //     //     MaterialPageRoute(
                    //     //         builder: (context) => WithDrawScreen()));
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.white,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(25),
                    //     ),
                    //     elevation: 15.0,
                    //   ),
                    //   child: Row(
                    //     children: [
                    //       Icon(
                    //         Icons.wallet,
                    //         color: black,
                    //       ),
                    //       const SizedBox(
                    //         width: 5,
                    //       ),
                    //       Text('Withdraw',
                    //           style: bodytext12Bold(color: black)),
                    //     ],
                    //   ),
                    // ),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child: SizedBox(
              height: height(context) * 0.041,
              // width: scWidth(context) * 0.95,
              child: TabBar(
                  controller: _tabController,
                  indicatorWeight: 0,
                  indicatorPadding: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  indicatorColor: primary,
                  unselectedLabelColor: primary,
                  indicator: BoxDecoration(
                      color: primary, borderRadius: BorderRadius.circular(8)),
                  labelStyle: bodytext12Bold(color: primary),
                  unselectedLabelStyle: bodyText12Small(color: Colors.grey),
                  isScrollable: false,
                  tabs: _tabList.map((e) {
                    return Tab(
                      child: Container(
                          width: width(context) * 0.6,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: primary)),
                          child: Text(e)),
                    );
                  }).toList()),
            ),
          ),
          addVerticalSpace(6),
          isLoaded == false
              ? CircularProgressIndicator()
              : SizedBox(
                  height: height(context) * 0.8,
                  child: TabBarView(controller: _tabController, children: [
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('Orders')
                            .where('vendorId',
                                isEqualTo: FirebaseAuth
                                    .instance.currentUser!.uid
                                    .substring(0, 20))
                            .where('orderCompleted', isEqualTo: true)
                            .snapshots(),
                        builder: (ctx, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasData) {
                            final data = snapshot.data!.docs;
                            return SizedBox(
                              height: height(context) * 0.7,
                              child: ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, i) {
                                    final paymentDate =
                                        data[i]['createdAt'].toDate();
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 8),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 1, horizontal: 12),
                                      height: height(context) * 0.12,
                                      width: width(context) * 0.92,
                                      decoration: BoxDecoration(
                                          color: white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 5)
                                          ]),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 21,
                                              ),
                                              const Icon(
                                                Icons.credit_score_outlined,
                                                size: 40,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                DateFormat('dd-MM-yyyy')
                                                    .format(paymentDate),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color:
                                                        black.withOpacity(0.4)),
                                              )
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Text(
                                                'Received from',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                "Desichikken",
                                                style: TextStyle(),
                                              )
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Builder(builder: (context) {
                                                  var total = ((data[i]['items']
                                                          as List)
                                                      .map((e) =>
                                                          (e['vendorPrice'] *
                                                              e['productQty']))
                                                      .toList()
                                                      .reduce((value,
                                                              element) =>
                                                          value +
                                                          element)).toString();
                                                  return Text(
                                                    'Rs. $total',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  );
                                                }),
                                                // RichText(
                                                //     text: TextSpan(children: [
                                                //   TextSpan(
                                                //       text: 'Credited to ',
                                                //       style: TextStyle(
                                                //           color: black.withOpacity(0.4))),
                                                //   TextSpan(
                                                //       text: 'XXXX',
                                                //       style: TextStyle(
                                                //           color: black,
                                                //           fontWeight: FontWeight.w500)),
                                                // ]))

                                                // addVerticalSpace(10),
                                                // Container(
                                                //   height: 25,
                                                //   width: width(context) * 0.25,
                                                //   color: Colors.green,
                                                // )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                            );
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }),
                    SizedBox(
                      height: height(context) * 0.7,
                      child: ListView.builder(
                          itemCount: 3,
                          itemBuilder: (context, i) {
                            // final paymentDate = data[i]['createdAt'].toDate();
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 12),
                              height: height(context) * 0.12,
                              width: width(context) * 0.92,
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: const [
                                    BoxShadow(color: Colors.grey, blurRadius: 5)
                                  ]),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 21,
                                      ),
                                      const Icon(
                                        Icons.credit_score_outlined,
                                        size: 40,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Date',
                                        // DateFormat('dd-MM-yyyy')
                                        //     .format(paymentDate),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: black.withOpacity(0.4)),
                                      )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'Received from',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        "Desichikken",
                                        style: TextStyle(),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Builder(builder: (context) {
                                          // var total = ((data[i]['items']
                                          //         as List)
                                          //     .map((e) => (e['vendorPrice'] *
                                          //         e['productQty']))
                                          //     .toList()
                                          //     .reduce((value, element) =>
                                          //         value +
                                          //         element)).toString();
                                          return Text(
                                            'Rs. 200',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600),
                                          );
                                        }),
                                        // RichText(
                                        //     text: TextSpan(children: [
                                        //   TextSpan(
                                        //       text: 'Credited to ',
                                        //       style: TextStyle(
                                        //           color: black.withOpacity(0.4))),
                                        //   TextSpan(
                                        //       text: 'XXXX',
                                        //       style: TextStyle(
                                        //           color: black,
                                        //           fontWeight: FontWeight.w500)),
                                        // ]))

                                        // addVerticalSpace(10),
                                        // Container(
                                        //   height: 25,
                                        //   width: width(context) * 0.25,
                                        //   color: Colors.green,
                                        // )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                    )
                  ]),
                )
        ])));
  }
}
