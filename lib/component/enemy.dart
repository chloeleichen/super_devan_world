import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:super_devan_world/component/Creature.dart';
import 'package:super_devan_world/component/bullet.dart';
import 'package:super_devan_world/component/command.dart';
import 'package:super_devan_world/component/devan.dart';
import 'package:super_devan_world/helper/creature_type.dart';

enum EnemyState {
  hit, idle
}

class Enemy<T extends FlameGame> extends Creature {
  late void Function() _onDestroyed;
  late CreatureType _type;
  late SpriteAnimation _idle;
  late SpriteAnimation _hit;
  CreatureType get type => _type;

  Enemy({
  Vector2? position,
  required void Function() onDestroyed,
  required SpriteAnimation idle,
  required SpriteAnimation hit,
    required CreatureType type,
  })
      : super(
      onDestroyed: onDestroyed,
  ){
    _onDestroyed =  onDestroyed;
    position = position;
    size = Vector2(16, 16);
    _type = type;
    _idle = idle;
    _hit = hit;
    animations = {
      EnemyState.hit: _hit,
      EnemyState.idle: _idle,
    };
  }

  @mustCallSuper
  @override
  Future<void> onLoad() async {
    current = EnemyState.idle;
    super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints,other);
    int point = _type == CreatureType.monster? 1 : -1;
    if (other is Devan){
        current = EnemyState.hit;
    }
    if (other is Bullet){
        current = EnemyState.hit;
        final command = Command<Devan>(action: (player){
          player.addToExp(point);
        });
        gameRef.addCommand(command);
        _onDestroyed();
        removeFromParent();
    }
  }
  @override
  void onCollisionEnd(Collidable other){
    super.onCollisionEnd(other);
    current = EnemyState.idle;
  }
}