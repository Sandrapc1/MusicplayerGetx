import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_player_1/colors/colors.dart';
import 'package:music_player_1/controller/favourite_controller.dart';
import 'package:music_player_1/models/dbfunctions.dart';
import 'package:music_player_1/models/favouritesmodel.dart';
import 'package:music_player_1/models/playlistmodel.dart';
import 'package:music_player_1/models/songmodel.dart';
import 'package:music_player_1/screen/home.dart';
import 'package:music_player_1/screen/miniplayer.dart';
import 'package:music_player_1/screen/playscreen.dart';
import 'package:music_player_1/widget/bottam.dart';
import 'package:on_audio_query/on_audio_query.dart';

// ignore: unused_element
bool _isPlaying = false;
final FavoriteController favController = Get.put(FavoriteController());
List<Audio> favconveraudio = [];


// ignore: must_be_immutable
class FavoutitsPage extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  FavoutitsPage({Key? key});

  late double height, width;
  final List<Favourites> favourite = [];
  bool favorites = true;
  final playlistbox = PlaylistBox.getInstance();
  late List<PlayListDb> playlistsong = playlistbox.values.toList();
  final TextEditingController createcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BottamNavication(),
                    ),
                    (route) => false);
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
              ],
            ),
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
                            image: AssetImage('assets/images/favlist.jpg'),
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
                                'My Favorites',
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
                            Playlist(audios: favconveraudio, startIndex: 0),
                            showNotification: true,
                          );
                          audioPlayer.play();
                          Get.to(
                            PlayScreen(),
                          );
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
                    favController.favgetx.isNotEmpty
                        ? ListView.separated(
                            padding: EdgeInsets.only(bottom: width * .3),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => songList(
                                favController.favgetx[index].id!,
                                favController.favgetx[index].songname!,
                                favController.favgetx[index].artist!,
                                index,
                                context),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            itemCount: favController.favgetx.length)
                        : SizedBox(
                            height: height / 1.6,
                            child: const Center(
                              child: Text(
                                'No songs found',
                                style: TextStyle(color: bkclr),
                              ),
                            ),
                          )),
              ],
            ),
          ),
        ),
        bottomSheet: Container(color: bgcolor, child: const MiniPlayer()),
      ),
    );
  }

  Widget songList(id, title, artist, index, context) {
    return Padding(
      padding: EdgeInsets.only(left: height * 0.01, right: height * 0.01),
      child: InkWell(
        onTap: () {
          audioPlayer.open(Playlist(audios: favconveraudio, startIndex: index),
              showNotification: true,
              headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
              loopMode: LoopMode.playlist);
          showBottomSheet(
            backgroundColor: bgcolor,
            context: context,
            builder: (context) => const MiniPlayer(),
          );
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: fillcolor,
              border: Border.all(width: 3, color: mostfill,
                  )),
          height: height * 0.09,
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(
                padding: const EdgeInsets.all(5),
                child: QueryArtworkWidget(
                    id: id,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/null.jpg'),
                      radius: 24,
                    ))),
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
            IconButton(
              icon: Icon(
                Icons.favorite,
                color: Colors.red.withOpacity(0.8),
              ),
              onPressed: () {
                // removed context
                favController.deletefav(index);

                Navigator.pushReplacement(
                    context as BuildContext,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          FavoutitsPage(),
                    ));
                const snackBar = SnackBar(
                  backgroundColor: delete,
                  content: Text('Removed From Favourite'),
                  dismissDirection: DismissDirection.down,
                  behavior: SnackBarBehavior.floating,
                  elevation: 20,
                  duration: Duration(seconds: 1),
                );
                ScaffoldMessenger.of(context)
                    .showSnackBar(snackBar);
              },
            ),
            // SizedBox(width: height * 0.03),
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
                                                  // ignore: unnecessary_null_comparison
                                                  createcontroller.text ==
                                                      null) {
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
                        
                          ValueListenableBuilder(
                            valueListenable: playlistbox.listenable(),
                            builder: (context, playlistsongs, child) {
                              List<PlayListDb> playlistsongdb =
                                  playlistsongs.values.toList();
                              return ListView.separated(
                                itemBuilder: (context, index) => playlists(
                                    playlistsongdb[index].playlistname!,
                                    playlistsongs,
                                    index,
                                    index,
                                    playlistsongdb,
                                    context),
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

  Widget playlists(String title, Box<PlayListDb> playlistsongs, index,
      songindex, playlistsongdb, context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            PlayListDb? playsongs = playlistsongs.getAt(index);
            List<Songs> playsongdb = playsongs!.playlistsongs!;
            List<Favourites> songdb = favController.favbox.values.toList();
            bool isThere =
                playsongdb.any((element) => element.id == songdb[songindex].id);
            if (!isThere) {
              playsongdb.add(Songs(
                  songname: songdb[songindex].songname,
                  artist: songdb[songindex].artist,
                  duration: songdb[songindex].duration,
                  songurl: songdb[songindex].songurl,
                  id: songdb[songindex].id));
            }
            playlistsongs.putAt(
                index,
                PlayListDb(
                    playlistname: playlistsongdb[index].playlistname,
                    playlistsongs: playsongdb));
            Navigator.pop(context as BuildContext);
            const snackbar = SnackBar(
              backgroundColor: bkclr,
              content: Text(
                'Song Added',
                style: TextStyle(color: Colors.black),
              ),
              dismissDirection: DismissDirection.down,
              behavior: SnackBarBehavior.floating,
              elevation: 30,
              duration: Duration(seconds: 1),
            );
            ScaffoldMessenger.of(context as BuildContext)
                .showSnackBar(snackbar);
          },
          child: Row(
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
        ));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('height', height));
    properties.add(DoubleProperty('width', width));
  }
}

// ignore: non_constant_identifier_names
final Songbox = SongBox.getInstance();



