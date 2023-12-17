import 'package:flutter/material.dart';

class ContainerTypeSong extends StatelessWidget {
  final String name;
  final String imagePath;
  final Color color;
  const ContainerTypeSong({Key? key, required this.name, required this.imagePath, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: 100,
      height: 70,
      decoration: BoxDecoration(
          color: color,
        borderRadius: const BorderRadius.all(Radius.circular(10))
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Image.asset(imagePath,
              color:  Colors.white,
              width: 25,
              height: 25,
            ),
            Text(name, style: const TextStyle(color:Colors.white,fontFamily: "ibm",fontSize: 15,fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }
}
