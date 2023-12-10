
import 'package:first_project/bloc/sort/sort_song_bloc.dart';
import 'package:first_project/screen/album/albom_page.dart';
import 'package:first_project/screen/artist/count_artist.dart';
import 'package:first_project/screen/folder/folder_song.dart';
import 'package:first_project/screen/list_song.dart';
import 'package:first_project/theme_mode.dart';
import 'package:first_project/widget/playall_container.dart';
import 'package:first_project/widget/them_seitcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'bottomNavigation_widget.dart';



class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  PageController controller=PageController();
  final List<Widget> _list=<Widget>[
    const Center(child:ListMusic() ),
    const Center(child: Artist()),
    const Center(child: AlbumPage()),
    Center(child: AlbumList()),
  ];
  int curr=0;
List<String> ListIssue=<String>["Songs ","Artist","Album","Folder"];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(

      appBar: AppBar(
        actions: [ThemeSwitcher()],

        title: Text('My music',textAlign: TextAlign.center,),
      ),
        bottomNavigationBar: BottomNavigationBarScreen(),
        body: Column(
          children: [
            SizedBox(height: 10,),
            Expanded(

              child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (BuildContext context, int index) {

                        return Column(crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30,right: 30),
                              child: SizedBox(
                                child: InkWell(
                                  onTap: (){
                                    controller.animateToPage(index,
                                        duration: Duration(milliseconds: 10),
                                        curve: Curves.easeOut);
                                  },
                                  child:  Text(ListIssue[index],
                                       ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10,),
                           curr==index? SmoothPageIndicator(
                              controller: controller,
                              count:  1,
                              axisDirection: Axis.horizontal,
                              effect:  const SlideEffect(
                                  spacing:  8.0,
                                  radius:  14.0,
                                  dotWidth:  24.0,
                                  dotHeight:  6.0,
                                  paintStyle:  PaintingStyle.fill,
                              ),

                            ):const SizedBox(),

                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 110, height: 30, child: PlayAllContainer()),
                    PopupMenuButton(
                      icon: Icon(Icons.sort,size: 30,),
                      onSelected: (value) {
                        print(value);
                        // select=value;
                      },
                      itemBuilder: (BuildContext bc) {
                        return [
                          PopupMenuItem(
                            onTap: (){
                              var songSortType=SongSortType.DATE_ADDED;
                              BlocProvider.of<SortSongBloc>(context).add(SortByAddEvent(songSortType));
                            },
                            value: '/time',
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Based on add time",
                                ),
                                SizedBox(width: 10,),

                              ],
                            ),
                          ),
                          PopupMenuItem(
                            onTap: (){
                              var songSortType=SongSortType.TITLE;
                              BlocProvider.of<SortSongBloc>(context).add(SortByAddEvent(songSortType));
                            },
                            value: '/name',
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Based on name",

                                ),SizedBox(width: 10,),

                              ],
                            ),
                          ),
                          PopupMenuItem(
                            onTap: (){
                              var songSortType=SongSortType.ARTIST;
                              BlocProvider.of<SortSongBloc>(context).add(SortByAddEvent(songSortType));
                            },
                            value: '/artist',
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Based on artist",

                                ),SizedBox(width: 10,),

                              ],
                            ),
                          ),

                        ];
                      },
                    )
                  ],
                )),
            Expanded(
              flex: 18,
              child: PageView(
                children:
                _list,
                scrollDirection: Axis.horizontal,
                controller: controller,
                onPageChanged: (num){
                   setState(() {
                     curr=num;
                   });
                },
              ),
            ),
          ],
        ),

    );
  }
}

