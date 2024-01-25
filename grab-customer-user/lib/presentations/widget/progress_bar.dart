import 'package:flutter/material.dart';
import 'package:grab/utils/constants/themes.dart';

class ProgressBar extends StatelessWidget {
  final double height, width,value;
  final Color color;
   const ProgressBar({
    Key? key,
    required this.width,
    required this.height,
    this.color = MyTheme.greyColor,
    this.value = 0.7,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: LinearProgressIndicator(
          value: value,
          valueColor:
              AlwaysStoppedAnimation<Color>(color),
          backgroundColor: MyTheme.greyColor,
        ),
      ),
    );
  }
}
