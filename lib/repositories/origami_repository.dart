import 'package:flutter/material.dart';
import '../models/origawi.dart';

class OrigamiRepository {
  Future<List<Origami>> obtenerOrigamisLocales() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      Origami(
        id: '1',
        nombre: 'Grulla',
        categoria: 'Animal',
        dificultad: 'Medio',
        tipo: 'Tradicional',
        tiempoEstimado: '12 min',
        colorFondoTarjeta: const Color(0xFFDFF5E1),
        esFavorito: true,
        pasos: [
          PasoOrigami(
            numeroPaso: 1,
            descripcion: 'Dobla el papel cuadrado por la mitad en diagonal para formar un triángulo.',
            recursoAnimacion: 'assets/images/logo_gato.png',
          ),
          PasoOrigami(
            numeroPaso: 2,
            descripcion: 'Vuelve a doblar por la mitad para obtener un triángulo más pequeño.',
            recursoAnimacion: 'assets/images/logo_gato.png',
          ),
          PasoOrigami(
            numeroPaso: 3,
            descripcion: 'Abre los bolsillos laterales y aplana formando un rombo (base preliminar).',
            recursoAnimacion: 'assets/images/logo_gato.png',
          ),
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
        pasos: [
          PasoOrigami(
            numeroPaso: 1,
            descripcion: 'Lleva las cuatro esquinas del cuadrado hacia el punto central.',
            recursoAnimacion: 'assets/images/logo_gato.png',
          ),
          PasoOrigami(
            numeroPaso: 2,
            descripcion: 'Repite el doblez llevando las nuevas esquinas nuevamente al centro.',
            recursoAnimacion: 'assets/images/logo_gato.png',
          ),
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
        esFavorito: true,
        pasos: [
          PasoOrigami(
            numeroPaso: 1,
            descripcion: 'Dobla la hoja rectangular por la mitad de arriba hacia abajo.',
            recursoAnimacion: 'assets/images/logo_gato.png',
          ),
        ],
      ),
      Origami(
        id: '4',
        nombre: 'Zorro',
        categoria: 'Animal',
        dificultad: 'Medio',
        tipo: 'Acción',
        tiempoEstimado: '10 min',
        colorFondoTarjeta: const Color(0xFFFFF3E0),
        pasos: [
          PasoOrigami(
            numeroPaso: 1,
            descripcion: 'Forma un triángulo base y levanta las puntas laterales para crear las orejas.',
            recursoAnimacion: 'assets/images/logo_gato.png',
          ),
        ],
      ),
    ];
  }
}