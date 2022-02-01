import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game/devan_world.dart';


void main() {
  final game = DevanWorld();
  runApp(GameWidget(
    game: game,
  ),);
}

