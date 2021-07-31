import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget popularStation({BuildContext? context, String? name, String? url}) {
  return Column(
    children: [
      CircleAvatar(
        backgroundColor: Colors.teal.withOpacity(0.1),
        child: ClipOval(
          child: Image.asset(
            'assets/images/person.png',
            width: 200,
            height: 200,
          ),
        ),
        radius: 65,
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
