import 'package:flame/sprite.dart';
import 'package:super_devan_world/helper/direction.dart';

class DevanAnimation {
  late Map<Direction, SpriteAnimation> direction;
  final double _animationSpeed = 0.15;

  DevanAnimation({
    required SpriteSheet spriteSheet,
    required int to,
  }) : super() {
    direction = {for (var dir in Direction.values)
      dir: spriteSheet.createAnimation(
          row: dir.index, stepTime: _animationSpeed)
    };
  }
}
