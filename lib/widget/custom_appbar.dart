import 'package:flutter/material.dart';

import '../utils/constants.dart';
import 'custom_textfield.dart';

class CustomAppbar extends StatefulWidget {
  const CustomAppbar({required this.title});

  final String title;

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  bool isSearch = false;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: white,
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: black,
          )),
      title: isSearch
          ? CustomTextField(hintText: 'Search')
          : Text(
              widget.title,
              style: bodyText16w600(color: black),
            ),
      actions: const [
        // IconButton(
        //     onPressed: () {
        //       isSearch = !isSearch;
        //       setState(() {});
        //     },
        //     icon: Icon(
        //       Icons.search,
        //       color: primary,
        //     ))
      ],
    );
  }
}
