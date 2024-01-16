import 'package:first_project/core/theme/theme_mode.dart';
import 'package:first_project/locator.dart';
import 'package:first_project/model/dataBase/recent_play/add_recent_play.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class RecentAddScreen extends StatefulWidget {
  RecentAddScreen({Key? key}) : super(key: key);

  @override
  State<RecentAddScreen> createState() => _RecentAddScreenState();
}

class _RecentAddScreenState extends State<RecentAddScreen> {
  Box recentPlay = Hive.box<RecentPlay>("Recent play");
  late final ThemeProvider themeProvider;
  @override
  void didChangeDependencies() {
    themeProvider = Provider.of<ThemeProvider>(context);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: ValueListenableBuilder(
          valueListenable:recentPlay.listenable(),
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
                itemCount: recentPlay.length,
                itemBuilder: (BuildContext context, int index) {
                  final RecentPlay recentPlay = box.getAt(index);

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
                      recentPlay.title!,
                      style: locator.get<MyThemes>().title(context),
                      maxLines: 1,
                    ),
                    subtitle: Text(
                      recentPlay.artist!,
                      style: locator.get<MyThemes>().subTitle(context),
                      maxLines: 1,
                    ),
                    leading: QueryArtworkWidget(
                        artworkWidth: 60,
                        artworkHeight: 60,
                        artworkFit: BoxFit.cover,
                        artworkBorder: const BorderRadius.all(
                            Radius.circular(5)),
                        id: recentPlay.id!,
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
