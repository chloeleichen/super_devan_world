
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:super_devan_world/game/super_devan_world.dart';

class Health extends SpriteComponent
    with Tappable, HasGameRef {
  Health({
    required Sprite sprite,
  }) : super(size: Vector2(16, 16), sprite: sprite);

  void update(double delta) {
    super.update(delta);
    // TODO: apply clipping
  }
}