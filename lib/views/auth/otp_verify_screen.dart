import 'dart:async';

import 'package:delicious_vendor/utils/constants.dart';
import 'package:delicious_vendor/views/auth/fill_your_profile.dart';
import 'package:delicious_vendor/widget/custom_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pin_put/pin_put.dart';

import '../../controller/auth_controller.dart';

class OtpVerifyScreen extends StatefulWidget {
  String phone;
  String verificationId;

  OtpVerifyScreen({required this.phone, required this.verificationId});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  bool isTapped = false;
  bool isResendTapped = false;
  int start = 30;
  final TextEditingController mobileController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final TextEditingController _pinPutController = TextEditingController();

  final BoxDecoration pinPutDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.blue),
    // color: isTapped ? Colors.white : Colors.white,
    boxShadow: const [
      BoxShadow(
        color: Colors.white,
        spreadRadius: 2,
      )
    ],
  );
  void startTimer() {
    const onsec = Duration(seconds: 1);
    Timer timer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          start = 30;
          isResendTapped = false;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  final TextEditingController digit1 = TextEditingController();

  final TextEditingController digit2 = TextEditingController();

  final TextEditingController digit3 = TextEditingController();

  final TextEditingController digit4 = TextEditingController();

  final TextEditingController digit5 = TextEditingController();

  final TextEditingController digit6 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            width: width(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // addVerticalSpace(30),
                Stack(
                  children: [
                    SizedBox(
                      height: height(context) * 0.35,
                      child: Image.asset(
                        'assets/images/otpbg.png',
                        color: ligthRed.withOpacity(0.3),
                      ),
                    ),
                    Positioned(
                        top: 57,
                        left: 80,
                        child: Image.asset('assets/images/otp1.png'))
                  ],
                ),
                addVerticalSpace(10),
                Text(
                  'Verification Code',
                  style: bodyText20w700(color: black),
                ),

                addVerticalSpace(30),
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
                      'Verify Phone',
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
                    width: width(context) * 0.8,
                    child: const Text(
                      'We have sent to your registerd to your mobile number',
                      textAlign: TextAlign.center,
                    )),
                addVerticalSpace(30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.phone,
                      style: bodyText16w600(color: black),
                    ),
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: primary,
                      child: const Icon(
                        Icons.edit,
                        size: 15,
                      ),
                    )
                  ],
                ),
                addVerticalSpace(20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PinPut(
                    animationDuration: const Duration(seconds: 1),
                    eachFieldHeight: 30,
                    eachFieldWidth: 50,
                    fieldsCount: 6,
                    autofocus: true,
                    submittedFieldDecoration: pinPutDecoration,
                    selectedFieldDecoration: pinPutDecoration,
                    followingFieldDecoration: pinPutDecoration,
                    textStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: primary),
                    focusNode: _pinPutFocusNode,
                    controller: _pinPutController,
                    pinAnimationType: PinAnimationType.fade,
                    onTap: () {
                      setState(() {
                        isTapped = true;
                      });
                    },
                  ),
                ),
                addVerticalSpace(20),
                GestureDetector(
                  onTap: () {
                    if (isResendTapped == false) {
                      setState(() {
                        isResendTapped = true;
                      });
                      startTimer();
                      setState(() {});
                      Fluttertoast.showToast(
                          msg: 'OTP sent successfully',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      sendOTPForSignUp(
                        context,
                        widget.phone,
                      );
                    }
                  },
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "Didn't receive an OTP? ",
                        style: bodyText13normal(color: black)),
                    TextSpan(
                        text: "Resend OTP",
                        style: TextStyle(
                            color: primary,
                            decoration: TextDecoration.underline)),
                  ])),
                ),
                addVerticalSpace(50),
                CustomButton(
                    buttonName: 'Verify',
                    onClick: () {
                      if (widget.verificationId.isEmpty &&
                          widget.phone.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Wrong OTP")));
                      } else {
                        verifyOTPForSignUp(
                          context,
                          _pinPutController,
                          widget.phone,
                          widget.verificationId,
                          // widget.name.toString(),
                        );
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TextEditorForPhoneVerify extends StatelessWidget {
  final TextEditingController controller;

  TextEditorForPhoneVerify(this.controller);
  final focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return TextField(
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        autofocus: true,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black38, width: 1.0),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1.0),
              borderRadius: BorderRadius.circular(10)),
          counterText: '',
          hintStyle: const TextStyle(
            color: Colors.black,
            fontSize: 20.0,
          ),
        ));
  }
}
