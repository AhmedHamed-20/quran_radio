import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:quran_radio/models/darkmodecach.dart';
import 'package:quran_radio/models/states/states.dart';
import 'package:quran_radio/screens/current_playing_screen.dart';
import 'package:quran_radio/screens/favourite_screen.dart';
import 'package:quran_radio/screens/home_screen.dart';

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

  bool isDark=false;


  void toggleDarkTheme({bool? valueFromCach}) {
    if (valueFromCach != null) {
      isDark = valueFromCach;
      emit(ChangeTheme());
    } else {
      isDark = !isDark;
      SaveToCach.putDate(key: 'isDark', isDark: isDark).then((value) {});
      emit(ChangeTheme());
    }
  }

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
        if (radio['radios'][i]['name'].toString().contains(name)) {
          search = [
            {
              'name': radio['radios'][i]['name'],
              'url': radio['radios'][i]['radio_url'],
            }
          ];
          emit(SearchScreen());
          print(search);
          Notfound = false;
          break;
        }
      } catch (error) {
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
    }).catchError((onError) {});
  }

  Map<String, dynamic> radio = {};
  List<dynamic> data = [];
  List<bool> audioSelectedList = [false];

  selected(int index) {
// set only one bool to be true
    emit(IsSelected());
    audioSelectedList =
        List.generate(radio['radios'].length, (i) => false); // set all to false
    audioSelectedList[index] = true;
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
      ).catchError((error) {});
    });
  }

  bool NoInternet = false;
  bool PlayError = false;
  Future<bool> noInternet() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      NoInternet = false;
      return false;
    } else {
      NoInternet = true;
      emit(NoInternetState());
      return true;
    }
  }

  Navigate(Widget Screen, BuildContext context) async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Screen),
      );
    } else {}
  }

  Future getdata({valueFromCach}) async {
    toggleDarkTheme(valueFromCach: valueFromCach);
    emit(LoadingState());
    NoInternet = false;

    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      print('connected');
      var response = await Dio()
          .get('http://api.mp3quran.net/radios/radio_arabic.json')
          .then(
        (value) {
          radio = Map<String, dynamic>.from(value.data);
          data = radio['radios'];
          //  data = value.data;
          createData();
          emit(SuccesState());
        },
      ).onError(
        (error, stackTrace) {
          print(error);
        },
      );
    } else {
      NoInternet = true;
    }
  }

  bool isplay = false;
  AssetsAudioPlayer audioStreamPlayer = AssetsAudioPlayer();

  Future playaudio(String url, String name, BuildContext context) async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
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

          await audioStreamPlayer
              .open(
            Audio.liveStream(
              url,
              metas: Metas(
                title: 'Quran Radio',
                artist: name,
                image: MetasImage.network(
                    'https://static5.depositphotos.com/1031888/412/v/600/depositphotos_4122008-stock-illustration-vintage-radio.jpg'),
              ),
            ),
            showNotification: true,
            playInBackground: PlayInBackground.enabled,
            notificationSettings: NotificationSettings(
              nextEnabled: false,
              prevEnabled: false,
            ),
          )
              .then((value) async {
            print(audioStreamPlayer.isPlaying.value);
            isplay = true;
            PlayError = false;
            changeCurrentplay(name, url);
            emit(IsPlaying());
          });
        }
      } catch (error) {
        PlayError = true;
        print(error);
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
      }
    } else {
      NoInternet = true;
    }
  }

  pauseaudio() async {
    await audioStreamPlayer.pause().then((value) async {
      await audioStreamPlayer.updateCurrentAudioNotification(
        metas: Metas(
          title: 'Quran Radio',
          image: MetasImage.network(
              'https://static5.depositphotos.com/1031888/412/v/600/depositphotos_4122008-stock-illustration-vintage-radio.jpg'),
        ),
      );
      emit(IsPause());
      isplay = false;
      changeCurrentplay('nothing', 'nothing');
    }).catchError((onError) {
      emit(IsError());
    });
  }

  stopaudio() {
    audioStreamPlayer.stop();
    changeCurrentplay('nothing', 'nothing');
    emit(StopAudio());
  }
}
