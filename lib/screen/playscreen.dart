// import 'package:audioplayers/audioplayers.dart';
// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_player_1/colors/colors.dart';
import 'package:music_player_1/models/songmodel.dart';
import 'package:music_player_1/screen/favlist.dart';
import 'package:music_player_1/screen/home.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:text_scroll/text_scroll.dart';

// ignore: must_be_immutable
class PlayScreen extends StatefulWidget {
  PlayScreen({super.key});
  List<Songs>? songs;
  static int? indexvalue = 0;
  static ValueNotifier<int> playscreenindex = ValueNotifier<int>(indexvalue!);

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  var size, height, width;
  final _audioPlayer = AssetsAudioPlayer.withId('0');
  final box = SongBox.getInstance();
  bool isShuffleon = false;
  bool isRepeat = false;
  double currentSlidervalue = 20;
  bool playarrow = false;
  bool fav = false;

  @override
  Widget build(BuildContext context) {
    bool playerDone = true;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    Duration duration = Duration.zero;
    Duration position = Duration.zero;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: bkclr,
              )),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF643D80),
                  Color(0xFF14052E),
                ],
              ),
            ),
            child: ValueListenableBuilder(
                valueListenable: PlayScreen.playscreenindex,
                builder: (BuildContext context, int playing, child) {
                  return ValueListenableBuilder<Box<Songs>>(
                      valueListenable: box.listenable(),
                      builder: ((context, Box<Songs> allsongbox, child) {
                        List<Songs> allSongs = allsongbox.values.toList();
                        if (allSongs.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        // ignore: unnecessary_null_comparison
                        if (allSongs == null) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return _audioPlayer.builderCurrent(
                            builder: ((context, playing) {
                          if (!playing.hasNext) {
                            audioPlayer.setLoopMode(LoopMode.single);
                          }
                          return Column(children: [
                            SizedBox(height: height * 0.10),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(height * 0.150),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.6),
                                      spreadRadius: 2,
                                      blurRadius: 9,
                                    ),
                                  ]),
                              child: QueryArtworkWidget(
                                  artworkQuality: FilterQuality.high,
                                  artworkHeight: height * 0.30,
                                  artworkWidth: height * 0.30,
                                  artworkBorder: BorderRadius.circular(150),
                                  artworkFit: BoxFit.cover,
                                  id: int.parse(playing.audio.audio.metas.id!),
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget: CircleAvatar(
                                    radius: height * 0.150,
                                    backgroundImage: const AssetImage(
                                        'assets/images/null.jpg'),
                                  )),
                            ),
                            Column(
                              children: [
                                Column(
                                  children: [
                                    SizedBox(height: height * 0.06),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 10),
                                      child: TextScroll(
                                        _audioPlayer.getCurrentAudioTitle,
                                        style: GoogleFonts.lato(
                                          color: bkclr,
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: height * 0.01),
                                    TextScroll(
                                      _audioPlayer.getCurrentAudioArtist,
                                      style: GoogleFonts.lato(
                                        color: bkclr,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: height * 0.010),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: height * 0.050,
                                      top: height * 0.020),
                                  child: Row(
                                    children: [
                                      SizedBox(height: height * 0.01),
                                      PlayerBuilder.isPlaying(
                                        player: _audioPlayer,
                                        builder: ((context, isPlaying) {
                                          return IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (isRepeat) {
                                                    _audioPlayer.setLoopMode(
                                                        LoopMode.none);
                                                    isRepeat = false;
                                                  } else {
                                                    _audioPlayer.setLoopMode(
                                                        LoopMode.single);
                                                    isRepeat = true;
                                                  }
                                                });
                                              },
                                              icon: (isRepeat)
                                                  ? const Icon(
                                                      Icons.repeat_one_outlined,
                                                      color: Colors.white)
                                                  : const Icon(
                                                      Icons.repeat,
                                                      color: Colors.white,
                                                    ));
                                        }),
                                      ),
                                      SizedBox(width: height * 0.26),
                                      IconButton(
                                        onPressed: () {
                                        },
                                        icon: Icon(Icons.playlist_add,
                                            color:
                                                Colors.white.withOpacity(0.8),
                                            size: 35),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: height * 0.01),
                                PlayerBuilder.realtimePlayingInfos(
                                  player: _audioPlayer,
                                  builder: (context, RealtimePlayingInfos) {
                                    duration = RealtimePlayingInfos
                                        .current!.audio.duration;
                                    position =
                                        RealtimePlayingInfos.currentPosition;
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          left: height * 0.04,
                                          right: height * 0.03),
                                      child: ProgressBar(
                                        baseBarColor: bkclr,
                                        thumbRadius: 7,
                                        timeLabelTextStyle:
                                            const TextStyle(color: bkclr),
                                        progress: position,
                                        total: duration,
                                        onSeek: (duration) async {
                                          await _audioPlayer.seek(duration);
                                        },
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: height * 0.03),
                                PlayerBuilder.isPlaying(
                                  player: _audioPlayer,
                                  builder: ((context, isPlaying) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            _audioPlayer.toggleShuffle();
                                            setState(() {
                                              isShuffleon = !isShuffleon;
                                            });
                                          },
                                          icon: (isShuffleon)
                                              ? const Icon(
                                                  CupertinoIcons.shuffle,
                                                  color: image2,
                                                )
                                              : const Icon(
                                                  CupertinoIcons.shuffle,
                                                  color: Colors.white,
                                                ),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            if (playerDone == true) {
                                              playerDone = false;
                                              await _audioPlayer.previous();

                                              playerDone = true;
                                            }
                                          },
                                          icon: Icon(
                                              Icons.skip_previous_outlined,
                                              color:
                                                  Colors.white.withOpacity(0.8),
                                              size: 40),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            if (isPlaying) {
                                              await _audioPlayer.pause();
                                            } else {
                                              await _audioPlayer.play();
                                            }
                                            setState(() {
                                              isPlaying = !isPlaying;
                                            });
                                          },
                                          icon: (isPlaying)
                                              ? Icon(
                                                  Icons.pause_outlined,
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                  size: 40,
                                                )
                                              : Icon(
                                                  Icons.play_arrow_outlined,
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                  size: 40,
                                                ),
                                        ),
                                        IconButton(
                                            onPressed: () async {
                                              if (playerDone == true) {
                                                playerDone = false;
                                                await _audioPlayer.next();
                                                playerDone = true;
                                              }
                                            },
                                            icon: Icon(
                                              Icons.skip_next_outlined,
                                              color:
                                                  Colors.white.withOpacity(0.8),
                                              size: 40,
                                            )),
                                        IconButton(
                                          icon: (favController. checkFavourite(
                                                  int.parse(playing
                                                      .audio.audio.metas.id!),
                                                  ))
                                              ? Icon(
                                                  Icons.favorite_outlined,
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                  size: 30,
                                                )
                                              : Icon(
                                                  Icons.favorite_outlined,
                                                  color: Colors.red
                                                      .withOpacity(0.8),
                                                  size: 30,
                                                ),
                                          onPressed: () {
                                            if (favController. checkFavourite(
                                                int.parse(playing
                                                    .audio.audio.metas.id!),
                                                )) {
                                             favController.addFavourites(
                                                  int.parse(playing
                                                      .audio.audio.metas.id!),
                                                  );
                                            } else if (! favController. checkFavourite(
                                                int.parse(playing
                                                    .audio.audio.metas.id!),
                                                )) {
                                              favController.removeFav(
                                                  int.parse(playing
                                                      .audio.audio.metas.id!),
                                                  context);
                                            }
                                            setState(() {
                                              favController. checkFavourite(
                                                      int.parse(playing.audio
                                                          .audio.metas.id!),
                                                      ) !=
                                                  favController. checkFavourite(
                                                      int.parse(playing.audio
                                                          .audio.metas.id!),
                                                      );
                                            });
                                          },
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                              ],
                            )
                          ]);
                        }));
                      }));
                })),
      ),
    );
  }
}
