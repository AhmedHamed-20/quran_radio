import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quran_radio/models/states/states.dart';
import 'package:quran_radio/screens/current_playing_screen.dart';
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
    CurrentPlaying(),
    SearchSreen(),
    FavouriteScreen(),
  ];

  List<String> title = [
    'Home',
    'Playing Now',
    'Search',
    'Favorite',
  ];

  String currentplayingname = 'nothing';
  String currentplayingurl = 'nothing';
  changeCurrentplay(String name, String url) {
    currentplayingname = name;
    currentplayingurl = url;
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
  List<Map> search = [];
  bool Notfound = false;

  bool searchInFavorite(String name) {
    for (int i = 0; i <= favorite.length; i++) {
      try {
        if (name == favorite[i]['name']) {
          return true;
        }
      } catch (onerror) {
        print(onerror);
      }
    }
    return false;
  }

  searchName(String name) {
    for (int i = 0; i <= radio['radios'].length; i++) {
      try {
        if (name == radio['radios'][i]['name']) {
          search = [
            {
              'name': name,
              'url': radio['radios'][i]['radio_url'],
            }
          ];
          emit(SearchScreen());
          print(search);
          Notfound = false;
          break;
        }
      } catch (error) {
        print(error);
        Notfound = true;
        emit(NotFonundSearch());
      }
    }
  }

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

  void deleteFromDataBase(int id, BuildContext context) async {
    await database!
        .rawDelete('DELETE FROM favorite WHERE id = ?', [id]).then((value) {
      getdataFromDataBase(database).then((value) {
        favorite = value;
        emit(AppGetDataBase());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Deleted ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.teal[200],
            duration: Duration(seconds: 2),
          ),
        );
      });
      emit(AppDeleteFromDataBase());
      print('deleted');
    }).catchError((onError) {
      print(onError);
    });
  }

  void deleteFromDataBaseName(String name, BuildContext context) async {
    await database!
        .rawDelete('DELETE FROM favorite WHERE name = ?', [name]).then((value) {
      getdataFromDataBase(database).then((value) {
        favorite = value;
        emit(AppGetDataBase());
      });
      favoriteIsclicked = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Deleted From Favorites Screen',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.teal[200],
          duration: Duration(seconds: 2),
        ),
      );
      emit(AppDeleteFromDataBase());
      print('deleted');
    }).catchError((onError) {
      print(onError);
    });
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
    BuildContext? context,
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
            ScaffoldMessenger.of(context!).showSnackBar(
              SnackBar(
                content: Text(
                  'Added To Favorites Screen',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.teal[200],
                duration: Duration(seconds: 2),
              ),
            );
            emit(AppGetDataBase());
            favoriteIsclicked = false;
          });
        },
      ).catchError((error) {
        print('error');
      });
    });
  }

  bool PlayError = false;
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
  // AssetsAudioPlayerCache cache;
  Future playaudio(String url, String name, BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Loading....',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.teal[200],
        duration: Duration(seconds: 2),
      ),
    );
    try {
      var response = await Dio().head(url);
      if (response.statusCode == 200) {
        pauseaudio();
        print('success');
        await audioStreamPlayer
            .open(
          Audio.liveStream(url),
          showNotification: true,
        )
            .then((value) {
          isplay = true;
          PlayError = false;
          changeCurrentplay(name, url);
          emit(IsPlaying());
        });
      }
    } catch (error) {
      PlayError = true;
      emit(PlayErrorState());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error in Station!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );

      print(error);
    }

    // try {
    //
    // } catch (error) {
    //   audioStreamPlayer.onErrorDo = (handler) {
    //     handler.player.stop();
    //   };
    //   //   stopaudio();
    //   //    audioStreamPlayer.dispose();
    //   print(error);
    // }
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
      changeCurrentplay('nothing', 'nothing');
    }).catchError((onError) {
      emit(IsError());
      print(onError);
    });
  }

  stopaudio() {
    audioStreamPlayer.stop();
    changeCurrentplay('nothing', 'nothing');
    emit(StopAudio());
  }
}
