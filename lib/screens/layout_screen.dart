import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
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
            if (cubit.currentindex == 0) {
              await MoveToBackground.moveTaskToBack();
              return false;
            } else {
              cubit.changBottomnav(0);
              return false;
            }
          },
          child: Scaffold(
            backgroundColor: cubit.isDark?Color(0xff22252b):Colors.white,
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: cubit.isDark?Color(0xff22252b):Colors.white,
              selectedItemColor: Colors.teal,
              unselectedItemColor:cubit.isDark? Colors.white:Colors.grey,
              onTap: (index) {
                cubit.changBottomnav(index);
              },
              currentIndex: cubit.currentindex,
              items: [
                BottomNavigationBarItem(
                  backgroundColor:  cubit.isDark?Color(0xff22252b):Colors.white,
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
              title: Text('${cubit.title[cubit.currentindex]}',style: TextStyle(color: cubit.isDark?Colors.white:Colors.black,),),
              actions: [IconButton(icon: Icon(cubit.isDark? Ionicons.moon_sharp:Ionicons.moon_outline,color:cubit.isDark? Colors.white:Colors.black,), onPressed: (){
                cubit.toggleDarkTheme();
              },),],
              elevation: 0,
            ),
            body: cubit.screen[cubit.currentindex],
          ),
        );
      },
    );
  }
}
