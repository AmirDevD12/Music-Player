import 'dart:core';

import 'package:checkbox_formfield/checkbox_icon_formfield.dart';
import 'package:first_project/bloc/play_list/play_list_bloc.dart';
import 'package:first_project/core/theme/theme_mode.dart';
import 'package:first_project/locator.dart';

import 'package:first_project/model/dataBase/favorite_dataBase/favorite_song.dart';
import 'package:first_project/model/dataBase/map_string_bool/map_playList.dart';
import 'package:first_project/model/dataBase/play_list_recent_add/play_list_recent_add.dart';
import 'package:first_project/model/dataBase/recent_play/add_recent_play.dart';
import 'package:first_project/model/newSong.dart';
import 'package:first_project/model/songs_model.dart';
import 'package:first_project/screen/bottum_navigation/list/select_song_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'show_song_playList_screen.dart';

class ListSongBottomNavigation extends StatefulWidget {
  final bool show;
  final SongModel? songModel;
  const ListSongBottomNavigation(
      {Key? key, required this.show, required this.songModel})
      : super(key: key);

  @override
  State<ListSongBottomNavigation> createState() =>
      _ListSongBottomNavigationState();
}

class _ListSongBottomNavigationState extends State<ListSongBottomNavigation> {
  List<String> name = ["Favorite", "Recent add", "Recent play", "Default list"];

  List<String> path = [
    'assets/icon/like.png',
    'assets/icon/clock(1).png',
    'assets/icon/recent.png',
    'assets/icon/list(2).png'
  ];

  Map<String, bool> boxName = {
    "Favorite": false,
    "Recent add": false,
    "Default list": false
  };

