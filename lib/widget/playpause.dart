import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
import 'package:music_player_1/screen/home.dart';

class PlayPause extends StatefulWidget {
  const PlayPause({super.key});

  @override
  State<PlayPause> createState() => _PlayPauseState();
}

class _PlayPauseState extends State<PlayPause> {
  @override
  Widget build(BuildContext context) {
    return PlayerBuilder.isPlaying(
                      player: audioPlayer,
                      builder: (context, isPlaying) {
                        return IconButton(
                          onPressed: () async {
                            await audioPlayer.playOrPause();
                            setState(() {
                              isPlaying = !isPlaying;
                            });
                          },
                          icon: (isPlaying)
                              ? Icon(
                                  Icons.pause_circle_outlined,
                                  color: Colors.white.withOpacity(0.8),
                                  size: 35,
                                )
                              : Icon(
                                  Icons.play_circle_outline,
                                  color: Colors.white.withOpacity(0.8),
                                  size: 35,
                                ),
                        );
                      },
                    );
  }
}