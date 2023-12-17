<<<<<<< HEAD
import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:first_project/locator.dart';
import 'package:first_project/model/chengeAnimation.dart';
import 'package:first_project/model/newSong.dart';
import 'package:first_project/model/songs_model.dart';
import 'package:first_project/core/theme/theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  final SongModel songModel;
  const BottomNavigationBarScreen({super.key, required this.songModel});

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen>
    with TickerProviderStateMixin {
  bool isPlaying = true;
  late AnimationController _animationController;
  late AnimationController _animationMusic;

  late Animation<double> _animation;
  late Animation<double> _SpeedAnimation;
  int id = 0;
  int number = 0;
  @override
  void initState() {
    // TODO: implement initState
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
    _animationMusic = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationMusic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      height: 60,
      decoration: BoxDecoration(
          color:
              themeProvider.isDarkMode ?  Colors.deepPurple: const Color(0xff1a1b1d),
          borderRadius: const BorderRadius.all(Radius.circular(0))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              BlocBuilder<PlaySongBloc, PlaySongState>(
                builder: (context, state) {
                  if (state is ShowNavState) {
                      isPlaying = state.play;
                      ChangeAnimation().toggleAnimation(
                          _animationController, isPlaying ? true : false);
                  }
                  return IconButton(
                      onPressed: () async {
                        if (isPlaying) {
                          locator.get<AudioPlayer>().stop();
                        } else {
                          locator.get<AudioPlayer>().play();
                        }
                        isPlaying = !isPlaying;
                        BlocProvider.of<PlaySongBloc>(context)
                            .add(PausePlayEvent());
                        ChangeAnimation().toggleAnimation(
                            _animationController, isPlaying ? true : false);
                        ChangeAnimation().toggleAnimation(
                            _animationMusic, isPlaying ? true : false);
                      },
                      icon: Image.asset(
                        !isPlaying
                            ? "assets/icon/play-button-arrowhead.png"
                            : "assets/icon/pause.png",
                        color: Colors.white,
                        width: 35,
                        height: 25,
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
                        List<SongModel> songs =
                            await SongList().getSongs(SongSortType.TITLE,null);
                        // ignore: use_build_context_synchronously
                        PlayNewSong().newSong(songs[number + 1].uri,
                            locator.get<AudioPlayer>(), context);
                        // newSong(songs[number + 1].uri);
                        if (!isPlaying) {
                          isPlaying = true;
                        }
                        // ignore: use_build_context_synchronously
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
                        "assets/icon/music-player(1).png",
                        color: Colors.white,
                        width: 35,
                        height: 30,
                      ));
                },
              ),
            ],
          ),
          Row(
            children: [
             Center(
                 child: Lottie.asset('assets/animation/Animation - 1702455265848.json',
                 controller: _animationMusic,

                 ),),
            ],
          ),
          Row(
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
                        backgroundImage:
                            const AssetImage("assets/icon/vinyl-record.png"),
                        radius: 30,
                        child: Center(
                          child: QueryArtworkWidget(
                              artworkBorder:
                                  const BorderRadius.all(Radius.circular(100)),
                              artworkWidth: 50,
                              artworkHeight: 50,
                              id: state is NewSongState ||
                                      state is PauseAnimationState && id != 0
                                  ? id
                                  : widget.songModel.id,
                              type: ArtworkType.AUDIO),
                        ),
                      ));
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
=======
import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:first_project/locator.dart';
import 'package:first_project/model/chengeAnimation.dart';
import 'package:first_project/model/newSong.dart';
import 'package:first_project/model/songs_model.dart';
import 'package:first_project/core/theme/theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  final SongModel songModel;
  const BottomNavigationBarScreen({super.key, required this.songModel});

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen>
    with TickerProviderStateMixin {
  bool isPlaying = true;
  late AnimationController _animationController;
  late AnimationController _animationMusic;

  late Animation<double> _animation;
  late Animation<double> _SpeedAnimation;
  int id = 0;
  int number = 0;
  @override
  void initState() {
    // TODO: implement initState
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
    _animationMusic = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationMusic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      height: 60,
      decoration: BoxDecoration(
          color:
              themeProvider.isDarkMode ?  Colors.deepPurple: const Color(0xff1a1b1d),
          borderRadius: const BorderRadius.all(Radius.circular(0))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              BlocBuilder<PlaySongBloc, PlaySongState>(
                builder: (context, state) {
                  if (state is ShowNavState) {
                      isPlaying = state.play;
                      ChangeAnimation().toggleAnimation(
                          _animationController, isPlaying ? true : false);
                  }
                  return IconButton(
                      onPressed: () async {
                        if (isPlaying) {
                          locator.get<AudioPlayer>().stop();
                        } else {
                          locator.get<AudioPlayer>().play();
                        }
                        isPlaying = !isPlaying;
                        BlocProvider.of<PlaySongBloc>(context)
                            .add(PausePlayEvent());
                        ChangeAnimation().toggleAnimation(
                            _animationController, isPlaying ? true : false);
                        ChangeAnimation().toggleAnimation(
                            _animationMusic, isPlaying ? true : false);
                      },
                      icon: Image.asset(
                        !isPlaying
                            ? "assets/icon/play-button-arrowhead.png"
                            : "assets/icon/pause.png",
                        color: Colors.white,
                        width: 35,
                        height: 25,
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
                        List<SongModel> songs =
                            await SongList().getSongs(SongSortType.TITLE,null);
                        // ignore: use_build_context_synchronously
                        PlayNewSong().newSong(songs[number + 1].uri,
                            locator.get<AudioPlayer>(), context);
                        // newSong(songs[number + 1].uri);
                        if (!isPlaying) {
                          isPlaying = true;
                        }
                        // ignore: use_build_context_synchronously
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
                        "assets/icon/music-player(1).png",
                        color: Colors.white,
                        width: 35,
                        height: 30,
                      ));
                },
              ),
            ],
          ),
          Row(
            children: [
             Center(
                 child: Lottie.asset('assets/animation/Animation - 1702455265848.json',
                 controller: _animationMusic,

                 ),),
            ],
          ),
          Row(
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
                        backgroundImage:
                            const AssetImage("assets/icon/vinyl-record.png"),
                        radius: 30,
                        child: Center(
                          child: QueryArtworkWidget(
                              artworkBorder:
                                  const BorderRadius.all(Radius.circular(100)),
                              artworkWidth: 50,
                              artworkHeight: 50,
                              id: state is NewSongState ||
                                      state is PauseAnimationState && id != 0
                                  ? id
                                  : widget.songModel.id,
                              type: ArtworkType.AUDIO),
                        ),
                      ));
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
