import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_player_1/colors/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player_1/models/playlistmodel.dart';
import 'package:music_player_1/models/songmodel.dart';
import 'package:music_player_1/screen/playscreen.dart';
import 'package:on_audio_query/on_audio_query.dart';

// ignore: must_be_immutable
class PopSongs extends StatefulWidget {
   PopSongs({
    super.key,required this.songindex,required this.playlistname});
    int? songindex;
    String? playlistname;

  @override
  State<PopSongs> createState() => _PopSongsState();
}

class _PopSongsState extends State<PopSongs> {
  final AssetsAudioPlayer audioPlayer= AssetsAudioPlayer.withId('0');
  List<Audio>convertAudio=[];
    final playbox=PlaylistBox.getInstance();

  @override
  void initState(){
    final  playlistbox=PlaylistBox.getInstance();
  List<PlayListDb>playlistsong=playlistbox.values.toList();
  for (var element in playlistsong[widget.songindex!].playlistsongs!) {
    convertAudio.add(
      Audio.file(
        element.songurl!,
        metas: Metas(
          title: element.songname,
          artist: element.artist,
          id: element.id.toString()
        ),
      )

    );
    
  }
super.initState();
  }

  bool favorites = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
     List<PlayListDb> playlistsong = playbox.values.toList();
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text(
            'PlayList Songs',
            style: TextStyle(color: bkclr),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
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
                Color(0xFF643D80),
                Color.fromARGB(255, 64, 112, 135),
              ],
            ),
          ),
          child: ValueListenableBuilder(
            valueListenable:playbox.listenable(),
            builder: (context, playlistsongs, child) {
              List<PlayListDb>playlistsong=playlistsongs.values.toList();
              List<Songs>playsong=playlistsong[widget.songindex!].playlistsongs!;
              return playsong.isNotEmpty
              ? ListView.separated(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: playsong.length,
                itemBuilder: (context, index) => songList(
                  title: playsong[index].songname,
                  artist: playsong[index].artist,
                  index: index,
                  playlistsong: playlistsong,
                  playsong: playsong,
                  id: playsong[index].id
                
                ),
                
                separatorBuilder: (context, index) => 
                 SizedBox(height:height*0.01),
                ):SizedBox(
                  height: height,
                  child: Center(
                    child: Text('No Songs',
                    style: GoogleFonts.lato(),),
                  ),
                );
  }),
        ),
      ),
    );
  }

  Widget songList(
    {
      String? title,
      String? artist,
      index,
      id,
      List<Songs>? playsong,
      List? playlistsong}) {
    var height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(left: height * 0.01, right: height * 0.01),
      child: InkWell(
        onTap: () {
          PlayScreen.playscreenindex.value=index;
          audioPlayer.open(
            Playlist(audios: convertAudio,startIndex:index ),
            headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
            showNotification: true
          );
          Navigator.push(context, 
          MaterialPageRoute(builder: (context) => PlayScreen(),));
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: fillcolor,
              border: Border.all(width: 2, color: mostfill
                  )),
          height: height * 0.09,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
               Padding(
                padding: const EdgeInsets.all(5),
                child: QueryArtworkWidget(
                  id:id , 
                  nullArtworkWidget: const CircleAvatar(
                    backgroundImage: AssetImage(
                      'assets/images/null.jpg'),
                      radius:24 ,
                  ),
                  type: ArtworkType.AUDIO),
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
                      title!,
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
                     artist!,
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
              SizedBox(width: height * 0.02),
              IconButton(onPressed: () {
                setState(() {
                  playsong!.removeAt(index);
                  playlistsong!.removeAt(widget.songindex!);
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                           PopSongs(playlistname: widget.playlistname, songindex: widget.songindex,),
                    ));
                });
                playbox.putAt(index,PlayListDb(
                  playlistname: widget.playlistname,
                   playlistsongs: playsong));
              }, 
              icon: const Icon(Icons.delete_outline_outlined),
              color: Colors.white.withOpacity(.8)),
              SizedBox(width: height * 0.03)
            ],
          ),
        ),
      ),
    );
  }
}
