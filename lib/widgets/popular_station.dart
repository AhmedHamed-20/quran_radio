import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran_radio/models/cubit/cubit.dart';

Widget popularStation({BuildContext? context, String? name, String? url}) {
   var cubit = Appcubit.get(context);
  return Column(
    children: [
      CircleAvatar(
        backgroundColor:cubit.isDark? Colors.teal.withOpacity(0.2):Colors.teal.withOpacity(0.1),
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
        style: TextStyle(color:  cubit.isDark?Colors.white:Colors.black),
      ),
    ],
  );
}
