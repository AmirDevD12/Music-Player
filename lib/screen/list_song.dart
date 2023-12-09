import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:first_project/bloc/sort/sort_song_bloc.dart';
import 'package:first_project/locator.dart';
import 'package:first_project/screen/playSong_page.dart';
import 'package:first_project/widget/playall_container.dart';
import 'package:first_project/widget/popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../model/songs_model.dart';

class ListMusic extends StatefulWidget {
  const ListMusic({super.key});

  @override
  State<ListMusic> createState() => _ListMusicState();
}

class _ListMusicState extends State<ListMusic> {
  final OnAudioQuery onAudioQuery = OnAudioQuery();
  final AudioPlayer audioPlayer = locator.get<AudioPlayer>();
  SongSortType songSortType = SongSortType.TITLE;
  TextStyle style = const TextStyle(color: Colors.white);
  String select="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1a1b1d),
      body: Column(
        children: [
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 110, height: 30, child: PlayAllContainer()),
              PopupMenuButton(
                color: const Color(0xff1a1b1d),

                icon: Icon(Icons.sort,color: Colors.white,size: 30,),
                onSelected: (value) {
                  print(value);
                  select=value;
                },
                itemBuilder: (BuildContext bc) {
                  return [
                    PopupMenuItem(
                      onTap: (){
                        songSortType=SongSortType.DATE_ADDED;
                        BlocProvider.of<SortSongBloc>(context).add(SortByAddEvent());
                      },
                      value: '/time',
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Based on add time",
                              style: style,
                            ),
                          const SizedBox(width: 10,),
                          select=='/time'?  const Icon(
                              Icons.check,
                              color: Colors.white,
                            ):const SizedBox()
                          ],
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      onTap: (){
                        songSortType=SongSortType.TITLE;
                        BlocProvider.of<SortSongBloc>(context).add(SortByTitleEvent());
                      },
                      value: '/name',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Based on name",
                            style: style,
                          ),const SizedBox(width: 10,),
                          select=='/name'? const Icon(
                            Icons.check,
                            color: Colors.white,
                          ):const SizedBox()
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      onTap: (){
                        songSortType=SongSortType.ARTIST;
                        BlocProvider.of<SortSongBloc>(context).add(SortByArtistEvent());
                      },
                      value: '/artist',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Based on artist",
                            style: style,
                          ),const SizedBox(width: 10,),
                          select=='/artist'? const Icon(
                            Icons.check,
                            color: Colors.white,
                          ):const SizedBox()
                        ],
                      ),
                    ),

                  ];
                },
              )
            ],
          )),
          BlocBuilder<SortSongBloc, SortSongState>(
           builder: (context, state) {
               return Expanded(
            flex: 8,
            child: FutureBuilder<List<SongModel>>(
              future: SongList().getSongs(songSortType),
              builder: (BuildContext context,
                  AsyncSnapshot<List<SongModel>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        trailing: const SizedBox(
                            width: 35, child: PopupMenuButtonWidget()),
                        title: Text(
                          maxLines: 1,
                          snapshot.data![index].title,
                          style: style,
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
