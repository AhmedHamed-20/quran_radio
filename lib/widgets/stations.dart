import 'package:flutter/material.dart';
import 'package:quran_radio/models/cubit/cubit.dart';
import 'package:quran_radio/models/states/states.dart';

Widget stations(
    {BuildContext? context,
    String? name,
    String? url,
    AppState? state,
    Icon? icon,
    int? index,
    Widget? button}) {
  var cubit = Appcubit.get(context);
  return Card(
    margin: EdgeInsets.all(8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    color: Colors.teal[50],
    elevation: 0,
    child: ListTile(
      contentPadding: EdgeInsets.all(8),
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
      trailing: button,
    ),
  );
}
