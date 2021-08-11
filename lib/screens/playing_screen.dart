import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_radio/models/cubit/cubit.dart';
import 'package:quran_radio/models/states/states.dart';

class PlayingScreen extends StatelessWidget {
  String? name;
  String? url;
  int? index;
  int? length;
  PlayingScreen({this.name, this.url, this.index, this.length});

  @override
  Widget build(BuildContext context) {
    var cubit = Appcubit.get(context);
    return BlocConsumer<Appcubit, AppState>(
      //  bloc: Appcubit()
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor:  cubit.isDark?Color(0xff22252b):Colors.white,
          appBar: AppBar(
            backwardsCompatibility: false,
            systemOverlayStyle: SystemUiOverlayStyle(systemNavigationBarIconBrightness: Brightness.light,),
            iconTheme: IconThemeData(color: cubit.isDark?Colors.white:Colors.black,),
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text('Will Play ',style: TextStyle(color: cubit.isDark?Colors.white:Colors.black,),),
            centerTitle: true,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  child: Center(
                      child: Text(
                    name!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color:  cubit.isDark?Colors.white:Colors.black,
                    ),
                  )),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color:cubit.isDark?Colors.teal.withOpacity(0.4): Colors.teal[50],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              // cubit.selected2(index!, length!);
                              if (name == cubit.currentplayingname) {
                                cubit.stopaudio();
                              } else {
                                cubit.playaudio(url!, name!, context);
                              }
                              print(cubit.searchInFavorite(name!));
                            },
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: cubit.isDark?Colors.teal.withOpacity(0.4): Colors.teal[100],
                              child: Icon(
                                (name == cubit.currentplayingname)
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Colors.teal[300],
                                size: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          cubit.changeFavoriteState();
                          cubit.searchInFavorite(name!)
                              ? cubit.deleteFromDataBaseName(name!, context)
                              : cubit.insertIntoDataBase(
                                  name: name!, url: url!, context: context);

                          print(index);
                          print(url);
                        },
                        child: Icon(
                          cubit.searchInFavorite(name!)
                              //  cubit.favorite[index!]['isFavorite'] == 'true'
                              ? Icons.favorite
                              : cubit.favoriteIsclicked
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                          color: Colors.teal[300],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
