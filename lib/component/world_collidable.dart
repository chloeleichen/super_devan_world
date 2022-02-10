import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:tiled/tiled.dart';
import '../helper/world_collidable_type.dart';

class WorldCollidable extends PositionComponent
    with HasGameRef, HasHitboxes, Collidable {
  late WorldCollidableType type;
  WorldCollidable (
      TiledObject obj,
      WorldCollidableType _type
      ){
    // debugMode = true;
    collidableType = CollidableType.passive;
    type = _type;
    if (obj.isEllipse){
      addHitbox(HitboxCircle());
    } else if (obj.isRectangle){
      addHitbox(HitboxRectangle());
    } else {
      return;
    }
  }
}