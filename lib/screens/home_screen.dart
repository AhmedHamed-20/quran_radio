import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_radio/models/cubit/cubit.dart';
import 'package:quran_radio/models/popular_list.dart';
import 'package:quran_radio/models/states/states.dart';
import 'package:quran_radio/screens/playing_screen.dart';
import 'package:quran_radio/widgets/bottom_sheet.dart';
import 'package:quran_radio/widgets/popular_station.dart';
import 'package:quran_radio/widgets/snack_bar.dart';
import 'package:quran_radio/widgets/stations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = Appcubit.get(context);
    return BlocConsumer<Appcubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        return cubit.NoInternet
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/noInternet.png'),
                    MaterialButton(
                      onPressed: () {
                        cubit.getdata();
                      },
                      child: Text(
                        'Retry',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ],
                ),
              )
            : state is LoadingState
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.orangeAccent,
                    ),
                  )
                : Scaffold(
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                        cubit.noInternet();
                                        String? url;
                                        for (int i = 0;
                                            i <= cubit.radio['radios'].length;
                                            i++) {
                                          if (cubit.radio['radios'][i]
                                                  ['name'] ==
                                              popular[index]) {
                                            url = cubit.radio['radios'][i]
                                                ['radio_url'];
                                            break;
                                          } else {
                                            continue;
                                          }
                                        }
                                        print(url);
                                        //

                                        cubit.Navigate(
                                            PlayingScreen(
                                              index: index,
                                              name: popular[index],
                                              url: url,
                                              length: popular.length,
                                            ),
                                            context);
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
                                    child: stations(
                                      context: context,
                                      name: cubit.radio['radios'][index]
                                          ['name'],
                                      button: InkWell(
                                        key: Key(index.toString()),
                                        onTap: () {
                                          cubit.selected(index);
                                          if (cubit.radio['radios'][index]
                                                  ['name'] ==
                                              cubit.currentplayingname) {
                                            cubit.stopaudio();
                                          } else {
                                            cubit.playaudio(
                                                cubit.radio['radios'][index]
                                                    ['radio_url'],
                                                cubit.radio['radios'][index]
                                                    ['name'],
                                                context);
                                          }
                                        },
                                        child: CircleAvatar(
                                          key: Key(index.toString()),
                                          backgroundColor: Colors.teal[100],
                                          radius: 25,
                                          child: Icon(
                                            (cubit.radio['radios'][index]
                                                        ['name'] ==
                                                    cubit.currentplayingname)
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                            color: Colors.teal[300],
                                            key: Key(index.toString()),
                                          ),
                                        ),
                                      ),
                                      url: cubit.radio['radios'][index]
                                          ['radio_url'],
                                      index: index,
                                      state: state,
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
                                            length:
                                                cubit.radio['radios'].length,
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
