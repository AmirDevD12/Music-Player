import 'package:first_project/bloc/favorite_song/favorite_bloc.dart';
import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:first_project/bloc/sort/sort_song_bloc.dart';
import 'package:first_project/locator.dart';
import 'package:first_project/model/chengeAnimation.dart';
import 'package:first_project/model/dataBase/favorite_dataBase/favorite_song.dart';
import 'package:first_project/model/newSong.dart';
import 'package:first_project/core/theme/theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../bloc/play_song_bloc.dart';

class PlayPage extends StatefulWidget {
  final ConcatenatingAudioSource? concatenatingAudioSource;
  final int index;
  final bool play;
  final List<SongModel> songs;

  const PlayPage({
    super.key,
    required this.play,
    required this.concatenatingAudioSource,
    required this.index,
    required this.songs,

  });

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool isPlaying = true;
  bool like = true;
  bool shuffle = false;
  late List<SongModel> songs;

  int? next = 0;
  @override
  void initState() {
    if (widget.play) {
      PlayNewSong().newSong(
          widget.index, context, widget.concatenatingAudioSource, false);
    } else {
      PlayNewSong().newSong(
          widget.index, context, widget.concatenatingAudioSource, false);
    }
    checkFavorite(
        widget.songs[locator.get<AudioPlayer>().currentIndex!], context);
    next = locator.get<AudioPlayer>().currentIndex;
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
    ChangeAnimation().toggleAnimation(_animationController, isPlaying);
  }

