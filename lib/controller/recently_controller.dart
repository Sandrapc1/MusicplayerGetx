import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import '../models/dbfunctions.dart';
import '../models/recentlymodel.dart';
class RecentlyPlayedController extends GetxController {
  var recentlygetx = <RecentlyPlayedSongs>[].obs;
  var recentlyconvert = <Audio>[].obs;
  final recentbox = RecentlyBox.getInstance();

  @override
  void onInit() {
    fetchAllSongs();
    super.onInit();
  }

  void fetchAllSongs() {
    recentlygetx.value = recentbox.values.toList();

    final List<RecentlyPlayedSongs> recentlyplayed =
        recentbox.values.toList().reversed.toList();
        recentlyconvert.clear();
    for (var element in recentlyplayed) {
      recentlyconvert.add(Audio.file(element.songurl.toString(),
          metas: Metas(
            title: element.songname,
            artist: element.artist,
            id: element.id.toString(),
          )));
    }
  }
  addrecentlyplayed(RecentlyPlayedSongs song) {
  List<RecentlyPlayedSongs> list = recentbox.values.toList();
  bool notThere =
      list.where((element) => element.songname == song.songname).isEmpty;
  if (notThere) {
    recentlyplayedopenbox.add(song);
  } else {
    int index = list.indexWhere((element) => element.songname == song.songname);
    recentlyplayedopenbox.deleteAt(index);
    recentlyplayedopenbox.add(song);
  }
}
}


