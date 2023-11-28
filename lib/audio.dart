
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';


import 'package:on_audio_query/on_audio_query.dart';
class Audio extends StatefulWidget {

   final SongModel songModel;
   final AudioPlayer audioPlayer;
   Audio({super.key, required this.songModel, required this.audioPlayer, });

  @override
  State<Audio> createState() => _AudioState();
}

class _AudioState extends State<Audio> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;

  void playSongs() async {
    try {
      Uri uri = Uri.parse(widget.songModel.uri!);

      if (uri.scheme == 'content') {
      } else {
        await _audioPlayer.setSourceUrl(uri.toString());
      }
      await _audioPlayer.play(AssetSource(uri.path));
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
                      Uri uri= Uri.parse(widget.songModel.uri!);
                      if(isPlaying){
                        widget.audioPlayer.pause();
                      }else {
                        widget.audioPlayer.play(DeviceFileSource(uri.path));
                      }
                      setState(() {
                        isPlaying=!isPlaying;
                      });
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
