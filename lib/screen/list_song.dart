import 'package:first_project/bloc/favorite_song/favorite_bloc.dart';
import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:first_project/bloc/play_list/play_list_bloc.dart';
import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:first_project/bloc/sort/sort_song_bloc.dart';
import 'package:first_project/core/card_widget.dart';
import 'package:first_project/core/playall_container.dart';
import 'package:first_project/locator.dart';
import 'package:first_project/model/dataBase/delete_song_dataBase/delete_song.dart';
import 'package:first_project/model/dataBase/favorite_dataBase/favorite_song.dart';
import 'package:first_project/model/dataBase/recent_play/add_recent_play.dart';
import 'package:first_project/screen/playSong_page.dart';
import 'package:first_project/core/theme/theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../model/songs_model.dart';
import 'bottum_navigation/list_song_bottomnav.dart';

class ListMusic extends StatelessWidget {
  SongSortType songSortType = SongSortType.TITLE;

  String select = "";
  Box boxDelete = Hive.box<DeleteSong>("Delete");
  int length = 0;
  ListMusic({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
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
          ),
          Expanded(
            child: BlocBuilder<SortSongBloc, SortSongState>(
              builder: (context, state) {
                SongSortType sort = SongSortType.TITLE;
                if (state is SortByAddState) {
                  sort = state.songSortType;
                }
                return BlocBuilder<PlaySongBloc, PlaySongState>(
                  buildWhen: (perivioce, current) {
                    if (current is DeleteSongState) {
                      return true;
                    } else {
                      return false;
                    }
                  },
                  builder: (context, state) {
                    return FutureBuilder<List<SongModel>>(
                      future:
                          SongList().getSongs(sort),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<SongModel>> snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (BuildContext context, int index) {

                              final themeProvider =
                                  Provider.of<ThemeProvider>(context);
                              return ListTile(
                                trailing: SizedBox(
                                  width: 36,
                                  child: InkWell(
                                    onTap: (){
                                      showModalBottomSheet<void>(
                                        // context and builder are
                                        // required properties in this widget
                                        context: context,
                                        builder: (BuildContext context) {
                                          // we set up a container inside which
                                          // we create center column and display text

                                          // Returning SizedBox instead of a Container
                                          return Container(
                                            color: themeProvider.isDarkMode?Colors.black:Colors.white,
                                            width: double.infinity,
                                            height: 200,
                                            child: Column(

                                              children:  <Widget>[
                                                const SizedBox(height: 10,),
                                                Text(
                                                  style:locator.get<MyThemes>().title(context) ,
                                                  maxLines: 1,
                                                  snapshot.data![index].title,
                                                ),
                                                const SizedBox(height: 20,),
                                                Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    GestureDetector(
                                                        child: const CardWidget(
                                                          text: 'My Music',path: "assets/icon/music(1).png",)),
                                                    GestureDetector(

                                                        child: const CardWidget(
                                                          text: 'search', path: "assets/icon/magnifying-glass.png",)),
                                                    GestureDetector(
                                                      onTap: (){
                                                        addPlayList(snapshot.data![index]);
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    MultiBlocProvider(
                                                                      providers: [
                                                                        BlocProvider(
                                                                            create: (context) =>
                                                                                locator.get<
                                                                                    PlaySongBloc>()),
                                                                        BlocProvider(
                                                                          create: (context) => locator
                                                                              .get<PlayNewSongBloc>(),
                                                                        ),
                                                                        BlocProvider(
                                                                          create: (context) => locator
                                                                              .get<FavoriteBloc>(),
                                                                        ),
                                                                        BlocProvider(
                                                                          create: (context) => locator
                                                                              .get<PlayListBloc>(),
                                                                        ),
                                                                      ],
                                                                      child: ListSongBottomNavigation(show: true,)
                                                                    )));

                                                      },

                                                        child: const CardWidget(text: 'List', path:"assets/icon/list(2).png",)),
                                                    GestureDetector(
                                                        child: const CardWidget(
                                                          text: 'Path',path:  "assets/icon/information-button.png",)),
                                                  ],
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Image.asset("assets/icon/dots.png",width: 25,height: 25,color: themeProvider.isDarkMode?
                                      Colors.white:Colors.black,),
                                  ),
                                ),
                                title: Text(
                                  style:locator.get<MyThemes>().title(context) ,
                                  maxLines: 1,
                                  snapshot.data![index].title,
                                ),
                                subtitle: Text(
                                  style: locator.get<MyThemes>().subTitle(context),
                                  maxLines: 1,
                                  snapshot.data![index].displayName,
                                ),
                                leading: QueryArtworkWidget(
                                    artworkWidth: 60,
                                    artworkHeight: 60,
                                    artworkFit: BoxFit.cover,
                                    artworkBorder: const BorderRadius.all(
                                        Radius.circular(5)),
                                    id: snapshot.data![index].id,
                                    type: ArtworkType.AUDIO ),
                                onTap: () async {
                                  BlocProvider.of<PlaySongBloc>(context).add(
                                      ShowEvent(snapshot.data![index], true));
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MultiBlocProvider(
                                                providers: [
                                                  BlocProvider(
                                                      create: (context) =>
                                                          locator.get<
                                                              PlaySongBloc>()),
                                                  BlocProvider(
                                                    create: (context) => locator
                                                        .get<PlayNewSongBloc>(),
                                                  ),
                                                  BlocProvider(
                                                    create: (context) => locator
                                                        .get<FavoriteBloc>(),
                                                  ),
                                                ],
                                                child: PlayPage(
                                                  songModel:
                                                      snapshot.data![index],
                                                  audioPlayer: locator
                                                      .get<AudioPlayer>(),
                                                  play: true,
                                                ),
                                              )));
                                             addRecentPlay(snapshot.data![index]);
                                  BlocProvider.of<PlayNewSongBloc>(context).add(
                                      NewSongEvent(
                                          snapshot.data![index].id,
                                          snapshot.data![index].title,
                                          snapshot.data![index].artist!,
                                          index));
                                },
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  add(String path) async {
    var box = await Hive.openBox<DeleteSong>("Delete");
    DeleteSong deleteSong = DeleteSong(path);
    await box.add(deleteSong);
  }
  addRecentPlay(SongModel songModel) async {
    bool check=false;
    var box = await Hive.openBox<RecentPlay>("Recent play");
    for(int i=0;i<box.length;i++){
      if (songModel.data==box.getAt(i)?.path) {
        check=true;
        return;
      }
    }
    if (!check) {
      if (box.length>10) {
        box.deleteAt(0);
      }
      RecentPlay recentPlay=RecentPlay(songModel.title, songModel.data, songModel.id, songModel.artist) ;
      await box.add(recentPlay);
    }
  }
  addPlayList(SongModel songModel) async {
    var box = await Hive.openBox<FavoriteSong>("Favorite");
    FavoriteSong favorite = FavoriteSong(songModel.title,songModel.data,songModel.id,songModel.artist!);
    await  box.add(favorite);
  }
}
