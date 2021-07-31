import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_radio/models/states/states.dart';
import 'package:quran_radio/screens/layout_screen.dart';

import 'models/cubit/cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (BuildContext context) => Appcubit()
              ..createData()
              ..getdata()),
      ],
      child: BlocConsumer<Appcubit, AppState>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primaryColor: Colors.teal[300],
            ),
            home: LayoutScreen(),
          );
        },
      ),
    );
  }
}
