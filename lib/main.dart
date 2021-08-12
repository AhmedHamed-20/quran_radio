import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_radio/models/darkmodecach.dart';
import 'package:quran_radio/models/states/states.dart';
import 'package:quran_radio/layouts/layout_screen.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import 'models/cubit/cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SaveToCach.init();
  bool? valueFromShared;
  if (SaveToCach.getData('isDark') == null) {
    valueFromShared = false;
  } else {
    valueFromShared = SaveToCach.getData('isDark')!;
  }

  runApp(MyApp(valueFromShared));
}

class MyApp extends StatelessWidget {
  bool valueFromCach;
  MyApp(this.valueFromCach);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => Appcubit()
            ..getdata()
            ..toggleDarkTheme(valueFromCach: valueFromCach),
        ),
      ],
      child: BlocConsumer<Appcubit, AppState>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            title: 'Quran Radio',
            theme: ThemeData(
              primaryColor: Colors.teal[300],
            ),
            home: SplashScreenView(
              imageSrc: 'assets/images/splash.gif',
              imageSize: 200,
              duration: 6000,
              speed: 5,

              pageRouteTransition: PageRouteTransition.CupertinoPageRoute,
              backgroundColor: Color(0xffF4CE57),
              //speed: 3,
              navigateRoute: LayoutScreen(),

              //    pageTransitionType: ,
            ),
          );
        },
      ),
    );
  }
}
