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
  late Timer _timer;
  Random random = Random();
  late Vector2 velocity;
  late void Function() _onDestroyed;

  Vector2 _charSize = Vector2(36, 34);

  Enemy({Vector2? position, required void Function() onDestroyed})
      : super(
      position: position,
      size: Vector2.all(16),
      priority: 1,
      anchor: Anchor.center,
      current: EnemyState.idle
  ){
    _timer = Timer(10, onTick: changeVelocity, repeat: true);
    velocity = Vector2((random.nextInt(2)).toDouble(), (random.nextInt(2)).toDouble());
    addHitbox(HitboxCircle());
    _onDestroyed = onDestroyed;
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
        current = EnemyState.hit;
        bounceOff();
    }
    if (other is Bullet){
        final command = Command<Devan>(action: (player){
          player.addToExp(1);
        });
        gameRef.addCommand(command);
        _onDestroyed();
        removeFromParent();
    }
  }

  @override
  void onCollisionEnd(Collidable other) {
    super.onCollisionEnd(other);
    _collisionActive = false;
  }

  void bounceOff() {
    velocity = -velocity;
    position.add(velocity * 10);
  }
  @override
  void update(double dt) {
    _timer.update(dt);
    move(dt);
    super.update(dt);
  }

  void changeVelocity(){
    double x = random.nextInt(3) - 1.0;
    double y = random.nextInt(3) - 1.0;
    var v = Vector2(x, y);
    if (!v.isZero()){
      velocity = v;
    }
  }

  void move(double dt){
    current = EnemyState.idle;
    position.add(velocity * 50 * dt);
    if (position.x < -10 || position.y < -10 || position.x > 2250 || position.y > 2250){
      removeFromParent();
      _onDestroyed();
    }
  }

  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  @override
  void onRemove() {
    super.onRemove();
    _timer.stop();
  }
}