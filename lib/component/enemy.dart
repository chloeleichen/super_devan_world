import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:super_devan_world/component/bullet.dart';
import 'package:super_devan_world/component/command.dart';
import 'package:super_devan_world/component/devan.dart';
import 'package:super_devan_world/game/devan_world.dart';

enum EnemyState {
  hit, idle
}

class Enemy<T extends FlameGame> extends SpriteAnimationGroupComponent
    with HasGameRef<DevanWorld>,  HasHitboxes, Collidable {
  bool _collisionActive = false;
  Random random = Random();

  Vector2 _lastValidPosition = Vector2(0, 0);
  Vector2 _charSize = Vector2(36, 34);

  Enemy({Vector2? position})
      : super(
      position: position,
      size: Vector2.all(16),
      priority: 1,
      anchor: Anchor.center,
      current: EnemyState.idle
  ){
    debugMode = true;
    addHitbox(HitboxCircle());
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
      EnemyState.idle : idle,
    };
    super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints,other);
    if (other is Devan){
      if(!_collisionActive){
        _collisionActive = true;
        current = EnemyState.hit;
        bounceOff();
      }
    }
    if (other is ScreenCollidable || other is Bullet){
      if (other is Bullet){
        final command = Command<Devan>(action: (player){
          player.addToExp(1);
        });
        gameRef.addCommand(command);
      }
      removeFromParent();
    }
  }

  @override
  void onCollisionEnd(Collidable other) {
    super.onCollisionEnd(other);
    _collisionActive = false;
  }

  void bounceOff() {
    position = _lastValidPosition;
    _lastValidPosition = Vector2(position.x, position.y);
  }
  @override
  void update(double dt) {
    move(dt);
    super.update(dt);
  }

  void move(double dt){
    if(_collisionActive){
      return;
    }
    if(!_collisionActive){
      _lastValidPosition = Vector2(position.x, position.y);
    }
    angle = pi * random.nextDouble();
    current = EnemyState.idle;
    double x = random.nextBool() ? 1 : -1;
    double y = random.nextBool() ? 1: -1;
    Vector2 velocity = Vector2(x, y);
    position.add(velocity/2 * 100 * dt);
  }
}