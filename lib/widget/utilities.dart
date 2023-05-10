import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';

import '../colors/colors.dart';
import '../models/dbfunctions.dart';
import '../models/playlistmodel.dart';
import '../models/songmodel.dart';
import '../screen/home.dart';
final playlistbox = PlaylistBox.getInstance();
  late List<PlayListDb> playlistsong = playlistbox.values.toList();
  

Future<dynamic> playlistBottomSheet(songindex, context, createcontroller) {
  var size = MediaQuery.of(context).size;
  var height = size.height;
  // var width = size.width;
  return showModalBottomSheet(
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
                                style: TextStyle(color: Colors.red),
                              )),
                          TextButton(
                              onPressed: () {
                                if (createcontroller.text.isEmpty ||
                                    createcontroller.text == null) {
                                  createcontroller.clear();
                                  Navigator.pop(context);
                                  const snackBar = SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text('Name is Empty'),
                                    dismissDirection: DismissDirection.down,
                                    behavior: SnackBarBehavior.floating,
                                    elevation: 30,
                                    duration: Duration(seconds: 2),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else {
                                  createplaylist(
                                      createcontroller.text, context);
                                  Navigator.pop(context);
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
            ValueListenableBuilder(
              valueListenable: playlistbox.listenable(),
              builder: (context, playlistsongs, child) {
                List<PlayListDb> playlistsongdb = playlistsongs.values.toList();
                return ListView.separated(
                  itemBuilder: (context, index) => playlists(
                      playlistsongdb[index].playlistname!,
                      playlistsongs,
                      index,
                      songindex,
                      playlistsongdb,context),
                  separatorBuilder: (context, index) => const SizedBox(
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
}

Widget playlists(String title, Box<PlayListDb> playlistsongs, index, songindex,
    playlistsongdb, context) {
      var size = MediaQuery.of(context).size;
  var height = size.height;
  // var width = size.width;
  return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          // playlist songs add

          PlayListDb? playsongs = playlistsongs.getAt(index);
          List<Songs> playsongdb = playsongs!.playlistsongs!;
          List<Songs> songdb = songsbox.values.toList();
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
