import 'package:flutter/material.dart';
import '../models/origawi.dart';

class OrigamiRepository {
  // Mientras no existan las animaciones reales de cada paso,
  // todos los pasos usan esta imagen (gato transparente).
  // ¡OJO! Quité la comilla doble extra que tenías al final.
  static const String _imgPaso = 'assets/image/logo_gato_blanco.png';

  Future<List<Origami>> obtenerOrigamisLocales() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      // ---------------- ANIMALES ----------------
      Origami(
        id: '1',
        nombre: 'Grulla',
        categoria: 'Animales',
        dificultad: 'Medio',
        tipo: 'Tradicional',
        tiempoEstimado: '12 min',
        colorFondoTarjeta: const Color(0xFFDFF5E1),
        // esFavorito: true, <-- ELIMINADO
        pasos: [
          PasoOrigami(
            numeroPaso: 1,
            descripcion: 'Dobla el papel cuadrado por la mitad en diagonal para formar un triángulo.',
            recursoAnimacion: _imgPaso,
          ),
          PasoOrigami(
            numeroPaso: 2,
            descripcion: 'Vuelve a doblar por la mitad para obtener un triángulo más pequeño.',
            recursoAnimacion: _imgPaso,
          ),
          PasoOrigami(
            numeroPaso: 3,
            descripcion: 'Abre los bolsillos laterales y aplana formando un rombo (base preliminar).',
            recursoAnimacion: _imgPaso,
          ),
          PasoOrigami(
            numeroPaso: 4,
            descripcion: 'Abre con cuidado para terminar: forma el cuello, la cola y las alas.',
            recursoAnimacion: _imgPaso,
          ),
        ],
      ),
      Origami(
        id: '4',
        nombre: 'Zorro',
        categoria: 'Animales',
        dificultad: 'Medio',
        tipo: 'Acción',
        tiempoEstimado: '10 min',
        colorFondoTarjeta: const Color(0xFFFFF3E0),
        pasos: [
          PasoOrigami(
            numeroPaso: 1,
            descripcion: 'Dobla el cuadrado en diagonal para formar un triángulo base.',
            recursoAnimacion: _imgPaso,
          ),
          PasoOrigami(
            numeroPaso: 2,
            descripcion: 'Levanta las puntas laterales hacia arriba para crear las orejas.',
            recursoAnimacion: _imgPaso,
          ),
          PasoOrigami(
            numeroPaso: 3,
            descripcion: 'Dobla la punta inferior hacia atrás para formar el hocico.',
            recursoAnimacion: _imgPaso,
          ),
        ],
      ),
      Origami(
        id: '5',
        nombre: 'Mariposa',
        categoria: 'Animales',
        dificultad: 'Difícil',
        tipo: 'Tradicional',
        tiempoEstimado: '15 min',
        colorFondoTarjeta: const Color(0xFFEDE7F6),
        pasos: [
          PasoOrigami(
            numeroPaso: 1,
            descripcion: 'Haz la base de pañuelo: lleva las cuatro esquinas al centro.',
            recursoAnimacion: _imgPaso,
          ),
          PasoOrigami(
            numeroPaso: 2,
            descripcion: 'Dobla la figura por la mitad para formar el cuerpo.',
            recursoAnimacion: _imgPaso,
          ),
          PasoOrigami(
            numeroPaso: 3,
            descripcion: 'Baja cada ala en diagonal hacia afuera.',
            recursoAnimacion: _imgPaso,
          ),
          PasoOrigami(
            numeroPaso: 4,
            descripcion: 'Abre las alas y marca un pequeño pliegue en las antenas.',
            recursoAnimacion: _imgPaso,
          ),
        ],
      ),

      // ---------------- FLORES ----------------
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
            recursoAnimacion: _imgPaso,
          ),
          PasoOrigami(
            numeroPaso: 2,
            descripcion: 'Repite el doblez llevando las nuevas esquinas nuevamente al centro.',
            recursoAnimacion: _imgPaso,
          ),
          PasoOrigami(
            numeroPaso: 3,
            descripcion: 'Voltea el papel y levanta cada pétalo desde atrás hacia el frente.',
            recursoAnimacion: _imgPaso,
          ),
        ],
      ),
      Origami(
        id: '7',
        nombre: 'Kusudama',
        categoria: 'Flores',
        dificultad: 'Difícil',
        tipo: 'Modular',
        tiempoEstimado: '40 min',
        colorFondoTarjeta: const Color(0xFFFFF8E1),
        pasos: [
          PasoOrigami(
            numeroPaso: 1,
            descripcion: 'Haz un pétalo: dobla un cuadrado a la mitad y luego lleva las esquinas al centro.',
            recursoAnimacion: _imgPaso,
            piezasRequeridas: 'Necesitas 5 piezas iguales. Corta 5 cuadrados de 10 cm.',
          ),
          PasoOrigami(
            numeroPaso: 2,
            descripcion: 'Repite el mismo pétalo con los cuadrados restantes.',
            recursoAnimacion: _imgPaso,
            piezasRequeridas: 'Piezas terminadas: 5 de 5.',
          ),
          PasoOrigami(
            numeroPaso: 3,
            descripcion: 'Une los pétalos por los costados y asegúralos con pegamento.',
            recursoAnimacion: _imgPaso,
            piezasRequeridas: 'Necesitas pegamento en barra.',
          ),
        ],
      ),

      // ---------------- TRANSPORTE ----------------
      Origami(
        id: '3',
        nombre: 'Barquito',
        categoria: 'Transporte',
        dificultad: 'Fácil',
        tipo: 'Tradicional',
        tiempoEstimado: '6 min',
        colorFondoTarjeta: const Color(0xFFE3F2FD),
        // esFavorito: true, <-- ELIMINADO
        pasos: [
          PasoOrigami(
            numeroPaso: 1,
            descripcion: 'Dobla la hoja rectangular por la mitad de arriba hacia abajo.',
            recursoAnimacion: _imgPaso,
          ),
          PasoOrigami(
            numeroPaso: 2,
            descripcion: 'Dobla las esquinas superiores hacia el centro para formar un techo.',
            recursoAnimacion: _imgPaso,
          ),
          PasoOrigami(
            numeroPaso: 3,
            descripcion: 'Sube los bordes inferiores a cada lado y abre el centro para formar el barco.',
            recursoAnimacion: _imgPaso,
          ),
        ],
      ),
      Origami(
        id: '6',
        nombre: 'Avión',
        categoria: 'Transporte',
        dificultad: 'Fácil',
        tipo: 'Acción',
        tiempoEstimado: '5 min',
        colorFondoTarjeta: const Color(0xFFE0F2F1),
        pasos: [
          PasoOrigami(
            numeroPaso: 1,
            descripcion: 'Dobla la hoja por la mitad a lo largo y vuelve a abrirla.',
            recursoAnimacion: _imgPaso,
          ),
          PasoOrigami(
            numeroPaso: 2,
            descripcion: 'Lleva las dos esquinas superiores hacia la línea central.',
            recursoAnimacion: _imgPaso,
          ),
          PasoOrigami(
            numeroPaso: 3,
            descripcion: 'Dobla de nuevo los bordes hacia el centro y luego dobla el avión por la mitad.',
            recursoAnimacion: _imgPaso,
          ),
          PasoOrigami(
            numeroPaso: 4,
            descripcion: 'Baja las alas a cada lado y ¡listo para volar!',
            recursoAnimacion: _imgPaso,
          ),
        ],
      ),
    ];
  }
}