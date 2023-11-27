import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();

    _getSongs();
  }

  void _getSongs() async {
    // Check if the plugin was granted the necessary permissions.
    if (!kIsWeb) {
      bool hasPermission = await onAudioQuery.permissionsStatus();

      if (hasPermission) {
        // Retrieve a list of songs.

        songs = await onAudioQuery.querySongs();
        print(songs);

        setState(() {});
      } else {
        // Request the necessary permissions.

        await onAudioQuery.permissionsRequest();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: GestureDetector(
                onTap: (){
                  Navigator.push(
                      context, MaterialPageRoute(
                      builder: (context)=>Audio(path: null,makan: songs[index].data,)));

                },
                child: Text(songs[index].data!)),
            subtitle: Text(songs[index].displayName),
            leading: QueryArtworkWidget(
                id: songs[index].id,
                type: ArtworkType.AUDIO
            ),
          );
        },
      ),
    );
  }
}
