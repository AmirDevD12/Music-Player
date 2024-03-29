import 'package:checkbox_formfield/checkbox_icon_formfield.dart';
import 'package:first_project/bloc/favorite_song/favorite_bloc.dart';
import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:first_project/bloc/play_list/play_list_bloc.dart';
import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:first_project/bloc/sort/sort_song_bloc.dart';
import 'package:first_project/core/card_widget.dart';
import 'package:first_project/locator.dart';
import 'package:first_project/model/chckFavorite.dart';
import 'package:first_project/model/dataBase/delete_song_dataBase/delete_song.dart';
import 'package:first_project/model/dataBase/recent_play/add_recent_play.dart';
import 'package:first_project/model/delete_model.dart';
import 'package:first_project/model/info_for_route.dart';
import 'package:first_project/core/theme/theme_mode.dart';
import 'package:first_project/model/newSong.dart';
import 'package:first_project/screen/playSong_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../model/songs_model.dart';
import '../../bottum_navigation/list/list_song_bottomnav.dart';

class ListMusic extends StatefulWidget {
  SongSortType sort = SongSortType.DATE_ADDED;

  final TextStyle sun = const TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontFamily: "ibm",
      fontWeight: FontWeight.bold);

  final TextStyle moon = const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontFamily: "ibm",
      fontWeight: FontWeight.bold);

  @override
  State<ListMusic> createState() => _ListMusicState();
}

class _ListMusicState extends State<ListMusic> {
  SongSortType songSortType = SongSortType.DATE_ADDED;

  String select = "";

  Box boxDelete = Hive.box<DeleteSong>("Delete Song");

  int length = 0;

