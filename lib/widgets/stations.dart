import 'package:flutter/material.dart';

Widget stations({BuildContext? context, String? name, String? url}) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    color: Colors.white,
    elevation: 0,
    child: ListTile(
      title: Text(name!),
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/radio.png'),
            fit: BoxFit.contain,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      trailing: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/play.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    ),
  );
}
