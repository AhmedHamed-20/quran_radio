import 'package:flutter/material.dart';

Widget popularStation({BuildContext? context, String? name, String? url}) {
  return Column(
    children: [
      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/live.gif'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      SizedBox(
        height: 15,
      ),
      Text(
        name!,
        style: TextStyle(color: Colors.black),
      ),
    ],
  );
}
