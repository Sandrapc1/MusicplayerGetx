import 'package:flutter/material.dart';
import 'package:music_player_1/colors/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class TranceAddction extends StatefulWidget {
  const TranceAddction({super.key});

  @override
  State<TranceAddction> createState() => _TranceAddctionState();
}

class _TranceAddctionState extends State<TranceAddction> {
  
   bool favorites=false;
  @override
  Widget build(BuildContext context) {
  var size = MediaQuery.of(context).size;
   var height = size.height;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        // backgroundColor: bgcolor,
        appBar: AppBar(
          title: const Text('Trance Addction',style: TextStyle(color: bkclr),),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color:bkclr,
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
                 Color(0xFF643D80),
                Color.fromARGB(255, 64, 112, 135),
              ],
            ),
          ),
          child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => songList(),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemCount: 3),
        ),
      ),
    );
  }
    Widget songList() {
      var height=MediaQuery.of(context).size.height;
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
            SizedBox(width: height * 0.03)
          ],
        ),
      ),
    );
  }
}