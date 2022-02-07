import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:super_devan_world/component/boss.dart';
import 'package:super_devan_world/component/castle_collidable.dart';
import 'package:super_devan_world/component/flying_creature.dart';
import 'package:super_devan_world/game/super_devan_world.dart';
import 'package:super_devan_world/helper/creature_type.dart';
import 'package:super_devan_world/helper/direction.dart';

import 'command.dart';
import 'devan.dart';

class Bullet extends SpriteComponent with HasHitboxes, Collidable, HasGameRef<SuperDevanWorld>{
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
    if(other is ScreenCollidable|| other is CastleColliable){
      removeFromParent();
    } else if(other is FlyingCreature){
      int point = other.type == CreatureType.skull? 1 : -1;
      final command = Command<Devan>(action: (player){
        player.addToExp(point);
      });
      gameRef.addCommand(command);
    } else if(other is Boss){
      final command = Command<Devan>(action: (player){
        player.addToExp(2);
      });
      gameRef.addCommand(command);
    }
  }

  @override
  void onCollisionEnd(Collidable other){
    if(other is Boss || other is FlyingCreature){
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