import 'package:checkbox_formfield/checkbox_icon_formfield.dart';
import 'package:first_project/bloc/favorite_song/favorite_bloc.dart';
import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:first_project/bloc/play_list/play_list_bloc.dart';
import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:first_project/bloc/sort/sort_song_bloc.dart';
import 'package:first_project/core/card_widget.dart';
import 'package:first_project/core/theme/theme_mode.dart';
import 'package:first_project/locator.dart';
import 'package:first_project/model/dataBase/delete_song_dataBase/delete_song.dart';
import 'package:first_project/model/delete_model.dart';
import 'package:first_project/model/songs_model.dart';
import 'package:first_project/screen/bottum_navigation/list_song_bottomnav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  static String nameText = "";
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search song',
              hintStyle: locator.get<MyThemes>().title(context),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  nameText = "";
                  _searchController.clear();
                  setState(() {});
                },
              ),
            ),
            onChanged: (value) {
              nameText = value;

              setState(() {});
            },
          ),
        ),
        Expanded(
            child: ValueListenableBuilder(
          valueListenable: Hive.box<DeleteSong>("Delete Song").listenable(),
          builder: (BuildContext context, value, Widget? child) {
            return FutureBuilder<List<SongModel>>(
              future: SongList().getSongs(SongSortType.TITLE),
              builder: (BuildContext context,
                  AsyncSnapshot<List<SongModel>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      final playlist = ConcatenatingAudioSource(
                        useLazyPreparation: true,
                        shuffleOrder: DefaultShuffleOrder(),
                        children: [
                          for (int i = 0; i < snapshot.data!.length; i++)
                            AudioSource.uri(Uri.parse(snapshot.data![i].data)),
                        ],
                      );

                      if (_searchController.text.isNotEmpty &&
                              snapshot.data![index].title
                                  .toLowerCase()
                                  .contains(
                                      _searchController.text.toLowerCase()) ||
                          snapshot.data![index].displayName
                                  .toLowerCase()
                                  .contains(
                                      _searchController.text.toLowerCase()) &&
                              nameText != "") {
                        return ListTile(
                          trailing: SizedBox(
                            width: 36,
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      color: themeProvider.isDarkMode
                                          ? Colors.black
                                          : Colors.white,
                                      width: double.infinity,
                                      height: 180,
                                      child: Column(
                                        children: <Widget>[
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            style: locator
                                                .get<MyThemes>()
                                                .title(context),
                                            maxLines: 1,
                                            snapshot.data![index].title,
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        GestureDetector(
                                                            child:
                                                                const CardWidget(
                                                          text: 'Play next',
                                                          path:
                                                              "assets/icon/music-player(1).png",
                                                        )),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        GestureDetector(
                                                            onTap: () {
// addPlayList(snapshot.data![index]);
                                                              Navigator.pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => MultiBlocProvider(
                                                                              providers: [
                                                                                BlocProvider(create: (context) => locator.get<PlaySongBloc>()),
                                                                                BlocProvider(
                                                                                  create: (context) => locator.get<PlayNewSongBloc>(),
                                                                                ),
                                                                                BlocProvider(
                                                                                  create: (context) => locator.get<FavoriteBloc>(),
                                                                                ),
                                                                                BlocProvider(
                                                                                  create: (context) => locator.get<PlayListBloc>(),
                                                                                ),
                                                                              ],
                                                                              child: ListSongBottomNavigation(
                                                                                show: true,
                                                                                songModel: snapshot.data![index],
                                                                              ))));
                                                            },
                                                            child:
                                                                const CardWidget(
                                                              text: 'List',
                                                              path:
                                                                  "assets/icon/list(2).png",
                                                            )),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Column(
                                                      children: [
                                                        GestureDetector(
                                                            child:
                                                                const CardWidget(
                                                          text: 'Info',
                                                          path:
                                                              "assets/icon/information-button.png",
                                                        )),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        GestureDetector(
                                                            child:
                                                                const CardWidget(
                                                          text: 'Share',
                                                          path:
                                                              "assets/icon/information-button.png",
                                                        )),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Column(
                                                      children: [
                                                        GestureDetector(
                                                            child:
                                                                const CardWidget(
                                                          text: 'Favorite',
                                                          path:
                                                              "assets/icon/like.png",
                                                        )),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        GestureDetector(
                                                            onTap: () {
                                                              DeleteSongFile()
                                                                  .getDeleteSong(
                                                                      snapshot.data![
                                                                          index]);
// deleteSong(snapshot.data![index].data);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                const CardWidget(
                                                              text: 'Delete',
                                                              path:
                                                                  "assets/icon/delete.png",
                                                            )),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Image.asset(
                                "assets/icon/dots.png",
                                width: 25,
                                height: 25,
                                color: themeProvider.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          title: Text(
                            style: locator.get<MyThemes>().title(context),
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
                              artworkBorder:
                                  const BorderRadius.all(Radius.circular(5)),
                              id: snapshot.data![index].id,
                              type: ArtworkType.AUDIO),
                          onTap: () {},
                        );
                      }
                      return const SizedBox();
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return const Center(child: CircularProgressIndicator());
              },
            );
          },
        )),
      ],
    );
  }
}
