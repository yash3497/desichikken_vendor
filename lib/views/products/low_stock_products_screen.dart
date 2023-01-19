import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class ProductlowScrn extends StatefulWidget {
  static String routeName = '/ProductlowScrn';
  const ProductlowScrn({Key? key}) : super(key: key);

  @override
  State<ProductlowScrn> createState() => _ProductlowScrnState();
}

class _ProductlowScrnState extends State<ProductlowScrn> {
  // List<dynamic> filtercoupon = [];
  // Map? productItems;
  // List<dynamic> products = [];

  // callApi() async {
  //   await FirebaseFirestore.instance
  //       .collection('productItems')
  //       .doc(FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
  //       .get()
  //       .then((value) {
  //     productItems = value.data();
  //     if (productItems != null) {
  //       products = productItems!['list'];
  //       filtercoupon = productItems!['list'];
  //       filtercoupon.forEach((element) {});
  //     }
  //     log(productItems.toString());
  //     // countDiscount();
  //     setState(() {});
  //   });
  // }

  // @override
  // void initState() {
  //   callApi();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
              Text("Low Stock Products", style: bodyText20w700(color: black)),
              Icon(
                Icons.search,
                color: primary,
              ),
            ],
          ),
        ),
        body: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Low Stock Products", style: bodyText20w700(color: black)),
              const SizedBox(
                height: 22,
              ),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('Products')
                      .where('vendorId',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid
                              .substring(0, 20))
                      .where(
                        'quantity',
                        isLessThan: 5,
                      )
                      .snapshots(),
                  builder: (ctx, snapshot) {
                    // log(snapshot.connectionState.toString());
                    if (snapshot.hasError) {
                      log(snapshot.error.toString());
                      return Text('Error = ${snapshot.error}');
                    }
                    if (snapshot.hasData) {
                      final docs = snapshot.data!.docs;
                      return Expanded(
                        child: GridView.builder(
                            padding: const EdgeInsets.only(top: 16),
                            itemCount: docs.length,
                            // physics: const NeverScrollableScrollPhysics(),

                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 0.67),
                            itemBuilder: (context, index) {
                              // final data = docs[index].data();

                              return Container(
                                height: height(context) / 4.3,
                                width: width(context),
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
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: height(context) * 0.2,
                                        width: width(context) / 2.3,
                                        child: ClipRRect(
                                            clipBehavior: Clip.antiAlias,
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft: Radius.circular(8),
                                                    topRight:
                                                        Radius.circular(8)),
                                            child: Image.network(
                                              docs[index]['image'],
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                      addVerticalSpace(7),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            docs[index]['name'],
                                            style: bodyText14w600(color: black),
                                          )),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 2),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.amber),
                                            child: Row(
                                              children: [
                                                Text(
                                                  '4.1',
                                                  style: bodyText12Small(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const Icon(
                                                  Icons.star_rounded,
                                                  color: Colors.white,
                                                  size: 12,
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "In Stocks :",
                                            style: bodyText12Small(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            "${docs[index]['quantity']}",
                                            style: bodyText14w600(color: black),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Rs.${docs[index]['price']}',
                                        style: bodyText14w600(color: black),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  })
            ],
          ),
        ));
  }
}
