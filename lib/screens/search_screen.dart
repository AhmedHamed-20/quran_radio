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
                  body: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextField(
                            textDirection: TextDirection.rtl,
                            controller: controller,
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              searchvalue = value;
                            },
                            onSubmitted: (val) {
                              cubit.searchName(
                                val.trim(),
                              );
                            },
                            decoration: InputDecoration(
                              labelText: 'Search',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: cubit.search.length == 0
                              ? Center(
                                  child: Text('Start Search Now'),
                                )
                              : cubit.Notfound
                                  ? Text('Not Found')
                                  : ListView.builder(
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          child: stations(
                                            name: cubit.search[index]['name'],
                                            context: context,
                                            url: cubit.search[index]['url'],
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PlayingScreen(
                                                  index: index,
                                                  name: cubit.search[index]
                                                      ['name'],
                                                  url: cubit.search[index]
                                                      ['url'],
                                                  length: cubit.search.length,
                                                ),
                                              ),
                                            );
                                          },
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
