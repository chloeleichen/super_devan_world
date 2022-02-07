import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'dart:math';
import 'dart:async';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:super_devan_world/component/mushroom.dart';
import 'package:super_devan_world/component/reward.dart';
import 'package:tiled/tiled.dart' show ObjectGroup;

class RewardManager extends PositionComponent with HasGameRef {
  late TiledComponent tiledMap;

  Random random = Random();
  RewardManager(this.tiledMap) : super();

  void _spawnFruit(Vector2 position, SpriteSheet spriteSheet) {
    int min = 0;
    int max = 20;
    int r = min + random.nextInt(max - min);

    Reward reward = Reward(
        sprite: spriteSheet.getSpriteById(r),
        position: position,
        size: Vector2.all(32)
    );
    gameRef.add(reward);
  }

  void _spawnMushroom(Vector2 position, SpriteSheet spriteSheet){
    int min = 0;
    int max = 36;
    int r = min + random.nextInt(max - min);

    Reward reward = Mushroom(
        sprite: spriteSheet.getSpriteById(r),
        position: position,
        size: Vector2.all(18),
        mushroomId: r
    );
    gameRef.add(reward);
  }

  @override
  Future<void> onLoad() async{
    final fruitsImg = gameRef.images.fromCache('fruits.png');
    final mushroomsImg = gameRef.images.fromCache('mushrooms.png');


    final spriteSheetFruit = SpriteSheet.fromColumnsAndRows(
        image: fruitsImg,
        columns: 5,
        rows: 4
    );

    final spriteSheetMushroom = SpriteSheet.fromColumnsAndRows(
        image: mushroomsImg,
        columns: 8,
        rows: 5
    );

    final ObjectGroup fruitObjGroup =
    tiledMap.tileMap.getObjectGroupFromLayer('Fruit');

    for (final obj in fruitObjGroup.objects) {
      _spawnFruit(Vector2(obj.x, obj.y), spriteSheetFruit);
    }

    final ObjectGroup mushroomObjGroup =
    tiledMap.tileMap.getObjectGroupFromLayer('Mushroom');

    for (final obj in mushroomObjGroup.objects) {
      _spawnMushroom(Vector2(obj.x, obj.y), spriteSheetMushroom);
    }
    super.onLoad();
  }
}
