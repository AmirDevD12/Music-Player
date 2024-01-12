import 'package:first_project/core/theme/theme_mode.dart';
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
    return   Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
          color:  Color(0xffff435e),
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            path,
            color: Colors.white,
            width: 25,
            height: 25,
          ),

        ],
      ),
    );
  }
}
