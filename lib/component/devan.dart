import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:meta/meta.dart';
import 'package:super_devan_world/component/world_collidable.dart';

enum DevanState {
  left, right, up, down, upLeft, upRight, downLeft, downRight, idle
}

class Devan<T extends FlameGame> extends SpriteAnimationGroupComponent
    with HasGameRef<T>,  HasHitboxes, Collidable {
  final JoystickComponent joystick;
  bool _collisionActive = false;
  Vector2 _lastValidPosition = Vector2(0, 0);

  Devan(this.joystick)
      : super(
    position: Vector2(1500, 1500),
    size: Vector2.all(48.0),
    priority: 1,
    anchor: Anchor.center, current: DevanState.left
  ){
    addHitbox(HitboxCircle());
  }

  @mustCallSuper
  @override
  Future<void> onLoad() async {
    final left = await gameRef.loadSpriteAnimation(
      'player_spritesheet.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2(29, 32.0),
        texturePosition: Vector2(0, 32*1),
        stepTime: 0.15,
      ),
    );

    final right = await gameRef.loadSpriteAnimation(
      'player_spritesheet.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2(29, 32.0),
        texturePosition: Vector2(0, 32*3),
        stepTime: 0.15,
      ),
    );

    final up = await gameRef.loadSpriteAnimation(
      'player_spritesheet.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2(29, 32.0),
        texturePosition: Vector2(0, 32*2),
        stepTime: 0.15,
      ),
    );

    final down = await gameRef.loadSpriteAnimation(
      'player_spritesheet.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2(29, 32.0),
        texturePosition: Vector2(0, 0),
        stepTime: 0.15,
      ),
    );

    final idle = await gameRef.loadSpriteAnimation(
      'player_spritesheet.png',
      SpriteAnimationData.sequenced(
        amount: 1,
        textureSize: Vector2(29, 32.0),
        texturePosition: Vector2(0, 0),
        stepTime: 0.15,
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
      DevanState.idle : idle,
    };
    super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is WorldCollidable || other is ScreenCollidable){
      if(!_collisionActive){
        _collisionActive = true;
        bounceOff();
      }
    }
  }

  @override
  void onCollisionEnd(Collidable other) {
    _collisionActive = false;
  }

  void bounceOff() {
    position = _lastValidPosition;
    _lastValidPosition = Vector2(position.x, position.y);
  }
  @override
  void update(double dt) {
    if (!joystick.delta.isZero()) {
      movePlayer(dt);
    } else {
      current = DevanState.idle;
    }
    super.update(dt);
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
      case JoystickDirection.down:
        current = DevanState.down;
        velocity = Vector2(1, 1);
        break;
      case JoystickDirection.up:
        current = DevanState.up;
        velocity = Vector2(0, -1);
        break;
      case JoystickDirection.left:
        current = DevanState.left;
        velocity = Vector2(-1, 0);
        break;
      case JoystickDirection.right:
        current = DevanState.right;
        velocity = Vector2(1, 0);
        break;
      case JoystickDirection.upLeft:
        current = DevanState.upLeft;
        velocity = Vector2(-1, -1);
        break;
      case JoystickDirection.upRight:
        current = DevanState.upRight;
        velocity = Vector2(1, -1);
        break;
      case JoystickDirection.downRight:
        current = DevanState.downRight;
        velocity = Vector2(1, 1);
        break;
      case JoystickDirection.downLeft:
        current = DevanState.downLeft;
        velocity = Vector2(-1, 1);
        break;
    }
    position.add(velocity/2 * 250 * dt);
  }
}