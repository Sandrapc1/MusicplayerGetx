
// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_1/colors/colors.dart';
import 'package:music_player_1/controller/mostplayed_controller.dart';
import 'package:music_player_1/models/mostplayedmodel.dart';
import 'package:music_player_1/screen/home.dart';
import 'package:music_player_1/screen/miniplayer.dart';
import 'package:music_player_1/screen/playscreen.dart';
import 'package:on_audio_query/on_audio_query.dart';


// ignore: unused_element
bool _isPlaying = false;
final MostplayedController mostcontroller = MostplayedController();
// ignore: must_be_immutable
class MostPlayed extends StatelessWidget {
  MostPlayed({super.key});

  // final box = MostlyPlayedBox.getInstance();
  var size, height, width;
  bool favorites = false;
  List<MostlyPlayedSongs> mostplayedsongs = [];

  @override
  Widget build(BuildContext context) {
    final MostplayedController mostcontroller = Get.put(MostplayedController());
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
                // Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: bkclr,
              )),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          height: height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF14052E),
                  Color(0xFF643D80),
                  Color(0xFF521293),
                  Color(0xFF14052E),
                ]),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      // color: Colors.red,
                      height: height * 0.335,
                    ),
                    Positioned(
                      top: 0,
                      child: Container(
                        height: height * 0.3,
                        width: width,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(60),
                          ),
                          image: DecorationImage(
                            image: AssetImage('assets/images/mostpic.jpeg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: height * 0.032,
                      child: BlurryContainer(
                        blur: 20,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(70),
                        ),
                        padding: const EdgeInsets.all(0),
                        height: height * 0.06,
                        width: height * 0.7,
                        child: Padding(
                          padding: EdgeInsets.only(left: height * 0.05),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Most Played',
                                style: GoogleFonts.raleway(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: height * 0.003,
                      right: height * 0.025,
                      child: FloatingActionButton(
                        backgroundColor: backcolor,
                        onPressed: () {
                          audioPlayer.open(
                            Playlist(
                              audios: mostcontroller.mostconvertedaudio,
                              startIndex: 0,
                            ),
                            showNotification: true,
                          );

                          audioPlayer.play();
                          Get.to(PlayScreen());
                        },
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white.withOpacity(0.8),
                          size: 45,
                        ),
                      ),
                    ),
                  ],
                ),

                Obx(() =>
                    mostcontroller.mostplayedgetx.isNotEmpty
                        ? ListView.separated(
                            padding: EdgeInsets.only(bottom: width * .3),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) =>
                             MostlySongTile(mostcontroller: mostcontroller, index: index),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            itemCount: mostcontroller.mostsong.length < 10
                                ? mostcontroller.mostsong.length
                                : 10,
                          )
                        : SizedBox(
                            height: height * 0.3,
                            child: const Center(
                                child: Text(
                              'No songs found',
                              style: TextStyle(color: bkclr),
                            )),
                          )),
              ],
            ),
          ),
        ),
        bottomSheet: Container(color: bgcolor, child: const MiniPlayer()),
      ),
    );
  }
}

class MostlySongTile extends StatelessWidget {
  final MostplayedController mostcontroller;
  final int index;
  const MostlySongTile({
    super.key,
    required this.mostcontroller,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(left: height * 0.01, right: height * 0.01),
      child: InkWell(
        onTap: () {
          audioPlayer.open(Playlist(
            audios: mostcontroller.mostconvertedaudio,
            startIndex: index,
          ));
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: fillcolor,
              border: Border.all(width: 2, color: mostfill
                  //  const Color.fromARGB(255, 155, 151, 152),
                  )),
          height: height * 0.09,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.all(5),
                  child: QueryArtworkWidget(
                    id: mostcontroller.mostsong[index].id!,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/null.jpg'),
                      radius: 24,
                    ),
                  )),
              SizedBox(
                width: height * 0.01,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mostcontroller.mostsong[index].songname,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 15,
                        )),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      mostcontroller.mostsong[index].artist,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                color: bkclr,
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 1,
                    child: Text('ADD Playlist'),
                  ),
                ],
              ),
              SizedBox(width: height * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
