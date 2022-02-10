import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:super_devan_world/component/bullet.dart';
import 'package:super_devan_world/component/devan.dart';
import 'package:super_devan_world/game/super_devan_world.dart';
import 'package:tiled/tiled.dart' show TiledObject;


enum BossState {
  left, right, up, down, upLeft,
  upRight, downLeft, downRight,
  idle, attackLeft, attackRight,
  hitLeft, hitRight,
  dead,
}

const int maxHealth = 100;


class Boss<T extends FlameGame> extends SpriteAnimationGroupComponent
    with HasGameRef<SuperDevanWorld>,  HasHitboxes, Collidable {
  bool _collisionActive = false;
  Vector2 _char_size = Vector2(78, 58);
  late Devan player;
  late Vector2 _lastValidPosition;
  int _health = maxHealth;
  Vector2 _velocity = Vector2(0, 0);
  late TiledComponent tiledMap;
  late TiledObject _bossBound;
  bool _isDead = false;
  final Vector2 initPosition = Vector2(336, 123);
  int get health => _health;

  Boss(
      this.player,
      this.tiledMap,
      )
      : super(
      position: Vector2(336, 123),
      size: Vector2(160, 120),
      priority: 1,
      anchor: Anchor.center,
      current: BossState.idle
  ){
    // debugMode = true;
    _lastValidPosition = position;
    addHitbox(HitboxCircle());
  }

  @mustCallSuper
  @override
  Future<void> onLoad() async {
    _bossBound =
    tiledMap.tileMap.getObjectGroupFromLayer('boss').objects[0];

    final left = await gameRef.loadSpriteAnimation(
      'boss/run-left.png',
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: _char_size,
        texturePosition: Vector2.all(0),
        stepTime: 0.15,
      ),
    );


    final right = await gameRef.loadSpriteAnimation(
      'boss/run-right.png',
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: _char_size,
        texturePosition: Vector2.all(0),
        stepTime: 0.15,
      ),
    );

    final up = await gameRef.loadSpriteAnimation(
      'boss/up.png',
      SpriteAnimationData.sequenced(
        amount: 3,
        textureSize: _char_size,
        texturePosition: Vector2(_char_size.x*2, 0),
        stepTime: 0.15,
      ),
    );

    final down = await gameRef.loadSpriteAnimation(
      'boss/down.png',
      SpriteAnimationData.sequenced(
        amount: 5,
        textureSize: _char_size,
        texturePosition: Vector2(_char_size.x*3, 0),
        stepTime: 0.15,
      ),
    );

    final idle = await gameRef.loadSpriteAnimation(
      'boss/idle.png',
      SpriteAnimationData.sequenced(
        amount: 11,
        textureSize: _char_size,
        texturePosition: Vector2.all(0),
        stepTime: 0.15,
      ),
    );

    final attackLeft = await gameRef.loadSpriteAnimation(
      'boss/attack-left.png',
      SpriteAnimationData.sequenced(
        amount: 3,
        textureSize: _char_size,
        texturePosition: Vector2.all(0),
        stepTime: 0.15,
      ),
    );

    final attackRight = await gameRef.loadSpriteAnimation(
      'boss/attack-right.png',
      SpriteAnimationData.sequenced(
        amount: 3,
        textureSize: _char_size,
        texturePosition: Vector2.all(0),
        stepTime: 0.15,
      ),
    );

    final hitLeft = await gameRef.loadSpriteAnimation(
      'boss/hit-right.png',
      SpriteAnimationData.sequenced(
        amount: 2,
        textureSize: _char_size,
        texturePosition: Vector2.all(0),
        stepTime: 0.15,
      ),
    );

    final hitRight = await gameRef.loadSpriteAnimation(
      'boss/hit-right.png',
      SpriteAnimationData.sequenced(
        amount: 2,
        textureSize: _char_size,
        texturePosition: Vector2.all(0),
        stepTime: 0.15,
      ),
    );



    final dead = await gameRef.loadSpriteAnimation(
      'boss/dead-left.png',
      SpriteAnimationData.sequenced(
        amount: 1,
        textureSize: _char_size,
        texturePosition: Vector2.all(0),
        stepTime: 0.15,
        loop: false,
      ),
    );

    animations = {
      BossState.left: left,
      BossState.right: right,
      BossState.up: up,
      BossState.down: down,
      BossState.idle : idle,
      BossState.attackLeft: attackLeft,
      BossState.attackRight: attackRight,
      BossState.hitLeft: hitLeft,
      BossState.hitRight: hitRight,
      BossState.dead: dead
    };
    current = BossState.idle;
    super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);
    if (_isDead || player.health <= 0){
      return;
    }
    if (other is Devan && other.health > 0){
      _velocity = Vector2.all(0);
      _collisionActive = true;
      if(other.position.x < position.x){
        current = BossState.attackLeft;
      } else{
        current = BossState.attackRight;
      }
    }
  }

  @override
  void onCollisionEnd(Collidable other) {
    super.onCollisionEnd(other);
    if (_isDead){
      return;
    } else{
      if (other is Devan){
        _collisionActive = false;
        current = BossState.idle;
      }
    }
  }

  void bounceOff() {
    position = _lastValidPosition;
    _lastValidPosition = Vector2(position.x, position.y);
    _velocity = -_velocity;
  }
  @override
  void update(double dt) {
    super.update(dt);
    if (_isDead){
      return;
    }
    if (player.health <= 0){
      current = BossState.idle;
      return;
    }
    movePlayer(dt);
    super.update(dt);
  }

  void movePlayer(double dt){
    if (!_collisionActive){
      getVelocity();
      position.add(_velocity/2 * 150 * dt);
      _lastValidPosition = position;
    }
  }

  @override
  void render(Canvas canvas) {
    // Draws a rectangular health bar at top right corner.
    canvas.drawRRect(
      RRect.fromLTRBR(-1, -1, maxHealth.toDouble()+1, 21, const Radius.circular(5)),
      Paint()..color = Colors.black,
    );
    canvas.drawRRect(
      RRect.fromLTRBR(0, 0, _health.toDouble(), 20, const Radius.circular(5)),
      Paint()..color = Colors.red,
    );
    super.render(canvas);
  }

  void getVelocity(){
    if (player.position.x > _bossBound.x &&
        player.position.x < _bossBound.x+_bossBound.width &&
        player.position.y < _bossBound.y+_bossBound.height &&
        position.x > _bossBound.x &&
        position.x < _bossBound.x+_bossBound.width - _char_size.x &&
        position.y < _bossBound.y+_bossBound.height - _char_size.y

    ){
      if(FlameAudio.bgm.isPlaying){
        FlameAudio.bgm.pause();
      }
      _velocity = (player.position - position).normalized();
      if(_velocity.x < -0.3){
        current = BossState.left;
      } else if(_velocity.x > 0.3){
        current = BossState.right;
      } else if(_velocity.y < -0.3){
        current = BossState.up;
      } else{
        current = BossState.down;
      }
    } else {
      current = BossState.idle;
      _health = maxHealth;
      _velocity = Vector2(0, 0);
      if(!FlameAudio.bgm.isPlaying){
        FlameAudio.bgm.resume();
      }
    }
  }

  void reset() {
    _health = maxHealth;
    _isDead = false;
    position = initPosition;
    _lastValidPosition = Vector2(1500, 1500);
    _collisionActive = false;
  }
}