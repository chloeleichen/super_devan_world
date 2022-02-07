import 'dart:math';
import 'package:flame/components.dart';
import 'package:super_devan_world/component/flying_creature.dart';
import 'package:super_devan_world/helper/creature_type.dart';

class CreatureManager extends Component with HasGameRef{
  late Timer _timer;
  int maxFlyingCreature = 30;
  Random random = Random();
  int flyingCreatureCount = 0;
  CreatureManager() : super(){
    _timer = Timer(1, onTick: _spawFlyingCreature, repeat: true);
  }

  void _spawFlyingCreature() async{
    final beeIdle = await gameRef.loadSpriteAnimation(
      'bee/idle.png',
      SpriteAnimationData.sequenced(
        amount: 6,
        textureSize: Vector2(36, 34),
        stepTime: 0.15,
      ),
    );

    final beeHit = await gameRef.loadSpriteAnimation(
      'bee/hit.png',
      SpriteAnimationData.sequenced(
        amount: 6,
        textureSize: Vector2(36, 34),
        stepTime: 0.15,
      ),
    );

    final skullIdle = await gameRef.loadSpriteAnimation(
      'skull/flying.png',
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: Vector2(52, 54),
        stepTime: 0.15,
      ),
    );

    final skullHit = await gameRef.loadSpriteAnimation(
      'skull/hit.png',
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: Vector2(52, 54),
        stepTime: 0.15,
      ),
    );

    if (flyingCreatureCount >=maxFlyingCreature){
      return;
    }
    Vector2 initPositionSkull = Vector2(2095, 193);
    Vector2 initPositionBee = Vector2(1167.7, 334.87);

    late FlyingCreature flyingCreature;
    if(random.nextBool()){
      flyingCreature = FlyingCreature(
        position:initPositionBee,
        onDestroyed:onFlyingCreatureDestroyed,
        idle: beeIdle,
        hit: beeHit,
        type: CreatureType.bee,
        speed: 50,
        isFixAngle: false
      );
    } else {
      flyingCreature = FlyingCreature(
        position:initPositionSkull,
        onDestroyed:onFlyingCreatureDestroyed,
        idle: skullIdle,
        hit: skullHit,
        type: CreatureType.skull,
        speed: 40,
        isFixAngle: true
      );
    }
    gameRef.add(flyingCreature);
    flyingCreatureCount +=1;
  }

  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  @override
  void onRemove(){
    super.onRemove();
    _timer.stop();
  }

  @override
  void update(double dt){
    super.update(dt);
    _timer.update(dt);
  }

  void onFlyingCreatureDestroyed(){
    flyingCreatureCount -=1;
  }
}