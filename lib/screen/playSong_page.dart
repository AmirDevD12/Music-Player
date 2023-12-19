import 'package:first_project/bloc/favorite_song/favorite_bloc.dart';
import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:first_project/locator.dart';
import 'package:first_project/model/chengeAnimation.dart';
import 'package:first_project/model/favorite_song.dart';
import 'package:first_project/model/newSong.dart';
import 'package:first_project/model/songs_model.dart';
import 'package:first_project/core/theme/theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../bloc/play_song_bloc.dart';

class PlayPage extends StatefulWidget {
  final SongModel songModel;
  final AudioPlayer audioPlayer;

  const PlayPage({
    super.key,
    required this.songModel,
    required this.audioPlayer,
  });

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool isPlaying = true;
  bool like=true;
  @override
  void initState() {

    checkFavorite(widget.songModel,context);
    PlayNewSong().newSong(widget.songModel.uri, widget.audioPlayer, context);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
    ChangeAnimation().toggleAnimation(_animationController, isPlaying);
    BlocProvider.of<PlayNewSongBloc>(context).add(PauseAnimationEvent());
  }

  @override
  void dispose() {
    BlocProvider.of<PlaySongBloc>(context)
        .add(ShowEvent(widget.songModel, isPlaying));
    _animationController.dispose();
    Navigator.pop(context);
    super.dispose();
  }

