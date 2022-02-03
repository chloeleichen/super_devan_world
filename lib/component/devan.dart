import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:meta/meta.dart';
import 'package:super_devan_world/component/bullet.dart';
import 'package:super_devan_world/component/enemy.dart';
import 'package:super_devan_world/helper/direction.dart';

enum DevanState {
  left,
  right,
  up,
  down,
  upLeft,
  upRight,
  downLeft,
  downRight,
  idle_down,
  idle_up,
  idle_left,
  idle_right
}

const int leftIndex = 1;
const int rightIndex = 3;
const int upIndex = 2;
const int downIndex = 0;


class Devan<T extends FlameGame> extends SpriteAnimationGroupComponent
    with HasGameRef<T>,  HasHitboxes, Collidable {
  final JoystickComponent joystick;
  bool _collisionActive = false;
  double _char_width = 29;
  double _char_height = 32.0;
  late Vector2 _lastValidPosition;
  Direction _direction = Direction.down;
  int _health = 8;
  int _exp = 0;

  int get exp => _exp;
  int get health => _health;
  Direction get direction => _direction;

  Devan(this.joystick)
      : super(
    position: Vector2(1500, 1500),
    size: Vector2(43.5, 48),
    priority: 1,
    anchor: Anchor.center, current: DevanState.left
  ){
    // debugMode = true;
    _lastValidPosition = position;
    addHitbox(HitboxCircle());
  }

  @mustCallSuper
  @override
  Future<void> onLoad() async {
    final left = await gameRef.loadSpriteAnimation(
      'player_spritesheet.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2(_char_width, _char_height),
        texturePosition: Vector2(0, _char_height *leftIndex),
        stepTime: 0.15,
      ),
    );

    final right = await gameRef.loadSpriteAnimation(
      'player_spritesheet.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2(_char_width, _char_height),
        texturePosition: Vector2(0, _char_height*rightIndex),
        stepTime: 0.15,
      ),
    );

    final up = await gameRef.loadSpriteAnimation(
      'player_spritesheet.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2(_char_width, _char_height),
        texturePosition: Vector2(0, _char_height*upIndex),
        stepTime: 0.15,
      ),
    );

    final down = await gameRef.loadSpriteAnimation(
      'player_spritesheet.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2(_char_width, _char_height),
        texturePosition: Vector2(0, _char_height *downIndex),
        stepTime: 0.15,
      ),
    );

    final idle_down = await gameRef.loadSpriteAnimation(
      'player_spritesheet.png',
      SpriteAnimationData.sequenced(
        amount: 1,
        textureSize: Vector2(_char_width, _char_height),
        texturePosition: Vector2(0, _char_height*downIndex ),
        stepTime: double.infinity,
        loop: false
      ),
    );
    final idle_up = await gameRef.loadSpriteAnimation(
      'player_spritesheet.png',
      SpriteAnimationData.sequenced(
          amount: 1,
          textureSize: Vector2(_char_width, 32.0),
          texturePosition: Vector2(0, _char_height*upIndex),
          stepTime: double.infinity,
          loop: false
      ),
    );
    final idle_left = await gameRef.loadSpriteAnimation(
      'player_spritesheet.png',
      SpriteAnimationData.sequenced(
          amount: 1,
          textureSize: Vector2(_char_width, 32.0),
          texturePosition: Vector2(0, _char_height*leftIndex),
          stepTime: double.infinity,
          loop: false
      ),
    );
    final idle_right = await gameRef.loadSpriteAnimation(
      'player_spritesheet.png',
      SpriteAnimationData.sequenced(
          amount: 1,
          textureSize: Vector2(_char_width, _char_height),
          texturePosition: Vector2(0, _char_height*rightIndex),
          stepTime: double.infinity,
          loop: false
      ),
    );

    animations = {
      DevanState.left: left,
      DevanState.right: right,
      DevanState.up: up,
      DevanState.down: down,
      DevanState.upLeft: left,
      DevanState.downLeft: left,
      DevanState.upRight: right,
      DevanState.downRight: right,
      DevanState.idle_down : idle_down,
      DevanState.idle_up : idle_up,
      DevanState.idle_left : idle_left,
      DevanState.idle_right : idle_right,
    };
    super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);
      if(!_collisionActive && other is! Bullet){
        _collisionActive = true;
        bounceOff();
      }
      if (other is Enemy){
        gameRef.camera.shake(intensity: 1, duration: 0.1);
        _health -= 1;
      }
      if(_health <= 0){
        _health = 0;
      }
  }

  @override
  void onCollisionEnd(Collidable other) {
    super.onCollisionEnd(other);
    _collisionActive = false;
  }

  void bounceOff() {
    position = _lastValidPosition;
    _lastValidPosition = Vector2(position.x, position.y);
  }
  @override
  void update(double dt) {
    movePlayer(dt);
    super.update(dt);
  }

  void idlePlayer(){
    switch(_direction){
      case (Direction.down):
        current = DevanState.idle_down;
        break;
      case (Direction.up):
        current = DevanState.idle_up;
        break;
      case (Direction.left):
        current = DevanState.idle_left;
        break;
      case (Direction.right):
        current = DevanState.idle_right;
        break;
      }
  }

  void movePlayer(double dt){
    if(_collisionActive){
      return;
    }
    if(!_collisionActive){
      _lastValidPosition = Vector2(position.x, position.y);
    }
    Vector2 velocity = Vector2(0, 0);
    switch(joystick.direction){
      case JoystickDirection.idle:
        idlePlayer();
        velocity = Vector2(0, 0);
        break;
      case JoystickDirection.down:
        _direction =  Direction.down;
        current = DevanState.down;
        velocity = Vector2(0, 1);
        break;
      case JoystickDirection.up:
        _direction =  Direction.up;
        current = DevanState.up;
        velocity = Vector2(0, -1);
        break;
      case JoystickDirection.left:
        _direction =  Direction.left;
        current = DevanState.left;
        velocity = Vector2(-1, 0);
        break;
      case JoystickDirection.right:
        _direction =  Direction.right;
        current = DevanState.right;
        velocity = Vector2(1, 0);
        break;
      case JoystickDirection.upLeft:
        _direction =  Direction.left;
        current = DevanState.upLeft;
        velocity = Vector2(-1, -1);
        break;
      case JoystickDirection.upRight:
        _direction =  Direction.right;
        current = DevanState.upRight;
        velocity = Vector2(1, -1);
        break;
      case JoystickDirection.downRight:
        _direction =  Direction.right;
        current = DevanState.downRight;
        velocity = Vector2(1, 1);
        break;
      case JoystickDirection.downLeft:
        _direction =  Direction.left;
        current = DevanState.downLeft;
        velocity = Vector2(-1, 1);
        break;

    }
    position.add(velocity/2 * 250 * dt);
  }

  void addToExp(int points){
    _exp += points;
  }

  void reset() {
    _exp = 0;
    _health = 8;
    position = Vector2(1500, 1500);
    _lastValidPosition = Vector2(1500, 1500);
    _collisionActive = false;
  }
}