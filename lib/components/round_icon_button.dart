import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoundIconButton extends StatelessWidget {
  RoundIconButton({@required this.icon, @required this.onPressed});

  final IconData? icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0.0,
      child: Icon(icon),
      onPressed: onPressed,

      shape: CircleBorder(),
      // fillColor: Colors.white,
    );
  }
}
