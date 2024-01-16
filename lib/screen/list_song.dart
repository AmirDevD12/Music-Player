
import 'package:checkbox_formfield/checkbox_icon_formfield.dart';
import 'package:first_project/bloc/favorite_song/favorite_bloc.dart';
import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:first_project/bloc/play_list/play_list_bloc.dart';
import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:first_project/bloc/sort/sort_song_bloc.dart';
import 'package:first_project/core/card_widget.dart';
import 'package:first_project/core/playall_container.dart';
import 'package:first_project/locator.dart';
import 'package:first_project/model/dataBase/delete_song_dataBase/delete_song.dart';
import 'package:first_project/model/dataBase/recent_play/add_recent_play.dart';
import 'package:first_project/model/delete_model.dart';
import 'package:first_project/screen/playSong_page.dart';
import 'package:first_project/core/theme/theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../model/songs_model.dart';
import 'bottum_navigation/list_song_bottomnav.dart';

class ListMusic extends StatefulWidget {

  ListMusic({super.key});

  @override
  State<ListMusic> createState() => _ListMusicState();
}

class _ListMusicState extends State<ListMusic> {
  SongSortType songSortType = SongSortType.TITLE;

  String select = "";

  Box boxDelete = Hive.box<DeleteSong>("Delete Song");

  int length = 0;

