import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:first_project/locator.dart';
import 'package:first_project/model/chengeAnimation.dart';
import 'package:first_project/theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() => _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> with SingleTickerProviderStateMixin{
  bool isPlaying = true;
  late AnimationController _animationController;
  late Animation<double> _animation;
  int id = 0;
  @override
  void initState() {
    // TODO: implement initState


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
  }
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      height: 50,
      color: Colors.deepPurple,
      child: Row(
        children: [
          BlocBuilder<PlaySongBloc, PlaySongState>(
            builder: (context, state) {
              return IconButton(
                  onPressed: () async {

                    if (isPlaying) {
                      locator.get<AudioPlayer>();
                    } else {
                      locator.get<AudioPlayer>();
                    }
                    isPlaying = !isPlaying;

                    BlocProvider.of<PlaySongBloc>(context)
                        .add(PausePlayEvent());
                    ChangeAnimation().toggleAnimation(_animationController, context,isPlaying?true:false);

                  },
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 40,
                    color: themeProvider.isDarkMode?Colors.white:Colors.black,

                  ));
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<PlayNewSongBloc, PlayNewSongState>(
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
                        radius: 50,
                        child: Center(
                          child: QueryArtworkWidget(
                              artworkBorder:
                              const BorderRadius.all(Radius.circular(100)),
                              artworkWidth: 200,
                              artworkHeight: 200,
                              id: state is NewSongState ||state is PauseAnimationState&&id!=0
                                  ? id
                                  : 0,
                              type: ArtworkType.AUDIO),
                        ),
                      )

                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
