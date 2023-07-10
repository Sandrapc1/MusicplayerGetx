
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_1/colors/colors.dart';
import 'package:music_player_1/models/songmodel.dart';
import 'package:music_player_1/screen/home.dart';
import 'package:music_player_1/screen/miniplayer.dart';
import 'package:music_player_1/screen/playscreen.dart';
// import 'package:music_player_1/screen/splashscreen.dart';
import 'package:music_player_1/widget/bottam.dart';
import 'package:music_player_1/widget/switch.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:music_player_1/controller/search_controller.dart';

import '../widget/utilities.dart';
final songsbox = SongBox.getInstance();
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController();
    SearchingController searchCtrl = Get.put(SearchingController());
    final size = MediaQuery.of(context).size;
    final height = size.height;

    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: bkclr),
        backgroundColor: bgcolor,
        title:
            Text('Search', style: GoogleFonts.lato(color: bkclr, fontSize: 30)),
      ),
      endDrawer: drawer(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                height: height * 0.06,
                width: height * 0.37,
                decoration: BoxDecoration(
                  color: searchbox,
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: TextField(
                        onChanged: (value) => searchCtrl.updateList(value),
                        controller: controller,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.search,
                              color: textclr,
                            ),
                            hintText: 'Search for a song',
                            hintStyle: const TextStyle(
                              color: textclr,
                              fontSize: 17,
                            ),
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                                onPressed: controller.clear,
                                icon: const Icon(Icons.clear))),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.05),
              Obx(() => searchCtrl.searchgetx.isEmpty?
              Padding(
                padding:  EdgeInsets.only(top: height*0.3),
                child: const Center(
                child: Text('Song not found',style: TextStyle(color: bkclr),),
                ),
              ):
              SizedBox(
                height: height / 1.38,
                child: ListView.separated(
                  padding: EdgeInsets.only(bottom: height*0.03),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => SearchSongTile(searchCtrl: searchCtrl, index: index) ,
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                    itemCount: searchCtrl.searchgetx.length),
              )
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SearchSongTile extends StatelessWidget {
  final SearchingController searchCtrl;
  final int index; 
  const SearchSongTile({super.key, required this.searchCtrl, required this.index});

  @override
  Widget build(BuildContext context) {
    final  completesongs= songsbox.values.toList();
    // final size = MediaQuery.of(context).size;
    // final height = size.height;
    // final width = size.width;
    return ListTile(
      onTap: () {
          PlayScreen.playscreenindex.value = index;
          audioPlayer.open(
            Playlist(audios: searchCtrl.searchConvertSongs, startIndex: index),
            headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
            showNotification: true,
          );
          showBottomSheet(
            backgroundColor: bgcolor,

            context: context, builder: (context) =>  const MiniPlayer( ),);
        },
      leading: QueryArtworkWidget(
                  type: ArtworkType.AUDIO,
                  id: searchCtrl.searchgetx[index].id,
                  nullArtworkWidget: const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/null.jpg'),
                    radius: 24,
                  ),
                ),
      title: Text(
                      searchCtrl.searchgetx[index].songname,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                    ),
                    subtitle: Text(
                      searchCtrl.searchgetx[index].artist,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      maxLines: 1,
                    ),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FavoriteButton(id: searchCtrl.searchgetx[index].id),
                                PopupMenuButton(
                                  color: bkclr,
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 1,
                                      child: PlayListBottomSheet(songindex: completesongs.indexWhere((element) => element.songname==searchCtrl.searchgetx[index].songname)),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
    );
  }
}
