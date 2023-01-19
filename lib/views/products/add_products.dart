import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

import '../../model/product_provider.dart';
import '../../utils/constants.dart';
import '../../widget/custom_textfield2.dart';

class AddProducts extends StatefulWidget {
  const AddProducts({super.key});

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _discription = TextEditingController();
  final TextEditingController _pTypeController = TextEditingController();
  final TextEditingController _piecesController = TextEditingController();
  final TextEditingController _servesController = TextEditingController();

  ImagePicker picker = ImagePicker();
  var _image;
  String? _imgUrl;
  bool isUploaded = false;
  Map<String, dynamic>? vendorData;
  String selectedItems = 'Select';
  int selectedIndex = 0;
  int selectedIndex2 = 0;

  String catName = '';
  String CatID = '';

  String subCatName = '';
  String subCatID = '';

  _getProfileData() async {
    await FirebaseFirestore.instance
        .collection('vendors')
        .doc(FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          vendorData = value.data()!.cast<String, dynamic>();

          // log(vendorData.toString());
        });
      }
    });
  }

  Map categoryItem = {};
  List category = [];
  List categoryName = [];
  List subCategoryName = [];

  _getCategories() async {
    await FirebaseFirestore.instance
        .collection('Categories')
        .get()
        .then((value) {
      log('message');
      // categoryItem = value.docs as Map;
      log(value.docs.toString());

      if (categoryItem != null) {
        // category = categoryItem['category'];
        for (var doc in value.docs) {
          categoryName.add(doc.data());
        }
        // log("sumit patil knddnid$categoryName");

        setState(() {});
      }
      _getSubCategories(categoryName.first['categoryId']);
    });
  }

  _getSubCategories(String catId) async {
    subCategoryName.clear();
    await FirebaseFirestore.instance
        .collection('SubCategories')
    .where("categoryId",isEqualTo:catId)
        .get()
        .then((value) {
      log('message');
      // categoryItem = value.docs as Map;
      log(value.docs.toString());

      if (subCategoryName != null) {
        // category = categoryItem['category'];
        for (var doc in value.docs) {
          subCategoryName.add(doc.data());
        }
        log("sumit patil knddnid$subCategoryName");

        setState(() {});
      }
    });
  }

  @override
  void initState() {
    _getProfileData();
    _getCategories();
    // _getSubCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    // _productProvider.addNewProduct();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: black,
            )),
        backgroundColor: white,
        title: Text(
          'Add Products',
          style: bodyText16w600(color: black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              _imgUrl == null
                  ? InkWell(
                      onTap: () {
                        _imagePickerBuilder(context);
                      },
                      child: Container(
                          height: height(context) * 0.13,
                          width: width(context) * 0.9,
                          margin: const EdgeInsets.all(11),
                          decoration: shadowDecoration(10, 3),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.camera_alt_outlined,
                                  size: 30, color: Colors.grey),
                              Text(
                                "Add photo",
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          )),
                    )
                  : Container(
                      margin: EdgeInsets.all(10),
                      height: height(context) * 0.2,
                      width: width(context) * 0.9,
                      child: _imgUrl != null
                          ? Image.network(_imgUrl.toString())
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),

              // SizedBox(
              //   width: width(context),
              //   height: height(context) * 0.07,
              //   child: ListView.builder(
              //       itemCount: _productProvider.categoryList.length,
              //       scrollDirection: Axis.horizontal,
              //       itemBuilder: (context, index) {
              //         return InkWell(
              //           onTap: () {
              //             _categoryController.text =
              //                 _productProvider.categoryList[index]["name"];
              //             var selectedCatId =
              //                 _productProvider.categoryList[index]["catId"];
              //             setState(() {});
              //           },
              //           child: Container(
              //             margin: const EdgeInsets.symmetric(horizontal: 7),
              //             padding: const EdgeInsets.all(5),
              //             decoration: myFillBoxDecoration(0, Colors.red, 15),
              //             child: Center(
              //                 child: Text(
              //                     _productProvider.categoryList[index]["name"])),
              //           ),
              //         );
              //       }),
              // ),
              // Row(
              //   children: [
              //     Container(
              //       margin: EdgeInsets.symmetric(vertical: 10),
              //       width: width(context) * 0.6,
              //       height: height(context) * 0.04,
              //       child: ListView.builder(
              //           itemCount: productTypeList.length,
              //           scrollDirection: Axis.horizontal,
              //           itemBuilder: (context, index) {
              //             return InkWell(
              //               onTap: () {
              //                 _pTypeController.text = productTypeList[index];
              //                 var productType = productTypeList[index];
              //                 setState(() {});
              //               },
              //               child: Container(
              //                 margin: const EdgeInsets.symmetric(horizontal: 7),
              //                 padding: const EdgeInsets.all(5),
              //                 decoration:
              //                     myOutlineBoxDecoration(1, Colors.grey, 30),
              //                 child: Center(child: Text(productTypeList[index])),
              //               ),
              //             );
              //           }),
              //     ),
              //     SizedBox(
              //       width: width(context) * 0.34,
              //       child: CustomTextfield(
              //         controller: _pTypeController,
              //         hintext: "Product Type",
              //         keyBoardtype: TextInputType.name,
              //       ),
              //     ),
              //   ],
              // ),
              addVerticalSpace(15),
              CustomTextfield(
                controller: _nameController,
                hintext: 'Product Name',
                keyBoardtype: TextInputType.name,
              ),
              addVerticalSpace(15),

              // CustomTextfield(
              //   controller: _categoryController,
              //   hintext: 'Product Category',
              //   keyBoardtype: TextInputType.name,
              // ),

              CustomTextfield(
                controller: _priceController,
                hintext: 'Product Price',
                keyBoardtype: TextInputType.number,
              ),
              addVerticalSpace(15),

              CustomTextfield(
                controller: _weightController,
                hintext: 'Product Weight',
                keyBoardtype: TextInputType.number,
              ),
              addVerticalSpace(15),

              CustomTextfield(
                controller: _qtyController,
                hintext: 'Product Quantity',
                keyBoardtype: TextInputType.number,
              ),
              addVerticalSpace(15),

              CustomTextfield(
                controller: _piecesController,
                hintext: 'Pieces Quantity',
                keyBoardtype: TextInputType.number,
              ),
              addVerticalSpace(15),

              CustomTextfield(
                controller: _servesController,
                hintext: 'Serves',
                keyBoardtype: TextInputType.number,
              ),
              addVerticalSpace(15),
              CustomTextfield(
                controller: _discription,
                hintext: 'Discription',
                keyBoardtype: TextInputType.name,
              ),
              addVerticalSpace(15),
              Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Choose Category',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),

                  Container(
                    height: height(context) * 0.05,
                    width: width(context) * 0.95,
                    // decoration: shadowDecoration(20, 5),
                    child: ListView.builder(
                        itemCount: categoryName.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, i) {
                          return InkWell(
                            onTap: () {
                              selectedIndex = i;
                              catName = categoryName[i]['Name'];
                              CatID = categoryName[i]['categoryId'];
                              // log(CatID);
                              _getSubCategories(categoryName[i]['categoryId']);

                              setState(() {});
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              // height: height(context) * 0.0,
                              // width: width(context) * 0.3,
                              decoration: selectedIndex == i
                                  ? myFillBoxDecoration(0, primary, 30)
                                  : myOutlineBoxDecoration(1, primary, 30),
                              child: Text(
                                "${categoryName[i]['Name']}",
                                style: bodyText14w600(
                                    color: selectedIndex == i ? white : black),
                              ),
                            ),
                          );
                        }),
                  ),
                  addVerticalSpace(30),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Choose Subcategory',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),

                  Container(
                    height: height(context) * 0.05,
                    width: width(context) * 0.95,
                    // decoration: shadowDecoration(20, 5),
                    child: ListView.builder(
                        itemCount: subCategoryName.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, i) {
                          return InkWell(
                            onTap: () {
                              selectedIndex2 = i;
                              subCatName = subCategoryName[i]['name'];
                              subCatID = subCategoryName[i]['subCategoryId'];
                              // log(subCatName);

                              setState(() {});
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              // height: height(context) * 0.0,
                              // width: width(context) * 0.3,
                              decoration: selectedIndex2 == i
                                  ? myFillBoxDecoration(0, primary, 30)
                                  : myOutlineBoxDecoration(1, primary, 30),
                              child: Text(
                                "${subCategoryName[i]['name']}",
                                style: bodyText14w600(
                                    color: selectedIndex2 == i ? white : black),
                              ),
                            ),
                          );
                        }),
                  )
                  //   Container(
                  //     height: height(context) / 17,
                  //     width: width(context) * 0.9,
                  //     margin: const EdgeInsets.only(top: 10, right: 10),
                  //     decoration: BoxDecoration(
                  //         color: black.withOpacity(0.09),
                  //         borderRadius: BorderRadius.circular(15)),
                  //     child: Padding(
                  //       padding: const EdgeInsets.symmetric(
                  //           vertical: 0, horizontal: 20),
                  //       child: DropdownButton<String>(
                  //           underline: SizedBox(),
                  //           value: selectedItems,
                  //           isExpanded: true,
                  //           iconSize: 36,
                  //           disabledHint: const Text(
                  //             'Select',
                  //             style: TextStyle(
                  //               fontFamily: 'NunitoSans',
                  //               fontWeight: FontWeight.w400,
                  //               fontSize: 14.0,
                  //               color: Color(0xff94A3B8),
                  //             ),
                  //           ),
                  //           dropdownColor: Colors.white,
                  //           icon: Icon(
                  //             Icons.keyboard_arrow_down_rounded,
                  //             size: 25.0,
                  //             color: Colors.grey[500],
                  //           ),
                  //           items: categoryName.map<DropdownMenuItem<String>>(
                  //             (String country) {
                  //               return DropdownMenuItem<String>(
                  //                 value: country,
                  //                 child: Text(
                  //                   country,
                  //                   style: const TextStyle(
                  //                       fontFamily: 'Nunito', fontSize: 16.0),
                  //                 ),
                  //               );
                  //             },
                  //           ).toList(),
                  //           onChanged: (String? newValue) {
                  //             setState(() {
                  //               selectedItems = newValue!;
                  //               log(selectedItems);
                  //               // isEdit = true;
                  //             });
                  //             // if (widget.label == 'Category') {
                  //             //   categoryName = selectedItems;
                  //             //   categoryId = widget.listItems.indexOf(selectedItems);
                  //             // }
                  //           }),
                  //     ),
                  //   ),
                ],
              ),

              addVerticalSpace(height(context) * 0.07),

              Container(
                  width: width(context) * 0.9,
                  decoration: myFillBoxDecoration(0, primary, 10),
                  margin: const EdgeInsets.all(5),
                  child: TextButton(
                      onPressed: () {
                        var productId =
                            DateTime.now().microsecondsSinceEpoch.toString();
                        if (_nameController.text.trim().isNotEmpty &&
                            // _categoryController.text.trim().isNotEmpty &&
                            // categoryName.isNotEmpty &&s
                            _priceController.text.trim().isNotEmpty &&
                            _weightController.text.trim().isNotEmpty) {
                          _productProvider.addNewProduct(
                            {
                              // "catId": selectedCatId,
                              "id": productId,

                              // "latlong": {
                              //   "lat": _locationProvider.lat,
                              //   "long": _locationProvider.long,
                              // },

                              "name": _nameController.text.trim(),
                              "discription": _discription.text.trim(),
                              // "categoryName": vendorData!['categoryName'],
                              "longitude": vendorData!['longitude'],
                              "latitude": vendorData!['latitude'],
                              "address": vendorData!['marketLocation'],
                              "serves": _servesController.text.trim(),
                              "pieces": _piecesController.text.trim(),
                              "image": _imgUrl,
                              'rating': 4,
                              'stock': 7,
                              'categoryName': catName,
                              'categoryId': CatID,
                              'subCategoryId': subCatID,
                              'timing': 10,
                              "productType": _pTypeController.text.trim(),
                              "quantity":
                                  double.parse(_qtyController.text.trim()),
                              "price":
                                  double.parse(_priceController.text.trim()),
                              "weight":
                                  double.parse(_weightController.text.trim()),
                              "vendorId": FirebaseAuth.instance.currentUser?.uid
                                  .substring(0, 20),
                            },
                            productId,
                          ).then((value) {
                            _nameController.text = "";
                            // _categoryController.text = "";

                            _priceController.text = "";
                            _weightController.text = "";
                          });
                        } else {
                          Fluttertoast.showToast(
                              msg: 'Please fill all the fields');
                        }
                      },
                      child: Text(
                        "Add Product",
                        style: bodyText16w600(color: Colors.white),
                      )))
            ],
          ),
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
                      log(_imgUrl!);
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
