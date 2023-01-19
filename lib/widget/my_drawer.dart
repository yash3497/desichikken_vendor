import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delicious_vendor/controller/auth_controller.dart';
import 'package:delicious_vendor/views/humburger_items_screens/contact_us_screen.dart';
import 'package:delicious_vendor/views/humburger_items_screens/privacy_policy_screen.dart';
import 'package:delicious_vendor/views/humburger_items_screens/product_update_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../utils/constants.dart';
import '../views/humburger_items_screens/about_us_screen.dart';
import '../views/humburger_items_screens/category_selection.dart';
import '../views/humburger_items_screens/faqs_screen.dart';
import '../views/humburger_items_screens/terms_and_conditions.dart';
import '../views/products/products_in_stock.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          addVerticalSpace(20),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('vendors')
                  .where('vendorId',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid
                          .substring(0, 20))
                  .snapshots(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  final data = snapshot.data!.docs;
                  return SizedBox(
                    height: height(context) * 0.14,
                    child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (ctx, i) {
                          return ListTile(
                            leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 30,
                                child: data[i]['image'] == ''
                                    ? Icon(
                                        Icons.maps_home_work_outlined,
                                        color: black,
                                      )
                                    : Image.network(data[i]['image'])),
                            title: Text(
                              data[i]['marketName'],
                              style: bodyText16w600(color: black),
                            ),
                            subtitle: Text(data[i]['marketPhone']),
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => FillYourProfileScreen()));
                            },
                          );
                        }),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
          addVerticalSpace(20),
          ListTile(
            leading: Icon(Icons.category),
            title: Text(
              'Products',
              style: bodyText14w600(color: black),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProductInStockScreen(
                            appBarName: ' Products in Stock',
                            heading: ' Products in Stock',
                          )));
            },
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: Icon(Icons.currency_exchange_rounded),
            title: Text(
              'Categories',
              style: bodyText14w600(color: black),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CategorySelection()));
            },
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: Icon(Icons.note_alt),
            title: Text(
              'Terms & Conditions ',
              style: bodyText14w600(color: black),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TermsAndCondition()));
            },
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip_outlined),
            title: Text(
              'Privacy Policy',
              style: bodyText14w600(color: black),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PrivacyPolicy()));
            },
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: Icon(Icons.report_gmailerrorred_outlined),
            title: Text(
              'About us',
              style: bodyText14w600(color: black),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AboutUsScreen()));
            },
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: Icon(Icons.call),
            title: Text(
              'Contact us',
              style: bodyText14w600(color: black),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ContactUsScreen()));
            },
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: Icon(Icons.help_outline_sharp),
            title: Text(
              'FAQs',
              style: bodyText14w600(color: black),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FAQsScreen()));
            },
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: Icon(Icons.logout_outlined),
            title: Text(
              'Logout',
              style: bodyText14w600(color: black),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              logOut(context);
            },
          ),
        ],
      ),
    );
  }
}
