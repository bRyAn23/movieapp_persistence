import 'package:flutter/material.dart';
import 'package:week3_movieapp/resources/colors.dart';
import 'package:week3_movieapp/resources/dimens.dart';

class PlayButtonView extends StatelessWidget {
  const PlayButtonView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.play_circle_fill,
      size :BANNER_PLAY_BUTTON_SIZE,
      color: PLAY_BUTTON_COLOR,
    );
  }
}