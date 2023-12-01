
import 'package:first_project/screen/playSong_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'model/songs_model.dart';

class ListMusic extends StatefulWidget {
  const ListMusic({super.key});

  @override
  State<ListMusic> createState() => _ListMusicState();
}

class _ListMusicState extends State<ListMusic> {
  final OnAudioQuery onAudioQuery = OnAudioQuery();
  List<SongModel> songs = [];

 final AudioPlayer audioPlayer=AudioPlayer();
  @override
  void initState() {
    super.initState();
  }
bool isPlaying = false;

 playSong(String? uri){
    try{
      audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(uri!))
      );
      Uri.parse(uri!);
      audioPlayer.play();
      print("play");
      isPlaying=true;
    }on Exception{
    }
 }
  @override
  Widget build(BuildContext context) {
    return
     Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Text('Song List'),
          ),
          body: FutureBuilder<List<SongModel>>(
            future: SongList().getSongs(),
            builder: (BuildContext context, AsyncSnapshot<List<SongModel>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(snapshot.data![index].title),
                      subtitle: Text(snapshot.data![index].displayName),
                      leading: QueryArtworkWidget(
                          id: snapshot.data![index].id,
                          type: ArtworkType.AUDIO
                      ),
                      onTap: (){
                        // playSong(item.data![index].uri);
                        Navigator.push(
                            context, MaterialPageRoute(
                            builder: (context)=>PlayPage(songModel:snapshot.data![index],audioPlayer: audioPlayer,
                            )));
                      },
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        );
  }
}
