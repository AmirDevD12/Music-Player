import 'package:first_project/bloc/favorite_song/favorite_bloc.dart';
import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:first_project/bloc/play_list/play_list_bloc.dart';
import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:first_project/bloc/sort/sort_song_bloc.dart';
import 'package:first_project/screen/bottum_navigation/pageview_screen.dart';
import 'package:first_project/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:on_audio_query/on_audio_query.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static String routeSplashScreen="/SplashScreen";
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    OnAudioQuery().permissionsStatus();
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      context.pushReplacement(MyHomePage.routeMyHomePage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                  color: Colors.deepPurple.shade200,
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 270,
                    height: 270,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(35))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [Image.asset("assets/icon/mosics.png")],
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    ));
  }
}
