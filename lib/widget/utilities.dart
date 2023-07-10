import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../colors/colors.dart';
import '../models/dbfunctions.dart';
import '../models/playlistmodel.dart';
import '../models/songmodel.dart';

final playlistbox = PlaylistBox.getInstance();
final songsbox = SongBox.getInstance();

class PlayListBottomSheet extends StatelessWidget {
  final int songindex;
  const PlayListBottomSheet({super.key, required this.songindex});

  @override
  Widget build(BuildContext context) {
    List<PlayListDb> allPlaylists = playlistbox.values.toList();
    final textController = TextEditingController();
    var size = MediaQuery.of(context).size;
    var height = size.height;
    return TextButton(
      onPressed: () {
        log('///////////////////////////////////');
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
                                controller: textController,
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
                                      style: TextStyle(color: Colors.red),
                                    )),
                                TextButton(
                                    onPressed: () {
                                      if (textController.text.isEmpty ||
                                          // ignore: unnecessary_null_comparison
                                          textController.text == null) {
                                        textController.clear();
                                        Get.back();
                                        // Navigator.pop(context);
                                        const snackBar = SnackBar(
                                          backgroundColor: Colors.green,
                                          content: Text('Name is Empty'),
                                          dismissDirection:
                                              DismissDirection.down,
                                          behavior: SnackBarBehavior.floating,
                                          elevation: 30,
                                          duration: Duration(seconds: 2),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      } else {
                                        createplaylist(
                                            textController.text, context);
                                        // Navigator.pop(context);
                                        Get.back();
                                      }
                                    },
                                    child: const Text(
                                      'Create',
                                      style: TextStyle(color: Colors.green),
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
                  ListView.separated(
                    itemBuilder: (context, index) => PlayListSongTile(
                      songindex: songindex,
                      index: index,
                      currentPlayList: allPlaylists[index],
                    ),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                    itemCount: allPlaylists.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  )
                  
                ],
              ),
            ),
          ),
        );
      },
      child: const Text('add to playlist'),
    );
  }
}



class PlayListSongTile extends StatelessWidget {
  final int songindex;
  final int index;
  final PlayListDb currentPlayList;
  const PlayListSongTile(
      {super.key,
      required this.songindex,
      required this.index,
      required this.currentPlayList});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    return ListTile(
      onTap: () {
        // playlist songs add

        // PlayListDb? playsongs = playlistsongs.getAt(index);
        List<Songs> playlistsongs = currentPlayList.playlistsongs!;
        List<Songs> songdb = songsbox.values.toList();
        bool isThere =
            playlistsongs.any((element) => element.id == songdb[songindex].id);
        if (!isThere) {
          playlistsongs.add(Songs(
              songname: songdb[songindex].songname,
              artist: songdb[songindex].artist,
              duration: songdb[songindex].duration,
              songurl: songdb[songindex].songurl,
              id: songdb[songindex].id));
        }
        playlistbox.putAt(
            index,
            PlayListDb(
                playlistname: currentPlayList.playlistname,
                playlistsongs: playlistsongs));
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
      leading: Container(
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
      title: Text(currentPlayList.playlistname!),
    );
  }
}


