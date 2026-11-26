import 'package:flutter/material.dart';
import 'models/colores.dart';
import 'views/splash_view.dart';

void main() {
  runApp(const OrigawiApp());
}

class OrigawiApp extends StatelessWidget {
  const OrigawiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Origawi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primario,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primario),
        useMaterial3: true,
      ),
      home: const SplashView(),
    );
  }
}