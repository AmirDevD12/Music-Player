
import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:first_project/core/theme/theme_mode.dart';
import 'package:first_project/locator.dart';
import 'package:first_project/model/info_for_route.dart';
import 'package:first_project/screen/division_songs/pags_bottomnavigation.dart';
import 'package:first_project/core/them_seitcher.dart';
import 'package:first_project/screen/bottum_navigation/list/list_song_bottomnav.dart';
import 'package:first_project/screen/bottum_navigation/page_search/search_bottum.dart';
import 'package:first_project/screen/division_songs/album/albom_page.dart';
import 'package:first_project/screen/playSong_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../core/bottomNavigation_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });
  static String routeMyHomePage='/MyHomePage';
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController controller = PageController();
  final List<Widget> _list = <Widget>[
    const Center(child: PageViewSong()),
    const Center(child: SearchPage()),
    const Center(
        child: ListSongBottomNavigation(
      show: false,
      songModel: null,
    )),
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
        title: Text(
          'My music',
          style: TextStyle(
              color: themeProvider.isDarkMode?Colors.white:Colors.black,
              fontSize: 20,
              fontFamily: "ibm",
              fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: BlocBuilder<PlayNewSongBloc, PlayNewSongState>(
        buildWhen: (previous, current) {
          if (current is NewSongState) {
            return true;
          } else {
            return false;
          }
        },
        builder: (context, state) {
          return BlocBuilder<PlaySongBloc, PlaySongState>(
            buildWhen: (previous, current) {
              if (current is DurationState == previous is DurationState) {
                return false;
              } else {
                return true;
              }
            },
            builder: (context, state) {
              if (state is ShowNavState) {
              }
              return SizedBox(
                width: double.infinity,
                height: state is PlaySongInitial ? 55 : 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    state is DurationState ||
                            state is PausePlayState ||
                            state is ShowNavState
                        ? GestureDetector(
                            onTap: () {
                              context.push(
                                  PlayPage.routePlayPage,
                                  extra: locator.get<InfoPage>());
                            },
                            child: BottomNavigationBarScreen(
                              listSong: locator.get<InfoPage>().songs!,
                            ))
                        : const SizedBox(),
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                          height: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(

                            height: 50,
                            child: BottomNavigationBar(
                              onTap: (index){
                                controller.animateToPage(
                                    index,
                                    duration:
                                    const Duration(milliseconds: 10),
                                    curve: Curves.easeOut);
                              },
                              unselectedItemColor: themeProvider.isDarkMode?Colors.white:Colors.black ,
                              showUnselectedLabels: true,
                                     fixedColor:themeProvider.isDarkMode?Colors.white:Colors.black ,
                                items:<BottomNavigationBarItem>[
                              BottomNavigationBarItem(
                                  icon: Image.asset("assets/icon/music(1).png",
                                  width: 20,
                                  height: 15,
                                    color: themeProvider.isDarkMode?Colors.white:Colors.black ,
                              ),label:'My Music',
                              ),
                              BottomNavigationBarItem(
                                  icon: Image.asset("assets/icon/magnifying-glass.png",
                                width: 20,
                                height: 15,
                                    color: themeProvider.isDarkMode?Colors.white:Colors.black ,
                                  ),label:'Search' ,),
                              BottomNavigationBarItem(
                                  icon: Image.asset("assets/icon/list(2).png",
                                width: 20,
                                height: 15,
                                    color: themeProvider.isDarkMode?Colors.white:Colors.black ,
                                  ),label:'List Song' ,),
                              BottomNavigationBarItem(
                                  icon: Image.asset("assets/icon/information-button.png",
                                    width: 20,
                                    height: 15,
                                    color: themeProvider.isDarkMode?Colors.white:Colors.black ,
                                  ),label:'Info' ,),
                            ]),
                          ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                            //   children: [
                            //
                            //     GestureDetector(
                            //         onTap: () {
                            //           controller.animateToPage(0,
                            //               duration:
                            //                   const Duration(milliseconds: 10),
                            //               curve: Curves.easeOut);
                            //         },
                            //         child: const CardWidget(
                            //           text: 'My Music',
                            //           path: "assets/icon/music(1).png",
                            //         )),
                            //     GestureDetector(
                            //         onTap: () {
                            //           controller.animateToPage(1,
                            //               duration:
                            //                   const Duration(milliseconds: 10),
                            //               curve: Curves.easeOut);
                            //         },
                            //         child: const CardWidget(
                            //           text: 'search',
                            //           path: "assets/icon/magnifying-glass.png",
                            //         )),
                            //     GestureDetector(
                            //         onTap: () {
                            //           controller.animateToPage(2,
                            //               duration:
                            //                   const Duration(milliseconds: 10),
                            //               curve: Curves.easeOut);
                            //         },
                            //         child: const CardWidget(
                            //           text: 'List',
                            //           path: "assets/icon/list(2).png",
                            //         )),
                            //     GestureDetector(
                            //         onTap: () {
                            //           controller.animateToPage(3,
                            //               duration:
                            //                   const Duration(milliseconds: 10),
                            //               curve: Curves.easeOut);
                            //         },
                            //         child: const CardWidget(
                            //           text: 'Path',
                            //           path:
                            //               "assets/icon/information-button.png",
                            //         )),
                            //   ],
                            // ),
                          ],
                        ),
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
              children: _list,
            ),
          ),
        ],
      ),
    );
  }
}
