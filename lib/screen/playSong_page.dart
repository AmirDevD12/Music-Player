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

  const PlayPage(
      {super.key, required this.songModel, required this.audioPlayer});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {

  Duration duration = const Duration();
  Duration position = const Duration();
  bool isPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    playSong();
  }

  playSong() {
    try {
      widget.audioPlayer
          .setAudioSource(AudioSource.uri(Uri.parse(widget.songModel.uri!)));
      widget.audioPlayer.play();
      isPlaying = true;
      print("play");
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
    } on Exception {}
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
    } on Exception {}
  }

  int number = 0;

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
                  BlocBuilder<PlayNewSongBloc, PlayNewSongState>(
                    builder: (context, state) {
                      int id = 0;
                      if (state is NewSongState) {
                        id = state.id;
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Transform.rotate(
                            angle: 360 * position.inSeconds.toDouble() / 10,
                            child: QueryArtworkWidget(
                                artworkBorder:
                                BorderRadius.all(Radius.circular(100)),
                                artworkWidth: 200,
                                artworkHeight: 200,
                                id: state is NewSongState
                                    ? id
                                    : widget.songModel.id,
                                type: ArtworkType.AUDIO),
                          )
                        ],
                      );
                    },
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 300,
                        child: BlocBuilder<PlayNewSongBloc, PlayNewSongState>(
                          builder: (context, state) {
                            String title = "";
                            String disName = "";
                            if (state is NewSongState) {
                              title = state.name;
                              disName = state.artist;
                            }
                            return ListTile(
                              title: Text(
                                state is NewSongState
                                    ? title
                                    : widget.songModel.title,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                state is NewSongState
                                    ? disName
                                    : widget.songModel.displayNameWOExt,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: IconButton(
                            onPressed: () {}, icon: Icon(Icons.monitor_heart)),
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
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: BlocBuilder<PlaySongBloc, PlaySongState>(
                      builder: (context, state) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(position.toString().split(".")[0]),
                            Text(duration.toString().split(".")[0]),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.repeat,
                            size: 40,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.skip_previous_rounded,
                            size: 40,
                            color: Colors.white,
                          )),
                      BlocBuilder<PlaySongBloc, PlaySongState>(
                        builder: (context, state) {
                          return IconButton(
                              onPressed: () {
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
                                size: 40,
                                color: Colors.white,
                              ));
                        },
                      ),
                      // BlocBuilder<PlayNewSongBloc, PlayNewSongState>(
                      //   builder: (context, state) {
                      //
                      //     if(state is NewSongState){
                      //       number=state.index;
                      //     }
                      //     return IconButton(
                      //         onPressed: () {
                      //           number++;
                      //           Future<List<SongModel>> songha=SongList().getSongs();
                      //
                      //             widget.audioPlayer.seekToPrevious();
                      //           BlocProvider.of<PlaySongBloc>(context)
                      //               .add(PausePlayEvent());
                      //
                      //         },
                      //         icon: Icon(
                      //           Icons.skip_next,
                      //           size: 40,
                      //           color: Colors.white,
                      //         ));
                      //   },
                      // ),
                      BlocBuilder<PlayNewSongBloc, PlayNewSongState>(
                        builder: (context, state) {
                          if(state is NewSongState){
                            number=state.index;
                          }
                          return IconButton(
                              onPressed: () {

                              },
                              icon: const Icon(
                                Icons.skip_next,
                                size: 45.0,
                                color: Colors.white,
                              ));
                        },
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.arrow_drop_down_circle,
                            size: 40,
                            color: Colors.white,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.menu,
                            size: 40,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.add_circle_outline,
                            size: 40,
                            color: Colors.white,
                          )),
                    ],
                  ),
                  Container(
                    height: 1000,
                    child: FutureBuilder<List<SongModel>>(
                      future: SongList().getSongs(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<SongModel>> snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: Text(snapshot.data![index].title,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),),
                                subtitle:
                                Text(snapshot.data![index].displayName,
                                  style: TextStyle(

                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),),
                                leading: QueryArtworkWidget(
                                    id: snapshot.data![index].id,
                                    type: ArtworkType.AUDIO),
                                onTap: () {
                                  newSong(snapshot.data![index].uri);
                                  print(snapshot.data![index+1].uri);
                                  print(snapshot.data![index].uri);

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
            )
          ],
        ),
      ),
    );
  }

  void changeSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }
}
