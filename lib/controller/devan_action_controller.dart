import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:super_devan_world/component/devan_animation.dart';
import 'package:super_devan_world/helper/devan_action.dart';

class DevanActionController extends Component with HasGameRef {
  late Map<DevanAction, DevanAnimation> _animations;

  Map<DevanAction, DevanAnimation> get animations => _animations;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _animations = {for (var action in DevanAction.values)
      action: getAnimation(action.toString().split('.').last)
    };
  }
  DevanAnimation getAnimation(String action){
    final spriteSheet = SpriteSheet(
      image: gameRef.images.fromCache('devan/$action.png'),
      srcSize: Vector2(100, 100),
    );
    return DevanAnimation(spriteSheet: spriteSheet, to:5);
  }
}