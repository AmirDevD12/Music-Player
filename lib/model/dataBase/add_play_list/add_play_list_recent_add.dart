import 'package:hive/hive.dart';
part "add_play_list_recent_add.g.dart";
@HiveType(typeId: 3)
class AddTOPlayListRecent{
  AddTOPlayListRecent(this.title,this.path,this.id,this.artist);

  @HiveField(0)
  String? title;

  @HiveField(1)
  String? path;

  @HiveField(2)
  String? artist;

  @HiveField(3)
  int? id;
}