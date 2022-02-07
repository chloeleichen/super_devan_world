import 'package:flutter/material.dart';
import 'package:super_devan_world/game/super_devan_world.dart';


// This class represents the game over menu overlay.
class GameOverMenu extends StatelessWidget {
  static const String ID = 'GameOverMenu';
  final SuperDevanWorld gameRef;
  const GameOverMenu({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50.0),
            child: Text(
              'GAME OVER',
              style: TextStyle(
                fontSize: 50.0,
                fontFamily: 'rowdies',
                color: Colors.red.shade900,
                shadows: const [
                  Shadow(
                    blurRadius: 30.0,
                    color: Colors.white,
                    offset: Offset(0, 0),
                  )
                ],
              ),
            ),
          ),

          // Restart button.
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'rowdies'
                ),
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),

              ),
              onPressed: () {
                gameRef.overlays.remove(GameOverMenu.ID);
                gameRef.reset();
                gameRef.resumeEngine();
              },
              child: const Text('Restart'),
            ),
          ),
        ],
      ),
    );
  }
}