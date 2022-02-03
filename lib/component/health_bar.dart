import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:super_devan_world/component/devan.dart';

class HealthBar extends HudMarginComponent {
  late final  SpriteComponent _health;
  late final  SpriteSheet _healthSpriteSheet;
  late final Devan player;

  HealthBar(this.player): super(
    margin: const EdgeInsets.only(
      top: 50,
      left: 17,
    ),
  );
  @override
  Future<void> onLoad() async {
    super.onLoad();
    _healthSpriteSheet = SpriteSheet.fromColumnsAndRows(
        image: gameRef.images.fromCache('heart.png'),
        columns: 5,
        rows: 1
    );
    _health = SpriteComponent(
        sprite: _healthSpriteSheet.getSpriteById(0),
        size: Vector2.all(16)
    );
    add(_health);
  }

  @override
  void update(double dt){
    super.update(dt);
    final int spriteId = 4 - player.health~/2;
    _health.sprite = _healthSpriteSheet.getSpriteById(spriteId);
  }
}