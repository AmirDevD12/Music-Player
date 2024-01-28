
import 'package:first_project/locator.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';


class ChangeAnimation{
  toggleAnimation(AnimationController animationController,) {
    if (locator.get<AudioPlayer>().playing) {
      animationController.repeat();
    } else {
       animationController.stop();
    }

  }
}