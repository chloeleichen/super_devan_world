import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:super_devan_world/component/Creature.dart';
import 'package:super_devan_world/component/bullet.dart';
import 'package:super_devan_world/component/command.dart';
import 'package:super_devan_world/component/devan.dart';

enum EnemyState {
  hit, idle
}

class Enemy<T extends FlameGame> extends Creature {
  late void Function() _onDestroyed;
  late SpriteAnimation _idle;
  late SpriteAnimation _hit;

  Enemy({
  Vector2? position,
  required void Function() onDestroyed,
  required SpriteAnimation idle,
  required SpriteAnimation hit
  })
      : super(
      onDestroyed: onDestroyed,
  ){
    _onDestroyed =  onDestroyed;
    position = position;
    size = Vector2(16, 16);
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
    if (other is Devan){
        current = EnemyState.hit;
    }
    if (other is Bullet){
        current = EnemyState.hit;
        final command = Command<Devan>(action: (player){
          player.addToExp(1);
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