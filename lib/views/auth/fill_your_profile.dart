import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delicious_vendor/utils/constants.dart';
import 'package:delicious_vendor/widget/my_bottom_navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../widget/custom_dropdown_button.dart';
import '../../widget/custom_gradient_button.dart';
import '../../widget/custom_textfield.dart';
import '../home/address_search_screen.dart';
import 'map_screen.dart';

class FillyourProfile extends StatefulWidget {
  const FillyourProfile({super.key});

  @override
  State<FillyourProfile> createState() => _FillyourProfileState();
}

class _FillyourProfileState extends State<FillyourProfile> {
  ImagePicker picker = ImagePicker();
  var _image;
  String _imgUrl = '';
  bool isUploaded = false;
  bool isEdit = false;

  var nameController = TextEditingController();
  var surnameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var marketnameController = TextEditingController();
  var marketlocationController = TextEditingController();
  var marketopeningtimeController = TextEditingController();
  var marketclosingtimeController = TextEditingController();
  var marketemailController = TextEditingController();
  var marketphoneController = TextEditingController();
  var banknameController = TextEditingController();
  var accountnumberController = TextEditingController();
  var ifsccodeController = TextEditingController();
  var marketEstablish = TextEditingController();
  var dateOfBirthController = TextEditingController();

  double? latitude;
  double? longitude;

