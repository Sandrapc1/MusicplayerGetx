import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
// import 'package:on_audio_query/on_audio_query.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return SizedBox(
      height: height*0.5,
      width: width,
      child: Column(
        children: [Row(
          children: [
          
          ],
        )],
      ),


    );
  }
}