import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:super_devan_world/component/devan.dart';
import 'package:super_devan_world/component/world_collidable.dart';
import 'package:tiled/tiled.dart';

class TombStone extends WorldCollidable{
  late  TextComponent _dialog;
  TombStone(TiledObject obj): super(obj){
    _dialog = TextComponent(
      text: (' Hi Devan!'),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 14,
          fontFamily: 'rowdies',
        ),
      ),
    );
  }


  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other){
    super.onCollision(intersectionPoints, other);
    if (other is Devan){
      add(_dialog);
    }
  }

  @override
  void onCollisionEnd(Collidable other){
    super.onCollisionEnd(other);
    if (other is Devan){
      _dialog.removeFromParent();
    }
  }
}