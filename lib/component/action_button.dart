
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/painting.dart';
import 'devan.dart';

class ActionButton extends HudMarginComponent with Tappable {
  late SpriteSheet _actionSpriteSheet;
  late SpriteComponent _action;
  late int _actionId;
  late CircleComponent _background;
  late Devan player;

  bool _beenPressed = false;
  ActionButton(this.player)
      : super(
    margin: const EdgeInsets.only(
      left: 50,
      bottom: 20,
    ),
    position: Vector2(0, 0),
    size: Vector2.all(34),
  );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _actionId = 0;
    _actionSpriteSheet = SpriteSheet.fromColumnsAndRows(
        image: gameRef.images.fromCache('devan/actions.png'),
        columns: 4,
        rows: 1
    );
    _action = SpriteComponent(
        sprite: _actionSpriteSheet.getSpriteById(_actionId),
        size: Vector2.all(34),
        anchor: Anchor.center
    );

    _background = CircleComponent(
        radius: 25,
        paint: BasicPalette.white.withAlpha(200).paint(),
        anchor: Anchor.center
    );
    add(_background);
    add(_action);
  }

  @override
  bool onTapUp(TapUpInfo info) {
    print('tap up');
    _beenPressed = false;
    _background.paint = BasicPalette.white.withAlpha(200).paint();
    player.resetAction();
    return super.onTapUp(info);
  }

  @override
  bool onTapDown(TapDownInfo info) {
    print('tap down');
    _beenPressed = true;
    _background.paint = BasicPalette.magenta.withAlpha(200).paint();
    player.useAxe();
    return super.onTapDown(info);
  }

  @override
  bool onTapCancel() {
    _beenPressed = false;
    _background.paint = BasicPalette.white.withAlpha(200).paint();
    player.resetAction();
    return super.onTapCancel();
  }
}