  String nameNew = "";
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    BlocProvider.of<PlayListBloc>(context).add(AddFromListEvent());
  }
  late final ThemeProvider themeProvider;
  @override
  void didChangeDependencies() {
    themeProvider = Provider.of<ThemeProvider>(context);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {

    if (widget.show) {
      BlocProvider.of<PlayListBloc>(context).add(ShowBoxEvent());
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeProvider.isDarkMode
            ? Colors.deepPurpleAccent
            : Colors.blueGrey.shade300,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('New Playlist'),
                content: TextField(
                  onChanged: (value) {
                    nameNew = value;
                  },
                  decoration: const InputDecoration(
                      labelText: "New Playlist",
                      border: UnderlineInputBorder()),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('CANCEL'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Box boxMap = await Hive.openBox<MapPlayList>("Map");
                      MapPlayList mapPlayList = MapPlayList(nameNew, false);
                      boxMap.add(mapPlayList);
                      List<SongModel> songs = await locator
                          .get<SongList>()
                          .getSongs(SongSortType.DATE_ADDED);
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectSongScreen(
                                    name: nameNew,
                                    songs: songs,
                                  )));
                    },
                    child: const Text('ok'),
                  ),
                ],
              );
            },
          );
        },
        child: SizedBox(
            width: 30,
            height: 30,
            child: Image.asset(
              'assets/icon/plus.png',
              color: themeProvider.isDarkMode ? Colors.white : Colors.black,
            )),
      ),
      bottomNavigationBar: widget.show
          ? BlocBuilder<PlayListBloc, PlayListState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () {
                    addNewList(boxName);
                    add(boxName, name);
                    Navigator.pop(context);
                    BlocProvider.of<PlayListBloc>(context)
                        .add(SelectListEvent());
                  },
                  child: Container(
                    width: 300,
                    height: 50,
                    color: Colors.red,
                    child: Text("add"),
                  ),
                );
              },
            )
          : const SizedBox(),
      appBar: widget.show
          ? AppBar(
              foregroundColor: Colors.white,
              title: const Text(
                style: TextStyle(color: Colors.white),
                maxLines: 1,
                "List song",
              ),
            )
          : null,
      body: BlocBuilder<PlayListBloc, PlayListState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 250,
                child: ListView.builder(
                    itemCount: name.length,
                    itemBuilder: (BuildContext context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SizedBox(
                          height: 50,
                          child: ListTile(
                            trailing: BlocBuilder<PlayListBloc, PlayListState>(
                              builder: (context, state) {
                                return widget.show
                                    ? CheckboxIconFormField(
                                  trueIconColor: themeProvider.isDarkMode?Colors.white:Colors.black,
                                  falseIconColor: themeProvider.isDarkMode?Colors.white:Colors.black,


                                        disabledColor: Colors.black,
                                        context: context,
                                        iconSize: 30,
                                        padding: 10,
                                        onSaved: (bool? value) {},
                                        onChanged: (value) {
                                          if (value) {
                                            boxName[name[index]] = true;
                                          } else {
                                            boxName[name[index]] = false;
                                          }
                                        },
                                      )
                                    : SizedBox(
                                  height: 50,
                                  width: 36,
                                  child: PopupMenuButton(
                                    iconSize: 200,
                                    icon: Image.asset(
                                      "assets/icon/dots.png",
                                      width: 40,
                                      height: 40,
                                      color: themeProvider.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    itemBuilder: (BuildContext bc) {
                                      return [
                                        PopupMenuItem(
                                          onTap: () async {
                                            Box boxNew = await Hive.openBox<FavoriteSong>(name[index]);
                                            final playlist = ConcatenatingAudioSource(
                                              useLazyPreparation: true,
                                              shuffleOrder: DefaultShuffleOrder(),
                                              children: [
                                                for(int i=0;i<boxNew.length;i++)
                                                  AudioSource.uri(Uri.parse(boxNew.getAt(i).path)),
                                              ],
                                            );
                                            // ignore: use_build_context_synchronously
                                            PlayNewSong().newSong(0, context, playlist,true);
                                          },
                                          value: '/add',
                                          child:
                                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("Add to queue",style: TextStyle(fontSize: 15,fontFamily: "ibm",fontWeight: FontWeight.bold),),
                                              SizedBox(
                                                  width: 30,

                                                  child: Image.asset("assets/icon/add-to-playlist.png"))
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          onTap: () async {
                                            Box boxNew = await Hive.openBox<FavoriteSong>(name[index]);
                                            final playlist = ConcatenatingAudioSource(
                                              useLazyPreparation: true,
                                              shuffleOrder: DefaultShuffleOrder(),
                                              children: [
                                                for(int i=0;i<boxNew.length;i++)
                                                  AudioSource.uri(Uri.parse(boxNew.getAt(i).path)),

                                              ],
                                            );
                                            // ignore: use_build_context_synchronously
                                            PlayNewSong().newSong(0, context, playlist,false);
                                          },
                                          value: '/add',
                                          child:
                                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("play",style: TextStyle(fontSize: 15,fontFamily: "ibm",fontWeight: FontWeight.bold),),
                                              SizedBox(
                                                  width: 30,

                                                  child: Image.asset("assets/icon/play-button.png"))
                                            ],
                                          ),
                                        )
                                      ];
                                    },
                                  ),
                                );
                              },
                            ),
                            title: Text(
                              style: locator.get<MyThemes>().title(context),
                              maxLines: 1,
                              name[index],
                            ),
                            subtitle: Text(
                              style: locator.get<MyThemes>().subTitle(context),
                              maxLines: 1,
                              name[index],
                            ),
                            leading: Container(
                              decoration: BoxDecoration(
                                  color: themeProvider.isDarkMode
                                      ? Colors.blueGrey.shade900
                                      : Colors.blueGrey.shade300,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5))),
                              width: 50,
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: Image.asset(
                                        path[index],
                                        color: themeProvider.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                                ],
                              ),
                            ),
                            onTap: () async {
                              if (!widget.show) {
                                if (name[index] == "Favorite") {
                                  Box boxes = await Hive.openBox<FavoriteSong>(
                                      name[index]);
                                  // ignore: use_build_context_synchronously
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FavoriteScreen(
                                                name: name[index],
                                                boxes: boxes,
                                              )));
                                } else if (name[index] == "Recent add") {
                                  // print(name[in])
                                  Box boxes =
                                      await Hive.openBox<PlayListRecentAdd>(
                                          name[index]);
                                  // ignore: use_build_context_synchronously
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FavoriteScreen(
                                                name: name[index],
                                                boxes: boxes,
                                              )));
                                } else if (name[index] == "Recent play") {
                                  Box boxes = await Hive.openBox<RecentPlay>(
                                      name[index]);
                                  // ignore: use_build_context_synchronously
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FavoriteScreen(
                                                name: name[index],
                                                boxes: boxes,
                                              )));
                                } else if (name[index] == "Default list") {}
                              }
                            },
                          ),
                        ),
                      );
                    }),
              ),
              Expanded(
                  flex: 10,
                  child: ValueListenableBuilder(
                    valueListenable: Hive.box<MapPlayList>("Map").listenable(),
                    builder: (context, Box box, child) {
                      if (box.values.isEmpty) {
                        return const SizedBox();
                      } else {
                        return ListView.builder(

                          itemCount: box.length,
                          itemBuilder: (BuildContext context, int index) {
                            final themeProvider =
                                Provider.of<ThemeProvider>(context);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: SizedBox(
                                height: 50,
                                child: ListTile(
                                  trailing: widget.show
                                      ? CheckboxIconFormField(
                                    trueIconColor: themeProvider.isDarkMode?Colors.white:Colors.black,
                                    falseIconColor: themeProvider.isDarkMode?Colors.white:Colors.black,
                                          disabledColor: Colors.white,
                                          context: context,
                                          iconSize: 30,
                                          padding: 10,
                                          onSaved: (bool? value) {},
                                          onChanged: (value) {
                                            if (value) {
                                              boxName[box.getAt(index).title] =
                                                  true;
                                            } else {
                                              boxName[box.getAt(index).title] =
                                                  false;
                                            }
                                          },
                                        )
                                      : SizedBox(
                                          height: 50,
                                          width: 36,
                                          child: PopupMenuButton(
                                            iconSize: 200,
                                            icon: Image.asset(
                                              "assets/icon/dots.png",
                                              width: 40,
                                              height: 40,
                                              color: themeProvider.isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            itemBuilder: (BuildContext bc) {
                                              return [
                                                PopupMenuItem(
                                                  onTap: () {
                                                    box.deleteAt(index);

                                                  },
                                                  value: '/delete',
                                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                       const Text("delete",style: TextStyle(fontSize: 15,fontFamily: "ibm",fontWeight: FontWeight.bold),),
                                                      SizedBox(
                                                          width: 30,
                                                          height: 30,
                                                          child: Image.asset("assets/icon/delete.png"))
                                                    ],
                                                  ),
                                                ),
                                                 PopupMenuItem(
                                                  onTap: (){
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return Dialog(
                                                          child: SizedBox(
                                                            width: 200,
                                                            height: 200,
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child:  Text('New Name',style: TextStyle(color: themeProvider.isDarkMode?Colors.white:Colors.black,fontSize: 20,fontFamily: "ibm",fontWeight: FontWeight.bold),),
                                                                  ),
                                                                   Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                     children: [
                                                                       SizedBox(
                                                                         width: 200,
                                                                         height: 60,
                                                                         child: TextField(
                                                                           onChanged: (value) {

                                                                             nameNew = value;
                                                                           },
                                                                           decoration:  const InputDecoration(
                                                                               labelText: "New Name",
                                                                               border: UnderlineInputBorder(
                                                                                 borderSide: BorderSide(
                                                                                   color: Colors.deepPurple
                                                                                 )
                                                                               )),
                                                                         ),
                                                                       ),
                                                                     ],
                                                                   ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        ElevatedButton(
                                                                        //   style: ElevatedButton.styleFrom(
                                                                        //   primary: Colors.blueGrey.shade300
                                                                        // ),
                                                                          onPressed: () {
                                                                            nameNew="";
                                                                            dispose();
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child: const Text('CANCEL'),
                                                                        ),
                                                                        ElevatedButton(
                                                                          onPressed: () async {
                                                                            box.putAt(index, MapPlayList(nameNew, false));
                                                                            nameNew="";
                                                                            dispose();
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child: const Text('ok'),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );

                                                  },
                                                  value: '/share',
                                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                       const Text("rename",style: TextStyle(fontSize: 15,fontFamily: "ibm",fontWeight: FontWeight.bold),),
                                                      SizedBox(
                                                          width: 30,

                                                          child: Image.asset("assets/icon/edit.png"))
                                                    ],
                                                  ),
                                                ),
                                                 PopupMenuItem(
                                                   onTap: () async {
                                                     Box boxNew = await Hive.openBox<FavoriteSong>(box.getAt(index).title);
                                                     final playlist = ConcatenatingAudioSource(
                                                       useLazyPreparation: true,
                                                       shuffleOrder: DefaultShuffleOrder(),
                                                       children: [
                                                         for(int i=0;i<boxNew.length;i++)
                                                         AudioSource.uri(Uri.parse(boxNew.getAt(i).path)),
                                                       ],
                                                     );
                                                     // ignore: use_build_context_synchronously
                                                     PlayNewSong().newSong(0, context, playlist,true);
                                                   },
                                                  value: '/add',
                                                  child:
                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                           Text("Add to queue",style: TextStyle(fontSize: 15,fontFamily: "ibm",fontWeight: FontWeight.bold),),
                                                          SizedBox(
                                                              width: 30,

                                                              child: Image.asset("assets/icon/add-to-playlist.png"))
                                                        ],
                                                      ),
                                                ),
                                                PopupMenuItem(
                                                  onTap: () async {
                                                    Box boxNew = await Hive.openBox<FavoriteSong>(box.getAt(index).title);
                                                    final playlist = ConcatenatingAudioSource(
                                                      useLazyPreparation: true,
                                                      shuffleOrder: DefaultShuffleOrder(),
                                                      children: [
                                                        for(int i=0;i<boxNew.length;i++)
                                                          AudioSource.uri(Uri.parse(boxNew.getAt(i).path)),

                                                      ],
                                                    );
                                                    // ignore: use_build_context_synchronously
                                                    PlayNewSong().newSong(0, context, playlist,false);
                                                  },
                                                  value: '/add',
                                                  child:
                                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                       const Text("play",style: TextStyle(fontSize: 15,fontFamily: "ibm",fontWeight: FontWeight.bold),),
                                                      SizedBox(
                                                          width: 30,

                                                          child: Image.asset("assets/icon/play-button.png"))
                                                    ],
                                                  ),
                                                )
                                              ];
                                            },
                                          ),
                                        ),
                                  title: Text(
                                    box.getAt(index).title!,
                                    style:
                                        locator.get<MyThemes>().title(context),
                                    maxLines: 1,
                                  ),
                                  subtitle: Text(
                                    box.getAt(index).title,
                                    style: locator
                                        .get<MyThemes>()
                                        .subTitle(context),
                                    maxLines: 1,
                                  ),
                                  leading: Container(
                                    decoration: BoxDecoration(
                                        color: themeProvider.isDarkMode
                                            ? Colors.blueGrey.shade900
                                            : Colors.blueGrey.shade300,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5))),
                                    width: 50,
                                    height: 50,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: Image.asset(
                                              path[path.length - 1],
                                              color: themeProvider.isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            )),
                                      ],
                                    ),
                                  ),
                                  onTap: () async {
                                    if (!widget.show) {
                                      Box boxList =
                                          await Hive.openBox<FavoriteSong>(
                                              box.getAt(index).title);
                                      // ignore: use_build_context_synchronously
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FavoriteScreen(
                                                    name:
                                                        box.getAt(index).title,
                                                    boxes: boxList,
                                                  )));
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ))
            ],
          );
        },
      ),
    );
  }

  add(Map<String, bool> boxName, List<String> namePlayList) async {
    for (int i = 0; i < namePlayList.length; i++) {
      if (boxName[namePlayList[i]] == true) {
        var box = await Hive.openBox<FavoriteSong>(namePlayList[i]);
        FavoriteSong favoriteSong = FavoriteSong(
            widget.songModel!.title,
            widget.songModel!.data,
            widget.songModel!.id,
            widget.songModel!.artist);
        box.add(favoriteSong);
      }
    }
  }

  addNewList(Map<String, bool> boxName) async {
    Box boxMap = await Hive.openBox<MapPlayList>("map");
    for (int j = 0; j < boxMap.length; j++) {
      if (boxName[boxMap.getAt(j).title] == true) {
        Box boxNew = await Hive.openBox<FavoriteSong>(boxMap.getAt(j).title);
        FavoriteSong favoriteSong = FavoriteSong(
            widget.songModel!.title,
            widget.songModel!.data,
            widget.songModel!.id,
            widget.songModel!.artist);
        boxNew.add(favoriteSong);
      }
    }
  }
}
