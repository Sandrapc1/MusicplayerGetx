// import 'package:hive/hive.dart';
// import 'package:flutter/material.dart';

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:music_player_1/colors/colors.dart';
import 'package:music_player_1/models/favouritesmodel.dart';
import 'package:music_player_1/models/mostplayedmodel.dart';
import 'package:music_player_1/models/playlistmodel.dart';
import 'package:music_player_1/models/recentlymodel.dart';
import 'package:music_player_1/models/songmodel.dart';

import '../screen/home.dart';



////.....Favourites function.....////
late Box<Favourites> favouritesdb;
openfavouritesdb() async {
  favouritesdb = await Hive.openBox<Favourites>('favourites');
}

addFavourites(int id,BuildContext context) async {
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
        ScaffoldMessenger.of(context).clearSnackBars();
          const snackBar= SnackBar(content: Text('Add to Favourite'),
            dismissDirection: DismissDirection.down,
            behavior: SnackBarBehavior.floating,
            elevation: 30,
            duration: Duration(seconds: 1),
            backgroundColor: Colors.green,);
ScaffoldMessenger.of(context).showSnackBar(snackBar);
  } else {
    int currentindex =
        favouritessongs.indexWhere((element) => element.id == id);
    await favouritesdb.deleteAt(currentindex);
    ScaffoldMessenger.of(context).clearSnackBars();
     const snackBar= SnackBar(content: Text('Remove from Favourite'),
            dismissDirection: DismissDirection.down,
            behavior: SnackBarBehavior.floating,
            elevation: 30,
            duration: Duration(seconds: 1),
            backgroundColor: delete,);
ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }
}

bool checkFavourite(int? songId, BuildContext) {
  List<Favourites> favouritesongs = [];
  List<Songs> dbSongs = songsbox.values.toList();
  Songs song = dbSongs.firstWhere((element) => element.id == songId);
  Favourites value = Favourites(
      songname: song.songname,
      artist: song.artist,
      duration: song.duration,
      songurl: song.songurl,
      id: song.id);

  favouritesongs = favouritesdb.values.toList();
  bool isPresent =
      favouritesongs.where((element) => element.id == value.id).isEmpty;
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
  ScaffoldMessenger.of(context).clearSnackBars();
     const snackBar= SnackBar(content: Text('Remove from Favourite'),
            dismissDirection: DismissDirection.down,
            behavior: SnackBarBehavior.floating,
            elevation: 30,
            duration: Duration(seconds: 1),
            backgroundColor: delete,);
ScaffoldMessenger.of(context).showSnackBar(snackBar);

}

deletefav(int index) async {
  await favouritesdb.deleteAt(favouritesdb.length - index - 1);
  
}


///...recently function....///
late Box<RecentlyPlayedSongs>recentlyplayedopenbox;
openrecentlyplayed()async{
recentlyplayedopenbox=await Hive.openBox('Recentlyname');
}

addrecentlyplayed(RecentlyPlayedSongs song){
  List<RecentlyPlayedSongs>list=recentlyplayedopenbox.values.toList();
  bool notThere=list.where((element) => element.songname==song.songname).isEmpty;
  if(notThere){
    recentlyplayedopenbox.add(song);
  }else{
    int index=list.indexWhere((element) => element.songname==song.songname);
    recentlyplayedopenbox.deleteAt(index);
    recentlyplayedopenbox.add(song);
  }
}

///.....mostlyplayed funaction....///
late Box<MostlyPlayedSongs>mostlyplayedboxopen;
openmostlyBox()async{
  mostlyplayedboxopen=await Hive.openBox<MostlyPlayedSongs>('MostlyPlayedDb');
}

addPlayedSongsCount(MostlyPlayedSongs song,int index){
final box=MostlyPlayedBox.getInstance();
List<MostlyPlayedSongs>mostlist=box.values.toList();
bool notThere=mostlist.where((element) => element.songname==song.songname).isEmpty;
if (notThere) {
  box.add(song);
}else{
  int index=mostlist.indexWhere((element) => element.songname==song.songname);
  box.deleteAt(index);
  box.put(index,song);
}
int count=song.count!;
song.count=count+1;
}


//..playlist function..//
late Box<PlayListDb> playlistdb;
openplaylistDb() async {
  playlistdb = await Hive.openBox<PlayListDb>('playlist');
}

createplaylist(String name, BuildContext context) async {
  final playbox = PlaylistBox.getInstance();
  List<Songs> songsplaylist = [];
  

  List<PlayListDb> list = playbox.values.toList();
  bool isnotpresent =
      list.where((element) => element.playlistname == name).isEmpty;
  if (isnotpresent) {
    playbox.add(PlayListDb(playlistname: name, playlistsongs: songsplaylist));
  } else {
    const snackbar = SnackBar(
      content: Text('This is already in your playlist.'),
      dismissDirection: DismissDirection.down,
      behavior: SnackBarBehavior.floating,
      elevation: 30,
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}

deleteplaylist(int index)  {
  final playsbox = PlaylistBox.getInstance();
  playsbox.deleteAt(index);
  
//  const snackBar= SnackBar(content: Text('Delete playlist'),
//             dismissDirection: DismissDirection.down,
//             behavior: SnackBarBehavior.floating,
//             elevation: 30,
//             duration: Duration(seconds: 1),
//             backgroundColor: delete,);
// ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

editeplaylist(int index, String name) async {
  final playbox = PlaylistBox.getInstance();
  List<PlayListDb> playlistsong = playbox.values.toList();
  final playbox2 = PlaylistBox.getInstance();
  playbox2.putAt(
      index,
      PlayListDb(
          playlistname: name,
          playlistsongs: playlistsong[index].playlistsongs));
}


