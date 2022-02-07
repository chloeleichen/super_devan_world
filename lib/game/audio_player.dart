import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';



class AudioPlayer extends Component {
  @override

  Future<void>? onLoad() async {
    await FlameAudio.audioCache.loadAll([
      'bgm.mp3',
      'laser.mp3',
      'eat.mp3',
      'sword.mp3',
    ]);
    FlameAudio.bgm.initialize();
    return super.onLoad();
  }

  void startBgmMusic(){
    if(kIsWeb){
      FlameAudio.audioCache.loop('bgm.mp3');
    } else {
      // FlameAudio.bgm.play('bgm.mp3');
    }
  }

  void playBulletSound(){
    FlameAudio.audioCache.play('laser.mp3');
  }
  void playEatSound(){
    FlameAudio.audioCache.play('eat.mp3');
  }
  void playSwordSound(){
    FlameAudio.audioCache.play('sword.mp3');
  }

  void stopBgmMusic(){
    if(kIsWeb){
      return;
    } else{
      FlameAudio.bgm.stop();
    }
  }
}