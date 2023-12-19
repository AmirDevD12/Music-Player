import 'package:first_project/bloc/favorite_song/favorite_bloc.dart';
import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:first_project/bloc/sort/sort_song_bloc.dart';
import 'package:first_project/core/pageview_widget.dart';
import 'package:first_project/core/playall_container.dart';
import 'package:first_project/core/them_seitcher.dart';
import 'package:first_project/core/theme/theme_mode.dart';
import 'package:first_project/locator.dart';
import 'package:first_project/screen/album/albom_page.dart';
import 'package:first_project/screen/artist/count_artist.dart';
import 'package:first_project/screen/bottum_navigation/favorite_screen.dart';
import 'package:first_project/screen/folder/folder_song.dart';
import 'package:first_project/screen/list_song.dart';
import 'package:first_project/screen/bottum_navigation/search_bottum.dart';
import 'package:first_project/screen/playSong_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'bottomNavigation_widget.dart';
import 'card_widget.dart';
import 'container_type_of_song.dart';

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
    const Center(child: AlbumPage()),
    Center(child: FavoriteScreen()),
  ];
  int curr = 0;
 bool show=false;

 @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    show=true;
  }
  late SongModel songModel;
  @override
  Widget build(BuildContext context) {
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

                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () {
                            curr = 0;
                            controller.animateToPage(curr,
                                duration: const Duration(milliseconds: 10),
                                curve: Curves.easeOut);
                          },
                          child: const CardWidget(
                            text: 'Home', iconData: Icons.home,)),
                      GestureDetector(
                          onTap: () {
                            curr = 1;
                            controller.animateToPage(curr,
                                duration: const Duration(milliseconds: 10),
                                curve: Curves.easeOut);
                          },
                          child: const CardWidget(
                            text: 'search', iconData: Icons.search,)),
                      const CardWidget(text: 'Home', iconData: Icons.home,),
                      GestureDetector(
                          onTap: () {
                            curr = 3;
                            controller.animateToPage(curr,
                                duration: const Duration(milliseconds: 10),
                                curve: Curves.easeOut);
                          }
                          ,
                          child: CardWidget(
                            text: 'Home', iconData: Icons.home,)),
                    ],
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
              onPageChanged: (num) {
                setState(() {
                  curr = num;
                });
              },
              children:
              _list,
            ),
          ),
        ],
      ),
    );
  }
}

