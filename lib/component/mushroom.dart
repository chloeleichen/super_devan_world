import 'package:flame/components.dart';
import 'package:super_devan_world/component/reward.dart';
import 'package:super_devan_world/helper/mushroom_type.dart';

List<int> badMushroomIndices = [12, 13, 14, 15,16, 30, 23];
List<int> psychedelicMushroomIndices = [ 17, 19, 20, 21, 22,  33, 35];


class Mushroom extends Reward {
  late MushroomType _type;
  MushroomType get type => _type;
  Mushroom({
    required Sprite sprite,
    required Vector2 size,
    required int mushroomId,
    required Vector2 position,
}): super(sprite: sprite, size: size, position: position){
    _type = _getMushroomTypeFromId(mushroomId);
  }
  MushroomType _getMushroomTypeFromId(int mushroomId){
    if (badMushroomIndices.contains(mushroomId)){
      return MushroomType.bad;
    } else if (psychedelicMushroomIndices.contains(mushroomId)){
      return MushroomType.psychedelic;
    } else{
      return MushroomType.good;
    }
  }
}