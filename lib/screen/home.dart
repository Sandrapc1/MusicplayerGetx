// ignore_for_file: sized_box_for_whitespace, prefer_typing_uninitialized_variables

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_player_1/colors/colors.dart';
import 'package:music_player_1/models/playlistmodel.dart';
import 'package:music_player_1/models/songmodel.dart';
import 'package:music_player_1/widget/bottam.dart';
import 'package:music_player_1/screen/favlist.dart';
import 'package:music_player_1/screen/mostplayed.dart';
import 'package:music_player_1/screen/playscreen.dart';
import 'package:music_player_1/screen/recently.dart';
import 'package:music_player_1/widget/switch.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../models/dbfunctions.dart';
// import 'bottam.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

final songsbox = SongBox.getInstance();
final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');

class _HomeState extends State<Home> {
  var size, height, width;
  final playlistbox = PlaylistBox.getInstance();
  late List<PlayListDb> playlistsong = playlistbox.values.toList();
  final TextEditingController addcontroller = TextEditingController();
  final TextEditingController createcontroller = TextEditingController();


  List<Audio> allsongs = [];
  @override
  void initState() {
    List<Songs> allDbsongs = songsbox.values.toList();
    for (var element in allDbsongs) {
      allsongs.add(
        Audio.file(
          element.songurl!,
          metas: Metas(
            artist: element.artist,
            title: element.songname,
            id: element.id.toString(),
          ),
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FavoutitsPage(),
                              ));
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MostPlayed(),
                              ));
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RecentlyPlayed(),
                              ));
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
                child: ValueListenableBuilder<Box<Songs>>(
                    valueListenable: SongBox.getInstance().listenable(),
                    builder: (context, Box<Songs> allsongbox, child) {
                      List<Songs> allDbsongs = allsongbox.values.toList();
                      return ListView.separated(
                          itemBuilder: (context, songindex) {
                            return musicList(
                                allDbsongs[songindex].songname!,
                                allDbsongs[songindex].artist!,
                                allDbsongs[songindex].id,
                                songindex);
                          },
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 13,
                            );
                          },
                          itemCount: allDbsongs.length);
                    }),
              ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  musicList(String title, String artist, id, songindex) {
    return Padding(
      padding: EdgeInsets.all(width * 0.008),
      child: InkWell(
        onTap: () {
          PlayScreen.playscreenindex.value = songindex;
          audioPlayer.open(
            Playlist(audios: allsongs, startIndex: songindex),
            headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
            showNotification: true,
          );
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlayScreen(),
              ));
        },
        child: Container(
          // width: 30,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: fillcolor,
              border: Border.all(
                width: 3,
                color: strokecolor,
              )),
          height: height * 0.09,
          child: Row(mainAxisAlignment: MainAxisAlignment.start,
           children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: QueryArtworkWidget(
                  id: id,
                  nullArtworkWidget: const CircleAvatar(
                      backgroundImage: AssetImage(
                        'assets/images/headphone.jpg',
                      ),
                      radius: 24),
                  type: ArtworkType.AUDIO),
            ),
            SizedBox(
              width: height * 0.01,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    artist,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            // SizedBox(width: height * 0.01),
            SwitchCase(id: id),
           
            // SizedBox(width: height * 0.01),
            PopupMenuButton(
              color: bkclr,
              onSelected: (value) {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.white70,
                  builder: (context) => SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: TextField(
                                        controller: createcontroller,
                                        onChanged: (value) {},
                                        decoration: const InputDecoration(
                                            hintText: 'Enter Folder Name'),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )),
                                        TextButton(
                                            onPressed: () {
                                              if (createcontroller
                                                      .text.isEmpty ||
                                                  createcontroller.text ==null) {
                                                createcontroller.clear();
                                                Navigator.pop(context);
                                                const snackBar = SnackBar(
                                                  backgroundColor: Colors.green,
                                                  content:
                                                      Text('Name is Empty'),
                                                  dismissDirection:
                                                      DismissDirection.down,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  elevation: 30,
                                                  duration:
                                                      Duration(seconds: 2),
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              } else {
                                                createplaylist(
                                                    createcontroller.text,
                                                    context);
                                                  Navigator.pop(context);
                                              }
                                            },
                                            child: const Text(
                                              'Create',
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ))
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Your PlayList',
                                    style: GoogleFonts.lato(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  SizedBox(width: height * 0.11),
                                  const Icon(
                                    Icons.add,
                                    size: 35,
                                  ),
                                ],
                              )),
                          //  SizedBox(height: height*0.02,),
                          ValueListenableBuilder(
                            valueListenable: playlistbox.listenable(),
                            builder: (context, playlistsongs, child) {
                              List<PlayListDb> playlistsongdb =
                                  playlistsongs.values.toList();
                              return ListView.separated(
                                itemBuilder: (context, index) => playlists(
                                    playlistsongdb[index].playlistname!,
                                    playlistsongs,
                                    index,songindex,playlistsongdb),
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  height: 10,
                                ),
                                itemCount: playlistsongdb.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 1,
                  child: Text('Add Playlist'),
                ),
              ],
            ),
            SizedBox(width: height * 0.03),
          ]),
        ),
      ),
    );
  }

  Widget playlists(String title, Box<PlayListDb> playlistsongs, index,songindex,playlistsongdb) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
           onTap: () {
            // playlist songs add
            
              PlayListDb? playsongs = playlistsongs.getAt(index);
              List<Songs>playsongdb=playsongs!.playlistsongs!;
              List<Songs>songdb=songsbox.values.toList();
              bool isThere=playsongdb.any((element) => element.id==songdb[songindex].id);
              if (!isThere) {
                playsongdb.add(
                  Songs(
                    songname: songdb[songindex].songname,
                     artist: songdb[songindex].artist, 
                     duration: songdb[songindex].duration, 
                     songurl:songdb[songindex].songurl, 
                     id: songdb[songindex].id)
                     );
              }
              playlistsongs.putAt(index, PlayListDb(
                playlistname: playlistsongdb[index].playlistname,
                 playlistsongs: playsongdb)
                 );
                 Navigator.pop(context);
                 const snackbar=SnackBar(
                  backgroundColor: bkclr,
                  content: Text('Song Added',style: TextStyle(color: Colors.black),),
                  dismissDirection: DismissDirection.down,
                  behavior: SnackBarBehavior.floating,
                  elevation: 30,
                  duration: Duration(seconds: 1),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
            },
     child:  Row(
        children: [
         
         
             Container(
              height: height * 0.07,
              width: height * 0.08,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/spotify.jpg'),
                  fit: BoxFit.cover,
                ),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          
          SizedBox(width: height * 0.04),
          Text(title)
        ],
      ),
      )
    );
  }
}
