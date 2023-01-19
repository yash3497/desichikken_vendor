// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delicious_vendor/views/auth/fill_your_profile.dart';
import 'package:delicious_vendor/views/auth/log_in_screen.dart';
import 'package:delicious_vendor/views/auth/otp_verify_screen.dart';
import 'package:delicious_vendor/widget/my_bottom_navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../views/auth/waiting_screen.dart';

class InitializerFirebaseUser extends StatefulWidget {
  const InitializerFirebaseUser({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _InitializerFirebaseUserState createState() =>
      _InitializerFirebaseUserState();
}

class _InitializerFirebaseUserState extends State<InitializerFirebaseUser> {
  late FirebaseAuth _auth;
  User? _user;
  bool isLoading = true;

  bool isVerified = false;
  final firebaseUser = FirebaseAuth.instance.currentUser;

  fetch() {
    try {
      FirebaseFirestore.instance
          .collection("vendors")
          .doc(firebaseUser?.uid.substring(0, 20))
          .get()
          .then((value) {
        // log(value["isVerified"].toString());
        log(value.toString());
        setState(() {
          isVerified = value["isVerified"];
        });
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    if (firebaseUser != null) {
      fetch();
    }
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    if (firebaseUser != null) {
      return isVerified ? const MyBottomBar() : const WaitingScreen();
    }
    return const LogInScreen();
    /*return isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : _user == null
            ? const LoginScrn()
            : const CustomBottomNavigation();*/
  }
}

//<------------------------------- Firebase Send Otp Method --------------------------->//
// void sendOTPForSignIN(
//     BuildContext context, TextEditingController controller) async {
//   String phone = "+91${controller.text.trim()}";
//   // var useId = FirebaseAuth.instance.currentUser!.uid.substring(0, 20);
//   await FirebaseAuth.instance.verifyPhoneNumber(
//       phoneNumber: phone,
//       codeSent: (verificationId, resendToken) {
//         Navigator.push(
//             context,
//             CupertinoPageRoute(
//                 builder: (context) => OtpScrn(
//                       phone: controller.text.trim(),
//                       verificationId: verificationId,
//                     )));
//       },
//       verificationCompleted: (credential) {},
//       verificationFailed: (ex) {
//         log(ex.code.toString());
//       },
//       codeAutoRetrievalTimeout: (verificationId) {},
//       timeout: const Duration(seconds: 30));
// }

//<------------------------------- Firebase Send Otp Method --------------------------->//
void sendOTPForSignUp(
  BuildContext context,
  String controller,
) async {
  String phone = "+91${controller.trim()}";
  // var useId = FirebaseAuth.instance.currentUser!.uid.substring(0, 20);
  await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      codeSent: (verificationId, resendToken) {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => OtpVerifyScreen(
                      phone: controller.trim(),
                      // name: name,
                      verificationId: verificationId,
                    )));
      },
      verificationCompleted: (credential) {},
      verificationFailed: (ex) {
        log(ex.code.toString());
      },
      codeAutoRetrievalTimeout: (verificationId) {},
      timeout: const Duration(seconds: 30));
}

//<----------------------- Firebase Verify Otp Method --------------------------->//
// void verifyOTPForSignIN(BuildContext context, TextEditingController controller,
//     String mobile, String verificationId) async {
//   String otp = controller.text.trim();

//   PhoneAuthCredential credential = PhoneAuthProvider.credential(
//       verificationId: verificationId, smsCode: otp);

//   try {
//     UserCredential userCredential =
//         await FirebaseAuth.instance.signInWithCredential(credential);
//     if (userCredential.user != null) {
//       Navigator.popUntil(context, (route) => route.isFirst);
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//               builder: (context) => const CustomBottomNavigation()));
//     }
//   } on FirebaseAuthException catch (ex) {
//     log(ex.code.toString());
//   }
// }

void verifyOTPForSignUp(
  BuildContext context,
  TextEditingController controller,
  String mobile,
  String verificationId,
) async {
  String otp = controller.text.trim();

  PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId, smsCode: otp);

  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    if (userCredential.user != null) {
      var userId = FirebaseAuth.instance.currentUser!.uid.substring(0, 20);
      FirebaseFirestore.instance
          .collection("vendors")
          .doc(userId)
          .set({"mobile": "+91$mobile", "vendorId": userId});
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const FillyourProfile()));
    }
  } on FirebaseAuthException catch (ex) {
    log(ex.code.toString());
  }
}

//<--------------------- Firebase Logout Method ------------------------>//
Future<void> logOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const LogInScreen(),
    ),
  );
}
