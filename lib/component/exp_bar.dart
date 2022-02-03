import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import 'devan.dart';

class ExpBar extends HudMarginComponent {
  late Devan player;

  late TextComponent _expText;
  final _regular = TextPaint(
    style: const TextStyle(
        color: Colors.white,
        fontFamily: 'rowdies',
        shadows: [
          Shadow(
              blurRadius: 10.0,
              color: Colors.black,
              offset: Offset(0, 0)
          )
        ]
    ),
  );

  ExpBar(this.player): super(margin: const EdgeInsets.only(
    top: 20,
    left: 19,
  ));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _expText = TextComponent(
      text: '0',
      textRenderer: _regular,
    )..positionType = PositionType.viewport;
    add(_expText);
  }

  @override
  void update(double dt){
    super.update(dt);
    _expText.text = '${player.exp}';
  }
}