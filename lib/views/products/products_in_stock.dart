import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delicious_vendor/widget/custom_appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../utils/constants.dart';
import '../../widget/custom_textfield.dart';
import 'add_products.dart';
import 'edit_product.dart';

class ProductInStockScreen extends StatefulWidget {
  const ProductInStockScreen({
    super.key,
    required this.appBarName,
    required this.heading,
  });

  final String appBarName;
  final String heading;

  @override
  State<ProductInStockScreen> createState() => _ProductInStockScreenState();
}

class _ProductInStockScreenState extends State<ProductInStockScreen> {
  Map orderData = {};
  Map orders = {};
  List<String> orderDocList = [];
  List orderList = [];
  String riderDocId = '';
  dynamic numLists;
  // dynamic numElements;

  // Future<void> fetchOrders() async {
  //   FirebaseFirestore.instance
  //       .collection("Orders")
  //       // .orderBy("createdAt", descending: true)
  //       .get()
  //       .then((value) {
  //     orderList.clear();
  //     orderDocList.clear();
  //     for (var doc in value.docs) {
  //       orderDocList.add(doc.id);
  //       orderList.add(doc.data());
  //       riderDocId = doc.id;
  //       // orderList.add(OrderModel.fromMap(doc.data()));
  //       // log(doc.data()["items"].toString());

  //       // log(doc.id.toString());

  //       setState(() {});
  //     }

  //     // notifyListeners();
  //   });
  // }

  // @override
  // void initState() {
  //   fetchOrders();
  //   log(orderList.toString());

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: black,
              )),
          title: Text(
            widget.appBarName,
            style: bodyText16w600(color: black),
          ),
          /*actions: [
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => const AddProducts()));
              },
              child: Container(
                margin: const EdgeInsets.only(right: 15, top: 10, bottom: 10),
                height: 30,
                width: width(context) * 0.3,
                decoration: myFillBoxDecoration(0, primary, 30),
                child: Center(
                  child: Text(
                    '+ Add Products',
                    style: bodytext12Bold(color: white),
                  ),
                ),
              ),
            ),
          ],*/
        ),
        body: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Products in Stock", style: bodyText20w700(color: black)),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('Products')
                      .where('vendorId',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid
                              .substring(0, 20))
                      .snapshots(),
                  builder: (ctx, snapshot) {
                    if (snapshot.hasError)
                      return Text('Error = ${snapshot.error}');
                    if (snapshot.hasData) {
                      final docs = snapshot.data!.docs;
                      // log(docs.toString());
                      FirebaseFirestore.instance
                          .collection("Orders")
                          .where('vendorId',
                              isEqualTo: FirebaseAuth.instance.currentUser!.uid
                                  .substring(0, 20))
                          .where('order')
                          // .orderBy("createdAt", descending: true)
                          .get()
                          .then((value) {
                        orderList.clear();
                        orderDocList.clear();
                        for (var doc in value.docs) {
                          orderDocList.add(doc.id);
                          orderList.add(doc.data()['items'][0]['productQty']);
                          riderDocId = doc.id;
                          // orderList.add(OrderModel.fromMap(doc.data()));
                          // log(doc.data()["items"].toString());

                          log(orderList.toString());
                          // int numLists = orderList.length;

                          // dynamic numElements = orderList.length;
                          // double sum;
                          // List<double> dataSum = <double>[];
                          // for (var i = 0; i < numLists; i++) {
                          //   sum = 0.0;
                          //   for (var j = 0; j < numLists; j++) {
                          //     sum += orderList[j]; //inverted indexes
                          //   }
                          //   dataSum.add(sum);
                          // }

                          // output
                          // log(dataSum.toString());
                        }
                      });

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
                                    childAspectRatio: 0.6),
                            itemBuilder: (context, index) {
                              final data = docs[index].data();

                              return Container(
                                height: height(context) / 4.3,
                                width: width(context),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    // border: Border.all(
                                    //     color: Color.fromARGB(255, 189, 184, 184), width: 2),

                                    boxShadow: [
                                      BoxShadow(
                                        color: black.withOpacity(0.32),
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
                                              data['image'],
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                      addVerticalSpace(7),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            data['name'],
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
                                        children: [
                                          Text(
                                            'Discription : ',
                                            style: bodyText12Small(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            data['discription'],
                                            style: TextStyle(fontSize: 12),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
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
                                          Spacer(),
                                          Text(
                                            '${data['quantity']}',
                                            style: bodyText14w600(color: black),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Rs.${data['price']}',
                                            style: bodyText14w600(color: black),
                                          ),
                                          Spacer(),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (ctx) =>
                                                          EditProducts(
                                                              productDocId:
                                                                  docs[index]
                                                                      .id,
                                                              productData:
                                                                  data)));
                                            },
                                            child: Container(
                                              height: 25,
                                              width: width(context) * 0.15,
                                              decoration:
                                                  BoxDecoration(color: primary),
                                              child: Center(
                                                child: Text(
                                                  'Edit',
                                                  style: bodyText13normal(
                                                      color: white),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  })
            ],
          ),
        ));
  }
}
