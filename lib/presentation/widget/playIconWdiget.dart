import 'package:flutter/material.dart';
import 'package:samma_tv/presentation/theme/app_color.dart';

class PlayIconWidget extends StatelessWidget {
  const PlayIconWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 50,
      top: 20,
      child: Icon(
        Icons.play_arrow,
        color: AppColor.GradTwo,
        size: 60,
      ),
    );
  }
}
