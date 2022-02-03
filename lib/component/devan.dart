import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:meta/meta.dart';
import 'package:super_devan_world/component/enemy.dart';
import 'package:super_devan_world/component/reward.dart';
import 'package:super_devan_world/component/world_collidable.dart';
import 'package:super_devan_world/helper/creature_type.dart';
import 'package:super_devan_world/helper/direction.dart';

const int leftIndex = 1;
const int rightIndex = 3;
const int upIndex = 2;
const int downIndex = 0;

const int maxHealth = 8;


class Devan<T extends FlameGame> extends SpriteAnimationComponent
    with HasGameRef<T>,  HasHitboxes, Collidable {
  final JoystickComponent joystick;
  bool _collisionActive = false;
  final double _charWidth = 29;
  final double _charHeight = 32.0;
  late final SpriteAnimation _runDownAnimation;
  late final SpriteAnimation _runLeftAnimation;
  late final SpriteAnimation _runUpAnimation;
  late final SpriteAnimation _runRightAnimation;

  late final SpriteAnimation _idleDownAnimation;
  late final SpriteAnimation _idleLeftAnimation;
  late final SpriteAnimation _idleUpAnimation;
  late final SpriteAnimation _idleRightAnimation;
  final double _animationSpeed = 0.15;

  late Vector2 _lastValidPosition;
  Direction _direction = Direction.down;
  int _health = maxHealth;
  int _exp = 0;

  int get exp => _exp;
  int get health => _health;
  Direction get direction => _direction;

  Devan(this.joystick)
      : super(
    position: Vector2(1500, 1500),
    size: Vector2(43.5, 48),
    anchor: Anchor.center,
  ){
    debugMode = true;
    _lastValidPosition = position;
    addHitbox(HitboxCircle());
  }

  @mustCallSuper
  @override
  Future<void> onLoad() async {
    _loadAnimation();
    animation = _idleDownAnimation;
    super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);
      if(!_collisionActive && (other is WorldCollidable || other is ScreenCollidable)){
        _collisionActive = true;
        bounceOff();
      }
      if (other is Enemy){
        bounceOff();
        if(other.type == CreatureType.monster ){
          _health -= 1;
        }

      }
      if(_health <= 0){
        _health = 0;
      }

      if(other is Reward){
        if(health < maxHealth){
          _health +=1;
        }
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
        animation = _idleDownAnimation;
        break;
      case (Direction.up):
        animation = _idleUpAnimation;
        break;
      case (Direction.left):
        animation = _idleLeftAnimation;
        break;
      case (Direction.right):
        animation = _idleRightAnimation;
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
        animation = _runDownAnimation;
        velocity = Vector2(0, 1);
        break;
      case JoystickDirection.up:
        _direction =  Direction.up;
        animation = _runUpAnimation;
        velocity = Vector2(0, -1);
        break;
      case JoystickDirection.left:
        _direction =  Direction.left;
        animation = _runLeftAnimation;
        velocity = Vector2(-1, 0);
        break;
      case JoystickDirection.right:
        _direction =  Direction.right;
        animation = _runRightAnimation;
        velocity = Vector2(1, 0);
        break;
      case JoystickDirection.upLeft:
        _direction =  Direction.left;
        animation = _runLeftAnimation;
        velocity = Vector2(-1, -1);
        break;
      case JoystickDirection.upRight:
        _direction =  Direction.right;
        animation = _runRightAnimation;
        velocity = Vector2(1, -1);
        break;
      case JoystickDirection.downRight:
        _direction =  Direction.right;
        animation = _runRightAnimation;
        velocity = Vector2(1, 1);
        break;
      case JoystickDirection.downLeft:
        _direction =  Direction.left;
        animation = _runLeftAnimation;
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

  void _loadAnimation(){
    final spriteSheet = SpriteSheet(
      image: gameRef.images.fromCache('player_spritesheet.png'),
      srcSize: Vector2(_charWidth, _charHeight),
    );

    _runDownAnimation =
        spriteSheet.createAnimation(row: downIndex, stepTime: _animationSpeed, to: 4);

    _runLeftAnimation =
        spriteSheet.createAnimation(row: leftIndex, stepTime: _animationSpeed, to: 4);

    _runUpAnimation =
        spriteSheet.createAnimation(row: upIndex, stepTime: _animationSpeed, to: 4);

    _runRightAnimation =
        spriteSheet.createAnimation(row: rightIndex, stepTime: _animationSpeed, to: 4);

    _idleDownAnimation =
        spriteSheet.createAnimation(row: downIndex, stepTime: _animationSpeed, to: 1);
    _idleUpAnimation =
        spriteSheet.createAnimation(row: upIndex, stepTime: _animationSpeed, to: 1);
    _idleLeftAnimation =
        spriteSheet.createAnimation(row: leftIndex, stepTime: _animationSpeed, to: 1);
    _idleRightAnimation =
        spriteSheet.createAnimation(row: rightIndex, stepTime: _animationSpeed, to: 1);
  }
}