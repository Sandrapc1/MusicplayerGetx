import 'package:hive/hive.dart';
part 'favouritesmodel.g.dart';
@HiveType(typeId:1)
class Favourites {
  @HiveField(0)
  String? songname;
  @HiveField(1)
  String? artist;
  @HiveField(2)
  int? duration;
  @HiveField(3)
  String? songurl;
  @HiveField(4)
  int? id;  

  Favourites(
    {
      required this.songname,
      required this.artist,
      required this.duration,
      required this.songurl,
      required this.id
    });
}
String boxnamefav='favourites';
 class Favouritesbox{
  static Box<Favourites>?_box; 
  static Box<Favourites> getInstance(){
    return _box ??= Hive.box(boxnamefav);
  }    
}