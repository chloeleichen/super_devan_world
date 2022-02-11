import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/cupertino.dart';

class JoyStick extends JoystickComponent{
  JoyStick():
      super(
        knob: CircleComponent(radius: 20, paint: BasicPalette.white.withAlpha(200).paint()),
        background: CircleComponent(radius: 50, paint: BasicPalette.white.withAlpha(100).paint()),
        margin: const EdgeInsets.only(right: 40, bottom: 40),
      );
}