import 'package:hive/hive.dart';
part 'recentlymodel.g.dart';


@HiveType(typeId:3)
class RecentlySong{
  @HiveField(0)
  String? songname;
  @HiveField(1)
  String? artist;
  @HiveField(2)
  String? duration;
  @HiveField(3)
  String? songurl;
  @HiveField(4)
  int? id;
  RecentlySong({
    required this.songname,
    required this.artist,
    required this.duration,
    required this.songurl,
    required this.id
  });

}
class RecentlyBox {
  static Box<RecentlySong>? _box;
  static Box<RecentlySong>getInstance(){
    return _box ??=Hive.box('Recentlyname');
  }
  
}

