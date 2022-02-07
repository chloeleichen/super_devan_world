import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
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
    add(_dialog);

  }

  @override
  void onCollisionEnd(Collidable other){
    super.onCollisionEnd(other);
    _dialog.removeFromParent();
  }
}