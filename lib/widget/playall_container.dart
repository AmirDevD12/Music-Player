
import 'package:first_project/theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayAllContainer extends StatelessWidget {
   PlayAllContainer({Key? key}) : super(key: key);
  TextStyle style =const TextStyle(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      decoration:  BoxDecoration(
          color: themeProvider.isDarkMode?Colors.deepPurple:Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(15))
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Play All",),
          const SizedBox(width: 10,),
          Image.asset("assets/icon/play-button.png",width: 20,
            color: themeProvider.isDarkMode?Colors.white:Colors.deepPurple,)
        ],
      ),
    );
  }
}
