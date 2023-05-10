import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_player_1/colors/colors.dart';
import 'package:music_player_1/models/dbfunctions.dart';
import 'package:music_player_1/models/favouritesmodel.dart';
import 'package:music_player_1/models/playlistmodel.dart';
import 'package:music_player_1/models/songmodel.dart';
import 'package:music_player_1/screen/home.dart';
import 'package:music_player_1/screen/miniplayer.dart';
import 'package:music_player_1/screen/playscreen.dart';
// import 'package:music_player_1/screen/splashscreen.dart';
import 'package:music_player_1/widget/bottam.dart';
import 'package:on_audio_query/on_audio_query.dart';

bool _isPlaying = false;

class FavoutitsPage extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const FavoutitsPage({Key? key});

  @override
  State<FavoutitsPage> createState() => _FavoutitsPageState();
}

final Songbox = SongBox.getInstance();
// final _audioPlayer = AssetsAudioPlayer.withId('0');

class _FavoutitsPageState extends State<FavoutitsPage> {
  late double height, width;
  final List<Favourites> favourite = [];
  final favbox = Favouritesbox.getInstance();
  late List<Favourites> fav = favbox.values.toList();
  List<Audio> favconveraudio = [];
  bool favorites = true;
  final playlistbox = PlaylistBox.getInstance();

  late List<PlayListDb> playlistsong = playlistbox.values.toList();
  final TextEditingController createcontroller = TextEditingController();

  @override
  void initState() {
    final List<Favourites> favallsongs =
        favbox.values.toList().reversed.toList();
    for (var element in favallsongs) {
      favconveraudio.add(Audio.file(element.songurl.toString(),
          metas: Metas(
            title: element.songname,
            artist: element.artist,
            id: element.id.toString(),
          )));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  if(_isPlaying){
    //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //     showBottomSheet(
    //       backgroundColor:bgcolor,
    //       context: context, builder: (context) => const MiniPlayer(),);
    //   });
    // }
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
                          setState(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlayScreen(),
                                ));
                            _isPlaying = !_isPlaying;
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
                    valueListenable: favbox.listenable(),
                    builder: (context, fav, child) {
                      List<Favourites> favourite1 =
                          fav.values.toList().reversed.toList();
                      return favourite1.isNotEmpty
                          ? ListView.separated(
                              padding: EdgeInsets.only(bottom: width * .3),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) => songList(
                                  favourite1[index].id!,
                                  favourite1[index].songname!,
                                  favourite1[index].artist!,
                                  index),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 10),
                              itemCount: favourite1.length)
                          : SizedBox(
                              height: height / 1.6,
                              child: const Center(
                                child: Text(
                                  'No songs found',
                                  style: TextStyle(color: bkclr),
                                ),
                              ),
                            );
                    }),
              ],
            ),
          ),
        ),
        bottomSheet: Container(color: bgcolor, child: const MiniPlayer()),
      ),
    );
  }

  Widget songList(id, title, artist, index) {
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
              border: Border.all(width: 3, color: mostfill
                  //  const Color.fromARGB(255, 155, 151, 152),
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
                deletefav(index);

                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const FavoutitsPage(),
                    ));
                const snackBar = SnackBar(
                  backgroundColor: delete,
                  content: Text('Removed From Favourite'),
                  dismissDirection: DismissDirection.down,
                  behavior: SnackBarBehavior.floating,
                  elevation: 20,
                  duration: Duration(seconds: 1),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                                    index,
                                    index,
                                    playlistsongdb),
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
      songindex, playlistsongdb) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            PlayListDb? playsongs = playlistsongs.getAt(index);
            List<Songs> playsongdb = playsongs!.playlistsongs!;
            List<Favourites> songdb = favbox.values.toList();
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
            Navigator.pop(context);
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
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
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
}
