import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/painting.dart';
import '../component/world.dart';
import '../component/devan.dart';

class DevanWorld extends FlameGame with HasDraggables, HasCollidables{
  late final Devan _player;
  late final JoystickComponent _joystick;
  final World _world = World();
  late SpriteAnimationComponent animationComponent;

  @override
  Future<void> onLoad() async {
    await images.loadAll(['heart.png']);
    await add(_world);

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
  }
}
