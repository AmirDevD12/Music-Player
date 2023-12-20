import 'package:first_project/core/theme/theme_mode.dart';
import 'package:first_project/locator.dart';
import 'package:first_project/model/dataBase/favorite_dataBase/favorite_song.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatelessWidget {
   FavoriteScreen({Key? key}) : super(key: key);
   Box favorite = Hive.box<FavoriteSong>("Favorite");
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: ValueListenableBuilder(
      valueListenable:favorite.listenable(),
      builder: (context, Box box, child) {
        if (box.values.isEmpty) {
          return const Center(
              child: Padding(
            padding: EdgeInsets.all(50.0),
            child: Text(
              'هیچ لیستی وجود ندارد',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ));
        } else {
          return ListView.builder(
            itemCount: favorite.length,
            itemBuilder: (BuildContext context, int index) {
              final FavoriteSong favoriteSongs = box.getAt(index);
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
                  favoriteSongs.title!,
                  style: locator.get<MyThemes>().title(context),
                  maxLines: 1,
                ),
                subtitle: Text(
                  favoriteSongs.artist!,
                  style: locator.get<MyThemes>().subTitle(context),
                  maxLines: 1,
                ),
                leading: QueryArtworkWidget(
                    artworkWidth: 60,
                    artworkHeight: 60,
                    artworkFit: BoxFit.cover,
                    artworkBorder: const BorderRadius.all(
                        Radius.circular(5)),
                    id: favoriteSongs.id!,
                    type: ArtworkType.AUDIO),
                onTap: () async {

                },
              );
            },
          );
        }
      },
    ));
  }
}
