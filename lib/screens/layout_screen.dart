import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_radio/models/cubit/cubit.dart';
import 'package:quran_radio/models/popular_list.dart';
import 'package:quran_radio/models/states/states.dart';
import 'package:quran_radio/widgets/popular_station.dart';
import 'package:quran_radio/widgets/stations.dart';

class LayoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cubit = Appcubit.get(context);
    return BlocConsumer<Appcubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.teal[50],
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              cubit.changBottomnav(index);
            },
            currentIndex: cubit.currentindex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_outlined),
                label: 'Favorite',
              ),
            ],
          ),
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            title: Text('${cubit.title[cubit.currentindex]}'),
            elevation: 0,
          ),
          body: cubit.screen[cubit.currentindex],
        );
      },
    );
  }
}
