import 'package:flutter/material.dart';
import '../models/colores.dart';
import '../models/origawi.dart';

class TutorialView extends StatefulWidget {
  final Origami origami;

  const TutorialView({super.key, required this.origami});

  @override
  State<TutorialView> createState() => _TutorialViewState();
}

class _TutorialViewState extends State<TutorialView> {
  int _indicePasoActual = 0;

  void _siguientePaso() {
    if (_indicePasoActual < widget.origami.pasos.length - 1) {
      setState(() {
        _indicePasoActual++;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Origami terminado! Excelente trabajo.'),
          backgroundColor: AppColors.primario,
        ),
      );
    }
  }

  void _pasoAnterior() {
    if (_indicePasoActual > 0) {
      setState(() {
        _indicePasoActual--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pasoActual = widget.origami.pasos[_indicePasoActual];
    final progreso = (_indicePasoActual + 1) / widget.origami.pasos.length;

    return Scaffold(
      backgroundColor: AppColors.fondoApp,
      appBar: AppBar(
        backgroundColor: AppColors.primario,
        foregroundColor: AppColors.blanco,
        title: Text(widget.origami.nombre),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Paso ${pasoActual.numeroPaso} de ${widget.origami.pasos.length}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.grisOscuro),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: GestureDetector(
                onTapUp: (details) {
                  final anchoPantalla = MediaQuery.of(context).size.width;
                  if (details.globalPosition.dx > anchoPantalla / 2) {
                    _siguientePaso();
                  } else {
                    _pasoAnterior();
                  }
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.blanco,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(pasoActual.recursoAnimacion, width: 180, height: 180),
                      const SizedBox(height: 16),
                      const Text(
                        'Toca derecha para avanzar • izquierda para retroceder',
                        style: TextStyle(fontSize: 11, color: AppColors.grisClaro),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.blanco,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                pasoActual.descripcion,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: _indicePasoActual > 0 ? _pasoAnterior : null,
                  iconSize: 48,
                  icon: Icon(
                    Icons.arrow_circle_left,
                    color: _indicePasoActual > 0 ? AppColors.primario : AppColors.grisClaro,
                  ),
                ),
                IconButton(
                  onPressed: _siguientePaso,
                  iconSize: 48,
                  icon: const Icon(
                    Icons.arrow_circle_right,
                    color: AppColors.primario,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progreso,
                minHeight: 12,
                backgroundColor: AppColors.grisClaro,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primarioClaro),
              ),
            ),
          ],
        ),
      ),
    );
  }
}