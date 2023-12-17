import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String text;
  final IconData iconData;
  const CardWidget({super.key, required this.text, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return   Column(
      children: [
        Icon(iconData,size: 35,),
        Text(text)
      ],
    );
  }
}
