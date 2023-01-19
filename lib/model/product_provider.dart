import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addNewProduct(Map<String, dynamic> map, String docId) async {
    await _firebaseFirestore
        .collection("Products")
        .doc(docId)
        .set(map)
        .then((value) {
      Fluttertoast.showToast(msg: "Product Added");
    });
    notifyListeners();
  }
}
