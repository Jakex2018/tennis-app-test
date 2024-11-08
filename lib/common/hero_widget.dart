import 'package:flutter/material.dart';

class HeroWidget extends StatefulWidget {
  const HeroWidget({super.key, required this.tag, required this.child});
  final String tag;
  final Widget child;

  @override
  State<HeroWidget> createState() => _HeroWidgetState();
}

class _HeroWidgetState extends State<HeroWidget> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.tag,
      child: Material(type: MaterialType.transparency, child: widget.child),
    );
  }
}
