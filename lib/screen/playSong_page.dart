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
  Box favorite = Hive.box<FavoriteSong>("Favorite");
  bool isFavorite=false;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
              const Text("New Song",style: TextStyle(fontSize: 25,fontFamily: "ibm",fontWeight: FontWeight.bold),),
              BlocBuilder<FavoriteBloc, FavoriteState>(
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
                        add(
                            widget.songs[
                            locator.get<AudioPlayer>().currentIndex!],
                            context);
                      } else {
                        deleteFavorite(
                            widget.songs[
                            locator.get<AudioPlayer>().currentIndex!],
                            context);
                      }
                    },
                    icon: Image.asset(
                      like
                          ? "assets/icon/like.png"
                          : "assets/icon/heart.png",
                      color: like ? Colors.red : Colors.red,
                      width: 25,
                      height: 25,
                    ),
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
                    buildWhen:(priviuse,current){
                      if(current is PlayFavoriteState){return true;}
                      else{return false;}
                    },
  builder: (context, state) {
    return BlocBuilder<PlayNewSongBloc, PlayNewSongState>(
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
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(130)),
                                boxShadow: [
                                  BoxShadow(
                                    color:themeProvider.isDarkMode? Colors.grey:const Color(0xff1a1b1d) ,
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  )
                                ]
                            ),
                            child: CircleAvatar(
                              backgroundColor:Colors.white ,
                              radius: 120,
                              child: Center(
                                child: QueryArtworkWidget(
                               nullArtworkWidget: Image.asset("assets/icon/vinyl-record.png"),
                                  keepOldArtwork: true,
                                    artworkBorder: const BorderRadius.all(
                                        Radius.circular(120)),
                                    artworkWidth: 252,
                                    artworkHeight: 252,
                                    id:isFavorite==false? widget
                                        .songs[locator
                                            .get<AudioPlayer>()
                                            .currentIndex!]
                                        .id:favorite.getAt(locator.get<AudioPlayer>().currentIndex!).id,
                                    type: ArtworkType.AUDIO),
                              ),
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
                    buildWhen:(priviuse,current){
                      if(current is PlayFavoriteState){return true;}
                      else{return false;}
                    },
  builder: (context, state) {
    return BlocBuilder<PlayNewSongBloc, PlayNewSongState>(
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
                          title: Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  style: locator.get<MyThemes>().title(context),
                                  maxLines: 1,
                                 isFavorite==false? widget
                                      .songs[
                                          locator.get<AudioPlayer>().currentIndex!]
                                      .title:favorite.getAt(locator.get<AudioPlayer>().currentIndex!).title.toString()??""),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  style: locator.get<MyThemes>().subTitle(context),
                                  maxLines: 1,
                                  isFavorite==false?  widget
                                          .songs[locator
                                              .get<AudioPlayer>()
                                              .currentIndex!]
                                          .artist ??
                                      "":favorite.getAt(locator.get<AudioPlayer>().currentIndex!).artist.toString()??""),
                            ],
                          ),
                        ),
                      );
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
                      onPressed: () {
                        Duration durationSeek=Duration(seconds: 10);
                        locator.get<AudioPlayer>().setShuffleModeEnabled(false);
                      },
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
                                borderRadius: const BorderRadius.all(Radius.circular(10))
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
                              borderRadius: const BorderRadius.all(Radius.circular(10))
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
                            locator.get<AudioPlayer>().setShuffleModeEnabled(shuffle==false?false:true);
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
            Row(
              children: [
                Text("Favorite Song",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "ibm",fontSize: 20),),
              ],
            ),
            ValueListenableBuilder(
              valueListenable:favorite.listenable(),
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
                          for(int i=0;i<box.length!;i++)
                            AudioSource.uri(Uri.parse(box.getAt(i).path)),
                        ],
                      );
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
                          favorite.getAt(index).title!,
                          style: locator.get<MyThemes>().title(context),
                          maxLines: 1,
                        ),
                        subtitle: Text(
                          favorite.getAt(index).artist!,
                          style: locator.get<MyThemes>().subTitle(context),
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
                          PlayNewSong().newSong(
                              index, context,playlist , false);
                          isFavorite=true;
                          BlocProvider.of<FavoriteBloc>(context).add(PlayFavoriteEvent());
                        },
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
