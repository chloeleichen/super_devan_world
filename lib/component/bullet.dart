import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:super_devan_world/component/enemy.dart';
import 'package:super_devan_world/helper/direction.dart';

class Bullet extends SpriteComponent with HasHitboxes, Collidable{
  final double _speed = 450;
  late Direction _direction;

  Bullet({
    Sprite? sprite,
    Vector2? position,
    Vector2? size,
    required Direction direction,
}) : super(sprite: sprite, position: position, size: size){
    _direction = direction;
    position = position;
  }

  @override
  void onMount() {
    super.onMount();
    addHitbox(HitboxCircle(size: Vector2.all(10)));
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);
    if(other is ScreenCollidable || other is Enemy){
      removeFromParent();
    }
  }

  @override
  void update(double dt) {
    var velocity = Vector2(1, 1);
    switch (_direction){
      case (Direction.up):
        velocity = Vector2(0, -1);
        break;
      case (Direction.down):
        velocity = Vector2(0, 1);
        break;
      case (Direction.left):
        velocity = Vector2(-1, 0);
        break;
      case (Direction.right):
        velocity = Vector2(1, 0);
        break;
    }
    position.add(velocity*_speed * dt);
    super.update(dt);
  }
}