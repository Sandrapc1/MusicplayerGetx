// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_player_1/colors/colors.dart';
import 'package:music_player_1/models/mostplayedmodel.dart';
import 'package:music_player_1/screen/home.dart';
import 'package:music_player_1/screen/miniplayer.dart';
import 'package:music_player_1/screen/playscreen.dart';
import 'package:music_player_1/widget/switch.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../widget/utilities.dart';

bool _isPlaying=false;
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

class MostPlayed extends StatefulWidget {
  const MostPlayed({super.key});

  @override
  State<MostPlayed> createState() => _MostPlayedState();
}

class _MostPlayedState extends State<MostPlayed> {
  final box = MostlyPlayedBox.getInstance();
  List<Audio> mostconvertedaudio = [];
  var size, height, width;
  bool favorites = false;

  @override
  void initState() {
    List<MostlyPlayedSongs> mostsong = box.values.toList();
    int count = 0;
    mostsong.sort((a, b) => b.count!.compareTo(a.count!));
    for (var element in mostsong) {
      if (element.count! > 2) {
        mostplayedsongs.insert(count, element);
        count++;
      }
    }
    for (var element in mostplayedsongs) {
      mostconvertedaudio.add(Audio.file(
      element.songurl!,
      metas: Metas(
        title: element.songname,
        artist: element.artist,
        id: element.id.toString(),
      )
      ));
      
    }

    super.initState();
  }
  List<MostlyPlayedSongs>mostplayedsongs=[];

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

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
                          audioPlayer.open(Playlist(audios: mostconvertedaudio,startIndex: 0),
                          showNotification: true,
                          );
                        audioPlayer.play();
                        setState(() {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PlayScreen(),));
                          _isPlaying=!_isPlaying;
                        });
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
                
                  // height: height /1.6,
                   ValueListenableBuilder(
                    valueListenable: box.listenable(),
                    builder: (context, value, child) {
                      return mostplayedsongs.isNotEmpty
                      ?ListView.separated(
                        padding:EdgeInsets.only(bottom: width * .3),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => songList(mostplayedsongs[index].id,
                        index,
                        mostplayedsongs[index].songname,
                        mostplayedsongs[index].artist),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemCount: mostplayedsongs.length<10?mostplayedsongs.length:10,
                        ):SizedBox(
                          height: height*0.3,
                          child: const Center(child: Text('No songs found',style: TextStyle(color: bkclr),)),
                        );
                    },
                  ),
                
              ],
            ),
          ),
        ),
        bottomSheet: Container(
          color: bgcolor,
          child: const MiniPlayer()),
      ),
    );
  }

  Widget songList(id,index,title,artist) {
    return Padding(
      padding: EdgeInsets.only(left: height * 0.01, right: height * 0.01),
      child: InkWell(
        onTap: () {
          audioPlayer.open(Playlist(
            audios: mostconvertedaudio,
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
                  id:mostplayedsongs[index].id!,
                   type: ArtworkType.AUDIO,
                   nullArtworkWidget: const CircleAvatar(backgroundImage:AssetImage('assets/images/null.jpg'),
                    radius: 24,),)
              ),
              SizedBox(
                width: height * 0.01,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                    overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 15,
                      )),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      artist,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: height * 0.02),
             SwitchCase(id: id),
              PopupMenuButton(
                color: bkclr,
                onSelected: (value) {
                 playlistBottomSheet(index, context, createcontroller);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 1,
                    child: Text('Add Playlist'),
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
