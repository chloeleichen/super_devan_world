import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:super_devan_world/component/Creature.dart';
import 'package:super_devan_world/component/bullet.dart';
import 'package:super_devan_world/component/castle_collidable.dart';
import 'package:super_devan_world/component/devan.dart';
import 'package:super_devan_world/helper/creature_type.dart';

enum FlyingCreatureState {
  hit, idle
}

class FlyingCreature<T extends FlameGame> extends Creature {
  late void Function() _onDestroyed;
  late CreatureType _type;
  late SpriteAnimation _idle;
  late SpriteAnimation _hit;
  CreatureType get type => _type;

  FlyingCreature({
    required Vector2 position,
    required double speed,
    required bool isFixAngle,
    required void Function() onDestroyed,
    required SpriteAnimation idle,
    required SpriteAnimation hit,
    required CreatureType type,
  })
      : super(
      speed: speed,
      onDestroyed: onDestroyed,
      isFixAngle: isFixAngle,
      position: position,
  ){
    _onDestroyed =  onDestroyed;
    size = (type == CreatureType.bee) ? Vector2.all(16) : Vector2.all(32);
    _type = type;
    _idle = idle;
    _hit = hit;
    animations = {
      FlyingCreatureState.hit: _hit,
      FlyingCreatureState.idle: _idle,
    };
  }

  @mustCallSuper
  @override
  Future<void> onLoad() async {
    super.onLoad();
    current = FlyingCreatureState.idle;
  }

  @override
  void update(double dt){
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints,other);
    if (other is CastleColliable){
      removeFromParent();
      return;
    }
    if (other is Devan){
        bounceOff();
        current = FlyingCreatureState.hit;
    }
    if (other is Bullet){
        current = FlyingCreatureState.hit;
        _onDestroyed();
        removeFromParent();
    }
  }
  @override
  void onCollisionEnd(Collidable other){
    super.onCollisionEnd(other);
    current = FlyingCreatureState.idle;
  }
}