import 'package:flame/sprite.dart';

class DevanAnimation {
  late SpriteAnimation top;
  late SpriteAnimation down;
  late SpriteAnimation left;
  late SpriteAnimation right;
  final double _animationSpeed = 0.15;

  DevanAnimation({
    required SpriteSheet spriteSheet
}) : super(){
    top =
        spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, to: 7);
    down =
        spriteSheet.createAnimation(row: 1, stepTime: _animationSpeed, to: 7);
    left =
        spriteSheet.createAnimation(row: 2, stepTime: _animationSpeed, to: 7);
    right =
        spriteSheet.createAnimation(row: 3, stepTime: _animationSpeed, to: 7);
     }
  }
