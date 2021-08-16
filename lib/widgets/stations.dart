import 'package:flutter/material.dart';
import 'package:quran_radio/models/cubit/cubit.dart';
import 'package:quran_radio/models/states/states.dart';

Widget stations({
  BuildContext? context,
  String? name,
  String? url,
  AppState? state,
  Icon? icon,
  int? index,
  Widget? button,
  Color? backgroundColor,
}) {
  var cubit = Appcubit.get(context);
  return Card(
    margin: EdgeInsets.all(8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    color: backgroundColor,
    elevation: 0,
    child: ListTile(
      contentPadding: EdgeInsets.all(8),
      title: Text(
        name!,
        style: TextStyle(color: cubit.isDark ? Colors.white : Colors.black),
      ),
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/microfone.png'),
            fit: BoxFit.contain,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      trailing: button,
    ),
  );
}
