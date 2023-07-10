
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import 'package:music_player_1/models/songmodel.dart';
import 'package:music_player_1/screen/splashscreen.dart';

class HomeController extends GetxController {

  var homegetx=<Songs>[].obs;
  var allSongsConvert=<Audio>[].obs;

  
@override
  void onInit() {
    fetchAllSongs();
    super.onInit();
  }

  void fetchAllSongs(){
    homegetx.value=box.values.toList();
   
   for (var element in homegetx) {
      allSongsConvert.add(
        Audio.file(
          element.songurl!,
          metas: Metas(
            artist: element.artist,
            title: element.songname,
            id: element.id.toString(),
          ),
        ),
      );
    }

  }
  
}