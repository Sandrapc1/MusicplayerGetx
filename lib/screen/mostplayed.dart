// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_1/colors/colors.dart';

// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

class MostPlayed extends StatefulWidget {
  const MostPlayed({super.key});

  @override
  State<MostPlayed> createState() => _MostPlayedState();
}

class _MostPlayedState extends State<MostPlayed> {
  var size, height, width;
    bool favorites=false;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
  

  
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
           leading: IconButton(onPressed: () {
            Navigator.pop(context);
          }, icon: const Icon(Icons.arrow_back,color: bkclr,
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
              ]
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
                        onPressed: () {},
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white.withOpacity(0.8),
                          size: 45,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  // height: height /1.6,
                  child: ListView.separated(
                    physics:const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => songList(),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemCount: 10),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
    Widget songList() {
    return Padding(
      padding: EdgeInsets.only(left: height * 0.01, right: height * 0.01),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: fillcolor,
            border: Border.all(
              width: 2,
              color:mostfill
              //  const Color.fromARGB(255, 155, 151, 152),
            )),
        height: height * 0.09,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(5),
              child: CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage('assets/images/most1.jpg'),
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
                  Text('Let Me Down Slowly',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 15,
                      )),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Alec Benjamin',
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
              icon: (favorites)
                  ? Icon(
                      Icons.favorite,
                      color: Colors.red.withOpacity(0.8),
                    )
                  : Icon(
                      Icons.favorite,
                      color: Colors.white.withOpacity(0.8),
                    ),
              onPressed: () {
                setState(() {
                  favorites = !favorites;
                });
              },
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
                      height: height*0.15,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: height * 0.01),
                            const Text(
                              ' Enter playlist name',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            SizedBox(height: height*0.02),
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
    );
  }
}
