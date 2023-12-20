import 'package:first_project/bloc/favorite_song/favorite_bloc.dart';
import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:first_project/bloc/sort/sort_song_bloc.dart';
import 'package:first_project/core/playall_container.dart';
import 'package:first_project/locator.dart';
import 'package:first_project/model/dataBase/delete_song_dataBase/delete_song.dart';
import 'package:first_project/model/delete_model.dart';
import 'package:first_project/screen/playSong_page.dart';
import 'package:first_project/core/theme/theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../model/songs_model.dart';

class ListMusic extends StatelessWidget {
  SongSortType songSortType = SongSortType.TITLE;

  String select = "";
  Box boxDelete = Hive.box<DeleteSong>("Delete");
  int length = 0;
  ListMusic({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 110, height: 30, child: PlayAllContainer()),
                PopupMenuButton(
                  icon: const Icon(Icons.sort,size: 30,),
                  onSelected: (value) {
                    print(value);
                    // select=value;
                  },
                  itemBuilder: (BuildContext bc) {
                    return [
                      PopupMenuItem(
                        onTap: (){
                          var songSortType=SongSortType.DATE_ADDED;
                          BlocProvider.of<SortSongBloc>(context).add(SortByAddEvent(songSortType));
                        },
                        value: '/time',
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Based on add time",
                            ),
                            SizedBox(width: 10,),

                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: (){
                          var songSortType=SongSortType.TITLE;
                          BlocProvider.of<SortSongBloc>(context).add(SortByAddEvent(songSortType));
                        },
                        value: '/name',
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Based on name",

                            ),SizedBox(width: 10,),

                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: (){
                          var songSortType=SongSortType.ARTIST;
                          BlocProvider.of<SortSongBloc>(context).add(SortByAddEvent(songSortType));
                        },
                        value: '/artist',
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Based on artist",

                            ),SizedBox(width: 10,),

                          ],
                        ),
                      ),

                    ];
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<SortSongBloc, SortSongState>(
              builder: (context, state) {
                SongSortType sort = SongSortType.TITLE;
                if (state is SortByAddState) {
                  sort = state.songSortType;
                }
                return BlocBuilder<PlaySongBloc, PlaySongState>(
                  buildWhen: (perivioce, current) {
                    if (current is DeleteSongState) {
                      return true;
                    } else {
                      return false;
                    }
                  },
                  builder: (context, state) {
                    return FutureBuilder<List<SongModel>>(
                      future:
                          SongList().getSongs(sort),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<SongModel>> snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (BuildContext context, int index) {

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
                                            add(snapshot.data![index].data);
                                            locator
                                                .get<DeleteSongFile>()
                                                .getDeleteSong(
                                                    snapshot.data![index]);
                                            BlocProvider.of<PlaySongBloc>(
                                                    context)
                                                .add(DeleteSongEvent(snapshot
                                                    .data![index].data));
                                          },
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
                                  style:locator.get<MyThemes>().title(context) ,
                                  maxLines: 1,
                                  snapshot.data![index].title,
                                ),
                                subtitle: Text(
                                  style: locator.get<MyThemes>().subTitle(context),
                                  maxLines: 1,
                                  snapshot.data![index].displayName,
                                ),
                                leading: QueryArtworkWidget(
                                    artworkWidth: 60,
                                    artworkHeight: 60,
                                    artworkFit: BoxFit.cover,
                                    artworkBorder: const BorderRadius.all(
                                        Radius.circular(5)),
                                    id: snapshot.data![index].id,
                                    type: ArtworkType.AUDIO ),
                                onTap: () async {
                                  BlocProvider.of<PlaySongBloc>(context).add(
                                      ShowEvent(snapshot.data![index], true));
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MultiBlocProvider(
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
                                                ],
                                                child: PlayPage(
                                                  songModel:
                                                      snapshot.data![index],
                                                  audioPlayer: locator
                                                      .get<AudioPlayer>(),
                                                  play: true,
                                                ),
                                              )));
                                  BlocProvider.of<PlayNewSongBloc>(context).add(
                                      NewSongEvent(
                                          snapshot.data![index].id,
                                          snapshot.data![index].title,
                                          snapshot.data![index].artist!,
                                          index));
                                },
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  add(String path) async {
    var box = await Hive.openBox<DeleteSong>("Delete");
    DeleteSong deleteSong = DeleteSong(path);
    await box.add(deleteSong);
  }
}
