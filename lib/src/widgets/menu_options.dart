import 'package:flutter/material.dart';

Widget w_MenuOptions() {
  return Container(
    decoration:
        BoxDecoration(color: Color(0xff473E43), borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0))),
    height: 300.0,
    child: Column(children: [
      Container(
        height: 60.0,
        decoration:
            BoxDecoration(color: Color(0xff2D2529), borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0))),
      ),
    ]),
  );
}
