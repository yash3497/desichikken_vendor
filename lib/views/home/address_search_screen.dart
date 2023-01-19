// ignore_for_file: null_check_always_fails, unnecessary_null_comparison, unused_element

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_place/google_place.dart';

import '../../utils/constants.dart';
import '../../widget/custom_gradient_button.dart';
import '../../widget/custom_location_listtile.dart';

class AddressSearch extends StatefulWidget {
  AddressSearch({Key? key}) : super(key: key);

  @override
  State<AddressSearch> createState() => _AddressSearchState();
}

class _AddressSearchState extends State<AddressSearch> {
  Map? vendorData;
  _getProfileData() async {
    await FirebaseFirestore.instance
        .collection('vendors')
        .doc(FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          vendorData = value.data()!;
          // ignore: avoid_print
          print(vendorData);
        });
      }
    });
  }

  List<AutocompletePrediction> predictions = [];
  GooglePlace googlePlace =
      GooglePlace("AIzaSyChdjtMqiIjjPN7Sj_rQfsxH6Qq_S2Ixuc");

  autoCompleSearch(String value) async {
    var gresult = await googlePlace.autocomplete.get(value);

    if (gresult != null && gresult.predictions != null && mounted) {
      setState(() {
        predictions = gresult.predictions!;
        log(gresult.toString());
      });
    }
  }

  @override
  void initState() {
    _getProfileData();
    startFocusNode = FocusNode();
    super.initState();
  }

  DetailsResult? startPosition;
  late FocusNode startFocusNode;

  @override
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    startFocusNode.dispose();
    super.dispose();
  }
  //add new address bottom sheet

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Form(
              child: Padding(
            padding: const EdgeInsets.only(top: 40, right: 10, left: 10),
            child: TextFormField(
              controller: _controller,
              focusNode: startFocusNode,
              onChanged: (value) {
                autoCompleSearch(value);
              },
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                  hintText: 'Search your location',
                  prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Icon(Icons.location_on))),
            ),
          )),
          const Divider(
            height: 4,
            thickness: 4,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: predictions.length,
                itemBuilder: ((context, index) => LocationListTile(
                    location: predictions[index].description!,
                    press: () async {
                      final placeId = predictions[index].placeId!;
                      final details = await googlePlace.details.get(placeId);
                      lat = details!.result!.geometry!.location!.lat;

                      long = details.result!.geometry!.location!.lng;
                      // FirebaseFirestore.instance
                      //     .collection("vendors")
                      //     .doc(FirebaseAuth.instance.currentUser!.uid
                      //         .substring(0, 20))
                      //     .update({'latitude': lat!, 'longitude': long!});

                      if (details != null &&
                          details.result != null &&
                          mounted) {
                        if (startFocusNode.hasFocus) {
                          setState(() {
                            startPosition = details.result;
                            _controller.text = predictions[index].description!;
                          });
                        }
                      }
                    }))),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: CustomButton(
                buttonName: 'Proceed',
                onClick: () {
                  // FirebaseFirestore.instance
                  //     .collection("vendors")
                  //     .doc(FirebaseAuth.instance.currentUser!.uid
                  //         .substring(0, 20))
                  //     .update({"marketLocation": _controller.text});

                  Navigator.pop(context, {
                    "marketLocation": _controller.text,
                    'latitude': lat,
                    'longitude': long
                  });
                }),
          )
        ],
      ),
    );
  }
}
