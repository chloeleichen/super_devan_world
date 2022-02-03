import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
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
  }
}