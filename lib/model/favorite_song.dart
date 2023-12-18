import 'package:hive/hive.dart';
part "favorite_song.g.dart";
@HiveType(typeId: 1)
class FavoriteSong {
  FavoriteSong(this.title,this.path,this.id,this.artist);

  @HiveField(0)
  String? title;

  @HiveField(1)
  String? path;

  @HiveField(2)
  String? artist;

  @HiveField(3)
  int? id;
}