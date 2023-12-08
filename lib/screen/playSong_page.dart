import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:first_project/model/newSong.dart';
import 'package:first_project/model/songs_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../bloc/play_song_bloc.dart';

class PlayPage extends StatefulWidget {
  final SongModel songModel;
  final AudioPlayer audioPlayer;

  const PlayPage(
      {super.key, required this.songModel, required this.audioPlayer,});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool isPlaying = true;
  bool _isAnimating= false;
  SongList songList = SongList();
  final playlistss = ConcatenatingAudioSource(
    useLazyPreparation: true,
    shuffleOrder: DefaultShuffleOrder(),
    children: [
      AudioSource.uri(Uri.parse('https://example.com/track1.mp3')),
      AudioSource.uri(Uri.parse('https://example.com/track2.mp3')),
      AudioSource.uri(Uri.parse('https://example.com/track3.mp3')),
    ],
  );

  @override
  void initState() {
    // TODO: implement initState

    PlayNewSong().newSong(widget.songModel.uri, widget.audioPlayer, context);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 5 ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
  } @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  void _toggleAnimation() {
    playlistss.children;
    _isAnimating = !_isAnimating;
    if (_isAnimating) {
      _animationController.stop();
      BlocProvider.of<PlayNewSongBloc>(context).add(PauseAnimationEvent());

    } else {
      _animationController.repeat();
      BlocProvider.of<PlayNewSongBloc>(context).add(PauseAnimationEvent());
    }
    BlocProvider.of<PlayNewSongBloc>(context).add(PauseAnimationEvent());
  }
  int number = 0;
  int id = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1a1b1d),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.white,
                        size: 40,
                      )),
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
                  Transform.rotate(
                    angle: 10,
                    child: BlocBuilder<PlayNewSongBloc, PlayNewSongState>(
                      buildWhen: (privioce,current){
                        if (current is PauseAnimationState) {
                          return false;
                        }  else {
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
                            backgroundImage: const AssetImage("assets/icon/vinyl-record.png"),
                            radius: 120,
                            child: Center(
                              child: QueryArtworkWidget(
                                  artworkBorder:
                                  const BorderRadius.all(Radius.circular(100)),
                                  artworkWidth: 200,
                                  artworkHeight: 200,
                                  id: state is NewSongState ||state is PauseAnimationState&&id!=0
                                      ? id
                                      : widget.songModel.id,
                                  type: ArtworkType.AUDIO),
                            ),
                          )

                        );
                      },
                    ),
                  )
                ],
              ),

              Row(
              children: [
              SizedBox(
              width: 300,
              child: BlocBuilder<PlayNewSongBloc, PlayNewSongState>(
                builder: (context, state) {
                   String title="";
                   String disName="";
                  if (state is NewSongState) {
                    title = state.name;
                    disName = state.artist;
                  }
                  return ListTile(
                    title: Text(maxLines: 1,
                      state is NewSongState||state is PauseAnimationState&&id!=0
                          ? title
                          : widget.songModel.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(maxLines: 1,
                      state is NewSongState ||state is PauseAnimationState&&id!=0
                          ? disName
                          : widget.songModel.displayNameWOExt,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: IconButton(
                  onPressed: () {}, icon: Image.asset("assets/icon/like.png",width: 25,height: 25,color: Colors.white,)),
            )
          ],
        ),
        Row(
          children: [
            Expanded(child: BlocBuilder<PlaySongBloc, PlaySongState>(
              builder: (context, state) {
                Duration duration = const Duration();
                Duration position = const Duration();
                if (state is DurationState) {
                  position=state.start;
                  duration=state.finish;
                }
                return Slider(
                  activeColor: Colors.white,
                  inactiveColor: Colors.grey,
                  value: duration.inSeconds.toDouble(),
                  max: position.inSeconds.toDouble(),
                  min: const Duration(milliseconds: 0)
                      .inSeconds
                      .toDouble(),
                  onChanged: (value) {
                    changeSeconds(value.toInt());
                    value = value;
                    BlocProvider.of<PlaySongBloc>(context).add(
                        DurationEvent(position,
                            duration));
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
                position=state.start;
                duration=state.finish;
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(maxLines: 1,duration.toString().split(".")[0],style: const TextStyle(color: Colors.white),),
                  Text(maxLines: 1,position.toString().split(".")[0],style: const TextStyle(color: Colors.white),),
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
                icon:Image.asset("assets/icon/shuffle.png",width: 35,height: 35,color: Colors.white,) ),
            BlocBuilder<PlayNewSongBloc, PlayNewSongState>(
              builder: (context, state) {

                if (state is NewSongState) {
                  number = state.index;
                }
                return IconButton(
                    onPressed: () async {
                      if (_isAnimating!=false) {
                        _toggleAnimation();
                      }
                      List<SongModel> songs = await songList.getSongs(SongSortType.TITLE);
                      PlayNewSong().newSong(songs[number -1].uri, widget.audioPlayer, context);
                      if (!isPlaying) {
                        isPlaying=true;
                      }
                      // newSong(songs[number - 1].uri);
                      BlocProvider.of<PlayNewSongBloc>(context).add(
                          NewSongEvent(
                              songs[number - 1].id,
                              songs[number - 1].title,
                              songs[number - 1].displayName,
                              number - 1));
                    },
                    icon: Image.asset("assets/icon/music-player(1).png",width: 35,height: 35,color: Colors.white,));
              },
            ),
            BlocBuilder<PlaySongBloc, PlaySongState>(
              builder: (context, state) {
                return IconButton(
                    onPressed: () {
                      _toggleAnimation();
                      if (isPlaying) {
                        widget.audioPlayer.pause();
                      } else {
                        widget.audioPlayer.play();
                      }
                      isPlaying = !isPlaying;
                      BlocProvider.of<PlaySongBloc>(context)
                          .add(PausePlayEvent());
                    },
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 45,
                      color: Colors.white,
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
                      if (_isAnimating!=false) {
                        _toggleAnimation();
                      }
                      List<SongModel> songs = await songList.getSongs(SongSortType.TITLE);
                      PlayNewSong().newSong(songs[number +1].uri, widget.audioPlayer, context);
                      // newSong(songs[number + 1].uri);
                      if (!isPlaying) {
                        isPlaying=true;
                      }
                      BlocProvider.of<PlayNewSongBloc>(context).add(
                          NewSongEvent(
                              songs[number + 1].id,
                              songs[number + 1].title,
                              songs[number + 1].displayName,
                              number + 1));
                    },
                    icon: Image.asset("assets/icon/music-player(3).png",width: 35,height: 35,color: Colors.white,)
                );
              },
            ),
            IconButton(
                onPressed: () {},
                icon: Image.asset("assets/icon/repeat.png",width: 35,height: 35,color: Colors.white,)),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.menu,
                  size: 40,
                  color: Colors.white,
                )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.add_circle_outline,
                  size: 40,
                  color: Colors.white,
                )),
          ],
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
    )],
    )
    )
    );
  }
  void changeSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }
}
