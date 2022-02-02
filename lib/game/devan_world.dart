import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/painting.dart';
import '../component/bullet.dart';
import '../component/command.dart';
import '../component/health.dart';
import '../component/world.dart';
import '../component/devan.dart';
import 'enemy_manager.dart';

class DevanWorld extends FlameGame with HasDraggables, HasCollidables, HasTappables{
  late final Devan _player;
  late  Health _health;
  late final JoystickComponent _joystick;
  late SpriteSheet _healthSpriteSheet;
  late TextComponent _expText;
  final World _world = World();
  late SpriteAnimationComponent animationComponent;

  final _commandList = List<Command>.empty(growable: true);
  final _addLaterCommandList = List<Command>.empty(growable: true);


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

    _healthSpriteSheet = SpriteSheet.fromColumnsAndRows(
        image: images.fromCache('heart.png'),
        columns: 3,
        rows: 1
    );

    _health =
    Health(sprite: _healthSpriteSheet.getSpriteById(0));

    final _regular = TextPaint(
      style: TextStyle(color: BasicPalette.white.color),
    );

    _expText = TextComponent(
      text: 'Exp: 0',
      textRenderer: _regular,
    )..positionType = PositionType.viewport;

    final speedWithMargin = HudMarginComponent(
      margin: const EdgeInsets.only(
        top: 25,
        left: 25,
      ),
    )..add(_expText);

    final healthWithMargin = HudMarginComponent(
      margin: const EdgeInsets.only(
        top: 45,
        left: 25,
      ),
    )..add(_health);

    add(speedWithMargin);
    add(healthWithMargin);
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

  @override
  void update(double dt){
    _commandList.forEach((command) {
      children.forEach((component) {
        command.run(component);
      });
    });
    _commandList.clear();
    _commandList.addAll(_addLaterCommandList);
    _addLaterCommandList.clear();


    super.update(dt);
    _expText.text = 'Exp: ${_player.exp}';
    _health.sprite = _healthSpriteSheet.getSpriteById(1);
  }

  void addCommand(Command command){
    _addLaterCommandList.add(command);
  }
}
