// ignore_for_file: sized_box_for_whitespace, prefer_typing_uninitialized_variables
import 'dart:developer';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_1/colors/colors.dart';
import 'package:music_player_1/controller/home_controller.dart';
import 'package:music_player_1/controller/mostplayed_controller.dart';
import 'package:music_player_1/controller/recently_controller.dart';
import 'package:music_player_1/models/dbfunctions.dart';
import 'package:music_player_1/models/mostplayedmodel.dart';
import 'package:music_player_1/models/playlistmodel.dart';
import 'package:music_player_1/models/recentlymodel.dart';
import 'package:music_player_1/models/songmodel.dart';
import 'package:music_player_1/screen/miniplayer.dart';
import 'package:music_player_1/widget/bottam.dart';
import 'package:music_player_1/screen/favlist.dart';
import 'package:music_player_1/screen/mostplayed.dart';
import 'package:music_player_1/screen/recently.dart';
import 'package:music_player_1/widget/switch.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../widget/utilities.dart';

bool isPlaying = false;
List<Audio> allConvertsongs = [];
Map isPlayingMap = {};
final songsbox = SongBox.getInstance();
final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');
final recentbox = RecentlyBox.getInstance();
final List<MostlyPlayedSongs> mostplayedsong =
    mostlyplayedboxopen.values.toList();
List<MostlyPlayedSongs> mostfulllist = [];
var size, height, width;
final playlistbox = PlaylistBox.getInstance();
List<PlayListDb> playlistsong = playlistbox.values.toList();
final TextEditingController addcontroller = TextEditingController();

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeCntrol = Get.put(HomeController());
    if (isPlaying) {
      log(isPlaying.toString());
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        showBottomSheet(
          backgroundColor: bgcolor,
          context: context,
          builder: (context) => const MiniPlayer(),
        );
      });
    }
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      extendBody: false,
      backgroundColor: bgcolor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: bkclr),
        title: Text(
          'Beat Route',
          style: GoogleFonts.lobster(
            color: Colors.white,
            fontSize: 35,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      endDrawer: drawer(context),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Librarys',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 130,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(FavoutitsPage());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                                image: AssetImage('assets/images/home1.jpeg'),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: 130,
                          width: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Favourites',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                              SizedBox(
                                height: height * 0.01,
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(MostPlayed());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                                image: AssetImage('assets/images/home2.jpg'),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: 150,
                          width: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Most played',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(
                                height: height * 0.01,
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      InkWell(
                        onTap: () {
                          Get.to(RecentlyPlayed());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                                image: AssetImage('assets/images/home3.jpg'),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: 150,
                          width: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Recently played',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(
                                height: height * 0.01,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Songs',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: height / 1.8,
                child: Obx(() =>
                        ListView.separated(
                            padding: EdgeInsets.only(bottom: width * .3),
                            itemBuilder: (context, songindex) {
                              return HomeSongTile(
                                songindex: songindex,
                                homeCntrol: homeCntrol,
                                allDbsongs: homeCntrol.homegetx,
                                convertSongs: allConvertsongs,
                              );
                            },
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: 13,
                              );
                            },
                            itemCount: homeCntrol.homegetx.length)
                    // }
                    ),
              ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

class HomeSongTile extends StatelessWidget {
  final int songindex;
  final HomeController homeCntrol;
  final List<Songs> allDbsongs;
  final List<Audio> convertSongs;
  const HomeSongTile({
    super.key,
    required this.songindex,
    required this.allDbsongs,
    required this.convertSongs,
    required this.homeCntrol,
  });

  @override
  Widget build(BuildContext context) {
    final RecentlyPlayedController recentCtrl =
        Get.put(RecentlyPlayedController());
    final MostplayedController mostCtrl = Get.put(MostplayedController());
    Songs song = allDbsongs[songindex];
    var size = MediaQuery.of(context).size;
    var height = size.height;
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: fillcolor,
            border: Border.all(
              width: 3,
              color: strokecolor,
            )),
        height: height * 0.09,
        child: ListTile(
          onTap: () {
            MostlyPlayedSongs mostsong = MostlyPlayedSongs(
              songname: song.songname,
              artist: song.artist,
              duration: song.duration,
              id: song.id,
              songurl: song.songurl,
              count: 1,
            );
            RecentlyPlayedSongs recentsongs = RecentlyPlayedSongs(
                songname: song.songname,
                artist: song.artist,
                duration: song.duration,
                songurl: song.songurl,
                id: song.id);
            recentCtrl.addrecentlyplayed(recentsongs);
            mostCtrl.addPlayedSongsCount(mostsong);
            audioPlayer.open(
              Playlist(audios: homeCntrol.allSongsConvert, startIndex: songindex),
              headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
              showNotification: true,
            );

            audioPlayer.setLoopMode(LoopMode.playlist);
            isPlaying = true;
            showBottomSheet(
                backgroundColor: bgcolor,
                context: context,
                builder: (context) {
                  log('before mini[]');
                  return const MiniPlayer();
                });
          },
          leading: QueryArtworkWidget(
            type: ArtworkType.AUDIO,
            id: allDbsongs[songindex].id!,
            nullArtworkWidget: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/null.jpg'),
              radius: 24,
            ),
          ),
          title: Text(
            allDbsongs[songindex].songname!,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 15,
            ),
            maxLines: 1,
          ),
          subtitle: Text(
            allDbsongs[songindex].artist!,
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
                FavoriteButton(id: allDbsongs[songindex].id!),
                PopupMenuButton(
                  color: bkclr,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: PlayListBottomSheet(songindex: songindex),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
