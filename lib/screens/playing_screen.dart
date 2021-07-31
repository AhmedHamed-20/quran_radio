import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_radio/models/cubit/cubit.dart';
import 'package:quran_radio/models/states/states.dart';

class PlayingScreen extends StatelessWidget {
  String? name;
  String? url;
  int? index;
  PlayingScreen({this.name, this.url, this.index});

  @override
  Widget build(BuildContext context) {
    var cubit = Appcubit.get(context);
    return BlocConsumer<Appcubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(name!),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            cubit.selected(index!);
                            if (cubit.audioSelectedList[index!] == true &&
                                state is IsPlaying) {
                              cubit.stopaudio();
                            } else if (state is IsPlaying &&
                                cubit.audioSelectedList[index!] == false) {
                              cubit.playaudio(url!);
                            } else {
                              cubit.playaudio(url!);
                            }
                          },
                          child: Icon(
                            (state is IsPlaying &&
                                    cubit.audioSelectedList[index!] == true)
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),
                        ),
                        InkWell(
                          child: Icon(
                            Icons.favorite_outline,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
