import 'package:first_project/bloc/favorite_song/favorite_bloc.dart';
import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:first_project/bloc/sort/sort_song_bloc.dart';
import 'package:first_project/core/pageview_widget.dart';
import 'package:first_project/core/them_seitcher.dart';
import 'package:first_project/core/theme/theme_mode.dart';
import 'package:first_project/locator.dart';

import 'package:first_project/model/songs_model.dart';
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


class MyHomePage extends StatelessWidget {

   MyHomePage({super.key, });

  PageController controller = PageController();

  final List<Widget> _list = <Widget>[
    const Center(child: PageViewSong()),
     Center(child: SearchPage()),
    const Center(child: ListSongBottomNavigation(show: false, songModel: null,)),
    const Center(child: AlbumPage()),
  ];

  List<SongModel> listSong=[];

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        actions: const [ThemeSwitcher()],
        title: const Text('My music', style: TextStyle(color: Colors.white),),
      ),
      bottomNavigationBar: BlocBuilder<PlayNewSongBloc, PlayNewSongState>(
        buildWhen: (privioc, current) {
          if (current is NewSongState) {
            return true;
          } else {
            return false;
          }
        },
  builder: (context, state) {
    return BlocBuilder<PlaySongBloc, PlaySongState>(
        buildWhen: (privioc, current) {
          if (current is DurationState ==privioc is DurationState) {
            return false;
          } else {
            return true;
          }
        },
        builder: (context, state) {
          if(state is ShowNavState){

            listSong=state.listSong;
          }
          return SizedBox(
            width: double.infinity,
            height: state is DurationState ||state is PausePlayState||state is ShowNavState?120:60,
            child: Column(mainAxisAlignment: MainAxisAlignment.end,
              children: [
                     state is DurationState ||state is PausePlayState||state is ShowNavState
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
                                          BlocProvider(
                                            create: (context) => locator
                                                .get<SortSongBloc>(),
                                          ),
                                        ],
                                        child: PlayPage(
                                          play: true, concatenatingAudioSource: null, index:locator.get<AudioPlayer>().currentIndex!, songs:listSong,
                                        ),
                                      )));
                        },
                        child: BottomNavigationBarScreen(listSong: listSong,)):const SizedBox(),

                const SizedBox(height: 5,),
                Expanded(

                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                )
              ],
            ),
          );
        },
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

