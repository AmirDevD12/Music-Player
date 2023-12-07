import 'package:first_project/model/songs_model.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AddressFolder {
Future<List<String>>  getAddress() async {
    List<String> file=[];
    List<String> address=[];
    List<SongModel> songs = await SongList().getSongs();
    if (songs.isNotEmpty) {
      for(int i=0; i<songs.length;i++){
        List<String> parts = songs[i].data.split('/');
        String fileName = parts[parts.length - 2];
        if (file.isEmpty) {
          file.add(fileName);
        }else {
          if (file.last!=fileName) {
            file.add(fileName);
          }
        }
      }
   address =file.toSet().toList();
    }
    return address;
  }

Future<List<String>>  Location() async {
  List<String> file=[];
  List<String> address=[];
  List<SongModel> songs = await SongList().getSongs();
  if (songs.isNotEmpty) {
    for(int i=0; i<songs.length;i++){
       file.add(songs[i].data);


    }
    address =file.toSet().toList();
    print(address);
  }
  return address;
}
}