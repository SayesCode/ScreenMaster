import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screen_recorder.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(ScreenMaster());

class ScreenMaster extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ScreenMaster',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light, // Tema claro padrão
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark, // Tema escuro
      ),
      themeMode: ThemeMode.system, // Muda automaticamente baseado no sistema
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _resolutions = ['1080p', '2K', '4K'];
  final _fpsOptions = ['30 FPS', '60 FPS', '120 FPS'];
  String _selectedResolution = '1080p';
  String _selectedFps = '30 FPS';
  bool _recordAudio = false;
  bool _isRecording = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ScreenMaster'),
        actions: [
          IconButton(
            icon: Icon(Icons.code),
            onPressed: () {
              launch('https://github.com/SayesCode/ScreenMaster');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text('Gravar com Microfone'),
              value: _recordAudio,
              onChanged: _isRecording ? null : (value) {
                setState(() {
                  _recordAudio = value;
                });
              },
            ),
            SizedBox(height: 10),
            Text('Escolha a Resolução:'),
            DropdownButton<String>(
              value: _selectedResolution,
              items: _resolutions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedResolution = newValue!;
                });
              },
            ),
            SizedBox(height: 20),
            Text('Escolha a Taxa de FPS:'),
            DropdownButton<String>(
              value: _selectedFps,
              items: _fpsOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedFps = newValue!;
                });
              },
            ),
            SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  if (!_isRecording) // Oculta o botão de iniciar se já estiver gravando
                    ElevatedButton(
                      onPressed: _startRecording,
                      child: Text('Iniciar Gravação'),
                    ),
                  if (_isRecording) // Oculta o botão de parar se não estiver gravando
                    ElevatedButton(
                      onPressed: _stopRecording,
                      child: Text('Parar Gravação'),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _startRecording() async {
    if (await Permission.microphone.request().isGranted) {
      setState(() {
        _isRecording = true;
      });
      try {
        await ScreenRecorder.start(
          resolution: _selectedResolution,
          fps: _selectedFps,
          recordAudio: _recordAudio,
        );
      } catch (e) {
        setState(() {
          _isRecording = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao iniciar gravação: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permissão de microfone necessária')),
      );
    }
  }

  Future<void> _stopRecording() async {
    try {
      await ScreenRecorder.stop();
      setState(() {
        _isRecording = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gravação finalizada e salva!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao parar gravação: $e')),
      );
    }
  }
}
