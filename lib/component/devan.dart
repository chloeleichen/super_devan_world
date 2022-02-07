import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:super_devan_world/component/boss.dart';
import 'package:super_devan_world/component/flying_creature.dart';
import 'package:super_devan_world/component/mushroom.dart';
import 'package:super_devan_world/component/reward.dart';
import 'package:super_devan_world/component/world_collidable.dart';
import 'package:super_devan_world/game/audio_player.dart';
import 'package:super_devan_world/helper/creature_type.dart';
import 'package:super_devan_world/helper/direction.dart';
import 'package:super_devan_world/helper/mushroom_type.dart';
import 'package:flutter/services.dart';
import 'package:throttling/throttling.dart';

import 'castle_collidable.dart';
const int leftIndex = 1;
const int rightIndex = 3;
const int upIndex = 2;
const int downIndex = 0;
const double initX = 2127.4;
const double initY = 73.83;
const int maxHealth = 8;



class Devan<T extends FlameGame> extends SpriteAnimationComponent
    with HasGameRef<T>,  HasHitboxes, Collidable {
  final JoystickComponent joystick;
  final AudioPlayer audioPlayer;
  final _deb = Debouncing(duration: const Duration(milliseconds: 500));
  final _thr = Throttling(duration: const Duration(seconds: 1));
  final _thrFast = Throttling(duration: const Duration(milliseconds: 500));
  bool _collisionActive = false;
  final double _charWidth = 29;
  final double _charHeight = 32.0;
  late final SpriteAnimation _runDownAnimation;
  late final SpriteAnimation _runLeftAnimation;
  late final SpriteAnimation _runUpAnimation;
  late final SpriteAnimation _runRightAnimation;

  late final SpriteAnimation _idleDownAnimation;
  late final SpriteAnimation _idleLeftAnimation;
  late final SpriteAnimation _idleUpAnimation;
  late final SpriteAnimation _idleRightAnimation;
  late final SpriteAnimation _deadAnimation;
  final double _animationSpeed = 0.15;

  late Vector2 _lastValidPosition;
  Direction _direction = Direction.down;
  int _health = maxHealth;
  int _exp = 0;

  int get exp => _exp;
  int get health => _health;
  Direction get direction => _direction;

  Devan(this.joystick, this.audioPlayer)
      : super(
    position: Vector2(initX, initY),
    size: Vector2(43.5, 48),
    anchor: Anchor.center,
  ){
    // debugMode = true;
    _lastValidPosition = position;
    addHitbox(HitboxCircle());
  }

  @mustCallSuper
  @override
  Future<void> onLoad() async {
    _loadAnimation();
    animation = _idleDownAnimation;
    super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);
      if (other is CastleColliable){
        return;
      }
      if(!_collisionActive && (other is WorldCollidable || other is ScreenCollidable)){
        _collisionActive = true;
        bounceOff();
      }
      if (other is FlyingCreature){
        _thr.throttle(()=>HapticFeedback.vibrate());
        bounceOff();
        if(other.type == CreatureType.skull ){
          _deb.debounce(hurt);
        }
      }
      if(other is Reward && other.isActive){
        if(health < maxHealth){
          _thr.throttle(()=>audioPlayer.playEatSound());
          heal();
        }
      }
      if(other is Boss){
        if(health >0){
          _thr.throttle(()=>audioPlayer.playSwordSound());
          _thrFast.throttle(hurt);
        }
      }

      if(other is Mushroom && other.isActive){
        _thr.throttle(()=>audioPlayer.playEatSound());
        if (other.type == MushroomType.bad){
          _deb.debounce(hurt);
        } else if(other.type == MushroomType.good){
          heal();
        } else{
          _deb.debounce(mushroomEffect);
        }
      }
  }

  void mushroomEffect(){
    gameRef.camera.shake(duration: 1, intensity: 3);
    add(
      ColorEffect(
        Colors.purple,
        const Offset(
          0.0,
          0.8,
        ), // Means, applies from 0% to 80% of the color
        EffectController(
          duration: 1.5,
          reverseDuration: 0.5,
          infinite: false,
        ),
      ),
    );
  }

  void hurt(){
    if (_health > 0){
      add(
        ColorEffect(
          Colors.red,
          const Offset(
            0.0,
            0.9,
          ), // Means, applies from 0% to 80% of the color
          EffectController(
            duration: 0.5,
            reverseDuration: 0.5,
            infinite: false,
          ),
        ),
      );
      _health -=1;
    }
  }

  void heal(){
    if(_health < maxHealth){
      _health +=1;
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
    super.update(dt);
    if(_health <=0){
      animation = _deadAnimation;
      angle = -1.4;
      return;
    }
    movePlayer(dt);
  }

  void idlePlayer(){
    switch(_direction){
      case (Direction.down):
        animation = _idleDownAnimation;
        break;
      case (Direction.up):
        animation = _idleUpAnimation;
        break;
      case (Direction.left):
        animation = _idleLeftAnimation;
        break;
      case (Direction.right):
        animation = _idleRightAnimation;
        break;
      }
  }

  void movePlayer(double dt){
    if(_collisionActive){
      return;
    }
    if(!_collisionActive){
      _lastValidPosition = Vector2(position.x, position.y);
    }
    Vector2 velocity = Vector2(0, 0);
    switch(joystick.direction){
      case JoystickDirection.idle:
        idlePlayer();
        velocity = Vector2(0, 0);
        break;
      case JoystickDirection.down:
        _direction =  Direction.down;
        animation = _runDownAnimation;
        velocity = Vector2(0, 1);
        break;
      case JoystickDirection.up:
        _direction =  Direction.up;
        animation = _runUpAnimation;
        velocity = Vector2(0, -1);
        break;
      case JoystickDirection.left:
        _direction =  Direction.left;
        animation = _runLeftAnimation;
        velocity = Vector2(-1, 0);
        break;
      case JoystickDirection.right:
        _direction =  Direction.right;
        animation = _runRightAnimation;
        velocity = Vector2(1, 0);
        break;
      case JoystickDirection.upLeft:
        _direction =  Direction.left;
        animation = _runLeftAnimation;
        velocity = Vector2(-1, -1);
        break;
      case JoystickDirection.upRight:
        _direction =  Direction.right;
        animation = _runRightAnimation;
        velocity = Vector2(1, -1);
        break;
      case JoystickDirection.downRight:
        _direction =  Direction.right;
        animation = _runRightAnimation;
        velocity = Vector2(1, 1);
        break;
      case JoystickDirection.downLeft:
        _direction =  Direction.left;
        animation = _runLeftAnimation;
        velocity = Vector2(-1, 1);
        break;

    }
    position.add(velocity/2 * 250 * dt);
  }

  void addToExp(int points){
    _exp += points;
  }

  void reset() {
    _exp = 0;
    angle = 0;
    _health = maxHealth;
    position = Vector2(initX, initY);
    _lastValidPosition = Vector2(initX, initX);
    _collisionActive = false;
  }

  void _loadAnimation(){
    final spriteSheet = SpriteSheet(
      image: gameRef.images.fromCache('player_spritesheet.png'),
      srcSize: Vector2(_charWidth, _charHeight),
    );

    _runDownAnimation =
        spriteSheet.createAnimation(row: downIndex, stepTime: _animationSpeed, to: 4);
    _runLeftAnimation =
        spriteSheet.createAnimation(row: leftIndex, stepTime: _animationSpeed, to: 4);
    _runUpAnimation =
        spriteSheet.createAnimation(row: upIndex, stepTime: _animationSpeed, to: 4);

    _runRightAnimation =
        spriteSheet.createAnimation(row: rightIndex, stepTime: _animationSpeed, to: 4);

    _idleDownAnimation =
        spriteSheet.createAnimation(row: downIndex, stepTime: _animationSpeed, to: 1);
    _idleUpAnimation =
        spriteSheet.createAnimation(row: upIndex, stepTime: _animationSpeed, to: 1);
    _idleLeftAnimation =
        spriteSheet.createAnimation(row: leftIndex, stepTime: _animationSpeed, to: 1);
    _idleRightAnimation =
        spriteSheet.createAnimation(row: rightIndex, stepTime: _animationSpeed, to: 1);
    _deadAnimation =
        spriteSheet.createAnimation(row: rightIndex, stepTime: _animationSpeed, to: 1);
  }
}