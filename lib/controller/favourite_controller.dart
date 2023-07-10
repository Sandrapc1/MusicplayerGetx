
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_1/models/songmodel.dart';
import '../colors/colors.dart';
import '../models/dbfunctions.dart';
import '../models/favouritesmodel.dart';
import '../screen/favlist.dart';
import '../screen/home.dart';

class FavoriteController extends GetxController{
  RxList favgetx=[].obs;
  final favbox = Favouritesbox.getInstance();


  @override
  void onInit() {
    fatchAllFavSongs();

    super.onInit();
  }

  void fatchAllFavSongs(){
    favgetx.value = favbox.values.toList();


    final List<Favourites> favallsongs =
        favbox.values.toList().reversed.toList();
    for (var element in favallsongs) {
      favconveraudio.add(Audio.file(element.songurl.toString(),
          metas: Metas(
            title: element.songname,
            artist: element.artist,
            id: element.id.toString(),
          )));
    }
  }




addFavourites(int id) async {
  List<Songs> dbSongs = songsbox.values.toList();
  List<Favourites> favouritessongs = favouritesdb.values.toList();
  bool isPresent = favouritessongs.any((element) => element.id == id);
  if (!isPresent) {
    Songs song = dbSongs.firstWhere((element) => element.id == id);
    favouritesdb.add(Favourites(
        songname: song.songname,
        artist: song.artist,
        duration: song.duration,
        songurl: song.songurl,
        id: song.id));
        Get.snackbar('add to favourite', '',
        colorText: Colors.white,
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
        snackPosition: SnackPosition.BOTTOM
        );
        
  } else {
    int currentindex =
        favouritessongs.indexWhere((element) => element.id == id);
    await favouritesdb.deleteAt(currentindex);
    Get.snackbar('remove from favourite', '',
    backgroundColor: Colors.red,
    colorText: Colors.white,
    duration: const Duration(seconds: 1),
    snackPosition: SnackPosition.BOTTOM
    );


  }
}


// ignore: avoid_types_as_parameter_names, non_constant_identifier_names
bool checkFavourite(int? songId) {
  List<Songs> dbSongs = songsbox.values.toList();
  Songs song = dbSongs.firstWhere((element) => element.id == songId);
  Favourites value = Favourites(
      songname: song.songname,
      artist: song.artist,
      duration: song.duration,
      songurl: song.songurl,
      id: song.id);

  favgetx.value = favouritesdb.values.toList();
  bool isPresent =
      favgetx.where((element) => element.id == value.id).isEmpty;
  return isPresent;
}



Future<void> removeFav(int songId,BuildContext context) async {
  final favbox = Favouritesbox.getInstance();
  List<Favourites> favouritesongs = favbox.values.toList();
  int currentindex =
      favouritesongs.indexWhere((element) => element.id == songId);
  if (currentindex >= 0) {
    await favouritesdb.deleteAt(currentindex);
  }
  // ignore: use_build_context_synchronously
  ScaffoldMessenger.of(context).clearSnackBars();
     const snackBar= SnackBar(content: Text('Remove from Favourite'),
            dismissDirection: DismissDirection.down,
            behavior: SnackBarBehavior.floating,
            elevation: 30,
            duration: Duration(seconds: 1),
            backgroundColor: delete,);
// ignore: use_build_context_synchronously
ScaffoldMessenger.of(context).showSnackBar(snackBar);

}

  deletefav(int index) async {
  await favouritesdb.deleteAt(favouritesdb.length - index - 1);
  favgetx.removeAt(index);
}


}
  
