import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import 'package:music_player_1/models/songmodel.dart';

class SearchingController extends GetxController {
  var searchgetx = [].obs;
  var searchConvertSongs = <Audio>[].obs;
 
  

  updateList(String value) {
    final box = SongBox.getInstance();
    final List<Songs> allDbsongs = box.values.toList();
    searchgetx.value = allDbsongs
        .where((element) =>
            element.songname!.toLowerCase().contains(value.toLowerCase()))
        .toList();
    searchConvertSongs.clear();
    // ignore: unused_local_variable
    for (var item in searchgetx) {
      searchConvertSongs.add(
        Audio.file(
          item.songurl.toString(),
          metas: Metas(
            artist: item.artist,
            title: item.songname,
            id: item.id.toString(),
          ),
        ),
      );
    }
  }
}
