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
                              Image.asset('assets/images/empty.png'),
                              Text(
                                'No playing media Running',
                                style: TextStyle(
                                  fontSize: 18,
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
                                            backgroundColor: Colors.teal[200],
                                            child: Icon(
                                              (cubit.currentplayingname ==
                                                      'nothing')
                                                  ? Icons.play_arrow
                                                  : Icons.pause,
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
