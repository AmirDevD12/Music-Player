import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
class Audio extends StatefulWidget {

   final SongModel songModel;
   Audio({super.key, required this.songModel, });

  @override
  State<Audio> createState() => _AudioState();
}

class _AudioState extends State<Audio> {
  final AudioPlayer _audioPlayer = AudioPlayer();


  void playSongs() async {

    try {

      Uri uri = Uri.parse(widget.songModel.uri!);

      if (uri.scheme == 'content') {
        // String filePath = await OnAudioQuery().getPath(widget.songModel.);
        // await _audioPlayer.setFilePath(filePath);
      } else {
        await _audioPlayer.setUrl(uri.toString());
      }
      await _audioPlayer.play();
    } catch (e) {
      print(e.toString());
    }
  }
  @override
  void initState() {
    super.initState();
    playSongs();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                color: Colors.blue,
                child: IconButton(
                    onPressed:() async {
                    } ,
                    icon: Icon(Icons.voice_chat,color: Colors.black,)),
              ),

              Container(
                width: 100,
                color: Colors.red,
                child: IconButton(
                    onPressed:() async {
                      print("stop");
                    } ,
                    icon: Icon(Icons.stop,size: 30,color: Colors.black,)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
