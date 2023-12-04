import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:first_project/model/songs_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../bloc/play_song_bloc.dart';

class PlayPage extends StatefulWidget {
  final SongModel songModel;
  final AudioPlayer audioPlayer;
  final int? length;
  const PlayPage(
      {super.key, required this.songModel, required this.audioPlayer, required this.length});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  Duration duration = const Duration();
  Duration position = const Duration();
  bool isPlaying = false;
  bool _isAnimating= false;
  SongList songList = SongList();
  String title = "";
  String disName = "";
  double length =0;
  @override
  void initState() {
    // TODO: implement initState
    length=widget.length!.toDouble();
    length=length*200;
    newSong(widget.songModel.uri);

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

  newSong(String? uri) {
    print(uri);
    try {
      widget.audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      widget.audioPlayer.play();
      isPlaying = true;

      widget.audioPlayer.durationStream.listen((event) {
        duration = event!;
        BlocProvider.of<PlaySongBloc>(context).add(DurationEvent(
          position.inSeconds.toDouble(),
          duration.inSeconds.toDouble(),
        ));
      });
      widget.audioPlayer.positionStream.listen((event) {
        position = event;
        BlocProvider.of<PlaySongBloc>(context).add(DurationEvent(
          position.inSeconds.toDouble(),
          duration.inSeconds.toDouble(),
        ));
      });
    } catch(e) {print(e);}
  }

  int number = 0;
  int id = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
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
                    angle:  position.inSeconds.toDouble(),
                    child: BlocBuilder<PlayNewSongBloc, PlayNewSongState>(
                      builder: (context, state) {bool isId=true;
                        if (state is NewSongState) {
                          id = state.id;

                          if (id==0) {
                            isId=false;
                          }else {isId= true;}
                        }

                        return RotationTransition(
                          turns: _animation,
                          child:isId? QueryArtworkWidget(
                              artworkBorder:
                              BorderRadius.all(Radius.circular(100)),
                              artworkWidth: 200,
                              artworkHeight: 200,
                              id: state is NewSongState ||state is PauseAnimationState&&id!=0
                                  ? id
                                  : widget.songModel.id,
                              type: ArtworkType.AUDIO):
                          RotationTransition(

                              turns: _animation,
                              child: Image.asset("assets/icon/vinyl-record.png",width: 80,height: 80,)),
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

                  if (state is NewSongState) {
                    title = state.name;
                    disName = state.artist;
                  }
                  return ListTile(
                    title: Text(
                      state is NewSongState||state is PauseAnimationState&&id!=0
                          ? title
                          : widget.songModel.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
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
                return Slider(
                  activeColor: Colors.white,
                  inactiveColor: Colors.grey,
                  value: position.inSeconds.toDouble(),
                  max: duration.inSeconds.toDouble(),
                  min: const Duration(milliseconds: 0)
                      .inSeconds
                      .toDouble(),
                  onChanged: (value) {
                    changeSeconds(value.toInt());
                    value = value;
                    BlocProvider.of<PlaySongBloc>(context).add(
                        DurationEvent(position.inSeconds.toDouble(),
                            duration.inSeconds.toDouble()));
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
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(position.toString().split(".")[0],style: const TextStyle(color: Colors.white),),
                  Text(duration.toString().split(".")[0],style: const TextStyle(color: Colors.white),),
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
                int num = 0;
                if (state is NewSongState) {
                  number = state.index;
                }
                return IconButton(
                    onPressed: () async {
                      List<SongModel> songs = await songList.getSongs();
                      newSong(songs[number - 1].uri);
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
                      List<SongModel> songs = await songList.getSongs();
                      newSong(songs[number + 1].uri);
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
        SizedBox(
          height:length??1,
          child: FutureBuilder<List<SongModel>>(
            future: SongList().getSongs(),
            builder: (BuildContext context,
                AsyncSnapshot<List<SongModel>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  physics:const NeverScrollableScrollPhysics() ,
                  itemCount: snapshot.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(snapshot.data![index].title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),),
                      subtitle:
                      Text(snapshot.data![index].displayName,
                        style: const TextStyle(

                            fontSize: 17,
                            fontWeight: FontWeight.bold),),
                      leading: QueryArtworkWidget(
                          id: snapshot.data![index].id,
                          type: ArtworkType.AUDIO),
                      onTap: () {
                        if (_isAnimating!=false) {
                          _toggleAnimation();
                        }
                        newSong(snapshot.data![index].uri);
                        BlocProvider.of<PlayNewSongBloc>(context).add(
                            NewSongEvent(
                                snapshot.data![index].id,
                                snapshot.data![index].title,
                                snapshot.data![index].displayName,
                                index));
                      },
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
        ],
      ),
    )],
    )
    ,
    )
    ,
    );
  }

  void changeSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }
}
