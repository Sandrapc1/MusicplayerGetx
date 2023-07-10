import 'dart:developer';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import '../models/dbfunctions.dart';
import '../models/mostplayedmodel.dart';

class MostplayedController extends GetxController {
  var mostplayedgetx = [].obs;
  var mostsong = [].obs;
  var mostconvertedaudio = <Audio>[].obs;
  

  final box = MostlyPlayedBox.getInstance();

  @override
  void onInit() {
    fetchAllSongs();
    super.onInit();
  }

  void fetchAllSongs() {
    mostplayedgetx.value = box.values.toList();
    mostsong.clear();
    for (var element in mostplayedgetx) {
      if (element.count! > 2) {
        mostsong.add(element);
      }
    }
    mostsong.sort((a, b) => b.count!.compareTo(a.count!));
    mostconvertedaudio.clear();
    for (var element in mostsong) {
      mostconvertedaudio.add(Audio.file(element.songurl!,
          metas: Metas(
            title: element.songname,
            artist: element.artist,
            id: element.id.toString(),
          )));
    }
  }

  addPlayedSongsCount(MostlyPlayedSongs currentSong) async{
    bool isAlreadyAdded = mostplayedgetx.where((song) => song.songname==currentSong.songname).isNotEmpty;
    if(isAlreadyAdded){
      int indexMostly = mostplayedgetx.indexWhere((element) => element.songname==currentSong.songname);
      currentSong.count = mostplayedgetx[indexMostly].count + 1;
      await mostlyplayedboxopen.putAt(indexMostly, currentSong);
      fetchAllSongs();
    } else{
      await mostlyplayedboxopen.add(currentSong);
      fetchAllSongs();
    }
  
    log('added????????????????');
 


  }
}
