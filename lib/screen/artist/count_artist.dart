import 'package:first_project/core/popup.dart';
import 'package:first_project/locator.dart';
import 'package:first_project/model/song_count_artist.dart';
import 'package:first_project/screen/artist/showSong_artist.dart';
import 'package:flutter/material.dart';

class Artist extends StatefulWidget {
  const Artist({super.key});

  @override
  State<Artist> createState() => _ListMusicState();
}

class _ListMusicState extends State<Artist> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<Map<String, int>>(
      future: locator.get<SongCountArtist>().getSongCountByArtist(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              String artist = snapshot.data?.keys.elementAt(index) ?? '';
              int songCount = snapshot.data?.values.elementAt(index) ?? 0;
              return Padding(
                padding: const EdgeInsets.only(left: 20),
                child: ListTile(
                  trailing:
                      const SizedBox(width: 35, child: PopupMenuButtonWidget()),
                  title: Text(
                    maxLines: 1,
                    artist,
                  ),
                  subtitle: Text(
                      maxLines: 1,
                      'Song Count: $songCount',
                      style: const TextStyle(fontSize: 16)),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ShowListArtist(nameArtist: artist)));
                  },
                ),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    ));
  }
}
