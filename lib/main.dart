import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:super_devan_world/overlays/game_won.menu.dart';
import 'game/super_devan_world.dart';
import 'overlays/game_over_menu.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();

  final game = SuperDevanWorld();
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
            GameOverMenu.ID: (BuildContext context, SuperDevanWorld gameRef) =>
                GameOverMenu(
                  gameRef: gameRef,
                ),
            GameWonMenu.ID: (BuildContext context, SuperDevanWorld gameRef) =>
                GameWonMenu(
                  gameRef: gameRef,
                ),
          },
        ),
      ),
    )
  ));
}

