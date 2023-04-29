// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_player_1/colors/colors.dart';
import 'package:music_player_1/models/dbfunctions.dart';
import 'package:music_player_1/models/playlistmodel.dart';
import 'package:music_player_1/screen/popsong.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../widget/bottam.dart';

class PlayList extends StatefulWidget {
  const PlayList({super.key});

  @override
  State<PlayList> createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  var size, height, width;
  final playlistbox = PlaylistBox.getInstance();
  final List<PlaylistModel> playlistsongs = [];
  late List<PlayListDb> playlistsong = playlistbox.values.toList();
  final TextEditingController textcontroller = TextEditingController();
  final TextEditingController editcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: favfill,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Create PlayList'),
                  content: TextField(
                    controller: textcontroller,
                    onChanged: (value) {},
                    decoration:
                        const InputDecoration(hintText: 'Enter Folder Name'),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel',
                            style: TextStyle(color: Colors.red))),
                    TextButton(
                        onPressed: () {
                          if (textcontroller.text.isEmpty||
                          textcontroller.text==null) {
                          Navigator.pop(context);
                         const snackBar =SnackBar(content: Text('Name is Empty'),
                           dismissDirection: DismissDirection.down,
                           behavior: SnackBarBehavior.floating,
                           elevation: 30,
                           duration: Duration(seconds: 2),
                           );
                           ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }else{
                            createplaylist(textcontroller.text, context);
                            textcontroller.clear();
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
          child: const Icon(
            Icons.add,
            color: bkclr,
            size: 45,
          ),
        ),
        backgroundColor: bgcolor,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: bkclr),
          backgroundColor: bgcolor,
          title: Text('PlayLists',
              style: GoogleFonts.lato(color: bkclr, fontSize: 30)),
        ),
        endDrawer: drawer(context),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: height * 0.35, bottom: height * 0.08),
                ),
                ValueListenableBuilder(
                  valueListenable: playlistbox.listenable(),
                  builder: (context, playlistsongs, child) {
                    List<PlayListDb> playlistsongdb =
                        playlistsongs.values.toList();
                    return ListView.separated(
                        // padding: EdgeInsets.only(bottom: height*0.07),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Padding(
                              padding: EdgeInsets.only(
                                  left: height * 0.04,
                                  right: height * 0.04,
                                  top: height * 0.02),
                              child: addPlaylist(
                                  playlistsongdb[index].playlistname, index),
                            ),
                        separatorBuilder: (context, index) {
                          return const SizedBox();
                        },
                        itemCount: playlistsongdb.length);
                  },
                )
              ]),
        ));
  }

  Widget addPlaylist(String? title, index) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PopSongs(songindex:index , playlistname: title),
              ),
            );
          },
          child: Container(
            height: height * 0.25,
            width: height * 0.40,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              image: DecorationImage(
                image: AssetImage('assets/images/playlist3.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: BlurryContainer(
            blur: 10,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            padding: const EdgeInsets.all(0),
            height: height * 0.06,
            width: height * 0.40,
            child: Column(
              children: [
                Text(
                  title!,
                  style: GoogleFonts.lato(
                    color: bkclr,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            PopupMenuButton(
              color: bkclr,
              iconSize: 30,
              onSelected: (value) {
                if (value == 1) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      elevation: 0,
                      title: const Text(
                        ' Rename',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      content: TextField(
                        controller: editcontroller,
                        onChanged: (value) {},
                        decoration: const InputDecoration(
                            hintText: 'Enter new playlist name'),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: delete),
                            )),
                        TextButton(
                            onPressed: () {
                              if ((editcontroller.text.isEmpty||
                              editcontroller.text==null)) {
                                Navigator.pop(context);
                                editcontroller.clear();

                              }else{
                               editeplaylist(index, editcontroller.text);
                               Navigator.pop(context);
                               editcontroller.clear();

                              }

                              
                            },
                            child: const Text(
                              'Save',
                              style: TextStyle(color: Colors.green),
                            ))
                      ],
                    ),
                  );
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 1,
                  child: Text('Edit'),
                ),
                PopupMenuItem(
                  value: 2,
                  child: TextButton(
                    onPressed: () {
                      deleteplaylist(index);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Remove',
                      style: TextStyle(
                        color: delete,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
