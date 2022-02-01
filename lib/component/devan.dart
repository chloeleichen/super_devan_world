import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:meta/meta.dart';
import 'package:super_devan_world/component/world_collidable.dart';

enum DevanState {
  left, right,
}

class Devan<T extends FlameGame> extends SpriteAnimationGroupComponent
    with HasGameRef<T>,  HasHitboxes, Collidable {
  final JoystickComponent joystick;
  bool _collisionActive = false;
  Vector2 _lastValidPosition = Vector2(0, 0);

  Devan(this.joystick)
      : super(
    position: Vector2(1500, 1500),
    size: Vector2.all(45.0),
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
        textureSize: Vector2(29.0, 32.0),
        stepTime: 0.15,
      ),
    );

    final right = await gameRef.loadSpriteAnimation(
      'bomb_ptero.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2(29.0, 32.0),
        stepTime: 0.15,
      ),
    );

    animations = {
      DevanState.left: left,
      DevanState.right: right
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
    current = DevanState.right;
    position.add(joystick.relativeDelta * 300 * dt);
  }
}