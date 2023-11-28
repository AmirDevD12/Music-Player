
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


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
  Future<void> _getSongs() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    final appDocDir = await getApplicationDocumentsDirectory();
    final musicDir = Directory('${appDocDir.path}/Music');
    if (!await musicDir.exists()) {
      await musicDir.create();
    }

// Check if musicDir is not null before using the listSync method
    if (musicDir != null) {
      final files = musicDir.listSync(recursive: true);
      final songss = files.where((file) {
        print('File path: ${file.path}'); // Add this line to print the file path
        return file.path.endsWith('.mp3');
      }).toList();
      print("ffdfgdgfd$songss");
      setState(() {
        songs = songss.cast<SongModel>();
      });
    }
  }
 playSong(String? uri){
    try{
      Uri.parse(uri!);
      // audioPlayer.play();
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
                    builder: (context)=>Audio(songModel:item.data![index],audioPlayer: audioPlayer
                      ,)));
              },
            );
          },
        );}
      ),
    );
  }
}
