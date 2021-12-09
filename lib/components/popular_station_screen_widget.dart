import 'package:flutter/material.dart';
import 'package:quran_radio/models/cubit/cubit.dart';
import 'package:quran_radio/models/popular_list.dart';
import 'package:quran_radio/screens/playing_screen.dart';
import 'package:quran_radio/widgets/popular_station.dart';

Widget popularStationWidget(BuildContext context) {
  var cubit = Appcubit.get(context);
  return ListView.builder(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(8),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: popular.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.all(8),
          child: InkWell(
              borderRadius: BorderRadius.circular(60),
              child: popularStation(
                context: context,
                name: popular[index],
              ),
              onTap: () {
                cubit.noInternet();
                String? url;
                for (int i = 0; i <= cubit.radio['radios'].length; i++) {
                  if (cubit.radio['radios'][i]['name'] == popular[index]) {
                    url = cubit.radio['radios'][i]['radio_url'];
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
                  context,
                );
              }),
        );
      });
}
