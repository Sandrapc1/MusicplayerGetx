// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player_1/colors/colors.dart';
import 'package:music_player_1/screen/account.dart';
import 'package:music_player_1/screen/home.dart';
import 'package:music_player_1/screen/playlist.dart';
import 'package:music_player_1/screen/search.dart';
import 'package:music_player_1/widget/privacy.dart';
import 'package:share_plus/share_plus.dart';

class BottamNavication extends StatefulWidget {
  const BottamNavication({super.key});

  @override
  State<BottamNavication> createState() => _BottamNavicationState();
}

class _BottamNavicationState extends State<BottamNavication> {
  int index = 0;
  var size, height, width;
  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      const Icon(Icons.home, size: 30, color: Colors.white),
      const Icon(Icons.search, size: 30, color: Colors.white),
      const Icon(Icons.library_music, size: 30, color: Colors.white),
      const Icon(Icons.person, size: 30, color: Colors.white),
    ];
    final screen = [
      const Home(),
      const SearchScreen(),
      const PlayList(),
      const Account(),
    ];
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
        extendBody: false,
        body: screen[index],
        backgroundColor: const Color(0xFF14052E),
        bottomNavigationBar: CurvedNavigationBar(
          color: const Color(0xFF27006B),
          backgroundColor: Colors.transparent,
          height: height*0.08,
          index: index,
          items: items,
          onTap: (index) => setState(() {
            this.index = index;
          }),
        ));
  }
}

 drawer(BuildContext context) {
  var height = MediaQuery.of(context).size.height;
  return Drawer(
    backgroundColor: bckcolor,
    child: Padding(
      padding: const EdgeInsets.only(
        left: 0,
      ),
      child: ListView(
        children: [
          Container(
            height: height * 0.080,
          ),
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              'Settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const Divider(
            thickness: 1,
            color: Colors.white30,
          ),
          SizedBox(
            height: height * 0.02,
          ),
          ListTile(
            onTap: ()  {
              // await Share.shareXFiles('');
             Share.share('https://play.google.com/store/apps/details?id=in.apps.beat_route');
            },
            title: const Text(
              'Shareapp',
              // style:GoogleFonts.
              style: TextStyle(fontSize: 20),
            ),
            textColor: Colors.white,
            leading: const Icon(
              Icons.share_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          SizedBox(height: height * 0.006),
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPolicy(),));
             
            },
            title: const Text(
              'Privacy policy',
              // style:GoogleFonts.
              style: TextStyle(fontSize: 20),
            ),
            textColor: Colors.white,
            leading: const Icon(
              Icons.privacy_tip_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
          SizedBox(height: height * 0.006),
          ListTile(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Column(
                      children: [
                        const Text('Beat Route V1.0',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        SizedBox(height: height * 0.01),
                        const Text(
                          'Beat Route is an advanced music player which can identify music that is playing around you.with Beat Route you will get unique sssmusic identification and playing experience.',
                       style: TextStyle(fontSize: 15),
                        )
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK')),
                    ],
                  );
                },
              );
            },
            title: const Text(
              'About us',
              // style:GoogleFonts.
              style: TextStyle(fontSize: 20),
            ),
            textColor: Colors.white,
            leading: const Icon(
              Icons.info,
              color: Colors.white,
              size: 30,
            ),
          ),
          SizedBox(height: height * 0.006),
          ListTile(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Are you sure you want to exit?',
                    style: TextStyle(fontSize: 15),),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel')),
                      TextButton(
                          onPressed: () {
                            SystemNavigator.pop();
                          },
                          child: const Text(
                            'Exit',
                            style: TextStyle(color: Colors.red),
                          ))
                    ],
                  );
                },
              );
            },
            title: const Text(
              'Exit',
              // style:GoogleFonts.
              style: TextStyle(fontSize: 20),
            ),
            textColor: Colors.white,
            leading: const Icon(
              Icons.logout,
              color: Colors.white,
              size: 30,
            ),
          ),
          SizedBox(height: height * 0.25),
          const Padding(
            padding: EdgeInsets.only(
              left: 120,
            ),
            child: Text(
              'Version  1.0',
              style: TextStyle(color: Colors.white54),
            ),
          ),
        ],
      ),
    ),
  );
}
