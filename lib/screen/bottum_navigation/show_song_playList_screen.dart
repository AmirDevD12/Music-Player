import 'package:first_project/core/theme/theme_mode.dart';
import 'package:first_project/locator.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatelessWidget {
  final String name;
  final Box boxes;
   const FavoriteScreen({Key? key, required this.name, required this.boxes}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
    appBar:  AppBar(foregroundColor: Colors.white,
          title:  Text(
            style: const TextStyle(color: Colors.white),
            maxLines: 1,
            name,
          ),),
        body: ValueListenableBuilder(
      valueListenable:boxes.listenable(),
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
            itemCount: box.length,
            itemBuilder: (BuildContext context, int index) {

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
                  boxes.getAt(index).title!,
                  style: locator.get<MyThemes>().title(context),
                  maxLines: 1,
                ),
                subtitle: Text(
                  boxes.getAt(index).artist!,
                  style: locator.get<MyThemes>().subTitle(context),
                  maxLines: 1,
                ),
                leading: QueryArtworkWidget(
                    artworkWidth: 60,
                    artworkHeight: 60,
                    artworkFit: BoxFit.cover,
                    artworkBorder: const BorderRadius.all(
                        Radius.circular(5)),
                    id: boxes.getAt(index).id!,
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
