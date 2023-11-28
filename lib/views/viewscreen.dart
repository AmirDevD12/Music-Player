

import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:first_project/audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    initRecorder();
    super.initState();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  final recorder = FlutterSoundRecorder();
  File? filepathVoice;
  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Permission not granted';
    }
    await recorder.openRecorder();
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future startRecord() async {
    await recorder.startRecorder(toFile: ".mp4",);
  }
String pathss="";
  Future stopRecorder() async {
     pathss = (await recorder.stopRecorder())!;

     // filepathVoice= File(filePath!).;
    // print('Recorded file path: $filePath');
  }

  AudioPlayer audioPlayer=AudioPlayer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
      ),
        backgroundColor: Colors.teal.shade700,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<RecordingDisposition>(
                builder: (context, snapshot) {
                  final duration = snapshot.hasData
                      ? snapshot.data!.duration
                      : Duration.zero;

                  String twoDigits(int n) => n.toString().padLeft(2, '0');

                  final twoDigitMinutes =
                  twoDigits(duration.inMinutes.remainder(60));
                  final twoDigitSeconds =
                  twoDigits(duration.inSeconds.remainder(60));

                  return Text(
                    '$twoDigitMinutes:$twoDigitSeconds',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
                stream: recorder.onProgress,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (recorder.isRecording) {
                    await stopRecorder();
                    setState(() {});
                  } else {
                    await startRecord();
                    setState(() {});
                  }
                },
                child: Icon(
                  recorder.isRecording ? Icons.stop : Icons.mic,
                  size: 100,
                ),
              ),
              Container(
                width: 100,
                color: Colors.blue,
                child: IconButton(
                    onPressed:() async {
                      if(pathss!=null){
                    await  audioPlayer.play(UrlSource(pathss));
                      print(pathss);
                    } },
                    icon: Icon(Icons.voice_chat,color: Colors.black,)),
              ),
              IconButton(
                  onPressed:(){
                    // Navigator.push(
                    //     context, MaterialPageRoute(
                    //     builder: (context)=>Audio(songModel: songs[index],)));
                  } , icon: Icon(Icons.arrow_back))
            ],
          ),
        ));
  }
}