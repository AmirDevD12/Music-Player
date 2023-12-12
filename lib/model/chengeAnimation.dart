import 'package:first_project/bloc/newSong/play_new_song_bloc.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeAnimation{
  toggleAnimation(AnimationController animationController,bool isAnimating) {

    if (!isAnimating) {
      animationController.stop();


    } else {
      animationController.repeat();

    }

  }
}