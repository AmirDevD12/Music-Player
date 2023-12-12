
import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:first_project/bloc/sort/sort_song_bloc.dart';
import 'package:first_project/core/theme/theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'core/pageview_widget.dart';
import 'locator.dart';

void main() {
  setup();
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
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            themeMode: themeProvider.themeMode,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            home: MultiBlocProvider(
              providers: [
                BlocProvider<PlaySongBloc>( create: (context) =>locator.get<PlaySongBloc>()),
                BlocProvider<SortSongBloc>( create: (context) =>locator.get<SortSongBloc>()),
                BlocProvider<PlayNewSongBloc>( create: (context) =>locator.get<PlayNewSongBloc>()),
              ],
              child: const MyHomePage(),)
        );
      },

    );
  }
}

