
import 'package:flutter/material.dart';

class PlayAllContainer extends StatelessWidget {
   PlayAllContainer({Key? key}) : super(key: key);
  TextStyle style =const TextStyle(color: Colors.white);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.deepPurpleAccent,
        borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Play All",style: style,),
          const SizedBox(width: 10,),
          Image.asset("assets/icon/play-button.png",width: 20,color: Colors.white,)
        ],
      ),
    );
  }
}
