import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SongList extends StatefulWidget {
  @override
  _SongListState createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  List<File> songs = [];
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _getSongs();
  }

  void _getSongs() async {
    // Get the path to the app's directory.
    Directory appDir = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> files = appDir.listSync(recursive: true);

    // Filter out directories and non-audio files.
    songs = files
        .where((file) => file is File)
        .map((file) => file as File)
        .where((file) => file.path.endsWith('.mp3'))
        .toList();

    setState(() {});
  }

  void _playSong(String path) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/song.mp3');
    await file.writeAsBytes(await File(path).readAsBytes());
    await audioPlayer.play(file.path as Source,);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(songs[index].path.split('/').last),
            subtitle: Text(songs[index].path),
            onTap: () => _playSong(songs[index].path),
          );
        },
      ),
    );
  }
}