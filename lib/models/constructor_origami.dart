import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'animacion_paso.dart';
import 'origawi.dart';

/// Describe un doblez: la recta [a]-[b] es el pliegue y [lado] es un punto
/// que está del lado del papel que SE MUEVE.
/// - [capas]: si se indica, solo se doblan las N capas de arriba.
/// - [detras]: la parte doblada pasa por detrás en vez de por delante.
class Pliegue {
  final Offset a;
  final Offset b;
  final Offset lado;
  final int? capas;
  final bool detras;

  const Pliegue(
    this.a,
    this.b, {
    required this.lado,
    this.capas,
    this.detras = false,
  });

  /// Lleva cada vértice al [centro] (cuatro dobleces simultáneos).
  static List<Pliegue> esquinasAlCentro(List<Offset> vertices, Offset centro) {
    return vertices.map((v) {
      final m = Offset((v.dx + centro.dx) / 2, (v.dy + centro.dy) / 2);
      final dx = centro.dx - v.dx;
      final dy = centro.dy - v.dy;
      return Pliegue(
        Offset(m.dx - dy, m.dy + dx),
        Offset(m.dx + dy, m.dy - dx),
        lado: v,
      );
    }).toList();
  }
}

class _Forma {
  List<Offset> pts;
  List<Offset> ini;
  bool rev;
  bool rev0;

  _Forma(this.pts, this.ini, this.rev, this.rev0);
}

double _cruz(Offset a, Offset b, Offset p) {
  return (b.dx - a.dx) * (p.dy - a.dy) - (b.dy - a.dy) * (p.dx - a.dx);
}

double _area(List<Offset> pts) {
  double suma = 0;
  for (var i = 0; i < pts.length; i++) {
    final p = pts[i];
    final q = pts[(i + 1) % pts.length];
    suma += p.dx * q.dy - q.dx * p.dy;
  }
  return suma.abs() / 2;
}

Offset _reflejar(Offset p, Offset a, Offset b) {
  final dx = b.dx - a.dx;
  final dy = b.dy - a.dy;
  final l = dx * dx + dy * dy;
  final t = ((p.dx - a.dx) * dx + (p.dy - a.dy) * dy) / l;
  final fx = a.dx + t * dx;
  final fy = a.dy + t * dy;
  return Offset(2 * fx - p.dx, 2 * fy - p.dy);
}

/// Se queda con la parte del polígono donde signo*cruz >= 0.
_Forma? _recortar(_Forma f, Offset a, Offset b, double signo) {
  final pts = <Offset>[];
  final ini = <Offset>[];
  final n = f.pts.length;
  for (var k = 0; k < n; k++) {
    final p = f.pts[k];
    final q = f.pts[(k + 1) % n];
    final pi = f.ini[k];
    final qi = f.ini[(k + 1) % n];
    final dp = signo * _cruz(a, b, p);
    final dq = signo * _cruz(a, b, q);
    if (dp >= -1e-9) {
      pts.add(p);
      ini.add(pi);
    }
    if ((dp > 1e-9 && dq < -1e-9) || (dp < -1e-9 && dq > 1e-9)) {
      final l = dp / (dp - dq);
      pts.add(Offset.lerp(p, q, l)!);
      ini.add(Offset.lerp(pi, qi, l)!);
    }
  }
  if (pts.length < 3 || _area(pts) < 1e-5) return null;
  return _Forma(pts, ini, f.rev, f.rev0);
}

Offset _promedio(List<Offset> puntos) {
  double x = 0;
  double y = 0;
  for (final p in puntos) {
    x += p.dx;
    y += p.dy;
  }
  return Offset(x / puntos.length, y / puntos.length);
}

