import 'package:flutter/material.dart';
class PopupMenuButtonWidget extends StatelessWidget {
  const PopupMenuButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      PopupMenuButton(iconSize: 200,
        icon: Image.asset("assets/icon/dots.png",width: 40,height: 40,),
        onSelected: (value) {
          // your logic
        },
        itemBuilder: (BuildContext bc) {
          return const [
            PopupMenuItem(
              child: Text("delete"),
              value: '/hello',
            ),
            PopupMenuItem(
              child: Text("Share"),
              value: '/about',
            ),
            PopupMenuItem(
              child: Text("Add to playlist"),
              value: '/contact',
            )
          ];
        },
      );
  }
}
