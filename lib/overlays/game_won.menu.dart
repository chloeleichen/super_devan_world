import 'package:flutter/material.dart';
import 'package:super_devan_world/game/super_devan_world.dart';


// This class represents the game over menu overlay.
class GameWonMenu extends StatelessWidget {
  static const String ID = 'GameWonMenu';
  final SuperDevanWorld gameRef;
  const GameWonMenu({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50.0),
            child: Text(
              'YOU WON !!!',
              style: TextStyle(
                fontSize: 50.0,
                fontFamily: 'rowdies',
                color: Colors.green,
                shadows: const [
                  Shadow(
                    blurRadius: 30.0,
                    color: Colors.yellow,
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
                backgroundColor: Colors.lightGreenAccent,
                textStyle: const TextStyle(
                    fontFamily: 'rowdies'
                ),
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),

              ),
              onPressed: () {
                gameRef.overlays.remove(GameWonMenu.ID);
                gameRef.reset();
                gameRef.resumeEngine();
              },
              child: const Text('Restart', style: TextStyle(color: Colors.black),),
            ),
          ),
        ],
      ),
    );
  }
}