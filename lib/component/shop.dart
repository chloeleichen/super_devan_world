import 'package:flame/components.dart';
import 'package:super_devan_world/component/world_collidable.dart';
import 'package:tiled/tiled.dart';

class Shop extends WorldCollidable{
  Shop(TiledObject obj): super(obj);

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other){
    super.onCollision(intersectionPoints, other);
  }
}