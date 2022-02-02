import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/painting.dart';
import 'package:super_devan_world/component/enemy.dart';
import 'package:super_devan_world/game/audio_player.dart';
import 'package:super_devan_world/overlays/game_over_menu.dart';
import '../component/bullet.dart';
import '../component/command.dart';
import '../component/health.dart';
import '../component/world.dart';
import '../component/devan.dart';
import 'enemy_manager.dart';

class DevanWorld extends FlameGame with HasDraggables, HasCollidables, HasTappables{
  late final Devan _player;
  late final EnemyManager _enemyManager;
  late  final Health _health;
  late final JoystickComponent _joystick;
  late SpriteSheet _healthSpriteSheet;
  late TextComponent _expText;
  final World _world = World();
  late SpriteAnimationComponent animationComponent;
  late AudioPlayer _audioPlayer;

  final _commandList = List<Command>.empty(growable: true);
  final _addLaterCommandList = List<Command>.empty(growable: true);


  @override
  Future<void> onLoad() async {
    await images.loadAll(['heart.png', 'bee/idle.png', 'bee/hit.png', 'bullet.png']);
    await add(_world);
    _audioPlayer = AudioPlayer();
    add(_audioPlayer);
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

    _enemyManager = EnemyManager();
    add(_enemyManager);

    _healthSpriteSheet = SpriteSheet.fromColumnsAndRows(
        image: images.fromCache('heart.png'),
        columns: 5,
        rows: 1
    );

    _health =
    Health(sprite: _healthSpriteSheet.getSpriteById(0));

    final _regular = TextPaint(
      style: TextStyle(
          color: Colors.white,
          fontFamily: 'rowdies',
          shadows: [
            Shadow(
              blurRadius: 10.0,
              color: Colors.black,
              offset: Offset(0, 0)
            )
          ]
      ),
    );

    _expText = TextComponent(
      text: '0',
      textRenderer: _regular,
    )..positionType = PositionType.viewport;

    final speedWithMargin = HudMarginComponent(
      margin: const EdgeInsets.only(
        top: 20,
        left: 19,
      ),
    )..add(_expText);

    final healthWithMargin = HudMarginComponent(
      margin: const EdgeInsets.only(
        top: 50,
        left: 17,
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
    _audioPlayer.playBulletSound();
  }

  @override
  void update(double dt){
    super.update(dt);

    _commandList.forEach((command) {
      children.forEach((component) {
        command.run(component);
      });
    });
    _commandList.clear();
    _commandList.addAll(_addLaterCommandList);
    _addLaterCommandList.clear();

    _expText.text = '${_player.exp}';
    final int spriteId = 4 - (_player.health/2).toInt();
    _health.sprite = _healthSpriteSheet.getSpriteById(spriteId);
    if(_player.health <= 0 && (!camera.shaking)){
      this.pauseEngine();
      this.overlays.add(GameOverMenu.ID);
    }
  }

  // This method gets called when game instance gets attached
  // to Flutter's widget tree.
  @override
  void onAttach() {
    _audioPlayer.startBgmMusic();
    super.onAttach();
  }

  @override
  void onDetach() {
    _audioPlayer.stopBgmMusic();
    super.onDetach();
  }

  void addCommand(Command command){
    _addLaterCommandList.add(command);
  }

  void reset() {
    // First reset player, enemy manager and power-up manager .
    _player.reset();
    _enemyManager.reset();

    // Now remove all the enemies, bullets and power ups
    // from the game world. Note that, we are not calling
    // Enemy.destroy() because it will unnecessarily
    // run explosion effect and increase players score.
    children.whereType<Enemy>().forEach((enemy) {
      enemy.removeFromParent();
    });

    children.whereType<Bullet>().forEach((bullet) {
      bullet.removeFromParent();
    });
  }
}
