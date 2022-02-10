import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_devan_world/component/boss.dart';
import 'package:super_devan_world/component/flying_creature.dart';
import 'package:super_devan_world/component/mushroom.dart';
import 'package:super_devan_world/component/reward.dart';
import 'package:super_devan_world/component/roadsign.dart';
import 'package:super_devan_world/component/shop.dart';
import 'package:super_devan_world/component/tomb_stone.dart';
import 'package:super_devan_world/component/world_collidable.dart';
import 'package:super_devan_world/game/audio_player.dart';
import 'package:super_devan_world/helper/creature_type.dart';
import 'package:super_devan_world/helper/devan_movement.dart';
import 'package:super_devan_world/helper/direction.dart';
import 'package:super_devan_world/helper/mushroom_type.dart';
import 'package:throttling/throttling.dart';

import '../controller/devan_animation_controller.dart';
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
  late DevanActionController _devanActionController;
  final _deb = Debouncing(duration: const Duration(milliseconds: 500));
  final _thr = Throttling(duration: const Duration(seconds: 1));
  final _thrFast = Throttling(duration: const Duration(milliseconds: 500));
  late final Timer _actionTimer = Timer(0.6, onTick: _resetMovement, repeat: true);

  bool _collisionActive = false;
  final double _runningThreshold = 0.7;
  late Vector2 _lastValidPosition;
  Direction _direction = Direction.down;
  int _health = maxHealth;
  int _exp = 0;
  late DevanMovement _movement;

  int get exp => _exp;
  int get health => _health;
  Direction get direction => _direction;

  Devan(this.joystick, this.audioPlayer)
      : super(
    position: Vector2(initX, initY),
    size: Vector2(100, 100),
    anchor: Anchor.center,
  ){
    debugMode = true;
    _lastValidPosition = position;
    addHitbox(HitboxCircle(normalizedRadius: 0.5));
  }

  @mustCallSuper
  @override
  Future<void> onLoad() async {
    _devanActionController = DevanActionController();
    add(_devanActionController);
    _movement = DevanMovement.idle;
    animation = _devanActionController.animations[_movement]?.direction[Direction.up];
    super.onLoad();
  }

  @override
  onCollision(Set<Vector2> intersectionPoints, Collidable other)  {
    super.onCollision(intersectionPoints, other);
    if (_health <=0){
      return;
    }
      if (other is CastleColliable){
        return;
      }

      if(other is WorldCollidable ||
        other is ScreenCollidable ||
        other is TombStone||
        other is Shop ||
        other is RoadSign){
        // _movement = DevanMovement.jump;
        _collisionActive = true;
        bounceOff();
      }
      if (other is FlyingCreature){
        _movement = DevanMovement.attackSword;
        _thr.throttle(()=>HapticFeedback.vibrate());
        bounceOff();
        if(other.type == CreatureType.skull ){
          _deb.debounce(hurt);
        }
      }
      if(other is Boss){
        _movement = DevanMovement.attackSword;
          _thr.throttle(()=>audioPlayer.playSwordSound());
          _thrFast.throttle(hurt);
      }

      if(other is Mushroom && !other.size.isZero()){
        _actionTimer.stop();
        _movement = DevanMovement.take;
        _actionTimer.start();
        other.getEaten();
        if (other.type == MushroomType.bad){
          _deb.debounce(hurt);
        } else if(other.type == MushroomType.good){
          heal();
        } else{
          _deb.debounce(mushroomEffect);
        }
      }
    animation = _devanActionController.animations[DevanMovement.take]?.direction[_direction];
  }

  @override
  void onCollisionEnd(Collidable other) {
    super.onCollisionEnd(other);
    _collisionActive = false;
    if(other is Mushroom && other.size.isZero()){
      other.reactivate();
      audioPlayer.playEatSound();
    }
  }

  void _resetMovement(){
    _movement = DevanMovement.idle;
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
          startDelay: 1,
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



  void bounceOff() {
    position = _lastValidPosition;
    _lastValidPosition = Vector2(position.x, position.y);
  }
  @override
  void update(double dt) {
    super.update(dt);
    _actionTimer.update(dt);
    if(_collisionActive || _health <= 0){
      return;
    }
    if(joystick.direction != JoystickDirection.idle){
      movePlayer(dt);
    } else{
      if (_movement == DevanMovement.walk || _movement == DevanMovement.run ){
        _movement = DevanMovement.idle;
      }
    }
    animation = _devanActionController.animations[_movement]?.direction[_direction];
  }

  void movePlayer(double dt){
    _lastValidPosition = Vector2(position.x, position.y);
      Vector2 velocity = Vector2(0, 0);
      double speed = joystick.relativeDelta.length;
      if(_movement == DevanMovement.idle){
        _movement = speed >= _runningThreshold ? DevanMovement.run : DevanMovement.walk;
      }
      switch(joystick.direction){
        case JoystickDirection.down:
          _direction =  Direction.down;
          velocity = Vector2(0, speed);
          break;
        case JoystickDirection.up:
          _direction =  Direction.up;
          velocity = Vector2(0, -speed);
          break;
        case JoystickDirection.left:
          _direction =  Direction.left;
          velocity = Vector2(-speed, 0);
          break;
        case JoystickDirection.right:
          _direction =  Direction.right;
          velocity = Vector2(speed, 0);
          break;
        case JoystickDirection.upLeft:
          _direction =  Direction.left;
          velocity = Vector2(-speed, -speed);
          break;
        case JoystickDirection.upRight:
          _direction =  Direction.right;
          velocity = Vector2(speed, -speed);
          break;
        case JoystickDirection.downRight:
          _direction =  Direction.right;
          velocity = Vector2(speed, speed);
          break;
        case JoystickDirection.downLeft:
          _direction =  Direction.left;
          velocity = Vector2(-speed, speed);
          break;
      }
      position.add(velocity * 150 * dt);
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
}