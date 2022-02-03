import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:super_devan_world/component/enemy.dart';
import 'package:super_devan_world/component/exp_bar.dart';
import 'package:super_devan_world/component/health_bar.dart';
import 'package:super_devan_world/component/joy_stick.dart';
import 'package:super_devan_world/game/audio_player.dart';
import 'package:super_devan_world/game/reward_manager.dart';
import 'package:super_devan_world/overlays/game_over_menu.dart';
import '../component/bullet.dart';
import '../component/command.dart';
import '../component/world.dart';
import '../component/devan.dart';
import 'enemy_manager.dart';

class DevanWorld extends FlameGame with HasDraggables, HasCollidables, HasTappables{
  late final Devan _player;
  late final EnemyManager _enemyManager;
  late final JoystickComponent _joystick;
  late World _world;
  late SpriteAnimationComponent animationComponent;
  late AudioPlayer _audioPlayer;
  late RewardManager _rewardManager;
  late HealthBar _healthBar;
  late ExpBar _expBar;

  final _commandList = List<Command>.empty(growable: true);
  final _addLaterCommandList = List<Command>.empty(growable: true);


  @override
  Future<void> onLoad() async {
    super.onLoad();
    await images.loadAll([
      'heart.png',
      'player_spritesheet.png',
      'bee/idle.png',
      'bee/hit.png',
      'bullet.png',
      'map.png',
      'mushrooms.png',
      'fruits.png',
      'empty.png',
    ]);

    final _tiledMap = await TiledComponent.load('map.tmx', Vector2.all(32));
    _world = World(_tiledMap);
    _audioPlayer = AudioPlayer();
    add(_world);
    add(_audioPlayer);
    add(ScreenCollidable());
    _joystick = JoyStick();
    _player = Devan(_joystick);
    add(_joystick);
    _enemyManager = EnemyManager();
    add(_enemyManager);
    _rewardManager = RewardManager(_tiledMap);
    add(_rewardManager);
    add(_player);
    _healthBar = HealthBar(_player);
    _expBar = ExpBar(_player);
    add(_healthBar);
    add(_expBar);
    camera.followComponent(_player, worldBounds:
    Rect.fromLTRB(0, 0, _world.size.x, _world.size.y));
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
        direction: _player.direction,
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
    for (var command in _commandList) {
      for (var component in children) {
        command.run(component);
      }
    }
    _commandList.clear();
    _commandList.addAll(_addLaterCommandList);
    _addLaterCommandList.clear();

    if(_player.health <= 0){
      pauseEngine();
      overlays.add(GameOverMenu.ID);
    }
  }

  // This method gets called when game instance gets attached
  // to Flutter's widget tree.
  @override
  void onAttach() {
    // _audioPlayer.startBgmMusic();
    super.onAttach();
  }

  @override
  void onDetach() {
    // _audioPlayer.stopBgmMusic();
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