List<_Forma> _plegar(List<_Forma> estado, Pliegue f, List<GuiaPliegue> guias) {
  final signo = _cruz(f.a, f.b, f.lado) > 0 ? 1.0 : -1.0;

  final candidatos = <int>[];
  for (var i = 0; i < estado.length; i++) {
    if (_recortar(estado[i], f.a, f.b, signo) != null) candidatos.add(i);
  }
  final elegidos = <int>{};
  if (f.capas == null) {
    elegidos.addAll(candidatos);
  } else {
    final inicio = math.max(0, candidatos.length - f.capas!);
    elegidos.addAll(candidatos.sublist(inicio));
  }

  final quedan = <_Forma>[];
  final mueven = <_Forma>[];
  final enLinea = <Offset>[];
  final antes = <Offset>[];
  final despues = <Offset>[];

  for (var i = 0; i < estado.length; i++) {
    if (elegidos.contains(i)) {
      final st = _recortar(estado[i], f.a, f.b, -signo);
      final mv = _recortar(estado[i], f.a, f.b, signo);
      if (st != null) quedan.add(st);
      if (mv != null) {
        for (final p in mv.pts) {
          if (_cruz(f.a, f.b, p).abs() < 1e-6) enLinea.add(p);
        }
        final nuevos = mv.pts.map((p) => _reflejar(p, f.a, f.b)).toList();
        antes.addAll(mv.pts);
        despues.addAll(nuevos);
        mueven.add(_Forma(nuevos, mv.ini, !mv.rev, mv.rev0));
      }
    } else {
      quedan.add(estado[i]);
    }
  }

  if (enLinea.length >= 2 && antes.isNotEmpty) {
    final dir = f.b - f.a;
    Offset menor = enLinea.first;
    Offset mayor = enLinea.first;
    double dMenor = double.infinity;
    double dMayor = -double.infinity;
    for (final p in enLinea) {
      final d = p.dx * dir.dx + p.dy * dir.dy;
      if (d < dMenor) {
        dMenor = d;
        menor = p;
      }
      if (d > dMayor) {
        dMayor = d;
        mayor = p;
      }
    }
    guias.add(GuiaPliegue(
      a: menor,
      b: mayor,
      flechaDesde: _promedio(antes),
      flechaHasta: _promedio(despues),
    ));
  }

  final alReves = mueven.reversed.toList();
  return f.detras ? [...alReves, ...quedan] : [...quedan, ...alReves];
}

Rect _caja(List<Offset> puntos) {
  double minX = puntos.first.dx;
  double maxX = puntos.first.dx;
  double minY = puntos.first.dy;
  double maxY = puntos.first.dy;
  for (final p in puntos) {
    minX = math.min(minX, p.dx);
    maxX = math.max(maxX, p.dx);
    minY = math.min(minY, p.dy);
    maxY = math.max(maxY, p.dy);
  }
  return Rect.fromLTRB(minX, minY, maxX, maxY);
}

/// Va doblando una hoja paso a paso y genera la animación de cada paso.
/// El estado del papel de un paso es el punto de partida del siguiente.
class ConstructorOrigami {
  final Color colorFrente;
  final Color colorReverso;
  List<_Forma> _estado;

  ConstructorOrigami({
    required List<Offset> hoja,
    required this.colorFrente,
    required this.colorReverso,
  }) : _estado = [
          _Forma(List<Offset>.from(hoja), List<Offset>.from(hoja), false, false),
        ];

  /// [pliegues]: lista de movimientos; cada movimiento es una lista de
  /// dobleces que ocurren a la vez (deben tocar zonas distintas del papel).
  PasoOrigami paso({
    required int numero,
    required String descripcion,
    required List<List<Pliegue>> pliegues,
    String? piezas,
  }) {
    final transiciones = <TransicionAnim>[];

    for (final simultaneos in pliegues) {
      for (final f in _estado) {
        f.ini = List<Offset>.from(f.pts);
        f.rev0 = f.rev;
      }
      final guias = <GuiaPliegue>[];
      for (final p in simultaneos) {
        _estado = _plegar(_estado, p, guias);
      }

      final formas = _estado
          .map((f) => FormaAnim(
                desde: List<Offset>.from(f.ini),
                hasta: List<Offset>.from(f.pts),
                reversoInicio: f.rev0,
                reversoFin: f.rev,
              ))
          .toList();
      final todosIni = <Offset>[for (final f in _estado) ...f.ini];
      final todosFin = <Offset>[for (final f in _estado) ...f.pts];

      transiciones.add(TransicionAnim(
        formas: formas,
        guias: guias,
        cajaInicio: _caja(todosIni),
        cajaFin: _caja(todosFin),
      ));
    }

    return PasoOrigami(
      numeroPaso: numero,
      descripcion: descripcion,
      recursoAnimacion: 'assets/image/logo_gato_blanco.png',
      piezasRequeridas: piezas,
      animacion: AnimacionPaso(
        transiciones: transiciones,
        colorFrente: colorFrente,
        colorReverso: colorReverso,
      ),
    );
  }
}
