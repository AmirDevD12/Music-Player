import 'package:first_project/bloc/favorite_song/favorite_bloc.dart';
import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:first_project/bloc/sort/sort_song_bloc.dart';
import 'package:first_project/core/theme/theme_mode.dart';
import 'package:first_project/locator.dart';
import 'package:first_project/model/dataBase/recent_play/add_recent_play.dart';
import 'package:first_project/model/songs_model.dart';
import 'package:first_project/screen/playSong_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class RecentAddScreen extends StatelessWidget {
  RecentAddScreen({Key? key}) : super(key: key);
  Box recentPlay = Hive.box<RecentPlay>("Recent play");
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.red,
        body: ValueListenableBuilder(
          valueListenable:recentPlay.listenable(),
          builder: (context, Box box, child) {
            if (box.values.isEmpty) {
              return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(50.0),
                    child: Text(
                      'No song',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ));
            } else {
              return ListView.builder(
                itemCount: recentPlay.length,
                itemBuilder: (BuildContext context, int index) {
                  final playlist = ConcatenatingAudioSource(
                    useLazyPreparation: true,
                    shuffleOrder: DefaultShuffleOrder(),
                    children: [
                      for(int i=0;i<box.length;i++)
                        AudioSource.uri(Uri.parse(box.getAt(i).path)),
                    ],
                  );
                  final RecentPlay recentPlay = box.getAt(index);
                  final themeProvider =
                  Provider.of<ThemeProvider>(context);
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
                              onTap: () {
                              },
                              value: '/delete',
                              child: Text("delete"),
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
                      recentPlay.title!,
                      style: locator.get<MyThemes>().title(context),
                      maxLines: 1,
                    ),
                    subtitle: Text(
                      recentPlay.artist!,
                      style: locator.get<MyThemes>().subTitle(context),
                      maxLines: 1,
                    ),
                    leading: QueryArtworkWidget(
                        artworkWidth: 60,
                        artworkHeight: 60,
                        artworkFit: BoxFit.cover,
                        artworkBorder: const BorderRadius.all(
                            Radius.circular(5)),
                        id: recentPlay.id!,
                        type: ArtworkType.AUDIO),
                    onTap: () async {
                      List<SongModel>songs=await SongList().getSongs(SongSortType.DATE_ADDED);
                      Box boxList =
                      await Hive.openBox<RecentPlay>(
                          "Recent play");
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                      create: (context) =>
                                          locator.get<
                                              PlaySongBloc>()),
                                  BlocProvider(
                                    create: (context) => locator
                                        .get<PlayNewSongBloc>(),
                                  ),
                                  BlocProvider(
                                    create: (context) => locator
                                        .get<FavoriteBloc>(),
                                  ),
                                  BlocProvider(
                                    create: (context) => locator
                                        .get<SortSongBloc>(),
                                  ),
                                ],
                                child: PlayPage(playInList: true, concatenatingAudioSource: playlist , index: index, songs:songs, nameList: boxList,
                                ),
                              )));
                    },
                  );
                },
              );
            }
          },
        ));
  }
}
