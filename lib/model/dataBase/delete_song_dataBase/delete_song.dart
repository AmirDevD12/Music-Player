import 'package:hive/hive.dart';
part "delete_song.g.dart";
@HiveType(typeId: 2)
class DeleteSong {
  DeleteSong(this.pathSong);

  @HiveField(0)
  final String pathSong;
}