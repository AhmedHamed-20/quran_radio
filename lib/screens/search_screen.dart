import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_radio/models/cubit/cubit.dart';
import 'package:quran_radio/models/states/states.dart';
import 'package:quran_radio/screens/playing_screen.dart';
import 'package:quran_radio/widgets/stations.dart';

class SearchSreen extends StatelessWidget {
  String? searchvalue;
  @override
  Widget build(BuildContext context) {
    var cubit = Appcubit.get(context);
    TextEditingController controller = TextEditingController();
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
                  backgroundColor:
                      cubit.isDark ? Color(0xff22252b) : Colors.white,
                  body: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Theme(
                            data: ThemeData(
                                primaryColor:
                                    cubit.isDark ? Colors.white : Colors.black),
                            child: TextField(
                              style: TextStyle(
                                color:
                                    cubit.isDark ? Colors.white : Colors.black,
                              ),
                              textDirection: TextDirection.rtl,
                              cursorColor:
                                  cubit.isDark ? Colors.white : Colors.black,
                              controller: controller,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                searchvalue = value;
                                cubit.searchName(
                                  value.trim(),
                                );
                              },
                              onSubmitted: (val) {
                                cubit.searchName(
                                  val.trim(),
                                );
                              },
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: cubit.isDark
                                        ? Colors.teal
                                        : Colors.black,
                                  ),
                                ),
                                labelText: 'Search',
                                labelStyle: TextStyle(
                                    color: cubit.isDark
                                        ? Colors.white
                                        : Colors.black),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: cubit.isDark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: cubit.isDark
                                      ? Colors.white
                                      : Colors.black,
                                )),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: cubit.isDark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: cubit.search.length == 0
                              ? Center(
                                  child: Text(
                                    'Start Search Now',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: cubit.isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                )
                              : cubit.Notfound
                                  ? Text(
                                      'Not Found',
                                      style: TextStyle(
                                        color: cubit.isDark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    )
                                  : ListView.builder(
                                      itemBuilder: (context, index) {
                                        return OpenContainer(
                                          closedBuilder: (context, k) {
                                            return InkWell(
                                              onTap: k,
                                              child: stations(
                                                backgroundColor: cubit.isDark
                                                    ? Colors.transparent
                                                    : Colors.teal[50],
                                                name: cubit.search[index]
                                                    ['name'],
                                                context: context,
                                                url: cubit.search[index]['url'],
                                              ),
                                            );
                                          },
                                          openBuilder: (context, k) {
                                            return PlayingScreen(
                                              index: index,
                                              name: cubit.search[index]['name'],
                                              url: cubit.search[index]['url'],
                                              length: cubit.search.length,
                                            );
                                          },
                                          closedElevation: 2,
                                          closedColor: cubit.isDark
                                              ? Colors.teal.withOpacity(0.2)
                                              : Color(0xffe0f2f1),
                                          openShape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          transitionType:
                                              ContainerTransitionType.fade,
                                          transitionDuration:
                                              Duration(milliseconds: 400),
                                          closedShape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        );
                                      },
                                      itemCount: cubit.search.length,
                                    ),
                        ),
                      ],
                    ),
                  ),
                );
        });
  }
}
