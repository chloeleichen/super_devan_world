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
  final Vector2 _charSize = Vector2(36, 34);
  Enemy({Vector2? position, required void Function() onDestroyed})
      : super(
      onDestroyed: onDestroyed,
  ){
    _onDestroyed =  onDestroyed;
    position = position;
    size = Vector2(16, 16);
  }

  @mustCallSuper
  @override
  Future<void> onLoad() async {
    final idle = await gameRef.loadSpriteAnimation(
      'bee/idle.png',
      SpriteAnimationData.sequenced(
        amount: 6,
        textureSize: _charSize,
        stepTime: 0.15,
      ),
    );

    final hit = await gameRef.loadSpriteAnimation(
      'bee/hit.png',
      SpriteAnimationData.sequenced(
        amount: 6,
        textureSize: _charSize,
        stepTime: 0.15,
      ),
    );
    animations = {
      EnemyState.hit: hit,
      EnemyState.idle: idle,
    };
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
}