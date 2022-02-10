import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:super_devan_world/component/Creature.dart';
import 'package:super_devan_world/component/bullet.dart';
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
  void onCollisionEnd(Collidable other){
    super.onCollisionEnd(other);
    current = FlyingCreatureState.idle;
  }

  void onHit(){
    current = FlyingCreatureState.hit;
  }
}