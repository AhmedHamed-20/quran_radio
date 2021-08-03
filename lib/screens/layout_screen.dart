import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_radio/models/cubit/cubit.dart';

import 'package:quran_radio/models/states/states.dart';
import 'package:move_to_background/move_to_background.dart';

class LayoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cubit = Appcubit.get(context);
    return BlocConsumer<Appcubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            await MoveToBackground.moveTaskToBack();
            return false;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: Colors.teal,
              unselectedItemColor: Colors.grey,
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
                  icon: Icon(Icons.headset_rounded),
                  label: 'Current Playing',
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
          ),
        );
      },
    );
  }
}
