import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_radio/models/cubit/cubit.dart';
import 'package:quran_radio/models/states/states.dart';
import 'package:quran_radio/widgets/stations.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = Appcubit.get(context);
    return BlocConsumer<Appcubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: ListView.builder(
            itemBuilder: (context, index) {
              return stations(
                url: cubit.favorite[index]['url'],
                name: cubit.favorite[index]['name'],
                context: context,
                button: InkWell(
                  onTap: () {
                    cubit.selected(index);
                    if (cubit.audioSelectedList[index] == true &&
                        state is IsPlaying) {
                      cubit.stopaudio();
                    } else if (state is IsPlaying &&
                        cubit.audioSelectedList[index] == false) {
                      cubit.playaudio(cubit.favorite[index]['url']);
                    } else {
                      cubit.playaudio(cubit.favorite[index]['url']);
                    }
                  },
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.teal[200],
                    child: Icon(
                      (state is IsPlaying &&
                              cubit.audioSelectedList[index] == true)
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.teal,
                      size: 30,
                    ),
                  ),
                ),
              );
            },
            itemCount: cubit.favorite.length,
          ),
        );
      },
    );
  }
}