  @override
  void dispose() {
    _animationController.dispose();
    Navigator.pop(context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {},
                  icon: Image.asset(
                    "assets/icon/dots.png",
                    color:
                        themeProvider.isDarkMode ? Colors.white : Colors.black,
                    width: 25,
                    height: 25,
                  )),
              BlocBuilder<PlayNewSongBloc, PlayNewSongState>(
                buildWhen: (privioce, current) {
                  if (current is NewSongState) {
                    return true;
                  } else {
                    return false;
                  }
                },
                builder: (context, state) {
                  return BlocBuilder<PlaySongBloc, PlaySongState>(
                    buildWhen: (privioce, current) {
                      if (current is PausePlayState) {
                        return true;
                      } else {
                        return false;
                      }
                    },
                    builder: (context, state) {
                      return IconButton(
                          onPressed: () {
                            if (locator.get<AudioPlayer>().currentIndex ==
                                widget.index) {
                              BlocProvider.of<PlayNewSongBloc>(context)
                                  .add(NewSongEvent(
                                widget.index,
                              ));
                            }
                            BlocProvider.of<PlaySongBloc>(context)
                                .add(ShowEvent(isPlaying, widget.songs));

                            _animationController.dispose();
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
                  BlocBuilder<PlayNewSongBloc, PlayNewSongState>(
                    buildWhen: (privioce, current) {
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
                          child: CircleAvatar(
                            backgroundColor:Colors.white ,
                            radius: 130,
                            child: Center(
                              child: QueryArtworkWidget(
                                  artworkBorder: const BorderRadius.all(
                                      Radius.circular(120)),
                                  artworkWidth: 252,
                                  artworkHeight: 252,
                                  id: widget
                                      .songs[locator
                                          .get<AudioPlayer>()
                                          .currentIndex!]
                                      .id,
                                  type: ArtworkType.AUDIO),
                            ),
                          ));
                    },
                  )
                ],
              ),
              Row(

                children: [
                  BlocBuilder<PlayNewSongBloc, PlayNewSongState>(
                    buildWhen: (privioce, current) {
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
                          title: Text(
                              style: locator.get<MyThemes>().title(context),
                              maxLines: 1,
                              widget
                                  .songs[
                                      locator.get<AudioPlayer>().currentIndex!]
                                  .title),
                          subtitle: Text(
                              style: locator.get<MyThemes>().subTitle(context),
                              maxLines: 1,
                              widget
                                      .songs[locator
                                          .get<AudioPlayer>()
                                          .currentIndex!]
                                      .artist ??
                                  ""),
                        ),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: BlocBuilder<PlaySongBloc, PlaySongState>(
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
                        Text(maxLines: 1, position.toString().split(".")[0]),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.add_circle_outline,
                        size: 40,
                        color: themeProvider.isDarkMode
                            ? Colors.white
                            : Color(0xff8f969d),
                      )),
                  BlocBuilder<SortSongBloc, SortSongState>(
                    builder: (context, state) {
                      SongSortType sortSong = SongSortType.TITLE;
                      if (state is SortByAddState) {
                        sortSong = state.songSortType;
                      }
                      return BlocBuilder<PlayNewSongBloc, PlayNewSongState>(
                        buildWhen: (privioc, current) {
                          if (current is ChangIconState ||
                              current is PauseAnimationState) {
                            return false;
                          } else {
                            return true;
                          }
                        },
                        builder: (context, state) {
                          return Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: themeProvider.isDarkMode?const Color(0xffff435e):Color(0xfff5d9e3),
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            child: IconButton(
                                onPressed: () async {
                                  locator.get<AudioPlayer>().seekToPrevious();

                                  ChangeAnimation().toggleAnimation(
                                      _animationController,
                                      locator.get<AudioPlayer>().playing
                                          ? true
                                          : false);

                                  // ignore: use_build_context_synchronously
                                  BlocProvider.of<PlayNewSongBloc>(context).add(
                                      NewSongEvent(locator
                                          .get<AudioPlayer>()
                                          .currentIndex!));
                                },
                                icon: Image.asset(
                                  "assets/icon/music-player(1).png",
                                  color: themeProvider.isDarkMode
                                      ? Colors.white
                                      : Color(0xffff435e),
                                  width: 35,
                                  height: 35,
                                )),
                          );
                        },
                      );
                    },
                  ),
                  BlocBuilder<PlaySongBloc, PlaySongState>(
                    builder: (context, state) {
                      return IconButton(
                          onPressed: () async {
                            if (isPlaying) {
                              locator.get<AudioPlayer>().pause();
                            } else {
                              locator.get<AudioPlayer>().play();
                            }
                            isPlaying = !isPlaying;

                            BlocProvider.of<PlaySongBloc>(context)
                                .add(PausePlayEvent());
                            ChangeAnimation().toggleAnimation(
                                _animationController, isPlaying ? true : false);
                          },
                          icon: Image.asset(
                            isPlaying
                                ? "assets/icon/pause.png"
                                : "assets/icon/play-button.png",
                            width: 50,

                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : const Color(0xffff435e),
                          ));
                    },
                  ),
                  BlocBuilder<SortSongBloc, SortSongState>(
                    builder: (context, state) {
                      SongSortType sortSong = SongSortType.TITLE;
                      if (state is SortByAddState) {
                        sortSong = state.songSortType;
                      }
                      return BlocBuilder<PlayNewSongBloc, PlayNewSongState>(
                        buildWhen: (privioc, current) {
                          if (current is ChangIconState ||
                              current is PauseAnimationState) {
                            return false;
                          } else {
                            return true;
                          }
                        },
                        builder: (context, state) {
                          if (state is NewSongState) {}
                          return Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color:themeProvider.isDarkMode?const Color(0xffff435e): Color(0xfff5d9e3),
                              borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            child: IconButton(
                                onPressed: () async {
                                  locator.get<AudioPlayer>().seekToNext();
                                  ChangeAnimation().toggleAnimation(
                                      _animationController,
                                      locator.get<AudioPlayer>().playing
                                          ? true
                                          : false);
                                  BlocProvider.of<PlayNewSongBloc>(context).add(
                                      NewSongEvent(locator
                                          .get<AudioPlayer>()
                                          .currentIndex!));
                                },
                                icon: Image.asset(
                                  "assets/icon/music-player(3).png",
                                  color: themeProvider.isDarkMode
                                      ? Colors.white
                                      : const Color(0xffff435e),
                                  width: 35,
                                  height: 35,
                                )),
                          );
                        },
                      );
                    },
                  ),
                  BlocBuilder<PlayNewSongBloc, PlayNewSongState>(
                    builder: (context, state) {
                      return IconButton(
                          onPressed: () {
                            shuffle = !shuffle;
                            if (!shuffle) {
                              locator.get<AudioPlayer>().shuffle();
                            }
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
                                : Color(0xff8f969d),
                          ));
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
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

  add(SongModel songModel, BuildContext context) async {
    var box = await Hive.openBox<FavoriteSong>("Favorite");
    FavoriteSong favorite = FavoriteSong(
        songModel.title, songModel.data, songModel.id, songModel.artist!);
    await box.add(favorite);
    // ignore: use_build_context_synchronously
    BlocProvider.of<FavoriteBloc>(context).add(FavoriteSongEvent(true));
  }
}

void deleteFavorite(SongModel songModel, BuildContext context) {
  Box favorite = Hive.box<FavoriteSong>("Favorite");
  for (int i = 0; i < favorite.length; i++) {
    final FavoriteSong favoriteSongs = favorite.getAt(i);
    if (favoriteSongs.path == songModel.data &&
        favoriteSongs.id == songModel.id) {
      favorite.deleteAt(i);
      BlocProvider.of<FavoriteBloc>(context).add(FavoriteSongEvent(false));
      return;
    }
  }
}

checkFavorite(SongModel songModel, BuildContext context) {
  Box favorite = Hive.box<FavoriteSong>("Favorite");
  bool check = false;
  for (int i = 0; i < favorite.length; i++) {
    final FavoriteSong favoriteSongs = favorite.getAt(i);
    if (favoriteSongs.path == songModel.data &&
        favoriteSongs.id == songModel.id) {
      BlocProvider.of<FavoriteBloc>(context).add(FavoriteSongEvent(true));
      check = true;
      return;
    }
    if (!check) {
      BlocProvider.of<FavoriteBloc>(context).add(FavoriteSongEvent(false));
    }
  }
}
