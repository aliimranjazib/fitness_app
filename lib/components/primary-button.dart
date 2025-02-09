import 'package:fit_fyp/constants.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatefulWidget {
  final String title;
  final Function onPress;
  bool loading;

  PrimaryButton({
    Key? key,
    required this.title,
    required this.onPress,
    this.loading = false,
  }) : super(key: key);

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            // Color primaryColor = Color(0x142B44);
            primary: primaryColor,
            alignment: Alignment.center,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: widget.loading
            ? CircularProgressIndicator(
                color: Colors.white,
              )
            : Text(
                widget.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
        onPressed: () {
          widget.onPress();
        },
      ),
    );
  }
}
