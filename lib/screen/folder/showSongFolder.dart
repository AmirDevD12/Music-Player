
import 'package:first_project/model/addres_folder.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ShowSongFolder extends StatelessWidget {
  final String path;

  ShowSongFolder({Key? key, required this.path,}) : super(key: key);
  TextStyle style =const TextStyle(color: Colors.white);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SongModel>>(
      future: AddressFolder().getSongFile(path),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data?.length ,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(maxLines: 1,snapshot.data![index].title,style: TextStyle(color: Colors.white),),
                subtitle: Text(maxLines: 1,snapshot.data![index].displayName,style: TextStyle(fontSize: 18),),
                leading: QueryArtworkWidget(
                    artworkWidth: 60,
                    artworkHeight: 60,
                    artworkFit: BoxFit.cover,
                    artworkBorder: const BorderRadius.all(Radius.circular(0)),
                    id: snapshot.data![index].id, type: ArtworkType.AUDIO),
                onTap: (){

                },
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
// namefolder() async {
//   List<String> path = await AddressFolder().getSongs();
//   print(path);
// }
}
