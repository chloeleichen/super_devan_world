
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/painting.dart';
import 'devan.dart';

class ActionButton extends HudMarginComponent with Tappable, Draggable {
  late SpriteSheet _actionSpriteSheet;
  late SpriteComponent _action;
  late int _actionId;
  late CircleComponent _background;
  late Devan player;

  ActionButton(this.player)
      : super(
    margin: const EdgeInsets.only(
      left: 30,
      bottom: 30,
    ),
    position: Vector2(0, 0),
    size: Vector2.all(50),
    anchor: Anchor.center
  );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _actionId = 0;
    _actionSpriteSheet = SpriteSheet.fromColumnsAndRows(
        image: gameRef.images.fromCache('devan/actions.png'),
        columns: 9,
        rows: 1
    );
    _action = SpriteComponent(
        sprite: _actionSpriteSheet.getSpriteById(_actionId),
        size: Vector2.all(34),
        position: Vector2(8, 8)
    );

    _background = CircleComponent(
        radius: 25,
        paint: BasicPalette.white.withAlpha(200).paint(),
    );
    add(_background);
    add(_action);
  }

  @override
  bool onDragStart(int pointerId, DragStartInfo info) {
    if(_actionId < 8){
      _actionId +=1;
    } else{
      _actionId = 0;
    }
    _action.sprite = _actionSpriteSheet.getSpriteById(_actionId);
    return super.onDragStart(pointerId, info);
  }


  @override
  bool onTapUp(TapUpInfo info) {
    _background.paint = BasicPalette.white.withAlpha(200).paint();
    player.resetAction();
    return super.onTapUp(info);
  }

  @override
  bool onTapDown(TapDownInfo info) {
    _background.paint = BasicPalette.magenta.withAlpha(200).paint();
    switch(_actionId){
      case(0):
        player.useAxe();
        break;
      case(1):
        player.useSweep();
        break;
      case(2):
        player.useDig();
        break;
      case(3):
        player.useFlower();
        break;
      case(4):
        player.useHammer();
        break;
      case(5):
        player.useKiss();
        break;
      case(6):
        player.usePickaxe();
        break;
      case(7):
        player.useSword();
        break;
      case(8):
        player.useWater();
        break;
    }
    return super.onTapDown(info);
  }

  @override
  bool onTapCancel() {
    _background.paint = BasicPalette.white.withAlpha(200).paint();
    player.resetAction();
    return super.onTapCancel();
  }
}