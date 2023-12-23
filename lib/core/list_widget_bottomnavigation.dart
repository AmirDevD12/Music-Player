import 'package:checkbox_formfield/checkbox_icon_formfield.dart';
import 'package:first_project/bloc/favorite_song/favorite_bloc.dart';
import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:first_project/bloc/play_list/play_list_bloc.dart';
import 'package:first_project/bloc/play_list/play_list_bloc.dart';
import 'package:first_project/bloc/play_song_bloc.dart';
import 'package:first_project/core/theme/theme_mode.dart';
import 'package:first_project/locator.dart';
import 'package:first_project/screen/playSong_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ListWidgetBottomNavigation extends StatelessWidget {
  final String path;
  final String title;
  final String subTitle;
   ListWidgetBottomNavigation({Key? key, required this.path, required this.title, required this.subTitle}) : super(key: key);
  String? name;
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    bool checkboxIconFormFieldValue = false;
    final themeProvider =
    Provider.of<ThemeProvider>(context);
    return Row(
      children: [
    Expanded(
      child: ListTile(
      trailing: BlocBuilder<PlayListBloc, PlayListState>(
  builder: (context, state) {
    return state is ShowBoxState?CheckboxIconFormField(
      disabledColor: Colors.black,
      context: context,
      initialValue: checkboxIconFormFieldValue,

      iconSize: 30,
      padding: 10,
      onSaved: (bool? value) {
        print(value);
        // checkboxIconFormFieldValue = value;
      },
      onChanged: (value) {
        if (value) {
          name=title;
          print(title);
        } else {
          name=null;
          print("Icon Not Checked :(");
        }

        // BlocProvider.of<PlayListBloc>(context).add(SelectEvent(name));
      },
    ):SizedBox(
        height: 50,
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
                child: const Text("delete"),
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
      );
  },
),
      title: Text(
        style:locator.get<MyThemes>().title(context) ,
        maxLines: 1,
        title,
      ),
      subtitle: Text(
        style: locator.get<MyThemes>().subTitle(context),
        maxLines: 1,
        subTitle,
      ),
      leading:Container(
        decoration: const BoxDecoration(
            color: Colors.black26,
          borderRadius: BorderRadius.all(Radius.circular(5))
        ),
         width: 50,
        height: 50,
        child: Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: 30,
                height: 30,
                child: Image.asset(path,color: themeProvider.isDarkMode?Colors.white:Colors.black,)),
          ],
        ),
      ),

          ),
    )
      ],
    );
  }
}
