import 'package:flutter/material.dart';

class ButtonOne extends StatelessWidget {
  const ButtonOne(
      {super.key,
      required this.title,
      required this.color,
      this.onTap,
      required this.width,
      this.fontSize});
  final String title;
  final Color color;
  final Function()? onTap;
  final double width;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width * width,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
              child: Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: fontSize),
          )),
        ),
      ),
    );
  }
}
