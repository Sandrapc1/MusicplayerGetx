import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_1/colors/colors.dart';
import 'package:music_player_1/screen/miniplayer.dart';
import 'package:music_player_1/widget/bottam.dart';
import 'package:music_player_1/screen/favlist.dart';
import 'package:music_player_1/screen/mostplayed.dart';
import 'package:music_player_1/screen/playlist.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  late Size size;
  late double height, width;
  final TextEditingController _nameController = TextEditingController();
   String userName = 'User';
  // String username = '';

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: bkclr),
        backgroundColor: bgcolor,
        title: Text(
          'Account',
          style: GoogleFonts.lato(color: bkclr, fontSize: 30),
        ),
      ),
      endDrawer: drawer(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Hey, $userName',
                    style: GoogleFonts.sora(
                        color: bkclr, fontWeight: FontWeight.bold, fontSize: 27),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Edit name',style:TextStyle(fontSize: 20,)),
                            content: TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                  hintText: 'Enter your name',
                                   hintStyle: TextStyle(fontSize: 15)

                                  ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel')),
                                  TextButton(
                                  onPressed: () {
                                    setState(() {
                                      userName = _nameController.text;
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(color: Colors.green),
                                  )),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: strokecolor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        color: bkclr,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.05),
              Container(
                height: height * 0.25,
                width: height * 0.42,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                        image: AssetImage('assets/images/music2.jpeg'),
                        fit: BoxFit.cover)),
              ),
              SizedBox(height: height * 0.05),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PlayList()));
                },
                child: Row(
                  children: [
                    Container(
                      height: height * 0.08,
                      width: height * 0.10,
                      decoration: const BoxDecoration(),
                      child: const CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            AssetImage('assets/images/accountimg.jpg'),
                      ),
                    ),
                    SizedBox(width: height * 0.02),
                    const Text(
                      'PlayList',
                      style: TextStyle(color: bkclr, fontSize: 20),
                    )
                  ],
                ),
              ),
              SizedBox(height: height * 0.05),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FavoutitsPage()));
                },
                child: Row(
                  children: [
                    Container(
                      height: height * 0.08,
                      width: height * 0.10,
                      decoration: const BoxDecoration(),
                      child: const CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            AssetImage('assets/images/accountimg.jpg'),
                      ),
                    ),
                    SizedBox(width: height * 0.02),
                    const Text(
                      'Favorites',
                      style: TextStyle(color: bkclr, fontSize: 20),
                    )
                  ],
                ),
              ),
              SizedBox(height: height * 0.05),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MiniPlayer()));
                },
                child: Row(
                  children: [
                    Container(
                      height: height * 0.08,
                      width: height * 0.10,
                      decoration: const BoxDecoration(),
                      child: const CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            AssetImage('assets/images/accountimg.jpg'),
                      ),
                    ),
                    SizedBox(width: height * 0.02),
                    const Text(
                      'Most Played',
                      style: TextStyle(color: bkclr, fontSize: 20),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
