import 'dart:async';

import 'package:flutter/material.dart';

class AnimatedGradientContainer extends StatefulWidget {
  final Widget child;
  const AnimatedGradientContainer({required this.child, super.key});

  @override
  _AnimatedGradientContainerState createState() =>
      _AnimatedGradientContainerState();
}

class _AnimatedGradientContainerState extends State<AnimatedGradientContainer> {
  List<Color> colors = [
    // Colors.purple.shade200,
    Colors.blue.shade200,
    Colors.green.shade200,
    // Colors.yellow.shade200,
    // Colors.orange.shade200,
    Colors.red.shade200,
  ];
  int index = 0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          index++;
          if (index >= colors.length) {
            index = 0;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors[index],
            colors[(index + 1) % colors.length],
          ],
        ),
      ),
      child: widget.child,
    );
  }
}
