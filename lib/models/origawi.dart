import 'package:flutter/material.dart';
import 'animacion_paso.dart';

class PasoOrigami {
  final int numeroPaso;
  final String descripcion;
  final String recursoAnimacion; // Ruta de imagen o animación
  final String? piezasRequeridas; // Opcional para origamis modulares
  final AnimacionPaso? animacion; // Animación 2D del doblez (opcional)

  PasoOrigami({
    required this.numeroPaso,
    required this.descripcion,
    required this.recursoAnimacion,
    this.piezasRequeridas,
    this.animacion,
  });
}

class Origami {
  final String id;
  final String nombre;
  final String categoria; // Animal, Flores, Transporte
  final String dificultad; // Fácil, Medio, Difícil
  final String tipo; // Tradicional, Acción, Modular
  final String tiempoEstimado;
  final Color colorFondoTarjeta;
  bool esFavorito;
  final List<PasoOrigami> pasos;

  Origami({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.dificultad,
    required this.tipo,
    required this.tiempoEstimado,
    required this.colorFondoTarjeta,
    this.esFavorito = false,
    required this.pasos,
  });
}