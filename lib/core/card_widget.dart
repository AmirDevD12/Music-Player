import 'package:first_project/core/theme/theme_mode.dart';
import 'package:first_project/locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardWidget extends StatelessWidget {
  final String text;
  final String path;
   const CardWidget({super.key, required this.text, required this.path,});

  @override
  Widget build(BuildContext context) {
    final themeProvider =
  Provider.of<ThemeProvider>(context);
    return   SizedBox(
      width: 70,
      height: 50,

      child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            path,
            color: themeProvider.isDarkMode?Colors.white:Colors.black,
            width: 25,
            height: 25,
          ),
          Text(text,style: locator.get<MyThemes>().subTitle(context),)
        ],
      ),
    );
  }
}
