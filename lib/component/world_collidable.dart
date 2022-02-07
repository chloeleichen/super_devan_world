import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:tiled/tiled.dart';

class WorldCollidable extends PositionComponent
    with HasGameRef, HasHitboxes, Collidable {
  WorldCollidable (
      TiledObject obj
      ){
    // debugMode = true;
    collidableType = CollidableType.passive;
    if (obj.isEllipse){
      addHitbox(HitboxCircle());
    } else if (obj.isRectangle){
      addHitbox(HitboxRectangle());
    } else {
      return;
    }
  }
}