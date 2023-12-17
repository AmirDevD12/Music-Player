import 'package:first_project/core/theme/theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class PopupMenuButtonWidget extends StatelessWidget {
  const PopupMenuButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return
      PopupMenuButton(iconSize: 200,
        icon: Image.asset("assets/icon/dots.png",
          width: 40,height: 40,color:themeProvider.isDarkMode?Colors.white:Colors.black ,),
        onSelected: (value) {
          // your logic
          print("value");
        },
        itemBuilder: (BuildContext bc) {
          return const [
            PopupMenuItem(
              value: '/hello',
              child: Text("delete"),
            ),
            PopupMenuItem(
              value: '/about',
              child: Text("Share"),
            ),
            PopupMenuItem(
              value: '/contact',
              child: Text("Add to playlist"),
            )
          ];
        },
      );
  }
}
