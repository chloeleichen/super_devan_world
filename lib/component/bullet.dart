import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:super_devan_world/component/enemy.dart';
import 'package:super_devan_world/component/world_collidable.dart';
import 'package:super_devan_world/helper/direction.dart';

import 'devan.dart';

class Bullet extends SpriteComponent with HasHitboxes, Collidable{
  final double _speed = 450;
  Vector2 _direction = Vector2(0, 1);

  Bullet({
    Sprite? sprite,
    Vector2? position,
    Vector2? size,
    required Vector2 direction,
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
    if(_direction.isZero()){
      _direction = Vector2(0, 1);
    }
    position.add(_direction*_speed * dt);
    super.update(dt);
  }
}