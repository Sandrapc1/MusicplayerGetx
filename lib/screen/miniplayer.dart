import 'dart:async';
import 'dart:developer';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_1/colors/colors.dart';
import 'package:music_player_1/models/dbfunctions.dart';
import 'package:music_player_1/models/songmodel.dart';
import 'package:music_player_1/screen/home.dart';
import 'package:music_player_1/screen/playscreen.dart';
import 'package:music_player_1/widget/playpause.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:text_scroll/text_scroll.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    log('mini playeer');
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return InkWell(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
          Timer(const Duration(milliseconds: 150), () {
            // miniscreen();
            Get.to(PlayScreen());
          });
        },
        child: Container(
          color: Colors.transparent,
          child: Container(
            height: height * 0.1,
            width: width,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF521293).withOpacity(.8),
                      Colors.black.withOpacity(.1),
                    ])),
            child: audioPlayer.builderCurrent(
              builder: (context, playing) {
                int id = int.parse(playing.audio.audio.metas.id!);
                // ignore: unused_local_variable
                Songs? data = boxsongfinder(id);
                if (!playing.hasNext) {
                  audioPlayer.setLoopMode(LoopMode.single);
                }
                return Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: QueryArtworkWidget(
                          artworkQuality: FilterQuality.high,
                          artworkHeight: height * 0.07,
                          artworkWidth: height * 0.07,
                          artworkFit: BoxFit.cover,
                          nullArtworkWidget: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(height * 0.035),
                              child: Image.asset(
                                'assets/images/null.jpg',
                                fit: BoxFit.cover,
                                height: height * 0.07,
                                width: height * 0.07,
                              )),
                          id: int.parse(playing.audio.audio.metas.id!),
                          type: ArtworkType.AUDIO),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: width * 0.6,
                          child: TextScroll(
                            audioPlayer.getCurrentAudioTitle,
                            velocity:
                                const Velocity(pixelsPerSecond: Offset(50, 0)),
                            style: GoogleFonts.lato(
                              color: bkclr,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        SizedBox(width: height * 0.02),
                        const PlayPause(),
                      ],
                    )
                  ],
                );
              },
            ),
          ),
        ));
  }
}
