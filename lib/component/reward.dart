import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/animation.dart';
import 'package:super_devan_world/component/devan.dart';


class Reward extends SpriteComponent with HasHitboxes, Collidable{
  Random random = Random();
  late Vector2 _size;
  late bool _isActive = random.nextBool();
  late Timer _timer;

  Reward({
    required Sprite sprite,
    required Vector2 size,
    Vector2? position,
  }) : super( position: position, sprite:sprite) {
    collidableType = CollidableType.passive;
    // debugMode = true;
    _size = size;
    _timer = Timer(100, onTick: _toggleState, repeat: true);
    if (!_isActive){
      size = Vector2.all(0);
    }
    addHitbox(HitboxCircle());
  }

  void _toggleState(){
     if(!_isActive){
       _isActive = true;
       add(SizeEffect.to(
           _size, EffectController(duration: 0.5, curve: Curves.bounceOut)
       ));
     }
  }

  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  @override
  void onRemove(){
    super.onRemove();
    _timer.stop();
  }

  @override
  void update(double dt){
    super.update(dt);
    _timer.update(dt);
  }

  void reset() {
    _timer.stop();
    _timer.start();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);
    if(other is Devan && _isActive){
        add(SizeEffect.to(
          Vector2.all(0),
          EffectController(duration: 0.1, curve: Curves.bounceInOut),
        ));
        _isActive = false;
    }
  }

  @override
  void onCollisionEnd(other){
    super.onCollisionEnd(other);
    if(other is Devan && !_isActive){
      _isActive = true;
      add(SizeEffect.to(
        _size,
        DelayedEffectController(
            EffectController(duration: 0.5, curve: Curves.bounceOut),
            delay: (10 + random.nextInt(100)).toDouble())
      ));
    }
  }
}