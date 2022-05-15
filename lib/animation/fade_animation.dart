import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

import 'animation_properties.dart';

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;
  final bool? showAnimation;

  const FadeAnimation(
      {required this.delay, required this.child, Key? key, this.showAnimation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!(showAnimation ?? true)) {
      return child;
    }
    final tween = MultiTween<String>()
      ..add(AniProps.opacity.toString(), Tween(begin: 0.0, end: 1.0),
          const Duration(milliseconds: 500));
    return PlayAnimation(
      delay: Duration(milliseconds: (300 * delay).round()),
      curve: Curves.decelerate,
      // or fastOutSlowIn
      tween: tween,
      child: child,
      builder: (context, child, MultiTweenValues value) =>
          Opacity(
            opacity: value.get(AniProps.opacity.toString()),
            child: child,
          ),
    );
  }
}
