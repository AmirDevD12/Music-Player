
import 'package:first_project/bloc/favorite_song/favorite_bloc.dart';
import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:first_project/bloc/sort/sort_song_bloc.dart';
import 'package:first_project/core/theme/theme_mode.dart';
import 'package:first_project/locator.dart';
import 'package:first_project/model/get_song_file.dart';
import 'package:first_project/screen/playSong_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class ShowSongFolder extends StatelessWidget {
  final String path;
  final String nameFile;
  const ShowSongFolder({Key? key, required this.path, required this.nameFile,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final  themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.isDarkMode?Colors.black:Colors.white,
      appBar: AppBar(

        title:Text(nameFile,) ,
      ),

      body: FutureBuilder<List<SongModel>>(
        future: locator.get<GetSongFile>().getSongFile(path),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length ,
              itemBuilder: (context, index) {
                final  playlist = ConcatenatingAudioSource(
                  useLazyPreparation: true,
                  shuffleOrder: DefaultShuffleOrder(),
                  children: [
                    for(int i=0;i<snapshot.data!.length;i++)
                      AudioSource.uri(Uri.parse(snapshot.data![i].data)),
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
                            artworkWidth: 60,
                            artworkHeight: 60,
                            artworkFit: BoxFit.cover,
                            artworkBorder: const BorderRadius.all(Radius.circular(0)),
                            id: snapshot.data![index].id, type: ArtworkType.AUDIO),
                        onTap: () async {List<SongModel>songs=await locator.get<GetSongFile>().getSongFile(path);
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
                                      BlocProvider(
                                        create: (context) => locator
                                            .get<FavoriteBloc>(),
                                      ),
                                    ],
                                    child: PlayPage(

                                       playInList: false, concatenatingAudioSource:playlist , index: index, songs:songs, nameList: null,
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
    );
  }
}
