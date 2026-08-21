import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/home_shell.dart';
import 'services/history_store.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  await HistoryStore.instance.load();
  runApp(const SmartCalculatorApp());
}

class SmartCalculatorApp extends StatelessWidget {
  const SmartCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Calculator Plus',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const HomeShell(),
    );
  }
}