  final TextStyle sun = const TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontFamily: "ibm",
      fontWeight: FontWeight.bold);

  final TextStyle moon = const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontFamily: "ibm",
      fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocBuilder<PlayNewSongBloc, PlayNewSongState>(
                  buildWhen: (previous, current) {
                    if (current is NewSongState) {
                      return true;
                    } else {
                      return false;
                    }
                  },
                  builder: (context, state) {
                    return BlocBuilder<PlaySongBloc, PlaySongState>(
                      builder: (context, state) {
                        return FutureBuilder<List<SongModel>>(
                          future: SongList().getSongs(songSortType),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<SongModel>> snapshot) {
                            if (snapshot.hasData) {
                              return
                                   Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              100,
                                          child: Text(
                                              locator
                                                  .get<AudioPlayer>()
                                                  .currentIndex==null?"Song not played":
                                            locator.get<InfoPage>().songs![locator
                                                            .get<AudioPlayer>()
                                                            .currentIndex!]
                                                    .artist ??
                                                "Not found",
                                            style: TextStyle(
                                                color: themeProvider.isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 20,
                                                fontFamily: "ibm",
                                                fontWeight: FontWeight.bold),
                                            maxLines: 1,
                                          )),
                                    );
                            } else if (snapshot.hasError) {
                              return const Text('Song not played');
                            }
                            return const Text('Song not played');
                          },
                        );
                      },
                    );
                  },
                ),
                PopupMenuButton(
                  color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                  icon: const Icon(
                    Icons.sort,
                    size: 30,
                  ),
                  itemBuilder: (BuildContext bc) {
                    return [
                      PopupMenuItem(
                        onTap: () {
                          var songSortType = SongSortType.DATE_ADDED;
                          BlocProvider.of<SortSongBloc>(context)
                              .add(SortByAddEvent(songSortType));
                        },
                        value: '/time',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Based on add time",
                              style: themeProvider.isDarkMode
                                  ? const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: "ibm")
                                  : const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: "ibm"),
                            ),
                            Image.asset(
                              "assets/icon/clock(1).png",
                              color: themeProvider.isDarkMode?Colors.black:Colors.white,
                              width: 25,
                              height: 25,
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () {
                          var songSortType = SongSortType.DATE_ADDED;
                          BlocProvider.of<SortSongBloc>(context)
                              .add(SortByAddEvent(songSortType));
                        },
                        value: '/name',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Based on name",
                              style: themeProvider.isDarkMode
                                  ? const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: "ibm")
                                  : const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: "ibm"),
                            ),
                            Image.asset(
                              "assets/icon/signature.png",
                              color: themeProvider.isDarkMode?Colors.black:Colors.white,
                              width: 25,
                              height: 25,
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () {
                          var songSortType = SongSortType.ARTIST;
                          BlocProvider.of<SortSongBloc>(context)
                              .add(SortByAddEvent(songSortType));
                        },
                        value: '/artist',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Based on artist",
                              style: themeProvider.isDarkMode
                                  ? const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: "ibm")
                                  : const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: "ibm"),
                            ),
                            Image.asset(
                              "assets/icon/artist.png",
                              color: themeProvider.isDarkMode?Colors.black:Colors.white,
                              width: 25,
                              height: 25,
                            ),
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
            child: BlocBuilder<PlayListBloc, PlayListState>(
              buildWhen: (previous, current) {
                if (current is NewListState) {
                  return true;
                } else {
                  return false;
                }
              },
              builder: (context, state) {
                return BlocBuilder<SortSongBloc, SortSongState>(
                  builder: (context, state) {
                    if (state is SortByAddState) {
                      songSortType = state.songSortType;
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
                        return ValueListenableBuilder(
                          valueListenable:
                              Hive.box<DeleteSong>("Delete Song").listenable(),
                          builder:
                              (BuildContext context, value, Widget? child) {
                            return FutureBuilder<List<SongModel>>(
                              future: SongList().getSongs(songSortType),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<SongModel>> snapshot) {
                                if (snapshot.hasData&&snapshot.data!.isNotEmpty) {
                                  return ListView.builder(
                                    itemCount: snapshot.data?.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {

                                      return Column(
                                        children: [
                                          Container(
                                            color: themeProvider.isDarkMode
                                                ? const Color(0xff1a1b1d)
                                                : locator
                                                    .get<MyThemes>()
                                                    .cContainerSong,
                                            child: ListTile(
                                              trailing: state is NewListState
                                                  ? CheckboxIconFormField(
                                                      disabledColor:
                                                          Colors.black,
                                                      context: context,
                                                      iconSize: 30,
                                                      padding: 10,
                                                      onSaved: (bool? value) {},
                                                      onChanged: (value) {
                                                        if (value) {
                                                          // boxc[name[index]]=true;
                                                        } else {
                                                          // boxc[name[index]]=false;
                                                        }
                                                      },
                                                    )
                                                  : SizedBox(
                                                      width: 36,
                                                      child: InkWell(
                                                        onTap: () {
                                                          showModalBottomSheet<
                                                              void>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return Container(
                                                                color: themeProvider
                                                                        .isDarkMode
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .white,
                                                                width: double
                                                                    .infinity,
                                                                height: 200,
                                                                child: Column(
                                                                  children: <Widget>[
                                                                    const SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Text(
                                                                      style: locator
                                                                          .get<
                                                                              MyThemes>()
                                                                          .title(
                                                                              context),
                                                                      maxLines:
                                                                          1,
                                                                      snapshot
                                                                          .data![
                                                                              index]
                                                                          .title,
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          15,
                                                                    ),
                                                                    Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              10.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceAround,
                                                                            children: [
                                                                              Column(
                                                                                children: [
                                                                                  GestureDetector(
                                                                                      onTap: () {
                                                                                        // locator.get<AudioPlayer>().setAudioSource(playlist!);
                                                                                      },
                                                                                      child: const CardWidget(
                                                                                        text: 'Play next',
                                                                                        path: "assets/icon/music-player(1).png",
                                                                                      )),
                                                                                  const SizedBox(
                                                                                    height: 10,
                                                                                  ),
                                                                                  GestureDetector(
                                                                                      onTap: () {
                                                                                        // addPlayList(snapshot.data![index]);
                                                                                        Navigator.pushReplacement(
                                                                                            context,
                                                                                            MaterialPageRoute(
                                                                                                builder: (context) => MultiBlocProvider(
                                                                                                        providers: [
                                                                                                          BlocProvider(create: (context) => locator.get<PlaySongBloc>()),
                                                                                                          BlocProvider(
                                                                                                            create: (context) => locator.get<PlayNewSongBloc>(),
                                                                                                          ),
                                                                                                          BlocProvider(
                                                                                                            create: (context) => locator.get<FavoriteBloc>(),
                                                                                                          ),
                                                                                                          BlocProvider(
                                                                                                            create: (context) => locator.get<PlayListBloc>(),
                                                                                                          ),
                                                                                                        ],
                                                                                                        child: ListSongBottomNavigation(
                                                                                                          show: true,
                                                                                                          songModel: snapshot.data![index],
                                                                                                        ))));
                                                                                      },
                                                                                      child: const CardWidget(
                                                                                        text: 'List',
                                                                                        path: "assets/icon/list(2).png",
                                                                                      )),
                                                                                ],
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 20,
                                                                              ),
                                                                              Column(
                                                                                children: [
                                                                                  GestureDetector(
                                                                                      onTap: () {
                                                                                        double duration = snapshot.data![index].duration! / 1000;

                                                                                        showDialog(
                                                                                          context: context,
                                                                                          builder: (BuildContext context) {
                                                                                            return AlertDialog(
                                                                                              backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
                                                                                              surfaceTintColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
                                                                                              title: Text(
                                                                                                'Info',
                                                                                                maxLines: 1,
                                                                                                style: locator.get<MyThemes>().title(context),
                                                                                              ),
                                                                                              actions: [
                                                                                                Column(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children: [
                                                                                                    Text(
                                                                                                      "name: ${snapshot.data![index].title}",
                                                                                                      maxLines: 1,
                                                                                                      style: locator.get<MyThemes>().title(context),
                                                                                                    ),
                                                                                                    Text("artist: ${snapshot.data![index].artist}", maxLines: 1, style: locator.get<MyThemes>().title(context)),
                                                                                                    snapshot.data![index].album != null ? Text("album:: ${snapshot.data![index].album}", maxLines: 1, style: locator.get<MyThemes>().title(context)) : const SizedBox(),
                                                                                                    Text("duration: $duration ", maxLines: 1, style: locator.get<MyThemes>().title(context)),
                                                                                                    Text("dis playName: ${snapshot.data![index].displayName}", maxLines: 1, style: locator.get<MyThemes>().title(context)),
                                                                                                  ],
                                                                                                ),
                                                                                              ],
                                                                                            );
                                                                                          },
                                                                                        );
                                                                                      },
                                                                                      child: const CardWidget(
                                                                                        text: 'Info',
                                                                                        path: "assets/icon/information-button.png",
                                                                                      )),
                                                                                  const SizedBox(
                                                                                    height: 10,
                                                                                  ),
                                                                                  GestureDetector(
                                                                                      onTap: () {
                                                                                        shareSong(snapshot.data![index].data);
                                                                                      },
                                                                                      child: const CardWidget(
                                                                                        text: 'Share',
                                                                                        path: "assets/icon/share.png",
                                                                                      )),
                                                                                ],
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 20,
                                                                              ),
                                                                              Column(
                                                                                children: [
                                                                                  GestureDetector(
                                                                                      onTap: () {},
                                                                                      child: const CardWidget(
                                                                                        text: 'Favorite',
                                                                                        path: "assets/icon/like.png",
                                                                                      )),
                                                                                  const SizedBox(
                                                                                    height: 10,
                                                                                  ),
                                                                                  GestureDetector(
                                                                                      onTap: () {
                                                                                        DeleteSongFile().getDeleteSong(snapshot.data![index]);
                                                                                        deleteSong(snapshot.data![index].data);
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: const CardWidget(
                                                                                        text: 'Delete',
                                                                                        path: "assets/icon/delete.png",
                                                                                      )),
                                                                                ],
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: Image.asset(
                                                          "assets/icon/dots.png",
                                                          width: 25,
                                                          height: 25,
                                                          color: themeProvider
                                                                  .isDarkMode
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                              title: Text(
                                                style: locator
                                                    .get<MyThemes>()
                                                    .title(context),
                                                maxLines: 1,
                                                snapshot.data![index].title,
                                              ),
                                              subtitle: Text(
                                                style: locator
                                                    .get<MyThemes>()
                                                    .subTitle(context),
                                                maxLines: 1,
                                                snapshot
                                                    .data![index].displayName,
                                              ), leading: QueryArtworkWidget(
                                                nullArtworkWidget: Image.asset(
                                                    "assets/icon/vinyl-record.png"),
                                                artworkWidth: 60,
                                                artworkHeight: 60,
                                                artworkFit: BoxFit.cover,
                                                artworkBorder:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                                id: snapshot.data![index].id,
                                                type: ArtworkType.AUDIO),

                                              onTap: () async {

                                                 locator.get<CheckFavorite>().check(snapshot.data![index].data, context,false);
                                                final playList=await locator.get<SongList>().getAudioSource(songSortType);
                                                List<SongModel> songs = await locator.get<SongList>().getSongs(songSortType);
                                                       locator.get<InfoPage>().setInfo( playList, index, songs, null);
                                                // ignore: use_build_context_synchronously
                                                context.push(
                                                    PlayPage.routePlayPage,
                                                    extra:locator.get<InfoPage>());
                                                // ignore: use_build_context_synchronously
                                                locator.get<PlayNewSong>()
                                                    .newSong(index, context,playList, false);
                                                addRecentPlay(
                                                    snapshot.data![index]);

                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          )
                                        ],
                                      );
                                    },
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }
                                return const Center(
                                    child: CircularProgressIndicator());
                              },
                            );
                          },
                        );
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

  deleteSong(String path) async {
    var box = await Hive.openBox<DeleteSong>("Delete Song");
    DeleteSong deleteSong = DeleteSong(path);
    await box.add(deleteSong);
  }

  addRecentPlay(SongModel songModel) async {
    bool check = false;
    var box = await Hive.openBox<RecentPlay>("Recent play");
    for (int i = 0; i < box.length; i++) {
      if (songModel.data == box.getAt(i)?.path) {
        check = true;
        return;
      }
    }
    if (!check) {
      if (box.length > 10) {
        box.deleteAt(0);
      }
      RecentPlay recentPlay = RecentPlay(
          songModel.title, songModel.data, songModel.id, songModel.artist);
      await box.add(recentPlay);
    }
  }

  Future<void> shareSong(String songPath) async {
    try {
      await Share.shareFiles([songPath], text: 'Check out this song!');
    } catch (e) {
      print('Error sharing file: $e');
    }
  }

}
