import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delicious_vendor/utils/constants.dart';
import 'package:delicious_vendor/views/auth/otp_verify_screen.dart';
import 'package:delicious_vendor/views/auth/waiting_screen.dart';
import 'package:delicious_vendor/widget/custom_gradient_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../controller/auth_controller.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  Map userData = {};

  // ignore: prefer_typing_uninitialized_variables
  var userId;

  final auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Future<void> signupGoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      UserCredential result = await auth.signInWithCredential(authCredential);
      User? user = result.user;

      if (result != null) {
        String randomUUDI = user!.uid;
        FirebaseFirestore.instance
            .collection("vendors")
            .where("email", isEqualTo: user.email)
            .get()
            .then((value) {
          if (value.docs.isEmpty) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LogInScreen(),
              ),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const WaitingScreen(),
              ),
            );
          }
        });
      } // if result not null we simply call the MaterialpageRoute,
      // for go to the HomePage screen
    }
  }

  _fetchUserData() async {
    await FirebaseFirestore.instance
        .collection('vendors')
        //
        .get()
        .then((value) {
      for (var doc in value.docs) {
        userData = doc.data();
        // log(userData.toString());
        setState(() {});
      }
    });
  }

  var phoneController = TextEditingController();
  var nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Container(
          width: width(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              addVerticalSpace(height(context) * 0.02),
              Stack(
                children: [
                  SizedBox(
                    height: height(context) * 0.36,
                    child: Image.asset(
                      'assets/images/logingbg.png',
                      color: ligthRed.withOpacity(0.3),
                    ),
                  ),
                  Positioned(
                      left: width(context) * 0.25,
                      top: 40,
                      child: Image.asset('assets/images/login2.png'))
                ],
              ),
              addVerticalSpace(10),
              SizedBox(
                width: width(context) * 0.6,
                child: Text(
                  'Welcome, manage your order',
                  textAlign: TextAlign.center,
                  style: bodyText20w700(color: black),
                ),
              ),
              addVerticalSpace(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 1,
                    width: width(context) * 0.29,
                    color: Colors.black12,
                  ),
                  addHorizontalySpace(8),
                  Text(
                    'Login or signup',
                    style: bodyText13normal(color: Colors.black54),
                  ),
                  addHorizontalySpace(8),
                  Container(
                    height: 1,
                    width: width(context) * 0.29,
                    color: Colors.black12,
                  ),
                ],
              ),
              addVerticalSpace(30),
              SizedBox(
                width: width(context) * 0.9,
                child: TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(top: 12, left: 20),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black38, width: 1.0),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black38, width: 1.0),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      filled: true,
                      hintStyle: const TextStyle(color: Colors.black38),
                      hintText: 'Enter Mobile Number',
                      fillColor: Colors.white70),
                ),
              ),
              addVerticalSpace(25),
              CustomButton(
                  buttonName: 'Verify',
                  onClick: () {
                    // log('Suminsdnt');

                    // if (userData['mobile'] == phoneController.text) {
                    //   log(userData['mobile']);
                    //   showMySnackBar(context, "You are already registered");
                    // if (phoneController.text.isNotEmpty) {
                    //   log('Sumit');

                    //   if (phoneController.text.isEmpty) {
                    //     showMySnackBar(context, "Can not be empty!");
                    //   } else {
                    sendOTPForSignUp(
                      context,
                      phoneController.text,
                    );
                    // }
                    // }
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => OtpVerifyScreen()));
                  }),
              addVerticalSpace(30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 1,
                    width: width(context) * 0.37,
                    color: Colors.black12,
                  ),
                  addHorizontalySpace(8),
                  Text(
                    'OR',
                    style: bodyText13normal(color: Colors.black54),
                  ),
                  addHorizontalySpace(8),
                  Container(
                    height: 1,
                    width: width(context) * 0.37,
                    color: Colors.black12,
                  ),
                ],
              ),
              addVerticalSpace(30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                      onTap: () {
                        signupGoogle(context);
                      },
                      child: Image.asset('assets/images/google.png')),
                  Image.asset('assets/images/fb.png'),
                  Image.asset('assets/images/apple.png'),
                ],
              ),
              addVerticalSpace(20),
              SizedBox(
                width: width(context) * .93,
                child: Text(
                  'By continuing you about to agree to the terms and conditions,privacy policay',
                  style: bodyText12Small(color: black.withOpacity(0.5)),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
