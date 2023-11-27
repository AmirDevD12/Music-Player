import 'dart:io';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
class Audio extends StatefulWidget {
  File? path;
 final String? makan;
   Audio({super.key,required this.path, this.makan});

  @override
  State<Audio> createState() => _AudioState();
}

class _AudioState extends State<Audio> {
   String miqrofon="";

  AudioPlayer audioPlayer=AudioPlayer();
   void playSong(String path) async {
     final dir = await getApplicationDocumentsDirectory();
     final file =await File('${dir.path}/song.mp3');
     await file.writeAsBytes(await File(path).readAsBytes());
     await audioPlayer.play(file.path as Source,);
   }
  @override
  Widget build(BuildContext context) {
    if(widget.path!=null){
      miqrofon=widget.path as String;
    }
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
                      if(widget.makan!=null){
                      final dir = await getApplicationDocumentsDirectory();
                      final file = File('${dir.path}/song.mp3');
                      await file.writeAsBytes(await File(widget.makan!).readAsBytes());
                      await audioPlayer.play(file.path as Source,);
                    }
                      // audioPlayer.play();
                      print(widget.makan);
                    } ,
                    icon: Icon(Icons.voice_chat,color: Colors.black,)),
              ),

              Container(
                width: 100,
                color: Colors.red,
                child: IconButton(
                    onPressed:() async {
                      final player = AudioPlayer();

                        await  audioPlayer.stop();


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
