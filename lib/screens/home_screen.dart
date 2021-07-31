import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:quran_radio/models/cubit/cubit.dart';
import 'package:quran_radio/models/popular_list.dart';
import 'package:quran_radio/models/states/states.dart';
import 'package:quran_radio/screens/playing_screen.dart';
import 'package:quran_radio/widgets/bottom_sheet.dart';
import 'package:quran_radio/widgets/popular_station.dart';
import 'package:quran_radio/widgets/stations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = Appcubit.get(context);
    return BlocConsumer<Appcubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        return state is LoadingState
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.orangeAccent,
                ),
              )
            : Scaffold(
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // MaterialButton(
                    //   onPressed: () {
                    //     for (int i = 0; i < cubit.radio['radios'].length; i++) {
                    //       if (cubit.radio['radios'][i]['name'] ==
                    //           'عبدالباسط عبدالصمد')
                    //         print(cubit.radio['radios'][i]['radio_url']);
                    //     }
                    //   },
                    //   color: Colors.black,
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, bottom: 10),
                      child: Text(
                        'Popular Station',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.all(8),
                          scrollDirection: Axis.horizontal,
                          itemCount: popular.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.all(8),
                              child: InkWell(
                                  child: popularStation(
                                    context: context,
                                    name: popular[index],
                                  ),
                                  onTap: () {
                                    String? url;
                                    for (int i = 0;
                                        i <= cubit.radio['radios'].length;
                                        i++) {
                                      if (cubit.radio['radios'][i]['name'] ==
                                          popular[index]) {
                                        url = cubit.radio['radios'][i]
                                            ['radio_url'];
                                        break;
                                        // showModalBottomSheet<void>(
                                        //     builder: (BuildContext context) {
                                        //       return bottomsheetdata(
                                        //         name: popular[index],
                                        //         index: index,
                                        //       );
                                        //     },
                                        //     context: (context));
                                      } else {
                                        continue;
                                      }
                                    }
                                    print(url);
                                    //
                                    // var snackBar = SnackBar(
                                    //   content: bottomsheetdata(
                                    //     name: popular[index],
                                    //     index: index,
                                    //     context: context,
                                    //     url: url,
                                    //     state: state,
                                    //     button: InkWell(
                                    //       onTap: () {
                                    //         var cubit = Appcubit.get(context);
                                    //         cubit.playaudio(url!);
                                    //         cubit.isplay
                                    //             ? cubit.stopaudio()
                                    //             : cubit.playaudio(url);
                                    //       },
                                    //       child: CircleAvatar(
                                    //         key: Key(index.toString()),
                                    //         backgroundColor: Colors.teal[100],
                                    //         radius: 25,
                                    //         child: Icon(
                                    //           Icons.play_arrow,
                                    //           color: Colors.teal[200],
                                    //           key: Key(
                                    //             index.toString(),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    //   behavior: SnackBarBehavior.floating,
                                    //   duration: Duration(days: 365),
                                    //   backgroundColor: Colors.teal[300],
                                    // );
                                    // ScaffoldMessenger.of(context)
                                    //     .showSnackBar(snackBar);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PlayingScreen(
                                          index: index,
                                          name: popular[index],
                                          url: url,
                                        ),
                                      ),
                                    );
                                  }),
                            );
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, bottom: 10),
                      child: Text(
                        'All Stations',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 4,
                        child: ListView.builder(
                          itemCount: cubit.radio['radios'].length,
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              color: Colors.teal[50],
                              elevation: 0,
                              child: InkWell(
                                child: ListTile(
                                  //   selected: cubit.audioSelectedList[index],
                                  key: Key(index.toString()),
                                  contentPadding: EdgeInsets.all(8),
                                  title: Text(
                                      cubit.radio['radios'][index]['name']),
                                  leading: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/radio.png'),
                                        fit: BoxFit.contain,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  trailing: InkWell(
                                    key: Key(index.toString()),
                                    onTap: () {
                                      cubit.selected(index);
                                      if (cubit.audioSelectedList[index] ==
                                              true &&
                                          state is IsPlaying) {
                                        cubit.stopaudio();
                                      } else if (state is IsPlaying &&
                                          cubit.audioSelectedList[index] ==
                                              false) {
                                        cubit.playaudio(cubit.radio['radios']
                                            [index]['radio_url']);
                                      } else {
                                        cubit.playaudio(cubit.radio['radios']
                                            [index]['radio_url']);
                                      }
                                    },
                                    child: CircleAvatar(
                                      key: Key(index.toString()),
                                      backgroundColor: Colors.teal[100],
                                      radius: 25,
                                      child: Icon(
                                        (state is IsPlaying &&
                                                cubit.audioSelectedList[
                                                        index] ==
                                                    true)
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.teal[300],
                                        key: Key(index.toString()),
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PlayingScreen(
                                        index: index,
                                        name: cubit.radio['radios'][index]
                                            ['name'],
                                        url: cubit.radio['radios'][index]
                                            ['radio_url'],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ))
                  ],
                ),
              );
      },
    );
  }
}

//
// stations(
// name: cubit.radio['radios'][index]['name'],
// context: context,
// url: cubit.radio['radios'][index]['radio_url'],
// state: state,
// index: index,
// button: InkWell(
// onTap: () {
// state is IsPlaying
// ? cubit.pauseaudio()
//     : cubit.playaudio(cubit.radio['radios']
// [index]['radio_url']);
// cubit.changeclick();
// },
// child: CircleAvatar(
// backgroundColor: Colors.teal[100],
// radius: 25,
// child: Icon(
// (state is IsPlaying &&
// cubit.isClicked == true)
// ? Icons.pause
//     : Icons.play_arrow,
//
// ),
// ),
// ),
// );
