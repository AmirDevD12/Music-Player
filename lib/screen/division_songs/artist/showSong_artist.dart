
import 'package:first_project/bloc/favorite_song/favorite_bloc.dart';
import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:first_project/bloc/sort/sort_song_bloc.dart';
import 'package:first_project/core/playall_container.dart';
import 'package:first_project/core/popup.dart';
import 'package:first_project/core/theme/theme_mode.dart';
import 'package:first_project/locator.dart';
import 'package:first_project/model/list_artist.dart';
import 'package:first_project/screen/playSong_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class ShowListArtist extends StatefulWidget {
  final String nameArtist;
  const ShowListArtist({Key? key, required this.nameArtist}) : super(key: key);

  @override
  State<ShowListArtist> createState() => _ShowListArtistState();
}

class _ShowListArtistState extends State<ShowListArtist> {
  @override
  Widget build(BuildContext context) {
    final  themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(widget.nameArtist,),
        ),
        body:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FutureBuilder<List<SongModel>>(
                future: locator.get<ListArtist>().getLisArtist(widget.nameArtist),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final playlist = ConcatenatingAudioSource(
                          useLazyPreparation: true,
                          shuffleOrder: DefaultShuffleOrder(),
                          children: [
                            for(int i=0;i<snapshot.data!.length;i++)
                              AudioSource.uri(Uri.parse(snapshot.data![i].data),
                                  tag: MediaItem(
                                    id: '${snapshot.data![i].id}',
                                    album: snapshot.data![i].album??"",
                                    title: snapshot.data![i].title,
                                    artUri: Uri.parse('https://example.com/albumart.jpg'),
                                  )),
                          ],
                        );
                        return Column(
                          children: [
                            Container(
                              color: themeProvider.isDarkMode?const Color(0xff1a1b1d):locator.get<MyThemes>().cContainerSong,
                              child: ListTile(
                                title: Text(maxLines: 1,snapshot.data![index].title,style: locator.get<MyThemes>().title(context),),
                                subtitle: Text(maxLines: 1,snapshot.data![index].displayName,style: locator.get<MyThemes>().subTitle(context),),
                                leading: QueryArtworkWidget(
                                    nullArtworkWidget: Image.asset(
                                        "assets/icon/vinyl-record.png"),
                                    artworkWidth: 60,
                                    artworkHeight: 60,
                                    artworkFit: BoxFit.cover,
                                    artworkBorder:
                                    const BorderRadius.all(
                                        Radius.circular(5)),
                                    id: snapshot.data![index].id,
                                    type: ArtworkType.AUDIO),
                                onTap: () async {
                                  List<SongModel> songs=await locator.get<ListArtist>().getLisArtist(widget.nameArtist);

                                  // ignore: use_build_context_synchronously
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MultiBlocProvider(
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
                                                    .get<SortSongBloc>(),
                                              ),
                                            ],
                                            child: PlayPage(playInList: false, concatenatingAudioSource: playlist , index: index, songs: songs, nameList: null,
                                            ),
                                          )));

                                },
                              ),
                            ),
                            const SizedBox(height: 20,)
                          ],
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ));
  }
}
