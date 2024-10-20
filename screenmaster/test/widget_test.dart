import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screenmaster/main.dart'; // Altere o caminho conforme sua estrutura de pastas

void main() {
  testWidgets('Verifica o layout e as interações principais', (WidgetTester tester) async {
    // Constrói o widget inicial do app
    await tester.pumpWidget(ScreenMaster());

    // Verifica se o título "ScreenMaster" está sendo exibido
    expect(find.text('ScreenMaster'), findsOneWidget);

    // Verifica se os elementos de configuração estão presentes
    expect(find.text('Gravar com Microfone'), findsOneWidget);
    expect(find.text('Escolha a Resolução:'), findsOneWidget);
    expect(find.text('Escolha a Taxa de FPS:'), findsOneWidget);
    expect(find.text('Iniciar Gravação'), findsOneWidget);
    expect(find.text('Parar Gravação'), findsOneWidget);

    // Testa a interação com o switch de áudio
    await tester.tap(find.byType(SwitchListTile));
    await tester.pump(); // Atualiza o frame após a interação
    expect(find.byWidgetPredicate((widget) =>
        widget is SwitchListTile && widget.value == true), findsOneWidget);

    // Testa a interação com o DropdownButton de resolução
    await tester.tap(find.text('1080p')); // Abre o dropdown de resolução
    await tester.pumpAndSettle(); // Aguarda a lista abrir
    await tester.tap(find.text('2K').last); // Seleciona 2K
    await tester.pump(); // Atualiza após seleção
    expect(find.text('2K'), findsOneWidget); // Verifica se foi atualizado

    // Testa a interação com o DropdownButton de FPS
    await tester.tap(find.text('30 FPS')); // Abre o dropdown de FPS
    await tester.pumpAndSettle(); // Aguarda a lista abrir
    await tester.tap(find.text('60 FPS').last); // Seleciona 60 FPS
    await tester.pump(); // Atualiza após seleção
    expect(find.text('60 FPS'), findsOneWidget); // Verifica se foi atualizado

    // Simula o início da gravação
    await tester.tap(find.text('Iniciar Gravação'));
    await tester.pump(); // Atualiza o frame após a interação

    // Verifica que o botão de iniciar está desabilitado
    final ElevatedButton startButton = tester.widget(find.byType(ElevatedButton).at(0));
    expect(startButton.onPressed, isNull);

    // Verifica que o botão de parar está habilitado
    final ElevatedButton stopButton = tester.widget(find.byType(ElevatedButton).at(1));
    expect(stopButton.onPressed, isNotNull);

    // Simula o término da gravação
    await tester.tap(find.text('Parar Gravação'));
    await tester.pump(); // Atualiza o frame após a interação
    expect(find.text('Gravação finalizada e salva!'), findsOneWidget); // Verifica a exibição da mensagem de sucesso
  });
}
