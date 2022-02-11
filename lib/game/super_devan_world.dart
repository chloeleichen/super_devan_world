import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:super_devan_world/component/boss.dart';
import 'package:super_devan_world/component/flying_creature.dart';
import 'package:super_devan_world/component/exp_bar.dart';
import 'package:super_devan_world/component/health_bar.dart';
import 'package:super_devan_world/component/joy_stick.dart';
import 'package:super_devan_world/game/audio_player.dart';
import 'package:super_devan_world/controller/reward_manager.dart';
import 'package:super_devan_world/overlays/game_over_menu.dart';
import 'package:super_devan_world/overlays/game_won.menu.dart';
import 'package:throttling/throttling.dart';
import '../component/action_button.dart';
import '../component/command.dart';
import '../component/world.dart';
import '../component/devan.dart';
import '../controller/creature_manager.dart';

class SuperDevanWorld extends FlameGame with
    HasDraggables, HasCollidables, HasTappables, HasDraggables{
  late final Devan _player;
  late final CreatureManager _creatureManager;
  late final JoyStick _joystick;
  late RewardManager _rewardManager;
  late HealthBar _healthBar;
  late ExpBar _expBar;
  late World _world;
  late SpriteAnimationComponent animationComponent;
  late AudioPlayer _audioPlayer;
  late Boss _boss;
  late ActionButton _actionButton;

  final _commandList = List<Command>.empty(growable: true);
  final _addLaterCommandList = List<Command>.empty(growable: true);
  late Timer timer;


  @override
  Future<void> onLoad() async {
    super.onLoad();
    await images.loadAll([
      'heart.png',
      'map.png',
      'mushrooms.png',
      'skull/flying.png',
      'skull/hit.png',
      'devan/actions.png',
      'devan/movement/attackSword.png',
      'devan/movement/axe.png',
      'devan/movement/carryIdle.png',
      'devan/movement/carryWalk.png',
      'devan/movement/climb.png',
      'devan/movement/dance.png',
      'devan/movement/die.png',
      'devan/movement/dig.png',
      'devan/movement/flower.png',
      'devan/movement/hammer.png',
      'devan/movement/hello.png',
      'devan/movement/idle.png',
      'devan/movement/jump.png',
      'devan/movement/kiss.png',
      'devan/movement/make.png',
      'devan/movement/pickaxe.png',
      'devan/movement/playGuitar.png',
      'devan/movement/read.png',
      'devan/movement/run.png',
      'devan/movement/showSword.png',
      'devan/movement/sit.png',
      'devan/movement/sweep.png',
      'devan/movement/take.png',
      'devan/movement/walk.png',
      'devan/movement/water.png',
    ]);
    final _tiledMap = await TiledComponent.load('map.tmx', Vector2.all(32));
    _world = World(_tiledMap);
    await add(_world);
    _audioPlayer = AudioPlayer();
    add(_audioPlayer);
    add(ScreenCollidable());
    _joystick = JoyStick();
    _player = Devan(_joystick, _audioPlayer);
    _actionButton = ActionButton(_player);

    camera.followComponent(_player, worldBounds:
    Rect.fromLTRB(0, 0, _world.size.x, _world.size.y));

    add(_player);

    _creatureManager = CreatureManager();
    add(_creatureManager);

    _rewardManager = RewardManager(_tiledMap);
    add(_rewardManager);

    _boss = Boss(_player, _tiledMap);

    add(_boss);
    add(_joystick);


    _healthBar = HealthBar(_player);
    _expBar = ExpBar(_player);
    add(_healthBar);
    add(_expBar);
    timer = Timer(2, onTick: _gameOver, repeat: false);
    add(_actionButton..anchor = Anchor.center);
  }

  bool isTappingOnJoystick(Vector2 position){
    if (position.x > size.x - 110 && position.y > size.y - 110){
      return true;
    }
    return false;
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
    if((_player.health <= 0 || _boss.health <=0)){
      timer.update(dt);
    }
  }

  void _gameOver(){
    HapticFeedback.vibrate();
    pauseEngine();
    if (_boss.health <=0){
      overlays.add(GameWonMenu.ID);
    } else {
      overlays.add(GameOverMenu.ID);
    }
  }

  // This method gets called when game instance gets attached
  // to Flutter's widget tree.
  @override
  void onAttach() {
    //_audioPlayer.startBgmMusic();
    timer.start();
    super.onAttach();
  }

  @override
  void onDetach() {
    _audioPlayer.stopBgmMusic();
    timer.stop();
    super.onDetach();
  }

  void addCommand(Command command){
    _addLaterCommandList.add(command);
  }

  void reset() {
    timer.stop();
    timer.start();
    // First reset player, flyingCreature manager and power-up manager .
    _player.reset();
    _audioPlayer.stopBgmMusic();
    _audioPlayer.startBgmMusic();
  }
}
