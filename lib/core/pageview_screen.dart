import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:first_project/bloc/sort/sort_song_bloc.dart';
import 'package:first_project/core/pageview_widget.dart';
import 'package:first_project/core/playall_container.dart';
import 'package:first_project/core/them_seitcher.dart';
import 'package:first_project/core/theme/theme_mode.dart';
import 'package:first_project/screen/album/albom_page.dart';
import 'package:first_project/screen/artist/count_artist.dart';
import 'package:first_project/screen/bottum_navigation/favorite_screen.dart';
import 'package:first_project/screen/folder/folder_song.dart';
import 'package:first_project/screen/list_song.dart';
import 'package:first_project/screen/bottum_navigation/search_bottum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                    if (current is DurationState || current is PausePlayState) {
                      return false;
                    } else {
                      return true;
                    }
                  },
                  builder: (context, state) {
                    return state is ShowNavState
                        ? BottomNavigationBarScreen(songModel: state.songModel,)
                        : const SizedBox();
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
                          child: CardWidget(
                            text: 'Home', iconData: Icons.home,)),
                      GestureDetector(
                          onTap: () {
                            curr = 1;
                            controller.animateToPage(curr,
                                duration: const Duration(milliseconds: 10),
                                curve: Curves.easeOut);
                          },
                          child: CardWidget(
                            text: 'search', iconData: Icons.search,)),
                      CardWidget(text: 'Home', iconData: Icons.home,),
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