  SongSortType sort = SongSortType.TITLE;

final TextStyle sun=TextStyle(color: Colors.black,fontSize: 20,fontFamily: "ibm",fontWeight: FontWeight.bold);

final TextStyle moon=TextStyle(color: Colors.white,fontSize: 20,fontFamily: "ibm",fontWeight: FontWeight.bold);
  late final ThemeProvider themeProvider;
  @override
  void didChangeDependencies() {
    themeProvider = Provider.of<ThemeProvider>(context);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode?const Color(0xff1a1b1d):const Color(0xfff3f6fb),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 110, height: 30, child: PlayAllContainer()),
                PopupMenuButton(
                  color: themeProvider.isDarkMode? Colors.white:Colors.black,
                  icon: const Icon(Icons.sort,size: 30,),
                  itemBuilder: (BuildContext bc) {
                    return [
                      PopupMenuItem(
                        onTap: (){
                          var songSortType=SongSortType.DATE_ADDED;
                          BlocProvider.of<SortSongBloc>(context).add(SortByAddEvent(songSortType));
                        },
                        value: '/time',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Based on add time",
                              style: themeProvider.isDarkMode?sun:moon,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Based on name",
                              style: themeProvider.isDarkMode?sun:moon,
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
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Based on artist",
                              style: themeProvider.isDarkMode?sun:moon,
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
            child: BlocBuilder<PlayListBloc, PlayListState>(
              buildWhen: (previous,current){
                if(current is NewListState){
                  return true;
                }else {
                  return false;
                }
              },
  builder: (context, state) {
    return BlocBuilder<SortSongBloc, SortSongState>(
              builder: (context, state) {

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
                    return ValueListenableBuilder(
                      valueListenable: Hive.box<DeleteSong>("Delete Song").listenable(),
                      builder: (BuildContext context, value, Widget? child) {
                        return FutureBuilder<List<SongModel>>(
                          future:
                          SongList().getSongs(sort),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<SongModel>> snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(

                                itemCount: snapshot.data?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  print(snapshot.data!.length);
                                  final playlist = ConcatenatingAudioSource(
                                    useLazyPreparation: true,
                                    shuffleOrder: DefaultShuffleOrder(),
                                    children: [
                                      for(int i=0;i<snapshot.data!.length;i++)
                                        AudioSource.uri(Uri.parse(snapshot.data![i].data)),
                                    ],
                                  );

                                  return ListTile(
                                    trailing: state is NewListState ?CheckboxIconFormField(
                                      disabledColor: Colors.black,
                                      context: context,
                                      iconSize: 30,
                                      padding: 10,
                                      onSaved: (bool? value) {},
                                      onChanged: (value) {
                                        if (value) {
                                          // boxc[name[index]]=true;
                                        } else {
                                          // boxc[name[index]]=false;
                                        }

                                      },
                                    ):SizedBox(
                                      width: 36,
                                      child: InkWell(
                                        onTap: (){
                                          showModalBottomSheet<void>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Container(

                                                color: themeProvider.isDarkMode?Colors.black:Colors.white,
                                                width: double.infinity,
                                                height: 180,
                                                child: Column(
                                                  children:  <Widget>[
                                                    const SizedBox(height: 10,),
                                                    Text(
                                                      style:locator.get<MyThemes>().title(context) ,
                                                      maxLines: 1,
                                                      snapshot.data![index].title,
                                                    ),
                                                    const SizedBox(height: 15,),
                                                    Column(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(10.0),
                                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  GestureDetector(
                                                                      child: const CardWidget(
                                                                        text: 'Play next',path: "assets/icon/music-player(1).png",)),
                                                                  const SizedBox(height: 10,),

                                                                  GestureDetector(
                                                                      onTap: (){
                                                                        // addPlayList(snapshot.data![index]);
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
                                                                                        child: ListSongBottomNavigation(show: true, songModel: snapshot.data![index],)
                                                                                    )));

                                                                      },

                                                                      child: const CardWidget(text: 'List', path:"assets/icon/list(2).png",)),

                                                                ],
                                                              ),
                                                              const SizedBox(width: 20,),
                                                              Column(
                                                                children: [
                                                                  GestureDetector(
                                                                      child: const CardWidget(
                                                                        text: 'Info',path:  "assets/icon/information-button.png",)),                                                              const SizedBox(height: 10,),

                                                                  const SizedBox(height: 10,),

                                                                  GestureDetector(
                                                                    onTap: (){
                                                                      shareSong(snapshot.data![index].data);
                                                                    },
                                                                      child: const CardWidget(
                                                                        text: 'Share',path:  "assets/icon/share.png",)),

                                                                ],
                                                              ),
                                                              const SizedBox(width: 20,),
                                                              Column(
                                                                children: [
                                                                  GestureDetector(
                                                                      child: const CardWidget(
                                                                        text: 'Favorite',path:  "assets/icon/like.png",)),                                                              const SizedBox(height: 10,),
                                                                  const SizedBox(height: 10,),


                                                                  GestureDetector(
                                                                      onTap: (){
                                                                        DeleteSongFile().getDeleteSong(snapshot.data![index]);
                                                                        deleteSong(snapshot.data![index].data);
                                                                        Navigator.pop(context);
                                                                      },
                                                                      child: const CardWidget(
                                                                        text: 'Delete', path: "assets/icon/delete.png",)),
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
                                        nullArtworkWidget: Image.asset("assets/icon/vinyl-record.png"),
                                        artworkWidth: 60,
                                        artworkHeight: 60,
                                        artworkFit: BoxFit.cover,
                                        artworkBorder: const BorderRadius.all(
                                            Radius.circular(5)),
                                        id: snapshot.data![index].id,
                                        type: ArtworkType.AUDIO ),
                                    onTap: () async {
                                      List<SongModel>songs=await SongList().getSongs(sort);
                                      // ignore: use_build_context_synchronously
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
                                                      play: true, concatenatingAudioSource: playlist, index: index, songs: songs,
                                                    ),
                                                  )));
                                      addRecentPlay(snapshot.data![index]);
                                      // BlocProvider.of<PlayNewSongBloc>(context).add(PlayNewSongEvent());

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

  deleteSong(String path) async {
    var box = await Hive.openBox<DeleteSong>("Delete Song");
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
  Future<void> shareSong(String songPath) async {
    try {
      await Share.shareFiles([songPath], text: 'Check out this song!');
    } catch (e) {
      print('Error sharing file: $e');
    }
  }
}
