import 'package:first_project/core/popup.dart';
import 'package:first_project/core/theme/theme_mode.dart';
import 'package:first_project/locator.dart';
import 'package:first_project/model/song_count_artist.dart';
import 'package:first_project/screen/artist/showSong_artist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Artist extends StatefulWidget {
  const Artist({super.key});

  @override
  State<Artist> createState() => _ListMusicState();
}

class _ListMusicState extends State<Artist> {
  @override
  Widget build(BuildContext context) {
    final  themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        backgroundColor: themeProvider.isDarkMode?Colors.black:Colors.white,
        body: FutureBuilder<Map<String, int>>(
      future: locator.get<SongCountArtist>().getSongCountByArtist(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              String artist = snapshot.data?.keys.elementAt(index) ?? '';
              int songCount = snapshot.data?.values.elementAt(index) ?? 0;
              return Column(
                children: [
                  Container(
                    color: themeProvider.isDarkMode?const Color(0xff1a1b1d):locator.get<MyThemes>().cContainerSong,
                    child: ListTile(
                      trailing:
                          const SizedBox(width: 35, child: PopupMenuButtonWidget()),
                      title: Text(
                        style: locator.get<MyThemes>().title(context),
                        maxLines: 1,
                        artist,
                      ),
                      subtitle: Text(
                          maxLines: 1,
                          'Song Count: $songCount',
                          style: locator.get<MyThemes>().subTitle(context)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ShowListArtist(nameArtist: artist)));
                      },
                    ),
                  ),
                  const SizedBox(height: 20,)
                ],
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