  Map vendorData = {};
  _getVendorData() async {
    await FirebaseFirestore.instance
        .collection('vendors')
        .doc(FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
        .get()
        .then((value) {
      if (value.exists) {
        // setState(() {
        vendorData = value.data()!;
        marketnameController.text = vendorData["marketName"] ?? '';
        marketEstablish.text = vendorData["marketEstablishment"] ?? '';
        marketemailController.text = vendorData["marketEmail"] ?? '';
        marketphoneController.text = vendorData["marketPhone"] ?? '';
        nameController.text = vendorData["ownerName"] ?? '';
        dateOfBirthController.text = vendorData["date of birth"].toString();
        emailController.text = vendorData["ownerEmail"] ?? '';

        phoneController.text = vendorData["ownerPhone"] ?? '';
        banknameController.text = vendorData["accountName"] ?? '';
        accountnumberController.text = vendorData["accountNumber"] ?? '';
        ifsccodeController.text = vendorData["ifscCode"] ?? '';
        marketlocationController.text = vendorData['marketLocation'];
        _imgUrl = vendorData['image'];
        latitude = vendorData['latitude'];
        longitude = vendorData['longitude'];
        // });

      }
      if (mounted) {
        setState(() {});
      }
      log('aaaaaaaaaaaa${vendorData['latitude'].toString()}');
      log(vendorData["longitude"].toString());
    });
  }
  //  _getProfileData() async {
  //   await FirebaseFirestore.instance
  //       .collection('vendors')
  //       .doc(FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
  //       .get()
  //       .then((value) {
  //     if (value.exists) {
  //       setState(() {
  //         vendorData = value.data()!.cast<String, dynamic>();
  //         // ignore: avoid_print
  //         print(vendorData);
  //       });
  //     }
  //   });
  // }

  String? vendorToken;
  List cats = [];
  List myCats = [];
  getCats() async {
    var a = await FirebaseFirestore.instance.collection("Categories").get();
    try {
      var b = await FirebaseFirestore.instance
          .collection("vendors")
          .doc(FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
          .get();
      if (b.exists) {
        myCats = b.data()!['cats'] ?? [];
        log(myCats.toString());
      }
    } catch (e) {}
    for (var j in a.docs) {
      cats.add(j);
    }
    setState(() {});
  }

  @override
  void initState() {
    getCats();
    _getVendorData();
    FirebaseMessaging _firebaseMessaging =
        FirebaseMessaging.instance; // Change here
    _firebaseMessaging.getToken().then((token) {
      log("token is $token");
      vendorToken = token;
      setState(() {});
    });

    super.initState();
  }

  String? gender;
  DateTime? _marketDate;
  DateTime? _dateTime;
  // Map<String, dynamic>? vendorData;
  List<dynamic> filtercoupon = [];
  Map? productItems;
  List<dynamic> products = [];

  final TextEditingController DateInput = TextEditingController();
  final TextEditingController marketSince = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // log(longitude.toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: black,
            )),
        title: Text(
          'Fill Your Profile',
          style: bodyText16w600(color: black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            addVerticalSpace(20),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey.shade500,
                    child: vendorData['image'] == ''
                        ? Icon(
                            Icons.person_rounded,
                            size: 50,
                            color: white,
                          )
                        : Image.network(_imgUrl.toString()),
                  ),
                  Positioned(
                      bottom: 1,
                      right: 1,
                      child: InkWell(
                        onTap: () {
                          _imagePickerBuilder(context);
                        },
                        child: Container(
                          height: 25,
                          width: 25,
                          decoration: myFillBoxDecoration(0, primary, 30),
                          child: Center(
                            child: Icon(
                              Icons.edit,
                              color: white,
                              size: 20,
                            ),
                          ),
                        ),
                      ))
                ],
              ),
            ),
            addVerticalSpace(20),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Store Details',
                    style: bodyText16w600(color: black),
                  ),
                  addVerticalSpace(20),
                  CustomTextField(
                      controller: marketnameController,
                      hintText: 'Name of the market'),
                  addVerticalSpace(15),
                  SizedBox(
                    height: 45,
                    width: width(context) * 0.91,
                    child: TextFormField(
                      onTap: () async {
                        await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1972),
                                lastDate: DateTime(2044))
                            .then((date) {
                          setState(() {
                            _marketDate = date!;
                          });
                          marketEstablish.text =
                              DateFormat('yyyy-MM-dd').format(_marketDate!);
                        });
                      },
                      controller: marketEstablish,
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.calendar_month),
                          border: const OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: const TextStyle(
                            color: Colors.black38,
                          ),
                          contentPadding: const EdgeInsets.all(10),
                          filled: true,
                          fillColor: black.withOpacity(0.05),
                          hintText: 'Market Since'),
                    ),
                  ),
                  addVerticalSpace(15),
                  CustomTextField(
                      controller: marketemailController, hintText: 'Email'),
                  addVerticalSpace(15),
                  CustomTextField(
                      controller: marketphoneController,
                      hintText: 'Phone Number'),
                  addVerticalSpace(15),
                  Container(
                      height: height(context) / 17,
                      width: width(context) * 0.9,
                      decoration: BoxDecoration(
                          color: black.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: width(context) * 0.68,
                            child: TextField(
                              onTap: () async {
                                // await Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             AddressSearch())).then((value) {
                                //   marketlocationController.text =
                                //       value['marketLocation'];
                                //   latitude = value['latitude'];
                                //   longitude = value['longitude'];
                                //
                                //   log(value.toString());
                                // });

                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MapScreen())).then((value) {
                                  marketlocationController.text =
                                      value['marketLocation'];
                                  latitude = value['latitude'];
                                  longitude = value['longitude'];
                                  log('sssss${value['longitude'].toString()}');
                                  log('sssss${value['latitude'].toString()}');
                                  setState(() {});

                                  log(value.toString());
                                });
                              },
                              controller: marketlocationController,
                              decoration: const InputDecoration(
                                  hintText: "Address",
                                  border: InputBorder.none),
                            ),
                          ),
                          Icon(
                            Icons.location_pin,
                            color: primary,
                            size: 30,
                          ),
                        ],
                      )),
                  addVerticalSpace(25),
                  Text(
                    'Owner Details',
                    style: bodyText16w600(color: black),
                  ),
                  addVerticalSpace(20),
                  CustomTextField(controller: nameController, hintText: 'Name'),
                  addVerticalSpace(15),
                  // CustomTextField(
                  //   controller: surnameController,
                  //   hintText: 'Surname'),
                  // addVerticalSpace(15),
                  SizedBox(
                    height: 45,
                    width: width(context) * 0.91,
                    child: TextFormField(
                      onTap: () async {
                        await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1972),
                                lastDate: DateTime(2044))
                            .then((date) {
                          setState(() {
                            _dateTime = date!;
                          });
                          dateOfBirthController.text =
                              DateFormat('yyyy-MM-dd').format(_dateTime!);
                        });
                      },
                      controller: dateOfBirthController,
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.calendar_month),
                          border: const OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: const TextStyle(
                            color: Colors.black38,
                          ),
                          contentPadding: const EdgeInsets.all(10),
                          filled: true,
                          fillColor: black.withOpacity(0.05),
                          hintText: 'Date of Birth'),
                    ),
                  ),
                  addVerticalSpace(15),
                  CustomTextField(
                      controller: emailController, hintText: 'Email'),
                  addVerticalSpace(15),
                  CustomTextField(
                      controller: phoneController, hintText: 'Phone Number'),
                  addVerticalSpace(25),
                  Text(
                    'Bank Details',
                    style: bodyText16w600(color: black),
                  ),
                  addVerticalSpace(20),
                  CustomTextField(
                      controller: banknameController,
                      hintText: 'Name as per Bank Account'),
                  addVerticalSpace(15),
                  CustomTextField(
                      controller: accountnumberController,
                      hintText: 'Account Number'),
                  addVerticalSpace(15),
                  CustomTextField(
                      controller: ifsccodeController, hintText: 'IFSC Code'),

                  addVerticalSpace(15),

                  Text(
                    'Select Category',
                    style: bodyText16w600(color: black),
                  ),
                  addVerticalSpace(20),

                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: cats.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(cats[index]['Name']),
                          trailing: Checkbox(
                            value: myCats.contains(cats[index]['categoryId']),
                            onChanged: (bool? value) {
                              if (myCats.contains(cats[index]['categoryId'])) {
                                myCats.remove(cats[index]['categoryId']);
                                setState(() {});
                                return;
                              } else {
                                myCats.add(cats[index]['categoryId']);
                                setState(() {});
                              }
                            },
                          ),
                        );
                      }),
                  // isEdit
                  //     ? const DropDownSelector(
                  //         'Category',
                  //         [
                  //           'Select',
                  //           'Chicken',
                  //           'Egg',
                  //           'Goat meat',
                  //           'Fish',
                  //           'Combos',
                  //           'Ready to cook'
                  //         ],
                  //         'Select',
                  //       )
                  //     : Container(
                  //         height: height(context) / 17,
                  //         width: width(context) * 0.9,
                  //         // margin: const EdgeInsets.only(top: 10),
                  //         decoration: BoxDecoration(
                  //             color: black.withOpacity(0.1),
                  //             borderRadius: BorderRadius.circular(15)),
                  //         padding: const EdgeInsets.symmetric(
                  //             vertical: 13, horizontal: 20),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Text(
                  //               'Category Name: ${vendorData['categoryName']}',
                  //               style: bodyText14w600(color: black),
                  //             ),
                  //             InkWell(
                  //                 onTap: () {
                  //                   isEdit = true;
                  //                   setState(() {});
                  //                 },
                  //                 child: Icon(Icons.edit))
                  //           ],
                  //         )),

                  addVerticalSpace(30),
                  CustomButton(
                      buttonName: 'Proceed',
                      onClick: () {
                        RegExp r = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');

                        if (r.hasMatch(ifsccodeController.text) &&
                            banknameController.text != "" &&
                            accountnumberController.text != "") {
                          FirebaseFirestore.instance
                              .collection("vendors")
                              .doc(FirebaseAuth.instance.currentUser!.uid
                                  .substring(0, 20))
                              .set({
                            'token': vendorToken,
                            "ownerEmail": emailController.text.trim(),
                            "ownerName": nameController.text.trim(),
                            "ownerPhone": phoneController.text.trim(),
                            "marketName": marketnameController.text.trim(),
                            "marketEmail": marketemailController.text.trim(),
                            "marketPhone": marketphoneController.text.trim(),
                            "openingTime":
                                marketopeningtimeController.text.trim(),
                            "closingTime":
                                marketclosingtimeController.text.trim(),
                            "accountName": banknameController.text.trim(),
                            "accountNumber":
                                accountnumberController.text.trim(),
                            "ifscCode": ifsccodeController.text.trim(),
                            "marketEstablishment": marketEstablish.text.trim(),
                            "marketLocation":
                                marketlocationController.text.trim(),
                            'latitude': latitude,
                            'longitude': longitude,
                            "date of birth": dateOfBirthController.text.trim(),
                            "image": _imgUrl,
                            // "categoryName": categoryName,
                            "isVerified": true,
                            "isBlocked": false,
                            'rating': 4,
                            'timing': 10,
                            'cats': myCats,
                            "vendorId": FirebaseAuth.instance.currentUser!.uid
                                .substring(0, 20)
                          }).then((value) => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => MyBottomBar())));
                        } else {
                          Fluttertoast.showToast(
                              msg: "Invalid banking details");
                        }
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _imagePickerBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Choose option',
          ),
          content: isUploaded
              ? const SizedBox(
                  height: 50, width: 50, child: CircularProgressIndicator())
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        width: width(context) * 0.25,
                        height: height(context) * 0.1,
                        decoration: myOutlineBoxDecoration(1, primary, 30),
                        child: IconButton(
                            onPressed: () async {
                              XFile? image = await picker.pickImage(
                                  source: ImageSource.camera);
                              setState(() {
                                _image = File(image!.path);
                              });
                              log(image!.path.toString());
                            },
                            icon: const Icon(Icons.camera))),
                    Container(
                      width: width(context) * 0.25,
                      height: height(context) * 0.1,
                      decoration: myOutlineBoxDecoration(1, primary, 30),
                      child: IconButton(
                          onPressed: () async {
                            XFile? image = await picker.pickImage(
                                source: ImageSource.gallery);
                            setState(() {
                              _image = File(image!.path);
                            });
                            log(image!.path.toString());
                          },
                          icon: const Icon(Icons.add_photo_alternate)),
                    ),
                  ],
                ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Upload'),
              onPressed: () async {
                if (_image.path.toString().isNotEmpty) {
                  var imageFile = File(_image!.path);
                  FirebaseStorage storage = FirebaseStorage.instance;
                  Reference ref = storage
                      .ref()
                      .child("Products/${DateTime.now().toString()}");

                  UploadTask uploadTask = ref.putFile(imageFile);
                  setState(() {
                    isUploaded = true;
                  });
                  await uploadTask.whenComplete(() async {
                    var url = await ref.getDownloadURL();
                    setState(() {
                      _imgUrl = url.toString();
                      isUploaded = false;
                      log(_imgUrl);
                    });
                    Navigator.pop(context);
                  }).catchError((onError) {
                    log(onError.toString());
                  });
                } else {
                  Fluttertoast.showToast(msg: "Please choose an image");
                }
              },
            ),
          ],
        );
      },
    );
  }
}
