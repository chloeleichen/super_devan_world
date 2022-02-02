
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:super_devan_world/game/devan_world.dart';

class Health extends SpriteComponent
    with Tappable, HasGameRef {
  double value = 1.0;

  Health({
    required Sprite sprite,
  }) : super(size: Vector2(23, 23), sprite: sprite);

  void update(double delta) {
    super.update(delta);
    // TODO: apply clipping
  }
}