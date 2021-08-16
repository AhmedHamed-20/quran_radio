import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_radio/components/all_station_widget.dart';
import 'package:quran_radio/components/popular_station_screen_widget.dart';
import 'package:quran_radio/models/cubit/cubit.dart';
import 'package:quran_radio/models/states/states.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
            : state is LoadingState
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.orangeAccent,
                    ),
                  )
                : Scaffold(
                    backgroundColor:
                        cubit.isDark ? Color(0xff22252b) : Colors.white,
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15, bottom: 10),
                          child: Text(
                            'Popular Station',
                            style: TextStyle(
                              color: cubit.isDark ? Colors.white : Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        popularStationWidget(context),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, bottom: 10),
                          child: Text(
                            'All Stations',
                            style: TextStyle(
                              color: cubit.isDark ? Colors.white : Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        allStationWidget(context, state),
                      ],
                    ),
                  );
      },
    );
  }
}
