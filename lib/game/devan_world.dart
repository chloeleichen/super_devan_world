import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/painting.dart';
import 'package:super_devan_world/component/bullet.dart';
import '../component/world.dart';
import '../component/devan.dart';
import 'enemy_manager.dart';

class DevanWorld extends FlameGame with HasDraggables, HasCollidables, HasTappables{
  late final Devan _player;
  late final JoystickComponent _joystick;
  final World _world = World();
  late SpriteAnimationComponent animationComponent;

  @override
  Future<void> onLoad() async {
    await images.loadAll(['heart.png', 'bee/idle.png', 'bee/hit.png', 'bullet.png']);
    await add(_world);
    add(ScreenCollidable());

    final knobPaint = BasicPalette.white.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.white.withAlpha(100).paint();

    _joystick = JoystickComponent(
      knob: CircleComponent(radius: 20, paint: knobPaint),
      background: CircleComponent(radius: 50, paint: backgroundPaint),
      margin: const EdgeInsets.only(right: 10, bottom: 10),
    );
    _player = Devan(_joystick);
    camera.followComponent(_player, worldBounds:
    Rect.fromLTRB(0, 0, _world.size.x, _world.size.y));

    add(_player);
    add(_joystick);

    EnemyManager enemyManager = EnemyManager();
    add(enemyManager);
  }

  bool isTappingOnJoystick(Vector2 position){
    if (position.x > size.x - 110 && position.y > size.y - 110){
      return true;
    }
    return false;
  }

  @override
  void onTapDown(int pointerId, TapDownInfo info){
    super.onTapDown(pointerId, info);
    if (isTappingOnJoystick(info.eventPosition.global)){
      return;
    }
    Bullet bullet = Bullet(
        direction: _joystick.relativeDelta,
        position: _player.position,
        sprite: Sprite(images.fromCache('bullet.png'))
    );
    bullet.anchor = Anchor.center;
    add(bullet);
  }
}
