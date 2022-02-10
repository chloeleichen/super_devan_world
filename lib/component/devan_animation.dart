import 'package:flame/sprite.dart';

class DevanAnimation {
  late SpriteAnimation up;
  late SpriteAnimation down;
  late SpriteAnimation left;
  late SpriteAnimation right;
  final double _animationSpeed = 0.15;

  DevanAnimation({
    required SpriteSheet spriteSheet,
    required int to,
}) : super(){
    up =
        spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed);
    down =
        spriteSheet.createAnimation(row: 1, stepTime: _animationSpeed);
    left =
        spriteSheet.createAnimation(row: 2, stepTime: _animationSpeed);
    right =
        spriteSheet.createAnimation(row: 3, stepTime: _animationSpeed);
     }
  }
