import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_radio/models/cubit/cubit.dart';
import 'package:quran_radio/models/states/states.dart';
import 'package:quran_radio/widgets/stations.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = Appcubit.get(context);
    return BlocConsumer<Appcubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (cubit.NoInternet) {
          return Center(
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
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: cubit.isDark ? Color(0xff22252b) : Colors.white,
            body: cubit.favorite.length == 0
                ? Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/notFound.png'),
                          Text(
                            'No Favorites',
                            style: TextStyle(
                              fontSize: 18,
                              color: cubit.isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ]),
                  )
                : ListView.builder(
                    itemBuilder: (context, index) {
                      return Dismissible(
                        background: Container(
                          color: Colors.teal[200],
                        ),
                        key: Key(cubit.favorite[index]['id'].toString()),
                        onDismissed: (directhion) {
                          cubit.deleteFromDataBase(
                              cubit.favorite[index]['id'], context);
                        },
                        child: stations(
                          url: cubit.favorite[index]['url'],
                          name: cubit.favorite[index]['name'],
                          context: context,
                          button: InkWell(
                            onTap: () {
                              // cubit.selected(index);
                              if (cubit.favorite[index]['name'] ==
                                  cubit.currentplayingname) {
                                cubit.stopaudio();
                              } else {
                                cubit.playaudio(cubit.favorite[index]['url'],
                                    cubit.favorite[index]['name'], context);
                              }
                            },
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: cubit.isDark
                                  ? Colors.teal.withOpacity(0.4)
                                  : Colors.teal[100],
                              child: Icon(
                                (cubit.favorite[index]['name'] ==
                                        cubit.currentplayingname)
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Colors.teal[300],
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: cubit.favorite.length,
                  ),
          );
        }
      },
    );
  }
}
