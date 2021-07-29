import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_radio/models/states/states.dart';
import 'package:quran_radio/screens/favourite_screen.dart';
import 'package:quran_radio/screens/home_screen.dart';
import 'package:quran_radio/screens/layout_screen.dart';
import 'package:quran_radio/screens/search_screen.dart';

class Appcubit extends Cubit<AppState> {
  Appcubit() : super(AppintiState());
  static Appcubit get(context) => BlocProvider.of(context);
  int currentindex = 0;
  List<Widget> screen = [
    HomeScreen(),
    SearchSreen(),
    FavouriteScreen(),
  ];
  List<String> title = [
    'Home',
    'Search',
    'Favorite',
  ];
  void changBottomnav(int index) {
    currentindex = index;
    emit(ChangebottomState());
  }

  Map<String, dynamic> radio = {};
  List<dynamic> data = [];
  Future getdata() async {
    emit(LoadingState());
    var response = await Dio()
        .get('http://api.mp3quran.net/radios/radio_arabic.json')
        .then(
      (value) {
        radio = Map<String, dynamic>.from(value.data);
        data = radio['radios'];
        //  data = value.data;
        emit(SuccesState());
        print(radio);
      },
    ).onError(
      (error, stackTrace) {
        print(error);
      },
    );
  }

  AssetsAudioPlayer audioStreamPlayer = AssetsAudioPlayer();
  Future playaudio() async {
    try {
      await audioStreamPlayer.open(
        Audio.liveStream('http://live.mp3quran.net:9718/'),
        showNotification: true,
      );
    } catch (t) {
      print(t);
    }
  }

  pauseaudio() {
    audioStreamPlayer.pause();
  }

  stopaudio() {
    audioStreamPlayer.stop();
  }
}
