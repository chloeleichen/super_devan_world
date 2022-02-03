import 'dart:math';
import 'package:flame/components.dart';
import 'package:super_devan_world/component/enemy.dart';

class EnemyManager extends Component with HasGameRef{
  late Timer _timer;
  int max_enemy = 100;
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

    if (enemyCount >=max_enemy){
      return;
    }
    Vector2 initialSize = Vector2(32, 32);
    Vector2 position = Vector2(random.nextDouble() * 2240, random.nextDouble() * 2240);

    position.clamp(
      Vector2.zero() + initialSize / 2,
      Vector2(2240, 2240) - initialSize / 2,
    );
    Enemy enemy = Enemy(
      position:position,
      onDestroyed:onEnemyDestroyed,
      idle: idle,
      hit: hit
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