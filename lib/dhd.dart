
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';

import 'audio.dart';

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
    _getSongs();
  }
bool isPlaying = false;
  void _getSongs() async {
    if (!kIsWeb) {
      bool hasPermission = await onAudioQuery.permissionsStatus();
      if (hasPermission) {
        songs = await onAudioQuery.querySongs();
        Future<List<String>> path=onAudioQuery.queryAllPath();
        print(path);
        setState(() {});
      } else {
        await onAudioQuery.permissionsRequest();
      }
    }
  }
 playSong(String? uri){
    try{
      Uri.parse(uri!);
      audioPlayer.play();
      print("play");
      isPlaying=true;
    }on Exception{

    }


 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<SongModel>>(
        future: onAudioQuery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
          ignoreCase: true
        ),
        builder:(context, item){ 

          return ListView.builder(
          itemCount: songs.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(songs[index].data!),
              subtitle: Text(songs[index].displayName),
              leading: QueryArtworkWidget(
                  id: songs[index].id,
                  type: ArtworkType.AUDIO
              ),
              onTap: (){
                Navigator.push(
                    context, MaterialPageRoute(
                    builder: (context)=>Audio(songModel:songs[index],)));
              },
            );
          },
        );}
      ),
    );
  }
}
