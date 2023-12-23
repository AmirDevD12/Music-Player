import 'package:hive/hive.dart';
part "add_recent_play.g.dart";
@HiveType(typeId: 4)
class RecentPlay{
  RecentPlay(this.title,this.path,this.id,this.artist);

  @HiveField(0)
  String? title;

  @HiveField(1)
  String? path;

  @HiveField(2)
  String? artist;

  @HiveField(3)
  int? id;
}