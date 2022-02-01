import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'world_collidable.dart';
import 'package:tiled/tiled.dart' show ObjectGroup, TiledObject;

class World extends SpriteComponent with HasGameRef, HasHitboxes, Collidable   {
  @override
  Future<void> ? onLoad() async {
    sprite = await gameRef.loadSprite('map.png');
    size = sprite!.originalSize;
    final tiledMap = await TiledComponent.load('map.tmx', Vector2.all(32));
    _addCollisions(tiledMap);
    return super.onLoad();
  }


  void _addCollisions(TiledComponent tiledMap) async {
    final ObjectGroup objGroup =
    await tiledMap.tileMap.getObjectGroupFromLayer('Collision');
    for (final obj in objGroup.objects) {
      add(WorldCollidable(obj)
        ..position = Vector2(obj.x, obj.y)
        ..width = obj.width
        ..height = obj.height);
    }
  }
}