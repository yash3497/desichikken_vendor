import 'dart:math';

import 'package:flutter/material.dart';

double height(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double width(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

String categoryName = '';
num categoryId = 2;
String Sneworder = '0';
String Scancelled = '0';
String Sprocessed = '0';
String Sdelivered = '0';
String Sreceived = '0';
String Sreturned = '0';
String Sshipped = '0';
int Swalletamount = 0;
double? Slat;
double? Slong;
String? Slocation;

double? lat;
double? long;


bool isEdit = false;
showMySnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

bool isToggle = false;
bool isPremium = false;
bool isPosition = false;
// for gradient
Color ligthRed = const Color.fromRGBO(255, 187, 186, 1);
Color darkRed = const Color.fromRGBO(255, 29, 29, 1);
Color darkRed2 = const Color.fromRGBO(197, 8, 8, 1);

// for custom
Color primary = Color.fromRGBO(228, 1, 1, 1);
Color boxBgColor = const Color.fromRGBO(51, 51, 51, 1);
Color white = Colors.white;
Color blackLight = Color.fromRGBO(50, 50, 50, 1);
Color black = Colors.black;

// only gradient
Gradient redGradient() {
  return LinearGradient(
    colors: [ligthRed, darkRed, darkRed, darkRed, darkRed2],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

// only gradient
Gradient tabGradient() {
  return LinearGradient(
    colors: [
      ligthRed.withOpacity(0.2),
      ligthRed,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

Gradient whiteLinerGradient() {
  return const LinearGradient(
    colors: [Colors.white, Colors.white],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

// Gradient decorations
BoxDecoration gradientBoxDecoration(Gradient gradient, double radius) {
  return BoxDecoration(
    gradient: gradient,
    borderRadius: BorderRadius.all(Radius.circular(radius) //
        ),
  );
}

//box decoration with border colors only
BoxDecoration myOutlineBoxDecoration(double width, Color color, double radius) {
  return BoxDecoration(
    border: Border.all(width: width, color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius) //
        ),
  );
}

//box decoration with fill box colors
BoxDecoration myFillBoxDecoration(double width, Color color, double radius) {
  return BoxDecoration(
    color: color,
    border: Border.all(width: width, color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius) //
        ),
  );
}

TextStyle bodyText14w600({required Color color}) {
  return TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.w600);
}

TextStyle bodyText14normal({required Color color}) {
  return TextStyle(
    fontSize: 13,
    color: color,
  );
}

TextStyle bodyText13normal({required Color color}) {
  return TextStyle(
    fontSize: 13,
    color: color,
  );
}

TextStyle bodyText16w600({required Color color}) {
  return TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.w700);
}

// small Size
TextStyle bodyText12Small({required Color color}) {
  return TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w400);
}

TextStyle bodyText11Small({required Color color}) {
  return TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w400);
}

TextStyle bodytext12Bold({required Color color}) {
  return TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600);
}

TextStyle bodyText20w700({required Color color}) {
  return TextStyle(fontSize: 20, color: color, fontWeight: FontWeight.bold);
}

TextStyle bodyText30W600({required Color color}) {
  return TextStyle(fontSize: 30, color: color, fontWeight: FontWeight.w700);
}

TextStyle bodyText30W400({required Color color}) {
  return TextStyle(
    fontSize: 30,
    color: color,
  );
}

// box decoration with Boxshadow
BoxDecoration shadowDecoration(double radius, double blur) {
  return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade400,
          blurRadius: blur,
        ),
      ]);
}

Widget addVerticalSpace(double height) {
  return SizedBox(height: height);
}

Widget addHorizontalySpace(double width) {
  return SizedBox(width: width);
}
// const kTextFieldDecoration = InputDecoration(
//   prefix: Text(
//     '    +91  ',
//     style: TextStyle(color: Colors.white, fontSize: 18),
//   ),
//   contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
//   border: OutlineInputBorder(
//     borderRadius: BorderRadius.all(Radius.circular(32.0)),
//   ),
//   enabledBorder: OutlineInputBorder(
//     borderSide: BorderSide(color: Colors.white, width: 1.0),
//     borderRadius: BorderRadius.all(Radius.circular(32.0)),
//   ),
//   focusedBorder: OutlineInputBorder(
//     borderSide: BorderSide(color: Colors.white, width: 2.0),
//     borderRadius: BorderRadius.all(Radius.circular(32.0)),
//   ),
// );'

TableRow textRowWidget({
  required String Menu,
  required String Rev,
  required String order,
}) {
  return TableRow(children: [
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Text(
            Menu,
            style: bodyText14normal(color: black),
          )
        ],
      ),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Text(
            Rev,
            style: bodyText14normal(color: black),
          )
        ],
      ),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Text(
            order,
            style: bodyText14normal(color: Colors.green),
          )
        ],
      ),
    ),
  ]);
}

class CustomCard extends StatelessWidget {
  const CustomCard({
    Key? key,
    required this.image,
    required this.text,
    required this.text2,
    required this.height,
    required this.width,
    required this.ontap,
  }) : super(key: key);
  final String image;
  final String text;
  final String text2;
  final double height;
  final double width;
  final Function() ontap;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: ontap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            height: height,
            width: width,
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
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  image,
                  // scale: 1.6,
                ),
                Text(
                  text,
                  style: bodyText14normal(
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                Text(
                  text2,
                  style: bodyText12Small(color: black),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
double calculateDistanceKM(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}
String mapsApiKey = "AIzaSyBtvEIVojiFHFC62dxHdpaCL5r5VFotq9s";
