// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_1/colors/colors.dart';
import 'package:music_player_1/models/songmodel.dart';
import 'package:music_player_1/screen/home.dart';
import 'package:music_player_1/screen/playscreen.dart';
import 'package:music_player_1/screen/splashscreen.dart';
import 'package:music_player_1/widget/bottam.dart';
import 'package:on_audio_query/on_audio_query.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var size, height, width;
  var controller = TextEditingController();
  late List<Songs> dbSongs;
  List<Audio> allSongs = [];
  late List<Songs> another = List.from(dbSongs);

  @override
  void initState() {
    super.initState();
    dbSongs = box.values.toList();
    for (var item in dbSongs) {
      allSongs.add(Audio.file(item.songurl!,
          metas: Metas(
              title: item.songname,
              artist: item.artist,
              id: item.id.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return serachList();
  }

  serachList() {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: bkclr),
        backgroundColor: bgcolor,
        title:
            Text('Search', style: GoogleFonts.lato(color: bkclr, fontSize: 30)),
      ),
      endDrawer: drawer(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                height: height * 0.06,
                width: height * 0.37,
                decoration: BoxDecoration(
                  color: searchbox,
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: TextField(
                        onChanged: (value) => updateList(value),
                        controller: controller,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.search,
                              color: textclr,
                            ),
                            hintText: 'Search for a song',
                            hintStyle: const TextStyle(
                              color: textclr,
                              fontSize: 17,
                            ),
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                                onPressed: controller.clear,
                                icon: const Icon(Icons.clear))),
                      ),
                    ),
                  ],
                ),
              ),
               SizedBox(height: height*0.20),
              (another.isEmpty)?const Center(
              child: Text('Song not found',style: TextStyle(color: bkclr),),
              ):SizedBox(
                height: height / 1.38,
                child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => songList(
                        another[index].songname!,
                        another[index].artist!,
                        another[index].id,
                        index),
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                    itemCount: another.length),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget songList(String title, String artist, id, index) {
    return Padding(
      padding: EdgeInsets.all(width * 0.008),
      child: InkWell(
        onTap: () {
          PlayScreen.playscreenindex.value = index;
          audioPlayer.open(
            Playlist(audios: allSongs, startIndex: index),
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
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: fillcolor,
              border: Border.all(
                width: 3,
                color: strokecolor,
              )),
          height: height * 0.09,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: QueryArtworkWidget(
                  type: ArtworkType.AUDIO,
                  id: id,
                  nullArtworkWidget: const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/circular.jpg'),
                    radius: 24,
                  ),
                ),
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
              PopupMenuButton(
                color: bkclr,
                onSelected: (value) {
                  showModalBottomSheet(
                    elevation: 0,
                    isDismissible: true,
                    context: context,
                    builder: (context) {
                      return SizedBox(
                        height: height * 0.15,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: height * 0.01),
                              const Text(
                                ' Enter playlist name',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              SizedBox(height: height * 0.02),
                              ElevatedButton(
                                  onPressed: () {},
                                  child: const Text('Create Playlist'))
                            ],
                          ),
                        ),
                      );
                    },
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
            ],
          ),
        ),
      ),
    );
  }

  void updateList(String value) {
    setState(() {
      another = dbSongs
          .where((element) =>
              element.songname!.toLowerCase().contains(value.toLowerCase()))
          .toList();
      allSongs.clear();
      for (var item in another) {
        allSongs.clear();
        for (var item in another) {
          allSongs.add(Audio.file(item.songurl.toString(),
              metas: Metas(
                artist: item.artist,
                title: item.songname,
                id: item.id.toString(),
              )));
        }
      }
    });
  }
}
