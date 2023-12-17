
import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:first_project/bloc/sort/sort_song_bloc.dart';
import 'package:first_project/core/playall_container.dart';
import 'package:first_project/core/them_seitcher.dart';
import 'package:first_project/core/theme/theme_mode.dart';
import 'package:first_project/screen/album/albom_page.dart';
import 'package:first_project/screen/artist/count_artist.dart';
import 'package:first_project/screen/folder/folder_song.dart';
import 'package:first_project/screen/list_song.dart';
import 'package:first_project/screen/search_bottum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'bottomNavigation_widget.dart';

import 'container_type_of_song.dart';
class PageViewSong extends StatefulWidget {
  const PageViewSong({super.key});
  @override
  _PageViewSong createState() => _PageViewSong();
}

class _PageViewSong extends State<PageViewSong> {

  PageController controller=PageController();
  final List<Widget> _list=<Widget>[
    const Center(child:ListMusic() ),
    const Center(child: Artist()),
    const Center(child: AlbumPage()),
    Center(child: AlbumList()),
  ];

List<String> ListIssue=<String>["Songs ","Artist","Album","Folder"];
  int curr=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10,),
          // Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     const ContainerTypeSong(name: 'Favorites', imagePath: "assets/icon/love-song.png", color: Colors.deepPurple,),
          //     ContainerTypeSong(name: 'Playlist', imagePath: "assets/icon/list.png", color: Colors.green.shade900,),
          //     const ContainerTypeSong(name: 'New items', imagePath: "assets/icon/clock.png", color: Colors.orange,),
          //   ],
          // ),
          // const SizedBox(height: 10,),
          Expanded(flex: 1,
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
                                        duration: const Duration(milliseconds: 10),
                                        curve: Curves.easeOut);
                                  },
                                  child:  Text(ListIssue[index],
                                    style: const TextStyle(fontFamily: "ibm",fontSize: 15,fontWeight: FontWeight.bold),
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
            ),
          Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 110, height: 30, child: PlayAllContainer()),
                      PopupMenuButton(
                        icon: const Icon(Icons.sort,size: 30,),
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
                  ),
                )),
            Expanded(
              flex: 15,
              child: PageView(
                scrollDirection: Axis.horizontal,
                controller: controller,
                onPageChanged: (num){
                   setState(() {
                     curr=num;
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

