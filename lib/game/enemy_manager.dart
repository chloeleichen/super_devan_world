import 'dart:math';
import 'package:flame/components.dart';
import 'package:super_devan_world/component/enemy.dart';
import 'package:super_devan_world/helper/creature_type.dart';

class EnemyManager extends Component with HasGameRef{
  late Timer _timer;
  int maxEnemy = 20;
  Random random = Random();
  int enemyCount = 0;
  EnemyManager() : super(){
    _timer = Timer(1, onTick: _spawEnemy, repeat: true);
  }

  void _spawEnemy() async{
    final idle = await gameRef.loadSpriteAnimation(
      'bee/idle.png',
      SpriteAnimationData.sequenced(
        amount: 6,
        textureSize: Vector2(36, 34),
        stepTime: 0.15,
      ),
    );

    final hit = await gameRef.loadSpriteAnimation(
      'bee/hit.png',
      SpriteAnimationData.sequenced(
        amount: 6,
        textureSize: Vector2(36, 34),
        stepTime: 0.15,
      ),
    );

    if (enemyCount >=maxEnemy){
      return;
    }
    Vector2 position = Vector2( 2230*random.nextDouble(), 2230*random.nextDouble());

    Enemy enemy = Enemy(
      position:position,
      onDestroyed:onEnemyDestroyed,
      idle: idle,
      hit: hit,
      type: CreatureType.bee,
    );
    gameRef.add(enemy);
    enemyCount +=1;
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

  void reset() {
    _timer.stop();
    _timer.start();
  }
  void onEnemyDestroyed(){
    enemyCount -=1;
  }
}