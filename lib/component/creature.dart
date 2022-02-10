import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:super_devan_world/game/super_devan_world.dart';

class Creature<T extends FlameGame> extends SpriteAnimationGroupComponent
    with HasGameRef<SuperDevanWorld>,  HasHitboxes, Collidable {
  bool _isColliding = false;
  late Timer _timer;
  Random random = Random();
  late Vector2 velocity;
  late void Function() _onDestroyed;
  late bool _isFixAngle;
  double _speed = 50;

  Creature({
    required void Function() onDestroyed, required bool isFixAngle, required Vector2 position, required double speed})
      : super(
      priority: 1,
      anchor: Anchor.center,
      position: position
  ){
    _timer = Timer(10, onTick: changeVelocity, repeat: true);
    _speed = speed;
    _isFixAngle = isFixAngle;
    velocity = Vector2((random.nextInt(2)).toDouble(), (random.nextInt(2)).toDouble());
    addHitbox(HitboxCircle());
    _onDestroyed = onDestroyed;
    if (!_isFixAngle){
      angle = -atan2(velocity.x, velocity.y);
    }
  }

  void bounceOff() {
    velocity = -velocity;
    if (!_isFixAngle){
      angle = -atan2(velocity.x, velocity.y);
    }
  }

  @override
  void update(double dt) {
    _timer.update(dt);
    move(dt);
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    _isColliding = true;
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(other){
    _isColliding = false;
  }

  void changeVelocity(){
    if(_isColliding){
      return;
    }
    double x = random.nextInt(3) - 1.0;
    double y = random.nextInt(3) - 1.0;
    var v = Vector2(x, y);
    if (!v.isZero()){
      velocity = v;
      if (!_isFixAngle){
        angle = -atan2(velocity.x, velocity.y);
      }
    }
  }

  void move(double dt){
    position.add(velocity * _speed * dt);
    if (position.x < -10 || position.y < -10 || position.x > 2250 || position.y > 2250){
      removeFromParent();
      _onDestroyed();
    }
  }

  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  @override
  void onRemove() {
    super.onRemove();
    _timer.stop();
  }
}