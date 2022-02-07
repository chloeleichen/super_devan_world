import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:super_devan_world/component/castle_collidable.dart';
import 'package:super_devan_world/component/roadsign.dart';
import 'package:super_devan_world/component/shop.dart';
import 'package:super_devan_world/component/tomb_stone.dart';
import 'world_collidable.dart';
import 'package:tiled/tiled.dart' show ObjectGroup;

class World extends SpriteComponent with HasGameRef, HasHitboxes, Collidable {
  final TiledComponent tiledMap;
  World(this.tiledMap)
      : super();

  @override
  Future<void> ? onLoad() async {
    sprite = Sprite(gameRef.images.fromCache('map.png'));
    size = sprite!.originalSize;
    _addCollisions(tiledMap);
    return super.onLoad();
  }

  void _addCollisions(TiledComponent tiledMap) async {
    final ObjectGroup objGroup =
    tiledMap.tileMap.getObjectGroupFromLayer('Collision');
    for (final obj in objGroup.objects) {
      add(WorldCollidable(obj)
        ..position = Vector2(obj.x, obj.y)
        ..width = obj.width
        ..height = obj.height);
    }

    final ObjectGroup objGroupCastle =
    tiledMap.tileMap.getObjectGroupFromLayer('CBound');
    for (final obj in objGroupCastle.objects) {
      add(CastleColliable(obj)
        ..position = Vector2(obj.x, obj.y)
        ..width = obj.width
        ..height = obj.height);
    }

    final ObjectGroup objGroupTombstone =
    tiledMap.tileMap.getObjectGroupFromLayer('Tombstone');
    for (final obj in objGroupTombstone.objects) {
      add(TombStone(obj)
        ..position = Vector2(obj.x, obj.y)
        ..width = obj.width
        ..height = obj.height);
    }

    final ObjectGroup objGroupShop =
    tiledMap.tileMap.getObjectGroupFromLayer('Shop');
    for (final obj in objGroupShop.objects) {
      add(Shop(obj)
        ..position = Vector2(obj.x, obj.y)
        ..width = obj.width
        ..height = obj.height);
    }

    final ObjectGroup objGroupRoadSign =
    tiledMap.tileMap.getObjectGroupFromLayer('RoadSign');
    for (final obj in objGroupRoadSign.objects) {
      add(RoadSign(obj)
        ..position = Vector2(obj.x, obj.y)
        ..width = obj.width
        ..height = obj.height);
    }
  }
}