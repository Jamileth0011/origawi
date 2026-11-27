import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/animacion_paso.dart';

/// Reproduce en bucle la animación 2D de un paso:
/// pausa mostrando el pliegue punteado -> el papel se dobla -> pausa final.
class AnimacionOrigami extends StatefulWidget {
  final AnimacionPaso animacion;
  final double tamano;

  const AnimacionOrigami({
    super.key,
    required this.animacion,
    this.tamano = 180,
  });

  @override
  State<AnimacionOrigami> createState() => _AnimacionOrigamiState();
}

class _AnimacionOrigamiState extends State<AnimacionOrigami>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controlador;

  Duration _duracion() => Duration(
        milliseconds: 1800 + widget.animacion.transiciones.length * 1500,
      );

  @override
  void initState() {
    super.initState();
    _controlador = AnimationController(vsync: this, duration: _duracion())
      ..repeat();
  }

  @override
  void didUpdateWidget(covariant AnimacionOrigami oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animacion != widget.animacion) {
      _controlador.duration = _duracion();
      _controlador.value = 0;
      _controlador.repeat();
    }
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.tamano,
      height: widget.tamano,
      child: AnimatedBuilder(
        animation: _controlador,
        builder: (context, _) => CustomPaint(
          painter: _PintorOrigami(widget.animacion, _controlador.value),
        ),
      ),
    );
  }
}

class _PintorOrigami extends CustomPainter {
  final AnimacionPaso anim;
  final double valor; // 0..1 dentro del bucle

  _PintorOrigami(this.anim, this.valor);

  static const Color _borde = Color(0xAA1A2E1A);

  double _escala(Rect r) => 0.74 / math.max(math.max(r.width, r.height), 1e-6);

  void _lineaDiscontinua(Canvas canvas, Offset a, Offset b, Paint paint) {
    final total = (b - a).distance;
    if (total < 1) return;
    final dir = (b - a) / total;
    double d = 0;
    while (d < total) {
      final fin = math.min(d + 6, total);
      canvas.drawLine(a + dir * d, a + dir * fin, paint);
      d += 11;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final n = anim.transiciones.length;
    if (n == 0) return;

    // 12% pausa inicial, 76% doblando, 12% pausa final
    final u = math.min(1.0, math.max(0.0, (valor - 0.12) / 0.76));
    int idx = (u * n).floor();
    double local = u * n - idx;
    if (idx >= n) {
      idx = n - 1;
      local = 1.0;
    }
    final e = Curves.easeInOut.transform(local);
    final tr = anim.transiciones[idx];

    // Centrado y tamaño: se interpolan para que el papel siempre quepa
    final escIni = _escala(tr.cajaInicio);
    final escFin = _escala(tr.cajaFin);
    final sc = escIni + (escFin - escIni) * e;
    final cx = tr.cajaInicio.center.dx +
        (tr.cajaFin.center.dx - tr.cajaInicio.center.dx) * e;
    final cy = tr.cajaInicio.center.dy +
        (tr.cajaFin.center.dy - tr.cajaInicio.center.dy) * e;

    Offset aPantalla(Offset p) => Offset(
          ((p.dx - cx) * sc + 0.5) * size.width,
          ((p.dy - cy) * sc + 0.5) * size.height,
        );

    final relleno = Paint()..style = PaintingStyle.fill;
    final contorno = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeJoin = StrokeJoin.round
      ..color = _borde;

    for (final f in tr.formas) {
      final path = Path();
      for (var i = 0; i < f.desde.length; i++) {
        final p = aPantalla(Offset.lerp(f.desde[i], f.hasta[i], e)!);
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      path.close();
      final reverso = e >= 0.5 ? f.reversoFin : f.reversoInicio;
      relleno.color = reverso ? anim.colorReverso : anim.colorFrente;
      canvas.drawPath(path, relleno);
      canvas.drawPath(path, contorno);
    }

    // Línea punteada del doblez + flecha (se desvanecen al empezar a doblar)
    final alfa = math.max(0.0, 1 - e * 3);
    if (alfa > 0) {
      final trazo = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFF1A2E1A).withValues(alpha: alfa);
      for (final g in tr.guias) {
        _lineaDiscontinua(canvas, aPantalla(g.a), aPantalla(g.b), trazo);

        final desde = aPantalla(g.flechaDesde);
        final hasta = aPantalla(g.flechaHasta);
        final v = hasta - desde;
        if (v.distance > 14) {
          canvas.drawLine(desde, hasta, trazo);
          final ang = math.atan2(v.dy, v.dx);
          for (final s in [-0.5, 0.5]) {
            canvas.drawLine(
              hasta,
              hasta - Offset(math.cos(ang + s), math.sin(ang + s)) * 8,
              trazo,
            );
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PintorOrigami old) =>
      old.valor != valor || old.anim != anim;
}
