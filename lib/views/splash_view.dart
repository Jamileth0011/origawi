import 'package:flutter/material.dart';
import '../models/colores.dart';
import 'home_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  // Ruta actualizada con el nombre nuevo
  static const String _rutaLogo = 'assets/images/logo_origami.png';

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeView()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primario,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              _rutaLogo,
              width: 160,
              height: 160,
              fit: BoxFit.contain,
              // Añadido por si la imagen falla, muestre un icono en lugar de un error
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 100, color: Colors.white), 
            ),
            const SizedBox(height: 16),
            const Text(
              'origawi',
              style: TextStyle(
                color: AppColors.blanco,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const Text(
              'dobla • crea • aprende',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}