import 'package:first_project/bloc/favorite_song/favorite_bloc.dart';
import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:first_project/core/pageview_widget.dart';
import 'package:first_project/core/them_seitcher.dart';
import 'package:first_project/core/theme/theme_mode.dart';
import 'package:first_project/locator.dart';
import 'package:first_project/screen/album/albom_page.dart';
import 'package:first_project/screen/bottum_navigation/show_song_playList_screen.dart';
import 'package:first_project/screen/bottum_navigation/list_song_bottomnav.dart';
import 'package:first_project/screen/bottum_navigation/search_bottum.dart';
import 'package:first_project/screen/playSong_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'bottomNavigation_widget.dart';
import 'card_widget.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  PageController controller = PageController();
  final List<Widget> _list = <Widget>[
    const Center(child: PageViewSong()),
    const Center(child: SearchScreen()),
    const Center(child: ListSongBottomNavigation(show: false,)),
    const Center(child: AlbumPage()),
  ];



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     OnAudioQuery().permissionsStatus();
  }
  late SongModel songModel;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        actions: const [ThemeSwitcher()],
        title: const Text('My music', style: TextStyle(color: Colors.white),),
      ),
      bottomNavigationBar: BlocBuilder<PlaySongBloc, PlaySongState>(
        builder: (context, state) {
          return SizedBox(
            width: double.infinity,
            height: state is PlaySongInitial?60:120,
            child: Column(mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BlocBuilder<PlaySongBloc, PlaySongState>(
                  buildWhen: (privioc, current) {
                    if (current is DurationState ==privioc is DurationState) {
                      return false;
                    } else {
                      return true;
                    }
                  },
                  builder: (context, state) {
                    if(state is ShowNavState){
                      songModel=state.songModel;
                    }
                    return state is DurationState ||state is PausePlayState
                    ?GestureDetector(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MultiBlocProvider(
                                        providers: [
                                          BlocProvider(
                                              create: (context) =>
                                                  locator.get<
                                                      PlaySongBloc>()),
                                          BlocProvider(
                                            create: (context) => locator
                                                .get<PlayNewSongBloc>(),
                                          ),
                                          BlocProvider(
                                            create: (context) => locator
                                                .get<FavoriteBloc>(),
                                          ),
                                        ],
                                        child: PlayPage(
                                          songModel:
                                          songModel,
                                          audioPlayer: locator
                                              .get<AudioPlayer>(), play: false,
                                        ),
                                      )));
                        },
                        child: const BottomNavigationBarScreen()):const SizedBox();
                  },
                ),
                const SizedBox(height: 5,),
                Expanded(

                  child: Container(
                    color: themeProvider.isDarkMode?const Color(0xff1a1b1d):Colors.deepPurple,
                    child: Column(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  controller.animateToPage(0,
                                      duration: const Duration(milliseconds: 10),
                                      curve: Curves.easeOut);
                                },
                                child: const CardWidget(
                                  text: 'My Music',path: "assets/icon/music(1).png",)),
                            GestureDetector(
                                onTap: () {
                                  controller.animateToPage(1,
                                      duration: const Duration(milliseconds: 10),
                                      curve: Curves.easeOut);
                                },
                                child: const CardWidget(
                                  text: 'search', path: "assets/icon/magnifying-glass.png",)),
                            GestureDetector(
                                onTap: () {
                                  controller.animateToPage(2,
                                      duration: const Duration(milliseconds: 10),
                                      curve: Curves.easeOut);
                                }
                                ,
                                child: const CardWidget(text: 'List', path:"assets/icon/list(2).png",)),
                            GestureDetector(
                                onTap: () {

                                  controller.animateToPage(3,
                                      duration: const Duration(milliseconds: 10),
                                      curve: Curves.easeOut);
                                }
                                ,
                                child: const CardWidget(
                                  text: 'Path',path:  "assets/icon/information-button.png",)),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
      body: Column(
        children: [
          Expanded(
            flex: 15,
            child: PageView(
              scrollDirection: Axis.horizontal,
              controller: controller,

              children:
              _list,
            ),
          ),
        ],
      ),
    );
  }
}

