import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:super_devan_world/controller/devan_animation.dart';
import 'package:super_devan_world/helper/devan_movement.dart';

class DevanActionController extends Component with HasGameRef {
  late Map<DevanMovement, DevanAnimation> _animations;

  Map<DevanMovement, DevanAnimation> get animations => _animations;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _animations = {for (var action in DevanMovement.values)
      action: getAnimation(action.toString().split('.').last)
    };
  }
  DevanAnimation getAnimation(String action){
    final spriteSheet = SpriteSheet(
      image: gameRef.images.fromCache('devan/movement/$action.png'),
      srcSize: Vector2(100, 100),
    );
    return DevanAnimation(spriteSheet: spriteSheet, to:5, animationSpeed: 0.15);
  }
}