import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:super_devan_world/controller/devan_animation.dart';
import 'package:super_devan_world/models/animation_data.dart';

import '../helper/animated_action.dart';

class DevanActionController extends Component with HasGameRef {
  late Map<AnimatedAction, DevanAnimation> _animations;

  Map<AnimatedAction, DevanAnimation> get animations => _animations;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _animations = {for (var animation in _devanAnimationList)
      animation.action: getAnimation(
          animation.action,
          animation.to,
          animation.speed,
          animation.directionIndex
      )
    };
  }
  DevanAnimation getAnimation(
      AnimatedAction action,
      int to,
      double speed,
      List<int> directionIndex
      ){
    final spriteSheet = SpriteSheet(
      image: gameRef.images.fromCache('devan/movement/${action
          .toString()
          .split('.')
          .last}.png'),
      srcSize: Vector2(100, 100),
    );
    return DevanAnimation(
        spriteSheet: spriteSheet,
        to:to,
        speed: speed,
        directionIndex: directionIndex
    );
  }
  
  static const List<AnimationData> _devanAnimationList = [
    AnimationData(
        action: AnimatedAction.attackSword,
        speed: 0.05,
        directionIndex: [0, 1, 2, 3],
        to: 6

    ),
    AnimationData(
        action: AnimatedAction.carryIdle,
        speed: 0.2,
        directionIndex: [0, 1, 2, 3],
        to: 5
    ),

    AnimationData(
        action: AnimatedAction.carryWalk,
        speed: 0.2,
        directionIndex: [0, 1, 2, 3],
      to: 7
    ),

    AnimationData(
        action: AnimatedAction.climb,
        speed: 0.2,
        directionIndex: [0, 0, 1, 2],
        to: 3
    ),

    AnimationData(
        action: AnimatedAction.idle,
        speed: 0.15,
        directionIndex: [0, 1, 2, 3],
      to: 5
    ),

    AnimationData(
        action: AnimatedAction.jump,
        speed: 0.05,
        directionIndex: [0, 1, 2, 3],
      to: 5
    ),

    AnimationData(
        action: AnimatedAction.run,
        speed: 0.05,
        directionIndex: [0, 1, 2, 3],
      to: 7
    ),
    AnimationData(
        action: AnimatedAction.sit,
        speed: 0.15,
        directionIndex: [0, 1, 2, 3],
      to: 7
    ),
    AnimationData(
        action: AnimatedAction.take,
        speed: 0.05,
        directionIndex: [0, 1, 2, 3],
      to: 4
    ),
    AnimationData(
        action: AnimatedAction.walk,
        speed: 0.15,
        directionIndex: [0, 1, 2, 3],
      to: 7
    ),
  ];
}