
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';


class ChangeAnimation{
  toggleAnimation(AnimationController animationController,bool isAnimating) {
    if (!isAnimating) {
      animationController.stop();
    } else {
      animationController.repeat();
    }

  }
}