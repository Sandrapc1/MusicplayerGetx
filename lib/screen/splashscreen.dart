// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_1/colors/colors.dart';
import 'package:music_player_1/models/songmodel.dart';
import 'package:music_player_1/widget/bottam.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

final audioquery = OnAudioQuery();
final box = SongBox.getInstance();

List<SongModel> fetchSongs = [];
List<SongModel> allSongs = [];

class _SplashScreenState extends State<SplashScreen> {
  var size, height, width;
  @override
  void initState() {
    requeststoragePermission();
    super.initState();
  }

  requeststoragePermission() async {
    bool permissionStatus = await audioquery.permissionsStatus();
    if (!permissionStatus) {
      await audioquery.permissionsRequest();

      fetchSongs = await audioquery.querySongs();
      for (var element in fetchSongs) {
        if (element.fileExtension == "mp3") {
          allSongs.add(element);
        }
      }
      for (var element in allSongs) {
        await box.add(
          Songs(
              songname: element.title,
              artist: element.artist,
              duration: element.duration,
              songurl: element.uri,
              id: element.id),
        );
      }
    }
    await Future.delayed(const Duration(seconds: 4));

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const BottamNavication(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      backgroundColor: bgcolor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: height * 0.200,
              width: width * 0.50,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/splashscreen.png')),
                // color:  Color(0xFF14052E),
              ),
            ),
          ),
          // SizedBox(height: 2,),
          Text(
            'Beat Route',
            style: GoogleFonts.aboreto(
              fontSize: 35,
              fontWeight: FontWeight.w900,
              color: backcolor,
            ),
          ),
        ],
      ),
    );
  }
}
