import 'package:flutter/material.dart';
import 'package:quran_radio/models/cubit/cubit.dart';
import 'package:quran_radio/screens/playing_screen.dart';
import 'package:quran_radio/widgets/stations.dart';

class Allstations extends StatelessWidget {
  var state;
  Allstations(this.state);
  @override
  Widget build(BuildContext context) {
    var cubit = Appcubit.get(context);
    return ListView.builder(
      shrinkWrap: true,
      itemCount: cubit.radio['radios'].length,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PlayingScreen(
                        index: index,
                        name: cubit.radio['radios'][index]['name'],
                        url: cubit.radio['radios'][index]['radio_url'],
                        length: cubit.radio['radios'].length,
                      )));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Colors.transparent,
              elevation: 0,
              child: stations(
                backgroundColor:
                    cubit.isDark ? Colors.transparent : Colors.teal[50],
                context: context,
                name: cubit.radio['radios'][index]['name'],
                button: InkWell(
                  key: Key(index.toString()),
                  onTap: () {
                    cubit.selected(index);
                    if (cubit.radio['radios'][index]['name'] ==
                        cubit.currentplayingname) {
                      cubit.stopaudio();
                    } else {
                      cubit.playaudio(cubit.radio['radios'][index]['radio_url'],
                          cubit.radio['radios'][index]['name'], context);
                    }
                  },
                  child: CircleAvatar(
                    key: Key(index.toString()),
                    backgroundColor: cubit.isDark
                        ? Colors.teal.withOpacity(0.4)
                        : Colors.teal[100],
                    radius: 25,
                    child: Icon(
                      (cubit.radio['radios'][index]['name'] ==
                                  cubit.currentplayingname &&
                              cubit.audioStreamPlayer.isPlaying.value)
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.teal[300],
                      key: Key(index.toString()),
                    ),
                  ),
                ),
                url: cubit.radio['radios'][index]['radio_url'],
                index: index,
                state: state,
              ),
            ),
          ),
        );
      },
    );
  }
}
