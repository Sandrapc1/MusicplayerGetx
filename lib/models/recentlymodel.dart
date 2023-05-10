import 'package:hive/hive.dart';
part 'recentlymodel.g.dart';


@HiveType(typeId:3)
class RecentlyPlayedSongs{
  @HiveField(0)
  String? songname;
  @HiveField(1)
  String? artist;
  @HiveField(2)
  int ? duration;
  @HiveField(3)
  String? songurl;
  @HiveField(4)
  int? id;
  RecentlyPlayedSongs({
    required this.songname,
    required this.artist,
    required this.duration,
    required this.songurl,
    required this.id
  });

}
class RecentlyBox {
  static Box<RecentlyPlayedSongs>? _box;
  static Box<RecentlyPlayedSongs>getInstance(){
    return _box ??=Hive.box('Recentlyname');
  }
  
}

