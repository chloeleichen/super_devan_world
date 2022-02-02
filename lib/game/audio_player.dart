import 'package:flame/components.dart';
import 'package:flame_audio/audio_pool.dart';
import 'package:flame_audio/flame_audio.dart';



class AudioPlayer extends Component {
  @override
  Future<void>? onLoad() async {
    FlameAudio.bgm.initialize();

    await FlameAudio.audioCache.loadAll([
      'bgm.mp3',
      'laser.mp3'
    ]);

    return super.onLoad();
  }

  void startBgmMusic(){
    FlameAudio.bgm.play('bgm.mp3');
  }

  void playBulletSound(){
    FlameAudio.audioCache.play('laser.mp3');
  }

  void stopBgmMusic(){
    FlameAudio.bgm.stop();
  }
}