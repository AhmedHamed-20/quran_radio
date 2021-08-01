import 'package:flutter/material.dart';
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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text('Will Play '),
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
                    ),
                  )),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.teal[100],
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
                                cubit.playaudio(url!, name!);
                              }
                            },
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.teal[200],
                              child: Icon(
                                (name == cubit.currentplayingname)
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Colors.teal,
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
                          cubit.insertIntoDataBase(name: name!, url: url!);

                          print(name);
                          print(url);
                        },
                        child: Icon(
                          cubit.favoriteIsclicked
                              //  cubit.favorite[index!]['isFavorite'] == 'true'
                              ? Icons.favorite
                              : Icons.favorite_outline,
                          color: Colors.teal,
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
