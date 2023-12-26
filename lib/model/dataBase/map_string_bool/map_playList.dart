
import 'package:hive/hive.dart';
part "map_playList.g.dart";
@HiveType(typeId: 6)
class MapPlayList{
  MapPlayList(this.title,this.check);

  @HiveField(0)
 final String? title;

  @HiveField(1)
 final bool check;
}