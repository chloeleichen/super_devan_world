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
  bool get isActive => _isActive;

  Reward({
    required Sprite sprite,
    required Vector2 size,
    Vector2? position,
  }) : super( position: position, sprite:sprite) {
    collidableType = CollidableType.passive;
    //debugMode = true;
    _size = size;
    _timer = Timer(100, onTick: _toggleState, repeat: true);
    if (!_isActive){
      size = Vector2.all(0);
    }
    addHitbox(HitboxCircle(normalizedRadius: 1.3));
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

  void getEaten() {
    if(!size.isZero()){
      add(SizeEffect.to(
        Vector2.all(0),
        EffectController(duration: 0.15, curve: Curves.bounceInOut),
      ));
    }
  }

  void reactivate() {
    if(size == Vector2.zero()){
      add(SizeEffect.to(
          _size,
          DelayedEffectController(
              EffectController(duration: 0.5, curve: Curves.bounceOut),
              delay: (10 + random.nextInt(100)).toDouble())
      ));
    }
  }
}