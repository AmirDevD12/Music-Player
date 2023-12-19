import 'package:first_project/bloc/favorite_song/favorite_bloc.dart';
import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:first_project/bloc/sort/sort_song_bloc.dart';
import 'package:first_project/locator.dart';
import 'package:first_project/model/delete_model.dart';
import 'package:first_project/screen/playSong_page.dart';
import 'package:first_project/core/theme/theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../model/songs_model.dart';

class ListMusic extends StatefulWidget {
  const ListMusic({
    super.key,
  });

  @override
  State<ListMusic> createState() => _ListMusicState();
}

class _ListMusicState extends State<ListMusic> {

  SongSortType songSortType = SongSortType.TITLE;
@override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  String select = "";
  String path="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BlocBuilder<SortSongBloc, SortSongState>(
            builder: (context, state) {
              SongSortType sort = SongSortType.TITLE;
              if (state is SortByAddState) {
                sort = state.songSortType;
              }
              return Expanded(
                flex: 10,
                child: BlocBuilder<PlaySongBloc, PlaySongState>(
                  buildWhen: (perivioce,current){
                    if (current is DeleteSongState) {
                      path=current.path;
                      return true ;
                    } else {
                      return false;
                    }
                  },
                  builder: (context, state) {
                    return FutureBuilder<List<SongModel>>(
                      future: SongList().getSongs(sort,path==""?null:path),
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

                                            locator.get<DeleteSong>().getDeleteSong(snapshot.data![index]);
                                            BlocProvider.of<PlaySongBloc>(context).add(DeleteSongEvent(snapshot.data![index].data));
                                          },
                                          value: '/delete',
                                          child: Text("delete"),
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
                                  style: TextStyle(color: themeProvider.isDarkMode?Colors.white:Colors.black,fontFamily: "ibm",fontSize: 15,fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  snapshot.data!.reversed.toList()![index].title,
                                ),
                                subtitle: Text(
                                  style: TextStyle(color: themeProvider.isDarkMode?Colors.white:Colors.black,fontFamily: "ibm",fontSize: 14,),
                                  maxLines: 1,
                                  snapshot.data!.reversed.toList()![index].displayName,
                                ),
                                leading: QueryArtworkWidget(
                                    artworkWidth: 60,
                                    artworkHeight: 60,
                                    artworkFit: BoxFit.cover,
                                    artworkBorder: const BorderRadius.all(
                                        Radius.circular(5)),
                                    id: snapshot.data!.reversed.toList()![index].id,
                                    type: ArtworkType.AUDIO),
                                onTap: () async {
                                  BlocProvider.of<PlaySongBloc>(context).add(
                                      ShowEvent(snapshot.data![index],true));
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
                                                      .get<AudioPlayer>(), play: true,
                                                ),
                                              )));
                                BlocProvider.of<PlayNewSongBloc>(context).add(
                                    NewSongEvent(snapshot.data![index].id,snapshot.data![index].title,
                                        snapshot.data![index].artist!,index));
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
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
