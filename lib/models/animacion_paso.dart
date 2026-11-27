import 'package:flutter/material.dart';

/// Una pieza de papel durante un doblez: va de [desde] a [hasta]
/// (ambas listas tienen el mismo número de puntos, en coordenadas libres).
class FormaAnim {
  final List<Offset> desde;
  final List<Offset> hasta;
  final bool reversoInicio; // ¿se ve la cara de atrás al empezar?
  final bool reversoFin; // ¿se ve la cara de atrás al terminar?

  const FormaAnim({
    required this.desde,
    required this.hasta,
    required this.reversoInicio,
    required this.reversoFin,
  });
}

/// Línea punteada del doblez + flecha que indica hacia dónde se dobla.
class GuiaPliegue {
  final Offset a;
  final Offset b;
  final Offset flechaDesde;
  final Offset flechaHasta;

  const GuiaPliegue({
    required this.a,
    required this.b,
    required this.flechaDesde,
    required this.flechaHasta,
  });
}

/// Un movimiento completo (uno o varios dobleces a la vez).
class TransicionAnim {
  final List<FormaAnim> formas;
  final List<GuiaPliegue> guias;
  final Rect cajaInicio; // para centrar y ajustar el tamaño del papel
  final Rect cajaFin;

  const TransicionAnim({
    required this.formas,
    required this.guias,
    required this.cajaInicio,
    required this.cajaFin,
  });
}

/// Animación 2D de un paso del tutorial.
class AnimacionPaso {
  final List<TransicionAnim> transiciones;
  final Color colorFrente;
  final Color colorReverso;

  const AnimacionPaso({
    required this.transiciones,
    required this.colorFrente,
    required this.colorReverso,
  });
}
