import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_player_1/models/favouritesmodel.dart';
import 'package:music_player_1/models/mostplayedmodel.dart';
import 'package:music_player_1/models/playlistmodel.dart';
import 'package:music_player_1/models/recentlymodel.dart';
import 'package:music_player_1/screen/splashscreen.dart';
import 'models/dbfunctions.dart';
import 'models/songmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SongsAdapter());
  await Hive.openBox<Songs>(boxname);
  Hive.registerAdapter(FavouritesAdapter());
  
  openfavouritesdb();
  Hive.registerAdapter(PlayListDbAdapter());
  openplaylistDb();
  Hive.registerAdapter(RecentlyPlayedSongsAdapter());
  openrecentlyplayed();
  Hive.registerAdapter(MostlyPlayedSongsAdapter());
  openmostlyBox();

  

  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Beat Route',
      color: const Color(0xFF9A0D3C),
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
