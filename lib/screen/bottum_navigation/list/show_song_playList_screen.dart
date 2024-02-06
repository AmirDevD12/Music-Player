import 'package:first_project/bloc/favorite_song/favorite_bloc.dart';
import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:first_project/bloc/sort/sort_song_bloc.dart';
import 'package:first_project/core/theme/theme_mode.dart';
import 'package:first_project/locator.dart';
import 'package:first_project/model/info_for_route.dart';
import 'package:first_project/model/newSong.dart';
import 'package:first_project/model/songs_model.dart';
import 'package:first_project/screen/playSong_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatelessWidget {
  final String name;
  final Box boxes;
  const FavoriteScreen({Key? key, required this.name, required this.boxes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final  themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: themeProvider.isDarkMode?Colors.black:Colors.white,
          title: Text(
            name,
          ),
        ),
        body: ValueListenableBuilder(
          valueListenable: boxes.listenable(),
          builder: (context, Box box, child) {
            if (box.values.isEmpty) {
              return const Center(
                  child: Padding(
                padding: EdgeInsets.all(50.0),
                child: Text(
                  'Not Found',
                  style: TextStyle(
                  ),
                ),
              ));
            } else {
              return ListView.builder(
                itemCount: box.length,
                itemBuilder: (BuildContext context, int index) {
                  final playlist = ConcatenatingAudioSource(
                    useLazyPreparation: true,
                    shuffleOrder: DefaultShuffleOrder(),
                    children: [
                      for (int i = 0; i < box.length; i++)
                        AudioSource.uri(Uri.parse(box.getAt(i).path),  tag: MediaItem(
                        id: '${box.getAt(i).id}',
                          album: "",
                          title: box.getAt(i).title!,
                          artUri: Uri.parse(box.getAt(i).id.toString()),
                        )),

                    ],
                  );
                  final themeProvider = Provider.of<ThemeProvider>(context);
                  return ListTile(
                    trailing: SizedBox(
                      width: 36,
                      child: PopupMenuButton(
                        iconSize: 200,
                        icon: Image.asset(
                          "assets/icon/dots.png",
                          width: 40,
                          height: 40,
                          color: themeProvider.isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                        itemBuilder: (BuildContext bc) {
                          return [
                            PopupMenuItem(
                              onTap: () {},
                              value: '/delete',
                              child: const Text("delete"),
                            ),
                            const PopupMenuItem(
                              value: '/share',
                              child: Text("Share"),
                            ),
                            const PopupMenuItem(
                              value: '/add',
                              child: Text("Add to playlist"),
                            )
                          ];
                        },
                      ),
                    ),
                    title: Text(
                      boxes.getAt(index).title!,
                      style: locator.get<MyThemes>().title(context),
                      maxLines: 1,
                    ),
                    subtitle: Text(
                      boxes.getAt(index).artist!,
                      style: locator.get<MyThemes>().subTitle(context),
                      maxLines: 1,
                    ),
                    leading: QueryArtworkWidget(
                        artworkWidth: 60,
                        artworkHeight: 60,
                        artworkFit: BoxFit.cover,
                        artworkBorder:
                            const BorderRadius.all(Radius.circular(5)),
                        id: boxes.getAt(index).id!,
                        type: ArtworkType.AUDIO),
                    onTap: () async {
                      List<String> paths=[];
                      for(int i=0;i<box.length;i++){
                        paths.add(box.getAt(i).path);
                      }
                        List<SongModel>songs=await locator.get<SongList>().getSongBox(paths);
                      // ignore: use_build_context_synchronously
                      locator.get<InfoPage>().setInfo( playlist, index, songs, boxes);
                      context.push(
                          PlayPage.routePlayPage,
                          extra:locator.get<InfoPage>());
                      locator.get<PlayNewSong>()
                          .newSong(index, context,playlist, false);
                    },
                  );
                },
              );
            }
          },
        ));
  }
}
