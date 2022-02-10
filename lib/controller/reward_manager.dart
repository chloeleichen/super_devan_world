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
    final mushroomsImg = gameRef.images.fromCache('mushrooms.png');


    final spriteSheetMushroom = SpriteSheet.fromColumnsAndRows(
        image: mushroomsImg,
        columns: 8,
        rows: 5
    );

    final ObjectGroup mushroomObjGroup =
    tiledMap.tileMap.getObjectGroupFromLayer('Mushroom');

    for (final obj in mushroomObjGroup.objects) {
      _spawnMushroom(Vector2(obj.x, obj.y), spriteSheetMushroom);
    }
    super.onLoad();
  }
}
