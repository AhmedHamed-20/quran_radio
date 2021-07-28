import 'package:flutter/material.dart';

Widget popularStation({BuildContext? context, String? name, String? url}) {
  return Column(
    children: [
      Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white70,
          image: DecorationImage(
            image: AssetImage('assets/images/photo.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(15),
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
