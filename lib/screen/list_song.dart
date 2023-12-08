import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:first_project/screen/playSong_page.dart';
import 'package:first_project/widget/playall_container.dart';
import 'package:first_project/widget/popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final AudioPlayer audioPlayer = AudioPlayer();
  final SongSortType songSortType=SongSortType.TITLE;
  TextStyle style =const TextStyle(color: Colors.white);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1a1b1d),
      body: Column(
        children: [
          Expanded(
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  width: 110,
                  height: 30,
                  child: PlayAllContainer()),
              IconButton(
                  onPressed:(){

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Column(mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height/4,
                              color: Colors.red,
                              child: Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Sort Song",textAlign: TextAlign.center),

                                  ),
                                ],
                              )
                              ,
                            ),
                          ],
                        );
                      },
                    );

                  } , icon: Icon(Icons.sort,color: Colors.white
                ,))
            ],
          )),
          Expanded(
            flex: 8,
            child: FutureBuilder<List<SongModel>>(
              future: SongList().getSongs(songSortType),
              builder:
                  (BuildContext context, AsyncSnapshot<List<SongModel>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                            trailing: const SizedBox(
                                width: 35,
                                child: PopupMenuButtonWidget()),
                        title: Text(maxLines: 1,snapshot.data![index].title,style: style,),
                        subtitle: Text(maxLines: 1,snapshot.data![index].displayName,),
                        leading: QueryArtworkWidget(
                            artworkWidth: 60,
                            artworkHeight: 60,
                            artworkFit: BoxFit.cover,
                            artworkBorder: const BorderRadius.all(Radius.circular(0)),
                            id: snapshot.data![index].id, type: ArtworkType.AUDIO),
                        onTap: () async {


                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MultiBlocProvider(
                                        providers: [
                                          BlocProvider(
                                              create: (context) => PlaySongBloc()),
                                          BlocProvider(
                                              create: (context) => PlayNewSongBloc())
                                        ],
                                        child: PlayPage(
                                            songModel: snapshot.data![index],
                                            audioPlayer: audioPlayer,
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
          ),
        ],
      ),
    );
  }
}
