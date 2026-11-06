import 'package:flutter/material.dart';

import 'core/di.dart';
import 'presentation/jokes_page.dart';

void main() {
  setupDependencies();
  runApp(const NetworkNinjasApp());
}

class NetworkNinjasApp extends StatelessWidget {
  const NetworkNinjasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Интересные факты',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const FactsPage(),
    );
  }
}
