import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:super_devan_world/helper/world_collidable_type.dart';
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

    for (var value in WorldCollidableType.values) {
      String type = value.toString().split('.').last;
      final ObjectGroup objGroup =
      tiledMap.tileMap.getObjectGroupFromLayer(type);
      for (final obj in objGroup.objects) {
        add(WorldCollidable(obj, value)
          ..position = Vector2(obj.x, obj.y)
          ..width = obj.width
          ..height = obj.height);
      }
    }
  }
}