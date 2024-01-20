import 'package:checkbox_formfield/checkbox_icon_formfield.dart';
import 'package:first_project/core/theme/theme_mode.dart';
import 'package:first_project/locator.dart';
import 'package:first_project/model/dataBase/favorite_dataBase/favorite_song.dart';
import 'package:first_project/model/songs_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';



class SelectSongScreen extends StatefulWidget {
  final String name;
 final
 List<SongModel> songs;
  const SelectSongScreen({super.key, required this.name, required this.songs});

  @override
  State<SelectSongScreen> createState() => _SelectSongScreenState();
}

class _SelectSongScreenState extends State<SelectSongScreen> {
  SongSortType songSortType = SongSortType.DATE_ADDED;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // boxName={widget.name:false};
    // boxName.addAll()
  }
  List<SongModel> songs=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Screen"),
        actions: [
         IconButton(
           onPressed: (){
             setState(() {
               add(songs);
             });
             Navigator.pop(context);
           },
             icon:  const Icon(Icons.check),)
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          Expanded(
            child:  FutureBuilder<List<SongModel>>(
              future:
              SongList().getSongs(songSortType),
              builder: (BuildContext context,
                  AsyncSnapshot<List<SongModel>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {

                      final themeProvider =
                      Provider.of<ThemeProvider>(context);
                      return ListTile(
                        trailing:CheckboxIconFormField(
                          disabledColor: Colors.black,
                          context: context,
                          iconSize: 30,
                          padding: 10,
                          onSaved: (bool? value) {},
                          onChanged: (value) {
                            if (value) {
                              songs.add(snapshot.data![index]);

                            } else {
                              // ignore: list_remove_unrelated_type
                              songs.removeWhere((element) =>element== snapshot.data![index]);
                            }
                          },
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
                        onTap: () {},
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
  add(List<SongModel> selectSong) async {
    for(int i=0;i<selectSong.length;i++){
      Box boxMain = await Hive.openBox<FavoriteSong>(widget.name);
      FavoriteSong favoriteSong=FavoriteSong(selectSong[i].title, selectSong[i].data,
          selectSong[i].id, selectSong[i].artist);
      boxMain.add(favoriteSong);
    }
  }
}
