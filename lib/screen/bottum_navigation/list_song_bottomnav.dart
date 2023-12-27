import 'dart:core';

import 'package:checkbox_formfield/checkbox_icon_formfield.dart';
import 'package:first_project/bloc/play_list/play_list_bloc.dart';
import 'package:first_project/core/theme/theme_mode.dart';
import 'package:first_project/locator.dart';

import 'package:first_project/model/dataBase/favorite_dataBase/favorite_song.dart';
import 'package:first_project/model/dataBase/map_string_bool/map_playList.dart';
import 'package:first_project/model/dataBase/play_list_recent_add/play_list_recent_add.dart';
import 'package:first_project/model/dataBase/recent_play/add_recent_play.dart';
import 'package:first_project/model/songs_model.dart';
import 'package:first_project/screen/bottum_navigation/list/select_song_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'show_song_playList_screen.dart';

class ListSongBottomNavigation extends StatefulWidget {
  final bool show;
  const ListSongBottomNavigation({Key? key, required this.show})
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

  Map<String, bool> boxc = {
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
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
                          .getSongs(SongSortType.TITLE);
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
                    add(boxc, name);
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
              widget.show
                  ? Expanded(
                flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SizedBox(
                            height: 50,
                            child: Row(
                              children: [
                                Expanded(
                                  child: ListTile(
                                    title: Text(
                                      style: locator
                                          .get<MyThemes>()
                                          .title(context),
                                      maxLines: 1,
                                      "Create new playlist",
                                    ),
                                    leading: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.black45,
                                          borderRadius: BorderRadius.all(
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
                                                'assets/icon/plus.png',
                                                color: themeProvider.isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )),
                      ),
                    )
                  : const SizedBox(),
              Expanded(
                flex: 6,
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
                                        disabledColor: Colors.black,
                                        context: context,
                                        iconSize: 30,
                                        padding: 10,
                                        onSaved: (bool? value) {},
                                        onChanged: (value) {
                                          if (value) {
                                            boxc[name[index]] = true;
                                          } else {
                                            boxc[name[index]] = false;
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
                                                onTap: () {},
                                                value: '/delete',
                                                child: const Text("delete"),
                                              ),
                                              const PopupMenuItem(
                                                value: '/share',
                                                child: Text("Share"),
                                              ),
                                              const PopupMenuItem(
                                                value: '/add',
                                                child: Text("Add to playlist"),
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
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(5))),
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
                            return SizedBox(
                              height: 50,
                              child: ListTile(
                                trailing: widget.show?CheckboxIconFormField(
                                    disabledColor: Colors.black,
                                    context: context,
                                    iconSize: 30,
                                    padding: 10,
                                    onSaved: (bool? value) {},
                                    onChanged: (value) {
                                      if (value) {
                                        boxc[box.getAt(index).titlle] = true;
                                      } else {
                                        boxc[box.getAt(index).title] = false;
                                      }
                                    },
                                  ): SizedBox(
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
                                          onTap: () {},
                                          value: '/delete',
                                          child: const Text("delete"),
                                        ),
                                        const PopupMenuItem(
                                          value: '/share',
                                          child: Text("Share"),
                                        ),
                                        const PopupMenuItem(
                                          value: '/add',
                                          child: Text("Add to playlist"),
                                        )
                                      ];
                                    },
                                  ),
                                ),

                                title: Text(
                                  box.getAt(index).title!,
                                  style: locator.get<MyThemes>().title(context),
                                  maxLines: 1,
                                ),
                                subtitle: Text(
                                  box.getAt(index).title,
                                  style:
                                      locator.get<MyThemes>().subTitle(context),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                  if(!widget.show){   Box boxList=await Hive.openBox<FavoriteSong>(box.getAt(index).title);
                                  // ignore: use_build_context_synchronously
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FavoriteScreen(
                                            name: box.getAt(index).title,
                                            boxes: boxList,
                                          )));}

                                },
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
    Box boxMain = await Hive.openBox<FavoriteSong>("Favorite");
    int length = boxMain.length;
    print(length);
    for (int i = 0; i < namePlayList.length; i++) {
      if (boxName[namePlayList[i]]!) {
        if (namePlayList[i] == "Recent play") {
          var box = await Hive.openBox<RecentPlay>(namePlayList[i]);
          RecentPlay recentPlay = RecentPlay(
              boxMain.getAt(length - 1)?.title,
              boxMain.getAt(length - 1)?.path,
              boxMain.getAt(length - 1)?.id,
              boxMain.getAt(length - 1)?.artist);
          box.add(recentPlay);
        } else if (namePlayList[i] == "Favorite") {
          var box = await Hive.openBox<FavoriteSong>(namePlayList[i]);
          FavoriteSong favoriteSong = FavoriteSong(
              boxMain.getAt(length - 1)?.title,
              boxMain.getAt(length - 1)?.path,
              boxMain.getAt(length - 1)?.id,
              boxMain.getAt(length - 1)?.artist);
          boxMain.deleteAt(length - 1);
          box.add(favoriteSong);
        } else if (namePlayList[i] == "Recent add") {
          var box = await Hive.openBox<PlayListRecentAdd>(namePlayList[i]);
          PlayListRecentAdd playListRecentAdd = PlayListRecentAdd(
              boxMain.getAt(length - 1)?.title,
              boxMain.getAt(length - 1)?.path,
              boxMain.getAt(length - 1)?.id,
              boxMain.getAt(length - 1)?.artist);
          box.add(playListRecentAdd);
        }else if (namePlayList[i] == nameNew) {
          var box = await Hive.openBox<FavoriteSong>(namePlayList[i]);
          FavoriteSong favorite = FavoriteSong(
              boxMain.getAt(length - 1)?.title,
              boxMain.getAt(length - 1)?.path,
              boxMain.getAt(length - 1)?.id,
              boxMain.getAt(length - 1)?.artist);
          box.add(favorite);
        }
      }
    }
  }
  // addNewList(List<SongModel> selectSong) async {
  //   Box boxMain = await Hive.openBox<FavoriteSong>("Favorite");
  //   int length = boxMain.length;
  //   for(int i=4;i<boxc.length;i++){
  //     if(boxc[i])
  //     Box boxMain = await Hive.openBox<FavoriteSong>(widget.name);
  //     FavoriteSong favoriteSong=FavoriteSong(selectSong[i].title, selectSong[i].data,
  //         selectSong[i].id, selectSong[i].artist);
  //     boxMain.add(favoriteSong);
  //   }
  // }
}