  int number = 0;
  int id = 0;
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
              BlocBuilder<PlaySongBloc, PlaySongState>(
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
                        BlocProvider.of<PlaySongBloc>(context)
                            .add(ShowEvent(widget.songModel, isPlaying));
                        _animationController.dispose();
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 40,
                      ));
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
                      if (current is PauseAnimationState) {
                        return false;
                      } else {
                        return true;
                      }
                    },
                    builder: (context, state) {
                      if (state is NewSongState) {
                        id = state.id;
                      }
                      return RotationTransition(
                          turns: _animation,
                          child: CircleAvatar(
                            backgroundImage: const AssetImage(
                                "assets/icon/vinyl-record.png"),
                            radius: 120,
                            child: Center(
                              child: QueryArtworkWidget(
                                  artworkBorder: const BorderRadius.all(
                                      Radius.circular(100)),
                                  artworkWidth: 200,
                                  artworkHeight: 200,
                                  id: state is NewSongState ||
                                          state is PauseAnimationState &&
                                              id != 0
                                      ? id
                                      : widget.songModel.id,
                                  type: ArtworkType.AUDIO),
                            ),
                          ));
                    },
                  )
                ],
              ),

              Row(
                children: [
                  SizedBox(
                    width: 300,
                    child: BlocBuilder<PlayNewSongBloc, PlayNewSongState>(
                      buildWhen: (privioce, current) {
                        if (current is PauseAnimationState) {
                          return false;
                        } else {
                          return true;
                        }
                      },
                      builder: (context, state) {
                        final themeProvider =
                            Provider.of<ThemeProvider>(context);
                        String title = "";
                        String disName = "";
                        if (state is NewSongState) {
                          title = state.name;
                          disName = state.artist;
                        }
                        return ListTile(
                          title: Text(
                            style: TextStyle(
                                color: themeProvider.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontFamily: "ibm",
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            maxLines: 1,
                            state is NewSongState ||
                                    state is PauseAnimationState && id != 0
                                ? title
                                : widget.songModel.title,
                          ),
                          subtitle: Text(
                            style: TextStyle(
                                color: themeProvider.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 18,
                                fontFamily: "ibm"),
                            maxLines: 1,
                            state is NewSongState ||
                                    state is PauseAnimationState && id != 0
                                ? disName
                                : widget.songModel.displayNameWOExt,
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: BlocBuilder<FavoriteBloc, FavoriteState>(
                        builder: (context, state) {
                         if (state is FavoriteSongState) {

                           if (state.like) {
                             like=false;
                           }else{like=true;}
                         }
                          return IconButton(
                            onPressed: () async {
                              like=!like;
                              if (!like) {
                                add(widget.songModel,context);
                              }else{
                                deleteFavorite(widget.songModel,context);
                              }
                            },
                            icon: Image.asset(
                              like?"assets/icon/like.png":"assets/icon/heart.png",
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              width: 25,
                              height: 25,
                            ),
                          );
                        },
                      ))
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
                      }
                      return Slider(
                        activeColor: themeProvider.isDarkMode
                            ? Colors.deepPurple
                            : Color(0xff1a1b1d),
                        inactiveColor: themeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black12,
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
                            : Colors.black,
                      )),
                  BlocBuilder<PlayNewSongBloc, PlayNewSongState>(
                    builder: (context, state) {
                      if (state is NewSongState) {
                        number = state.index;
                      }
                      return IconButton(
                          onPressed: () async {
                            List<SongModel> songs = await locator
                                .get<SongList>()
                                .getSongs(SongSortType.TITLE, null);

                            if (!isPlaying) {
                              isPlaying = true;
                            }
                            ChangeAnimation().toggleAnimation(
                                _animationController, isPlaying ? true : false);
                            // newSong(songs[number - 1].uri);
                            // ignore: use_build_context_synchronously
                            BlocProvider.of<PlayNewSongBloc>(context).add(
                                NewSongEvent(
                                    songs[number - 1].id,
                                    songs[number - 1].title,
                                    songs[number - 1].displayName,
                                    number - 1));
                            // ignore: use_build_context_synchronously
                            PlayNewSong().newSong(songs[number - 1].uri,
                                widget.audioPlayer, context);
                          },
                          icon: Image.asset(
                            "assets/icon/music-player(1).png",
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            width: 35,
                            height: 35,
                          ));
                    },
                  ),
                  BlocBuilder<PlaySongBloc, PlaySongState>(
                    builder: (context, state) {
                      return IconButton(
                          onPressed: () async {
                            if (isPlaying) {
                              widget.audioPlayer.pause();
                            } else {
                              widget.audioPlayer.play();
                            }
                            isPlaying = !isPlaying;

                            BlocProvider.of<PlaySongBloc>(context)
                                .add(PausePlayEvent());
                            ChangeAnimation().toggleAnimation(
                                _animationController, isPlaying ? true : false);
                          },
                          icon: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 40,
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ));
                    },
                  ),
                  BlocBuilder<PlayNewSongBloc, PlayNewSongState>(
                    builder: (context, state) {
                      if (state is NewSongState) {
                        number = state.index;
                      }
                      return IconButton(
                          onPressed: () async {
                            List<SongModel> songs = await locator
                                .get<SongList>()
                                .getSongs(SongSortType.TITLE, null);
                            PlayNewSong().newSong(songs[number + 1].uri,
                                widget.audioPlayer, context);
                            // newSong(songs[number + 1].uri);
                            if (!isPlaying) {
                              isPlaying = true;
                            }
                            ChangeAnimation().toggleAnimation(
                                _animationController, isPlaying ? true : false);
                            BlocProvider.of<PlayNewSongBloc>(context).add(
                                NewSongEvent(
                                    songs[number + 1].id,
                                    songs[number + 1].title,
                                    songs[number + 1].displayName,
                                    number + 1));
                          },
                          icon: Image.asset(
                            "assets/icon/music-player(3).png",
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            width: 35,
                            height: 35,
                          ));
                    },
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        "assets/icon/repeat.png",
                        color: themeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black,
                        width: 35,
                        height: 35,
                      )),
                ],
              ),
              const SizedBox(
                height: 20,
              ),

              // FutureBuilder<List<SongModel>>(
              //   future: SongList().getSongs(),
              //   builder: (BuildContext context,
              //       AsyncSnapshot<List<SongModel>> snapshot) {
              //     if (snapshot.hasData) {
              //       return ListView.builder(
              //         shrinkWrap: true,
              //         physics:const NeverScrollableScrollPhysics() ,
              //         itemCount: snapshot.data?.length,
              //         itemBuilder: (BuildContext context, int index) {
              //           return ListTile(
              //             title: Text(maxLines: 1,snapshot.data![index].title,
              //               style: const TextStyle(
              //                   color: Colors.white,
              //                   fontSize: 20,
              //                   fontWeight: FontWeight.bold),),
              //             subtitle:
              //             Text(maxLines: 1,snapshot.data![index].displayName,
              //               style: const TextStyle(
              //
              //                   fontSize: 17,
              //                   fontWeight: FontWeight.bold),),
              //             leading: QueryArtworkWidget(
              //                 id: snapshot.data![index].id,
              //                 type: ArtworkType.AUDIO),
              //             onTap: () {
              //               if (_isAnimating!=false) {
              //                 _toggleAnimation();
              //                 isPlaying=true;
              //               }
              //               PlayNewSong().newSong(snapshot.data![index].uri, widget.audioPlayer, context);
              //               // newSong(snapshot.data![index].uri);
              //               BlocProvider.of<PlayNewSongBloc>(context).add(
              //                   NewSongEvent(
              //                       snapshot.data![index].id,
              //                       snapshot.data![index].title,
              //                       snapshot.data![index].displayName,
              //                       index));
              //
              //             },
              //           );
              //         },
              //       );
              //     } else if (snapshot.hasError) {
              //       return Text('Error: ${snapshot.error}');
              //     }
              //     return const CircularProgressIndicator();
              //   },
              // ),
            ],
          ),
        )
      ],
    )));
  }
  void changeSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }
  add(SongModel songModel,BuildContext context) async {
    var box = await Hive.openBox<FavoriteSong>("Favorite");
    FavoriteSong favorite = FavoriteSong(songModel.title,songModel.data,songModel.id,songModel.artist!);
    await  box.add(favorite);
    BlocProvider.of<FavoriteBloc>(context).add(FavoriteSongEvent(true));
  }

}

void deleteFavorite(SongModel songModel,BuildContext context) {
  Box favorite = Hive.box<FavoriteSong>("Favorite");
  for(int i=0; i<favorite.length;i++) {
    final FavoriteSong favoriteSongs = favorite.getAt(i);
    if (favoriteSongs.path == songModel.data &&
        favoriteSongs.id == songModel.id) {
      favorite.deleteAt(i);
      BlocProvider.of<FavoriteBloc>(context).add(FavoriteSongEvent(false));
      return;
    }
  }
}

 checkFavorite(SongModel songModel,BuildContext context) {
  Box favorite = Hive.box<FavoriteSong>("Favorite");
  bool check=false;
  for(int i=0; i<favorite.length;i++){
    final FavoriteSong favoriteSongs = favorite.getAt(i);
    if (favoriteSongs.path==songModel.data&&favoriteSongs.id==songModel.id) {
    BlocProvider.of<FavoriteBloc>(context).add(FavoriteSongEvent(true));
    check=true;
    return ;
    }
    if (!check) {
      BlocProvider.of<FavoriteBloc>(context).add(FavoriteSongEvent(false));}
    }
}
