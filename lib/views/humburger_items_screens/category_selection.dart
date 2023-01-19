import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class CategorySelection extends StatefulWidget {
  const CategorySelection({Key? key}) : super(key: key);

  @override
  State<CategorySelection> createState() => _CategorySelectionState();
}

class _CategorySelectionState extends State<CategorySelection> {
  List cats = [];
  List myCats = [];
  bool loading = true;
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
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    getCats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select Category",
          style: TextStyle(color: Colors.red),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: cats.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(cats[index]['Name']),
                            trailing: Checkbox(
                              value: myCats.contains(cats[index]['categoryId']),
                              onChanged: (bool? value) {
                                if (myCats
                                    .contains(cats[index]['categoryId'])) {
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
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          color: Colors.red,
                          onPressed: () async {
                            FirebaseFirestore.instance
                                .collection("vendors")
                                .doc(FirebaseAuth.instance.currentUser!.uid
                                    .substring(0, 20))
                                .update({"cats": myCats});
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("updated")));
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Update",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
