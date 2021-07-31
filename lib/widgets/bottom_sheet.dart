import 'package:flutter/material.dart';
import 'package:quran_radio/models/cubit/cubit.dart';
import 'package:quran_radio/models/states/states.dart';

Widget bottomsheetdata(
    {String? name,
    int? index,
    String? url,
    BuildContext? context,
    AppState? state,
    Widget? button}) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name!),
        button!,
      ],
    ),
  );
}
