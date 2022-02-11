import 'package:flame/sprite.dart';
import 'package:super_devan_world/helper/direction.dart';

class DevanAnimation {
  late Map<Direction, SpriteAnimation> direction;
  DevanAnimation({
    required SpriteSheet spriteSheet,
    required int to,
    required double speed,
    required List<int> directionIndex
  }) : super() {
    direction = {for (var dir in Direction.values)
      dir: spriteSheet.createAnimation(
          row: directionIndex[dir.index], stepTime: speed)
    };
  }
}
