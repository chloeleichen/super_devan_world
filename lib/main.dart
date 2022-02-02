import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game/devan_world.dart';
import 'overlays/game_over_menu.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();

  final game = DevanWorld();
  runApp(MaterialApp(
    themeMode: ThemeMode.light,
    darkTheme: ThemeData(
      brightness: Brightness.light,
      fontFamily: 'rowdies',
      scaffoldBackgroundColor: Colors.green
    ),
    home: Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,
        child: GameWidget(
          game: game,
          overlayBuilderMap: {
            GameOverMenu.ID: (BuildContext context, DevanWorld gameRef) =>
                GameOverMenu(
                  gameRef: gameRef,
                ),
          },
        ),
      ),
    )
  ));
}

