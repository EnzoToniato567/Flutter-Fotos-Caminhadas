import 'package:flutter/material.dart';
import 'ui/splash.dart';
import 'ui/styles/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CaminhadasApp());
}

class CaminhadasApp extends StatelessWidget {
  const CaminhadasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.modo,
      builder: (context, modo, _) => MaterialApp(
        title: 'Minhas Caminhadas',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.temaClaro,
        darkTheme: AppTheme.temaEscuro,
        themeMode: modo,
        home: const Splash(),
      ),
    );
  }
}
