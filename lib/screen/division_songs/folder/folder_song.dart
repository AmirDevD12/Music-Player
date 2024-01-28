import 'package:first_project/core/theme/theme_mode.dart';
import 'package:first_project/locator.dart';
import 'package:first_project/model/addres_folder.dart';
import 'package:first_project/screen/division_songs/folder/showSongFolder.dart';

import 'package:flutter/material.dart';

class FolderList extends StatelessWidget {
  const FolderList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: AddressFolder().location(),
      builder: (context, snapshot) {
        List<String> file = [];
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              for (int i = 0; i <= snapshot.data!.length - 1; i++) {
                List<String> parts = snapshot.data![i].split('/');
                String fileName = parts[parts.length - 1];
                file.add(fileName);
              }
              return ListTile(
                title: Text(
                    maxLines: 1,
                    file[index],
                    style: locator.get<MyThemes>().title(context)),
                subtitle: Text(
                    maxLines: 1,
                    snapshot.data![index],
                    style: locator.get<MyThemes>().subTitle(context)),
                leading: Image.asset(
                  "assets/icon/folder.png",
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShowSongFolder(
                              path: snapshot.data![index],
                              nameFile: file[index])));
                },
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
