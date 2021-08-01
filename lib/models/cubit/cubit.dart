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
import 'package:sqflite/sqflite.dart';

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

  String currentplayingname = 'nothing';

  changeCurrentplay(String name) {
    currentplayingname = name;
    print(currentplayingname);
  }

  Database? database;
  void changBottomnav(int index) {
    currentindex = index;
    emit(ChangebottomState());
  }

  bool favoriteIsclicked = false;
  changeFavoriteState() {
    favoriteIsclicked = !favoriteIsclicked;
    emit(ClickedFavorite());
  }

  List<Map> favorite = [];
  void createData() {
    emit(LoadingState());
    openDatabase(
      'favorite.db',
      version: 1,
      onCreate: (createdDataBase, ver) {
        createdDataBase
            .execute(
                'CREATE TABLE favorite (id INTEGER PRIMARY KEY, name TEXT, url TEXT)')
            .then(
              (value) => {
                print('database created'),
              },
            );
      },
      onOpen: (createdDataBase) {
        getdataFromDataBase(createdDataBase).then((value) {
          favorite = value;
          database = createdDataBase;
          print(favorite);
          emit(AppGetDataBase());
        });
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDataBase());
    });
  }

  Future<List<Map>> getdataFromDataBase(createdDataBase) async {
    return await createdDataBase.rawQuery('SELECT * FROM favorite');
  }

  Map<String, dynamic> radio = {};
  List<dynamic> data = [];
  List<bool> audioSelectedList = [false];
  List<bool> audioSelectedList2 = [false];
  List<bool> audioSelectedList3 = [false];
  selected(int index) {
// set only one bool to be true
    emit(IsSelected());
    audioSelectedList =
        List.generate(radio['radios'].length, (i) => false); // set all to false
    audioSelectedList[index] = true;
    print(radio['radios'].length);
  }

  selected2(int index, int length) {
// set only one bool to be true
    emit(IsSelected());
    audioSelectedList2 =
        List.generate(length, (i) => false); // set all to false
    audioSelectedList2[index] = true;
    print(length);
  }

  selected3(int index, int length) {
// set only one bool to be true
    emit(IsSelected());
    audioSelectedList3 =
        List.generate(length, (i) => false); // set all to false
    audioSelectedList3[index] = true;
    print(length);
  }

  insertIntoDataBase({
    String? name,
    String? url,
  }) async {
    return await database!.transaction((txn) async {
      await txn.rawInsert('INSERT INTO favorite(name, url) VALUES(?, ?)',
          ['$name', '$url']).then(
        (value) {
          print('Inserted succ');

          emit(AppInsertDataBase());

          getdataFromDataBase(database).then((value) {
            favorite = value;
            print(favorite);
            emit(AppGetDataBase());
            favoriteIsclicked = false;
          });
        },
      ).catchError((error) {
        print('error');
      });
    });
  }

  Future getdata() async {
    emit(LoadingState());
    var response = await Dio()
        .get('http://api.mp3quran.net/radios/radio_arabic.json')
        .then(
      (value) {
        radio = Map<String, dynamic>.from(value.data);
        data = radio['radios'];
        //  data = value.data;
        createData();
        emit(SuccesState());
        print(radio);
      },
    ).onError(
      (error, stackTrace) {
        print(error);
      },
    );
  }

  bool isplay = false;
  AssetsAudioPlayer audioStreamPlayer = AssetsAudioPlayer();
  Future playaudio(String url, String name) async {
    pauseaudio();
    await audioStreamPlayer
        .open(
      Audio.liveStream(url),
      showNotification: true,
    )
        .then((value) {
      isplay = true;
      changeCurrentplay(name);
      emit(IsPlaying());
    }).catchError((onError) {
      print(onError);
    });
  }

  bool isClicked = false;
  List<bool> items = [];
  // changeclick() {
  //   isClicked = !isClicked;
  //   print(radio['radios'].length);
  //   print(items);
  //   emit(IsSelected());
  // }

  pauseaudio() async {
    await audioStreamPlayer.pause().then((value) {
      emit(IsPause());
      isplay = false;
      changeCurrentplay('nothing');
    }).catchError((onError) {
      emit(IsError());
      print(onError);
    });
  }

  stopaudio() {
    audioStreamPlayer.stop();
    changeCurrentplay('nothing');
    emit(StopAudio());
  }
}
