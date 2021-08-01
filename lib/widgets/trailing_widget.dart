import 'package:flutter/material.dart';
import 'package:quran_radio/models/cubit/cubit.dart';
import 'package:quran_radio/models/states/states.dart';

Widget trailingWidget({BuildContext? context, int? index, AppState? state}) {
  var cubit = Appcubit.get(context);
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      InkWell(
        onTap: () {
          cubit.selected(index!);
          if (cubit.audioSelectedList[index] == true && state is IsPlaying) {
            cubit.stopaudio();
          } else if (state is IsPlaying &&
              cubit.audioSelectedList[index] == false) {
            cubit.playaudio(cubit.radio['radios'][index]['radio_url'],
                cubit.radio['radios'][index]['name']);
          } else {
            cubit.playaudio(cubit.radio['radios'][index]['radio_url'],
                cubit.radio['radios'][index]['name']);
          }
        },
        child: CircleAvatar(
          key: Key(index.toString()),
          backgroundColor: Colors.teal[100],
          radius: 25,
          child: Icon(
            (state is IsPlaying && cubit.audioSelectedList[index!] == true)
                ? Icons.pause
                : Icons.play_arrow,
            color: Colors.teal[300],
            key: Key(index.toString()),
          ),
        ),
      ),
    ],
  );
}
