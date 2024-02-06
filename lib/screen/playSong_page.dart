
import 'package:first_project/bloc/favorite_song/favorite_bloc.dart';
import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:first_project/locator.dart';
import 'package:first_project/model/chckFavorite.dart';
import 'package:first_project/model/chengeAnimation.dart';
import 'package:first_project/model/dataBase/favorite_dataBase/favorite_song.dart';
import 'package:first_project/model/info_for_route.dart';
import 'package:first_project/model/newSong.dart';
import 'package:first_project/core/theme/theme_mode.dart';
import 'package:first_project/model/songs_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../bloc/play_song_bloc.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({
    super.key,
  });
  static String routePlayPage = "/PlayPage";
  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool like = true;
  bool shuffle = false;

  late final blocPlaySong;
  late final blocNewSong;
  int? next = 0;
  List<SongModel> songList = [];
  int current = 0;

  @override
  void initState() {
    blocPlaySong = BlocProvider.of<PlaySongBloc>(context);
    blocNewSong = BlocProvider.of<PlayNewSongBloc>(context);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 50),
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.slowMiddle,
      ),
    );
    // ChangeAnimation().toggleAnimation(_animationController,);

  }

  @override
  void dispose() {
    try {
      if (locator.get<AudioPlayer>().currentIndex == current) {
        blocNewSong.add(NewSongEvent(
          locator.get<AudioPlayer>().currentIndex!,
        ));
      }
      blocPlaySong.add(ShowEvent(locator.get<AudioPlayer>().playing, songList));
    } catch (e) {
      print(e);
    }
    _animationController.dispose();
    Navigator.pop(context);
    super.dispose();
  }

  Box favorite = Hive.box<FavoriteSong>("Favorite");
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final InfoPage play = GoRouterState.of(context).extra! as InfoPage;
    songList = play.songs!;
    current = play.index;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 10),
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
                    buildWhen: (previous, current) {
                      if (current is PausePlayState) {
                        return true;
                      } else {
                        return false;
                      }
                    },
                    builder: (context, state) {
                      return IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 40,
                          ));
                    },
                  );
                },
              ),
              const Text(
                "New Song",
                style: TextStyle(
                    fontSize: 25,
                    fontFamily: "ibm",
                    fontWeight: FontWeight.bold),
              ),
              BlocBuilder<PlayNewSongBloc, PlayNewSongState>(
                builder: (context, state) {
                  return BlocBuilder<FavoriteBloc, FavoriteState>(
                    builder: (context, state) {
                      if (state is FavoriteSongState) {
                        if (state.like) {
                          like = false;
                        } else {
                          like = true;
                        }
                      }
                      return IconButton(
                        onPressed: () async {
                          like = !like;
                          if (!like) {
                            locator.get<CheckFavorite>().add(
                                play.songs![
                                    locator.get<AudioPlayer>().currentIndex!],
                                context);
                          } else {
                            locator.get<CheckFavorite>().deleteFavorite(
                                play
                                    .songs![locator
                                        .get<AudioPlayer>()
                                        .currentIndex!]
                                    .data,
                                context);
                          }
                        },
                        icon: Image.asset(
                          like
                              ? "assets/icon/like.png"
                              : "assets/icon/heart.png",
                          color: Colors.red,
                          width: 25,
                          height: 25,
                        ),
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocBuilder<FavoriteBloc, FavoriteState>(
                    buildWhen: (previous, current) {
                      if (current is PlayFavoriteState) {
                        return true;
                      } else {
                        return false;
                      }
                    },
                    builder: (context, state) {
                      return BlocBuilder<PlayNewSongBloc, PlayNewSongState>(
                        buildWhen: (previous, current) {
                          if (current is PauseAnimationState ||
                              current is ChangIconState) {
                            return false;
                          } else {
                            return true;
                          }
                        },
                        builder: (context, state) {
                          return RotationTransition(
                              turns: _animation,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(130)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: themeProvider.isDarkMode
                                            ? Colors.grey
                                            : const Color(0xff1a1b1d),
                                        blurRadius: 15,
                                        spreadRadius: 2,
                                      )
                                    ]),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 120,
                                  child: Center(
                                      child: QueryArtworkWidget(
                                          nullArtworkWidget: Image.asset(
                                              "assets/icon/vinyl-record.png"),
                                          keepOldArtwork: true,
                                          artworkBorder: const BorderRadius.all(
                                              Radius.circular(120)),
                                          artworkWidth: 252,
                                          artworkHeight: 252,
                                          id: play
                                              .songs![locator
                                                  .get<AudioPlayer>()
                                                  .currentIndex!]
                                              .id,
                                          type: ArtworkType.AUDIO)),
                                ),
                              ));
                        },
                      );
                    },
                  )
                ],
              ),
              Row(
                children: [
                  BlocBuilder<FavoriteBloc, FavoriteState>(
                    buildWhen: (previous, current) {
                      if (current is PlayFavoriteState) {
                        return true;
                      } else {
                        return false;
                      }
                    },
                    builder: (context, state) {
                      return BlocBuilder<PlayNewSongBloc, PlayNewSongState>(
                        buildWhen: (previous, current) {
                          if (current is PauseAnimationState ||
                              current is ChangIconState) {
                            return false;
                          } else {
                            return true;
                          }
                        },
                        builder: (context, state) {
                          return Expanded(
                              child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  style: locator.get<MyThemes>().title(context),
                                  maxLines: 1,
                                  play
                                      .songs![locator
                                          .get<AudioPlayer>()
                                          .currentIndex!]
                                      .title,
                                )
                              ],
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    style: locator
                                        .get<MyThemes>()
                                        .subTitle(context),
                                    maxLines: 1,
                                    isFavorite == false
                                        ? play
                                                .songs![locator
                                                    .get<AudioPlayer>()
                                                    .currentIndex!]
                                                .artist ??
                                            ""
                                        : favorite
                                            .getAt(locator
                                                .get<AudioPlayer>()
                                                .currentIndex!)
                                            .artist
                                            .toString()),
                              ],
                            ),
                          ));
                        },
                      );
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(child: BlocBuilder<PlaySongBloc, PlaySongState>(
                    builder: (context, state) {
                      final themeProvider = Provider.of<ThemeProvider>(context);
                      Duration duration = const Duration();
                      Duration position = const Duration();
                      if (state is DurationState) {
                        position = state.start;
                        duration = state.finish;
                        if (next != locator.get<AudioPlayer>().currentIndex) {
                          next = locator.get<AudioPlayer>().currentIndex;
                          BlocProvider.of<PlayNewSongBloc>(context)
                              .add(NewSongEvent(next!));
                        }
                      }
                      return Slider(
                        activeColor: themeProvider.isDarkMode
                            ? const Color(0xffff435e)
                            : const Color(0xffff435e),
                        inactiveColor: themeProvider.isDarkMode
                            ? Colors.white
                            : const Color(0xffd4d5d7),
                        value: duration.inSeconds.toDouble(),
                        max: position.inSeconds.toDouble(),
                        min: const Duration(milliseconds: 0)
                            .inSeconds
                            .toDouble(),
                        onChanged: (value) {
                          changeSeconds(value.toInt());
                          value = value;
                          BlocProvider.of<PlaySongBloc>(context)
                              .add(DurationEvent(position, duration));
                        },
                      );
                    },
                  )),
                ],
              ),
              BlocBuilder<PlaySongBloc, PlaySongState>(
                builder: (context, state) {
                  Duration duration = const Duration();
                  Duration position = const Duration();
                  if (state is DurationState) {

                    position = state.start;
                    duration = state.finish;
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        maxLines: 1,
                        duration.toString().split(".")[0],
                      ),
                      Text(
                        maxLines: 1,
                        position.toString().split(".")[0],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () async {
                        Duration duration = const Duration(seconds: 10);
                        locator.get<AudioPlayer>().seek(
                            locator.get<AudioPlayer>().position + duration);
                      },
                      icon: Image.asset(
                        "assets/icon/ten(2).png",
                        color: themeProvider.isDarkMode
                            ? Colors.white
                            : const Color(0xff8f969d),
                        width: 35,
                        height: 35,
                      )),
                  BlocBuilder<FavoriteBloc, FavoriteState>(
                    builder: (context, state) {
                      return Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: themeProvider.isDarkMode
                                ? const Color(0xffff435e)
                                : const Color(0xfff5d9e3),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: IconButton(
                            onPressed: () async {
                              locator.get<AudioPlayer>().seekToPrevious();
                              ChangeAnimation().toggleAnimation(
                                _animationController,
                              );
                              if (isFavorite) {
                                locator
                                    .get<CheckFavorite>()
                                    .check(null, context, isFavorite);
                              } else {
                                locator.get<CheckFavorite>().check(
                                    play
                                        .songs![locator
                                            .get<AudioPlayer>()
                                            .currentIndex!]
                                        .data,
                                    context,
                                    isFavorite);
                              }
                            },
                            icon: Image.asset(
                              "assets/icon/music-player(1).png",
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : const Color(0xffff435e),
                              width: 35,
                              height: 35,
                            )),
                      );
                    },
                  ),
                  BlocBuilder<PlaySongBloc, PlaySongState>(
                    builder: (context, state) {
                      return Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: themeProvider.isDarkMode
                                ? const Color(0xffff435e)
                                : const Color(0xfff5d9e3),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: IconButton(
                            onPressed: () async {
                              if (locator.get<AudioPlayer>().playing) {
                                locator.get<AudioPlayer>().pause();
                              } else {
                                locator.get<AudioPlayer>().play();
                              }
                              BlocProvider.of<PlaySongBloc>(context)
                                  .add(PausePlayEvent());
                              ChangeAnimation().toggleAnimation(
                                _animationController,
                              );
                            },
                            icon: Image.asset(
                              locator.get<AudioPlayer>().playing
                                  ? "assets/icon/pause.png"
                                  : "assets/icon/play-button.png",
                              width: 30,
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : const Color(0xffff435e),
                            )),
                      );
                    },
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: themeProvider.isDarkMode
                            ? const Color(0xffff435e)
                            : const Color(0xfff5d9e3),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: IconButton(
                        onPressed: () async {
                          locator.get<AudioPlayer>().seekToNext();
                          ChangeAnimation().toggleAnimation(
                            _animationController,
                          );
                          if (isFavorite) {
                            locator
                                .get<CheckFavorite>()
                                .check(null, context, isFavorite);
                          } else {
                            locator.get<CheckFavorite>().check(
                                play
                                    .songs![locator
                                        .get<AudioPlayer>()
                                        .currentIndex!]
                                    .data,
                                context,
                                isFavorite);
                          }
                        },
                        icon: Image.asset(
                          "assets/icon/music-player(3).png",
                          color: themeProvider.isDarkMode
                              ? Colors.white
                              : const Color(0xffff435e),
                          width: 35,
                          height: 35,
                        )),
                  ),
                  BlocBuilder<PlayNewSongBloc, PlayNewSongState>(
                    builder: (context, state) {
                      return IconButton(
                          onPressed: () {
                            shuffle = !shuffle;
                            locator.get<AudioPlayer>().setShuffleModeEnabled(
                                shuffle == false ? false : true);
                            BlocProvider.of<PlayNewSongBloc>(context)
                                .add(ChangIconEvent());
                          },
                          icon: Image.asset(
                            shuffle
                                ? "assets/icon/shuffle.png"
                                : "assets/icon/repeat.png",
                            width: 30,
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : const Color(0xff8f969d),
                          ));
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Row(
                children: [
                  Text(
                    "Favorite Song",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "ibm",
                        fontSize: 20),
                  ),
                ],
              ),
              ValueListenableBuilder(
                valueListenable: favorite.listenable(),
                builder: (context, Box box, child) {
                  if (box.values.isEmpty) {
                    return const Center(
                        child: Padding(
                      padding: EdgeInsets.all(50.0),
                      child: Text(
                        'Song not found',
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ));
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: box.length,
                      itemBuilder: (BuildContext context, int index) {
                        final playlist = ConcatenatingAudioSource(
                          useLazyPreparation: true,
                          shuffleOrder: DefaultShuffleOrder(),
                          children: [
                            for (int i = 0; i < box.length; i++)
                              AudioSource.uri(Uri.parse(box.getAt(i).path),
                                  tag: MediaItem(
                                    id: '${box.getAt(i).id}',
                                    album: "",
                                    title: box.getAt(i).title!,
                                    artUri:
                                        Uri.parse(box.getAt(i).id.toString()),
                                  )),
                          ],
                        );
                        final themeProvider =
                            Provider.of<ThemeProvider>(context);
                        return Column(
                          children: [
                            Container(
                              color: themeProvider.isDarkMode
                                  ? const Color(0xff1a1b1d)
                                  : locator.get<MyThemes>().cContainerSong,
                              child: ListTile(
                                trailing: Image.asset(
                                  "assets/icon/heart.png",
                                  color: Colors.red,
                                  width: 25,
                                  height: 25,
                                ),
                                title: Text(
                                  favorite.getAt(index).title!,
                                  style: locator.get<MyThemes>().title(context),
                                  maxLines: 1,
                                ),
                                subtitle: Text(
                                  favorite.getAt(index).artist!,
                                  style:
                                      locator.get<MyThemes>().subTitle(context),
                                  maxLines: 1,
                                ),
                                leading: QueryArtworkWidget(
                                    artworkWidth: 60,
                                    artworkHeight: 60,
                                    artworkFit: BoxFit.cover,
                                    artworkBorder: const BorderRadius.all(
                                        Radius.circular(5)),
                                    id: favorite.getAt(index).id!,
                                    type: ArtworkType.AUDIO),
                                onTap: () async {
                                  List<String> paths = [];
                                  for (int i = 0; i < box.length; i++) {
                                    paths.add(box.getAt(i).path);
                                  }
                                  List<SongModel> songs = await locator
                                      .get<SongList>()
                                      .getSongBox(paths);
                                  songs == songs.reversed;
                                  locator
                                      .get<InfoPage>()
                                      .setInfo(playlist, index, songs, box);
                                  locator
                                      .get<PlayNewSong>()
                                      .newSong(index, context, playlist, false);
                                  isFavorite = true;
                                  locator
                                      .get<CheckFavorite>()
                                      .check("", context, isFavorite);
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        );
                      },
                    );
                  }
                },
              )
            ],
          ),
        ),
      ],
    )));
  }

  void changeSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    locator.get<AudioPlayer>().seek(duration);
  }

}
