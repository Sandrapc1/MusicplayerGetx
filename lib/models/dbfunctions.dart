import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:music_player_1/models/favouritesmodel.dart';
import 'package:music_player_1/models/mostplayedmodel.dart';
import 'package:music_player_1/models/playlistmodel.dart';
import 'package:music_player_1/models/recentlymodel.dart';
import 'package:music_player_1/models/songmodel.dart';
import 'package:music_player_1/screen/splashscreen.dart';

// import '../screen/home.dart';



////.....Favourites function.....////
late Box<Favourites> favouritesdb;
openfavouritesdb() async {
  favouritesdb = await Hive.openBox<Favourites>('favourites');
}



///...recently function....///
late Box<RecentlyPlayedSongs>recentlyplayedopenbox;
openrecentlyplayed()async{
recentlyplayedopenbox=await Hive.openBox('Recentlyname');
}



///.....mostlyplayed funaction....///
late Box<MostlyPlayedSongs>mostlyplayedboxopen;
openmostlyBox()async{
  mostlyplayedboxopen=await Hive.openBox<MostlyPlayedSongs>('MostlyPlayedDb');
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


Songs? boxsongfinder(int id){
List<Songs> allsongs=box.values.toList();
Songs? data;
  for(Songs element in allsongs){
    if(element.id==id){
      data=element;
    }
  }
  return data;
}