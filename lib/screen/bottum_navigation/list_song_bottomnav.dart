import 'package:first_project/bloc/play_list/play_list_bloc.dart';
import 'package:first_project/core/list_widget_bottomnavigation.dart';
import 'package:first_project/core/theme/theme_mode.dart';
import 'package:first_project/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'favorite_screen.dart';
import 'list/recent_add_screen.dart';

class ListSongBottomNavigation extends StatelessWidget {
 final bool show;
  const ListSongBottomNavigation({Key? key, required this.show}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider =
    Provider.of<ThemeProvider>(context);
    if (show) {
      BlocProvider.of<PlayListBloc>(context).add(ShowBoxEvent());
    }print("aasaasasasasa");
    return Scaffold(
      bottomNavigationBar: BlocBuilder<PlayListBloc, PlayListState>(
  builder: (context, state) {

    return GestureDetector(
        onTap: (){
          BlocProvider.of<PlayListBloc>(context).add(SelectListEvent());
        },
        child: Container(
          width: 300,
          height: 50,
          color: Colors.red,
          child: Text("add")
          ,
        ),
      );
  },
),

//       appBar: AppBar(foregroundColor: Colors.white,
//         title: const Text(
//           style: TextStyle(color: Colors.white),
//           maxLines: 1,
//           "List song",
//         ) ,
//       ),
      body: BlocBuilder<PlayListBloc, PlayListState>(
  builder: (context, state) {
    return Column(
        children: [
          Container(
            color:const Color(0xff304861).withAlpha(themeProvider.isDarkMode?32:320) ,

            child: Column(
              children: [
                show? Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(

                      height: 50,
                      child: Row(
                        children: [
                  Expanded(
                    child: ListTile(
                      title: Text(
                      style:locator.get<MyThemes>().title(context) ,
                    maxLines: 1,
                    "Create new playlist",
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
                                child: Image.asset('assets/icon/plus.png',color: themeProvider.isDarkMode?Colors.white:Colors.black,)),
                          ],
                        ),
                      ),
                    ),
                  )
                        ],
                      )),
                ):SizedBox(),
                InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FavoriteScreen()));
                  },
                  child:  SizedBox(

                      height: 50,
                      child: ListWidgetBottomNavigation(path: 'assets/icon/like.png', title: 'My Favorite', subTitle: '1',)),
                ),
                const SizedBox(height: 10,),
                SizedBox(
                    height: 50,
                    child: ListWidgetBottomNavigation(path: 'assets/icon/clock(1).png', title: 'Recent add', subTitle: '1',)),
                const SizedBox(height: 10,),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecentAddScreen()));
                  },
                  child: SizedBox(
                      height: 50,
                      child: ListWidgetBottomNavigation(path: 'assets/icon/recent.png', title: 'Recent play', subTitle: '1',)),
                ),
                const SizedBox(height: 10,),
                SizedBox(
                    height: 50,
                    child: ListWidgetBottomNavigation(path: 'assets/icon/list(2).png', title: 'Default list', subTitle: '1',)),
                const SizedBox(height: 20,),

              ],
            ),
          ),
        ],
      );
  },
),
    );
  }
}
