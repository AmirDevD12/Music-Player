import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:first_project/bloc/sort/sort_song_bloc.dart';
import 'package:first_project/locator.dart';
import 'package:first_project/model/delete_model.dart';
import 'package:first_project/screen/playSong_page.dart';
import 'package:first_project/theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../model/songs_model.dart';

class ListMusic extends StatefulWidget {
  const ListMusic({super.key});

  @override
  State<ListMusic> createState() => _ListMusicState();
}

class _ListMusicState extends State<ListMusic> {

  final OnAudioQuery onAudioQuery = OnAudioQuery();
  SongSortType songSortType = SongSortType.TITLE;

  String select="";
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BlocBuilder<SortSongBloc, SortSongState>(
           builder: (context, state) {
             SongSortType sort=SongSortType.TITLE;
             if (state is SortByAddState){
               sort=state.songSortType;
             }
               return Expanded(
            flex: 8,
            child: FutureBuilder<List<SongModel>>(
              future: SongList().getSongs(sort),
              builder: (BuildContext context,
                  AsyncSnapshot<List<SongModel>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(

                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      final themeProvider = Provider.of<ThemeProvider>(context);
                      return ListTile(
                        trailing:    SizedBox(width: 36,
                          child: PopupMenuButton(iconSize: 200,
                            icon: Image.asset("assets/icon/dots.png",
                              width: 40,height: 40,color:themeProvider.isDarkMode?Colors.white:Colors.black ,),
                            itemBuilder: (BuildContext bc) {
                              return  [
                                PopupMenuItem(
                                  onTap: (){
                                    DeleteSong().getDeleteSong(snapshot.data![index]);
                                  },
                                  value: '/hello',
                                  child: Text("delete"),
                                ),
                                PopupMenuItem(
                                  value: '/about',
                                  child: Text("Share"),
                                ),
                                PopupMenuItem(
                                  value: '/contact',
                                  child: Text("Add to playlist"),
                                )
                              ];
                            },
                          ),
                        ),
                        title: Text(
                          maxLines: 1,
                          snapshot.data![index].title,

                        ),
                        subtitle: Text(
                          maxLines: 1,
                          snapshot.data![index].displayName,
                        ),
                        leading: QueryArtworkWidget(
                            artworkWidth: 60,
                            artworkHeight: 60,
                            artworkFit: BoxFit.cover,
                            artworkBorder:
                                const BorderRadius.all(Radius.circular(0)),
                            id: snapshot.data![index].id,
                            type: ArtworkType.AUDIO),
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MultiBlocProvider(
                                        providers: [
                                          BlocProvider(
                                              create: (context) =>
                                                  locator.get<PlaySongBloc>()),
                                          BlocProvider(
                                              create: (context) =>
                                                  locator.get<PlayNewSongBloc>())
                                        ],
                                        child: PlayPage(
                                          songModel: snapshot.data![index],
                                          audioPlayer: locator.get<AudioPlayer>(),
                                        ),
                                      )));
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return const Center(child: CircularProgressIndicator());
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
