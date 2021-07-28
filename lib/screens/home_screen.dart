import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_radio/models/cubit/cubit.dart';
import 'package:quran_radio/models/popular_list.dart';
import 'package:quran_radio/models/states/states.dart';
import 'package:quran_radio/widgets/popular_station.dart';
import 'package:quran_radio/widgets/stations.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cubit = Appcubit.get(context);
    return BlocBuilder<Appcubit, AppState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
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
                flex: 1,
                child: ListView.builder(
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
                              url: 'ha'),
                          onTap: () {
                            for (int i = 0;
                                i < cubit.radio['radios'].length;
                                i++) {
                              if (cubit.radio['radios'][i]['name'] ==
                                  popular[index])
                                print(cubit.radio['radios'][i]['radio_url']);
                            }
                          },
                        ),
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
                  child: StaggeredGridView.countBuilder(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    crossAxisCount: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    itemCount: cubit.radio['radios'].length,
                    staggeredTileBuilder: (int index) {
                      return StaggeredTile.fit(1);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return stations(
                        name: cubit.radio['radios'][index]['name'],
                        context: context,
                        url: cubit.radio['radios'][index]['radio_url'],
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
