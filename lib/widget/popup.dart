import 'package:flutter/material.dart';
class PopupMenuButtonWidget extends StatelessWidget {
  const PopupMenuButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      PopupMenuButton(iconSize: 200,
        icon: Image.asset("assets/icon/dots.png",width: 40,height: 40,color: Colors.white,),
        onSelected: (value) {
          // your logic
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
