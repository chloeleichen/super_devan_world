import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:super_devan_world/component/devan.dart';
import 'package:super_devan_world/game/devan_world.dart';

class Creature<T extends FlameGame> extends SpriteAnimationGroupComponent
    with HasGameRef<DevanWorld>,  HasHitboxes, Collidable {
  late Timer _timer;
  Random random = Random();
  late Vector2 velocity;
  late void Function() _onDestroyed;
  double _speed = 50;

  Creature({Vector2? position, required void Function() onDestroyed, double? speed})
      : super(
      position: position,
      size: Vector2.all(16),
      priority: 1,
      anchor: Anchor.center,
  ){
    _timer = Timer(10, onTick: changeVelocity, repeat: true);
    if(speed != null){
      _speed = speed;
    }
    velocity = Vector2((random.nextInt(2)).toDouble(), (random.nextInt(2)).toDouble());
    addHitbox(HitboxCircle());
    _onDestroyed = onDestroyed;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints,other);
    if (other is Devan){
      bounceOff();
    }
  }

  void bounceOff() {
    velocity = -velocity;
    position.add(velocity * 10);
  }
  @override
  void update(double dt) {
    _timer.update(dt);
    move(dt);
    super.update(dt);
  }

  void changeVelocity(){
    double x = random.nextInt(3) - 1.0;
    double y = random.nextInt(3) - 1.0;
    var v = Vector2(x, y);
    if (!v.isZero()){
      velocity = v;
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