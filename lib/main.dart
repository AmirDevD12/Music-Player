
import 'package:first_project/core/theme/theme_mode.dart';
import 'package:first_project/screen/bottum_navigation/pageview_screen.dart';
import 'package:first_project/screen/division_songs/artist/showSong_artist.dart';
import 'package:first_project/screen/playSong_page.dart';
import 'package:first_project/screen/spalsh/splashScreeen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'bloc/favorite_song/favorite_bloc.dart';
import 'bloc/newSong/play_new_song_bloc.dart';
import 'bloc/play_list/play_list_bloc.dart';
import 'bloc/play_song_bloc.dart';
import 'bloc/sort/sort_song_bloc.dart';
import 'locator.dart';
import 'model/dataBase/delete_song_dataBase/delete_song.dart';
import 'model/dataBase/favorite_dataBase/favorite_song.dart';
import 'model/dataBase/map_string_bool/map_playList.dart';
import 'model/dataBase/play_list_recent_add/play_list_recent_add.dart';
import 'model/dataBase/recent_play/add_recent_play.dart';




Future<void> main() async {

 await Hive.initFlutter();
  Hive.registerAdapter(FavoriteSongAdapter());
  Hive.registerAdapter(DeleteSongAdapter());
  Hive.registerAdapter(RecentPlayAdapter());
  Hive.registerAdapter(PlayListRecentAddAdapter());
  Hive.registerAdapter(MapPlayListAdapter());
await  Hive.openBox<FavoriteSong>("Favorite");
await  Hive.openBox<DeleteSong>("Delete Folder");
await  Hive.openBox<DeleteSong>("Delete Song");
await  Hive.openBox<PlayListRecentAdd>("Recent add");
await  Hive.openBox<RecentPlay>("Recent play");
await  Hive.openBox<MapPlayList>("Map");
 setup();
 await JustAudioBackground.init(notificationColor: locator.get<MyThemes>().cContainerSong,
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,

  );
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ],
        child: const MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder:(context, themeProvider, child){
        return MaterialApp.router(
          routerConfig: GoRouter(
              initialLocation: themeProvider.showSplash?SplashScreen.routeSplashScreen:MyHomePage.routeMyHomePage,
              routes: [
            GoRoute(
                path:SplashScreen.routeSplashScreen,
              builder: (context,state){
                  return const SplashScreen();
              }
            ),
            GoRoute(
                path:MyHomePage.routeMyHomePage,
                builder: (context,state){
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider<PlaySongBloc>(
                          create: (context) => locator.get<PlaySongBloc>()),
                      BlocProvider<SortSongBloc>(
                          create: (context) => locator.get<SortSongBloc>()),
                      BlocProvider<PlayNewSongBloc>(
                          create: (context) => locator.get<PlayNewSongBloc>()),
                      BlocProvider<FavoriteBloc>(
                          create: (context) => locator.get<FavoriteBloc>()),
                      BlocProvider<PlayListBloc>(
                          create: (context) => locator.get<PlayListBloc>()),
                    ],
                    child: const MyHomePage(),
                  );
                }
            ),
            GoRoute(
                path:ShowListArtist.routeShowListArtist,
                builder: (context,state){
                  return const ShowListArtist();
                }
            ),
                GoRoute(
                    path:PlayPage.routePlayPage,
                    builder: (context,state){
                      return MultiBlocProvider(
                        providers: [
                          BlocProvider<PlaySongBloc>(
                              create: (context) => locator.get<PlaySongBloc>()),
                          BlocProvider<SortSongBloc>(
                              create: (context) => locator.get<SortSongBloc>()),
                          BlocProvider<PlayNewSongBloc>(
                              create: (context) => locator.get<PlayNewSongBloc>()),
                          BlocProvider<FavoriteBloc>(
                              create: (context) => locator.get<FavoriteBloc>()),
                          BlocProvider<PlayListBloc>(
                              create: (context) => locator.get<PlayListBloc>()),
                        ],
                        child: const PlayPage(),
                      );
                    }
                ),
          ]),
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            themeMode: themeProvider.themeMode,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,

        );
      },
    );
  }
}

