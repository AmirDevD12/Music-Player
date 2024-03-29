
import 'package:first_project/bloc/favorite_song/favorite_bloc.dart';
import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:first_project/bloc/sort/sort_song_bloc.dart';
import 'package:first_project/core/popup.dart';
import 'package:first_project/core/theme/theme_mode.dart';
import 'package:first_project/locator.dart';
import 'package:first_project/model/info_for_route.dart';
import 'package:first_project/model/newSong.dart';
import 'package:first_project/model/songs_model.dart';
import 'package:first_project/screen/playSong_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({super.key});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  final OnAudioQuery onAudioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    final  themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.isDarkMode?Colors.black:Colors.white,
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<SongModel>>(
              future: SongList().getSongs(SongSortType.ALBUM),
              builder:
                  (BuildContext context, AsyncSnapshot<List<SongModel>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(

                    itemCount: snapshot.data?.length??0,
                    itemBuilder: (BuildContext context, int index) {
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
                                  artUri: Uri.parse(snapshot.data![i].id.toString()),
                                )),
                        ],
                      );
                      return Column(
                        children: [
                          Container(
                            color: themeProvider.isDarkMode?const Color(0xff1a1b1d):locator.get<MyThemes>().cContainerSong,
                            child: ListTile(
                              title: Text(
                                style: locator.get<MyThemes>().title(context),
                                maxLines: 1,
                                snapshot.data![index].album??snapshot.data![index].displayName,
                              ),
                              subtitle: Text(
                                style: locator.get<MyThemes>().subTitle(context),
                                maxLines: 1,
                                snapshot.data![index].artist??snapshot.data![index].title,
                              ),
                              leading: QueryArtworkWidget(
                                  artworkWidth: 60,
                                  artworkHeight: 60,
                                  artworkFit: BoxFit.cover,
                                  artworkBorder: const BorderRadius.all(Radius.circular(0)),
                                  id: snapshot.data![index].id,
                                  type: ArtworkType.AUDIO),
                              onTap: () async {
                                List<SongModel> songs=await SongList().getSongs(SongSortType.ALBUM);
                                locator.get<InfoPage>().setInfo(playlist, index, songs, null);
                                // ignore: use_build_context_synchronously
                                context.push(
                                    PlayPage.routePlayPage,
                                    extra: locator.get<InfoPage>());
                                locator.get<PlayNewSong>()
                                    .newSong(index, context,playlist, false);
                              },
                            ),
                          ),
                          const SizedBox(height: 20,)
                        ],
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
