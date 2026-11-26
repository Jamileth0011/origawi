import 'package:flutter/material.dart';
import '../models/origawi.dart';

class OrigamiRepository {
  // Usa el nombre nuevo de la imagen
  static const String _rutaLogo = 'assets/images/logo_origami.png';

  Future<List<Origami>> obtenerOrigamisLocales() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      Origami(
        id: '1',
        nombre: 'Grulla',
        categoria: 'Animales', // Cambiado para coincidir con Figma
        dificultad: 'Medio',
        tipo: 'Tradicional',
        tiempoEstimado: '12 min',
        colorFondoTarjeta: const Color(0xFFDFF5E1),
        esFavorito: false,
        pasos: [
          PasoOrigami(numeroPaso: 1, descripcion: 'Dobla el papel cuadrado por la mitad en diagonal para formar un triángulo.', recursoAnimacion: _rutaLogo),
          PasoOrigami(numeroPaso: 2, descripcion: 'Vuelve a doblar por la mitad para obtener un triángulo más pequeño.', recursoAnimacion: _rutaLogo),
          PasoOrigami(numeroPaso: 3, descripcion: 'Abre los bolsillos laterales y aplana formando un rombo (base preliminar).', recursoAnimacion: _rutaLogo),
        ],
      ),
      Origami(
        id: '2',
        nombre: 'Flor de loto',
        categoria: 'Flores',
        dificultad: 'Fácil',
        tipo: 'Tradicional',
        tiempoEstimado: '8 min',
        colorFondoTarjeta: const Color(0xFFFCE4EC),
        esFavorito: false,
        pasos: [
          PasoOrigami(numeroPaso: 1, descripcion: 'Lleva las cuatro esquinas del cuadrado hacia el punto central.', recursoAnimacion: _rutaLogo),
          PasoOrigami(numeroPaso: 2, descripcion: 'Repite el doblez llevando las nuevas esquinas nuevamente al centro.', recursoAnimacion: _rutaLogo),
        ],
      ),
      Origami(
        id: '3',
        nombre: 'Barquito',
        categoria: 'Transporte',
        dificultad: 'Fácil',
        tipo: 'Tradicional',
        tiempoEstimado: '6 min',
        colorFondoTarjeta: const Color(0xFFE3F2FD),
        esFavorito: false,
        pasos: [
          PasoOrigami(numeroPaso: 1, descripcion: 'Dobla la hoja rectangular por la mitad de arriba hacia abajo.', recursoAnimacion: _rutaLogo),
        ],
      ),
      Origami(
        id: '4',
        nombre: 'Zorro',
        categoria: 'Animales', // Cambiado para coincidir con Figma
        dificultad: 'Medio',
        tipo: 'Acción',
        tiempoEstimado: '10 min',
        colorFondoTarjeta: const Color(0xFFFFF3E0),
        esFavorito: false,
        pasos: [
          PasoOrigami(numeroPaso: 1, descripcion: 'Forma un triángulo base y levanta las puntas laterales para crear las orejas.', recursoAnimacion: _rutaLogo),
        ],
      ),
    ];
  }
}