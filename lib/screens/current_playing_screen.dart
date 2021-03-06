import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_radio/models/cubit/cubit.dart';
import 'package:quran_radio/models/states/states.dart';

class CurrentPlaying extends StatelessWidget {
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
            : Scaffold(
                backgroundColor:  cubit.isDark?Color(0xff22252b):Colors.white,
                body: Center(
                  child: cubit.currentplayingname == 'nothing'
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/notFound.png'),
                              Text(
                                'No playing media Running',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: cubit.isDark?Colors.white:Colors.black,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                child: Center(
                                    child: Text(
                                  cubit.currentplayingname,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: cubit.isDark?Colors.white:Colors.black,
                                  ),
                                )),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color:cubit.isDark? Colors.teal.withOpacity(0.4):Colors.teal[50],
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    topRight: Radius.circular(25),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            cubit.currentplayingname ==
                                                    'nothing'
                                                ? cubit.playaudio(
                                                    cubit.currentplayingurl,
                                                    cubit.currentplayingurl,
                                                    context)
                                                : cubit.pauseaudio();
                                          },
                                          child: CircleAvatar(
                                            radius: 40,
                                            backgroundColor: cubit.isDark?Colors.teal.withOpacity(0.4): Colors.teal[100],
                                            child: Icon(
                                              (cubit.currentplayingname ==
                                                      'nothing')
                                                  ? Icons.play_arrow
                                                  : Icons.pause,
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
                          cubit.searchInFavorite(cubit.currentplayingname)
                              ? cubit.deleteFromDataBaseName(cubit.currentplayingname, context)
                              : cubit.insertIntoDataBase(
                                  name: cubit.currentplayingname, url: cubit.currentplayingurl, context: context);

                         
                        },
                        child: Icon(
                          cubit.searchInFavorite(cubit.currentplayingname)
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
                ),
              );
      },
    );
  }
}
