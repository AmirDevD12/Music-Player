
import 'package:first_project/screen/album/albom_page.dart';
import 'package:first_project/screen/artist/count_artist.dart';
import 'package:first_project/screen/folder/folder_song.dart';
import 'package:first_project/screen/list_song.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
class PageViewSong extends StatefulWidget {
  const PageViewSong({super.key});
  @override
  _PageViewSong createState() => _PageViewSong();
}

class _PageViewSong extends State<PageViewSong> {

  PageController controller=PageController();
  final  List<Widget> _list=<Widget>[
     Center(child:ListMusic() ),
    const Center(child: Artist()),
    const Center(child: AlbumPage()),
    Center(child: FolderList()),
  ];

static const List<String> ListIssue=<String>["Songs ","Artist","Album","Folder"];
  int curr=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10,),
          SizedBox(
            height: 40,
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
              flex: 17,
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

