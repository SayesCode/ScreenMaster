import 'package:flutter_screen_recording/flutter_screen_recording.dart';

class ScreenRecorder {
  static Future<void> start({required String resolution, required String fps, required bool recordAudio}) async {
    // Configurar parâmetros de gravação baseados nas escolhas do usuário
    int width, height;
    int frameRate = int.parse(fps.split(" ")[0]);

    switch (resolution) {
      case '4K':
        width = 3840;
        height = 2160;
        break;
      case '2K':
        width = 2560;
        height = 1440;
        break;
      default: // 1080p
        width = 1920;
        height = 1080;
        break;
    }

    // Iniciar a gravação de tela com um nome
    await FlutterScreenRecording.startRecordScreen('my_recording',
      titleNotification: 'Recording',
      messageNotification: 'Screen recording in progress...',
    );
  }

  static Future<void> stop() async {
    // Corrigir a chamada para o método stopRecordScreen
    await FlutterScreenRecording.stopRecordScreen;
  }
}
