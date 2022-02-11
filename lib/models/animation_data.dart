import 'package:flutter/material.dart';

import '../helper/animated_action.dart';

class AnimationData {
  final double speed;

  final List<int> directionIndex;

  final AnimatedAction action;

  final int to;


  const AnimationData({
    required this.speed,
    required this.directionIndex,
    required this.action,
    required this.to
  });
}