
import 'package:first_project/core/theme/theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayAllContainer extends StatefulWidget {
   const PlayAllContainer({Key? key}) : super(key: key);

  @override
  State<PlayAllContainer> createState() => _PlayAllContainerState();
}

class _PlayAllContainerState extends State<PlayAllContainer> {
  late final ThemeProvider themeProvider;
  @override
  void didChangeDependencies() {
    themeProvider = Provider.of<ThemeProvider>(context);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      decoration:  BoxDecoration(
          color: themeProvider.isDarkMode?Colors.deepPurple:Color(0xff1a1b1d),
        borderRadius: const BorderRadius.all(Radius.circular(15))
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Play All",style: TextStyle(color: Colors.white),),
          const SizedBox(width: 10,),
          Image.asset("assets/icon/play-button.png",width: 20,
            color: themeProvider.isDarkMode?Colors.white:Colors.white,)
        ],
      ),
    );
  }
}
