import 'package:flutter/material.dart';
import '../models/colores.dart';
import '../models/origawi.dart';
import '../viewmodels/origami_viewmodel.dart';
import 'animacion_origami.dart';

class TutorialView extends StatefulWidget {
  final Origami origami;
  final OrigamiViewModel? viewModel;

  const TutorialView({
    super.key,
    required this.origami,
    this.viewModel,
  });

  @override
  State<TutorialView> createState() => _TutorialViewState();
}

class _TutorialViewState extends State<TutorialView> {
  int _indicePasoActual = 0;

  // Al terminar: regresa a la pantalla principal (primera ruta de la pila)
  void _terminarOrigami() {
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).popUntil((route) => route.isFirst);
    messenger.showSnackBar(
      SnackBar(
        content: Text('¡${widget.origami.nombre} terminado! Excelente trabajo.'),
        backgroundColor: AppColors.primario,
      ),
    );
  }

  void _siguientePaso() {
    if (_indicePasoActual < widget.origami.pasos.length - 1) {
      setState(() => _indicePasoActual++);
    } else {
      _terminarOrigami();
    }
  }

  // Animación 2D del paso (o la imagen de respaldo si no hay animación)
  Widget _visualPaso(PasoOrigami paso, double tam) {
    if (paso.animacion != null) {
      return AnimacionOrigami(animacion: paso.animacion!, tamano: tam);
    }
    return Image.asset(
      paso.recursoAnimacion,
      width: tam,
      height: tam,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.image_not_supported, color: Colors.grey, size: 50),
    );
  }

  // Nota para origamis modulares (cuántas piezas, cortar, pegar...)
  Widget _notaPiezas(PasoOrigami paso) {
    if (paso.piezasRequeridas == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        paso.piezasRequeridas!,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.primario,
        ),
      ),
    );
  }

  void _pasoAnterior() {
    if (_indicePasoActual > 0) {
      setState(() => _indicePasoActual--);
    }
  }

  void _alternarFavorito() {
    if (widget.viewModel != null) {
      widget.viewModel!.cambiarFavorito(widget.origami);
    } else {
      widget.origami.esFavorito = !widget.origami.esFavorito;
    }
    setState(() {});
  }

  void _abrirPantallaCompleta() {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setFullState) {
              final pasoActual = widget.origami.pasos[_indicePasoActual];
              final totalPasos = widget.origami.pasos.length;

              void avanzarFull() {
                if (_indicePasoActual < totalPasos - 1) {
                  setState(() => _indicePasoActual++);
                  setFullState(() {});
                } else {
                  _terminarOrigami();
                }
              }

              void retrocederFull() {
                if (_indicePasoActual > 0) {
                  setState(() => _indicePasoActual--);
                  setFullState(() {});
                }
              }

              return Scaffold(
                backgroundColor: widget.origami.colorFondoTarjeta,
                body: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.blanco,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Paso ${_indicePasoActual + 1} de $totalPasos',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: AppColors.primario,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: AppColors.blanco,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.06),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.close, color: Color(0xFF1A2E1A)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 270,
                              height: 270,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.blanco.withValues(alpha: 0.6),
                                  width: 1.5,
                                ),
                              ),
                            ),
                            _visualPaso(pasoActual, 230),
                            Positioned(
                              left: 16,
                              child: GestureDetector(
                                onTap: _indicePasoActual > 0 ? retrocederFull : null,
                                child: Opacity(
                                  opacity: _indicePasoActual > 0 ? 1.0 : 0.35,
                                  child: const Row(
                                    children: [
                                      Icon(Icons.chevron_left, color: AppColors.primario, size: 22),
                                      Text(
                                        'Anterior',
                                        style: TextStyle(
                                          color: AppColors.primario,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 16,
                              child: GestureDetector(
                                onTap: avanzarFull,
                                child: Row(
                                  children: [
                                    Text(
                                      _indicePasoActual < totalPasos - 1 ? 'Siguiente' : 'Terminar',
                                      style: const TextStyle(
                                        color: AppColors.primario,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Icon(
                                      _indicePasoActual < totalPasos - 1 ? Icons.chevron_right : Icons.check,
                                      color: AppColors.primario,
                                      size: 22,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.blanco,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              pasoActual.descripcion,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A2E1A),
                              ),
                            ),
                            _notaPiezas(pasoActual),
                          ],
                        ),
                      ),
                      Container(
                        height: 6,
                        width: double.infinity,
                        color: AppColors.primarioClaro,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalPasos = widget.origami.pasos.length;
    final pasoActual = widget.origami.pasos[_indicePasoActual];
    final progreso = (_indicePasoActual + 1) / totalPasos;
    final porcentaje = (progreso * 100).round();
    final esUltimoPaso = _indicePasoActual == totalPasos - 1;

    return Scaffold(
      backgroundColor: AppColors.fondoApp,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.blanco,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 16,
                        color: Color(0xFF1A2E1A),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _alternarFavorito,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: widget.origami.esFavorito
                            ? const Color(0xFFFCE8E8)
                            : AppColors.blanco,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.bookmark,
                        color: widget.origami.esFavorito
                            ? AppColors.favoritoActivo
                            : const Color(0xFFFF8A8A),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${widget.origami.categoria.toUpperCase()} · ${widget.origami.dificultad.toUpperCase()}',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: AppColors.primario,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    widget.origami.nombre,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A2E1A),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Paso ${_indicePasoActual + 1} de $totalPasos',
                      style: const TextStyle(fontSize: 12, color: AppColors.grisOscuro),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GestureDetector(
                onTap: _abrirPantallaCompleta,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 18),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: widget.origami.colorFondoTarjeta,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.blanco,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.auto_awesome, size: 14, color: AppColors.primario),
                                SizedBox(width: 4),
                                Text(
                                  'Modo guiado',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primario,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.blanco,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.fullscreen, size: 15, color: Color(0xFF1A2E1A)),
                                SizedBox(width: 4),
                                Text(
                                  'Toca para ampliar',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1A2E1A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.blanco.withValues(alpha: 0.6),
                              width: 1.5,
                            ),
                          ),
                          child: _visualPaso(pasoActual, 145),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.blanco,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              pasoActual.descripcion,
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A2E1A),
                              ),
                            ),
                            _notaPiezas(pasoActual),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 44,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                scrollDirection: Axis.horizontal,
                itemCount: totalPasos,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, idx) {
                  final bool activo = idx == _indicePasoActual;
                  final bool completado = idx < _indicePasoActual;

                  return GestureDetector(
                    onTap: () => setState(() => _indicePasoActual = idx),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: activo ? AppColors.primario : AppColors.blanco,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: activo ? AppColors.primario : Colors.grey.shade200,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: activo
                                  ? AppColors.primarioClaro
                                  : (completado
                                      ? const Color(0xFFEAF8EC)
                                      : AppColors.fondoApp),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: completado
                                ? const Icon(Icons.check, size: 14, color: AppColors.primario)
                                : Text(
                                    '${idx + 1}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: activo ? AppColors.blanco : AppColors.grisOscuro,
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Fig ${idx + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: activo ? FontWeight.bold : FontWeight.w500,
                              color: activo
                                  ? AppColors.blanco
                                  : (completado ? AppColors.primario : AppColors.grisOscuro),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _indicePasoActual > 0 ? _pasoAnterior : null,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.blanco,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Icon(
                        Icons.chevron_left,
                        color: _indicePasoActual > 0 ? AppColors.primario : AppColors.grisClaro,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        '$porcentaje%',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A2E1A),
                        ),
                      ),
                      const Text(
                        'Completado',
                        style: TextStyle(fontSize: 11, color: AppColors.grisOscuro),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: _siguientePaso,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: AppColors.primarioClaro,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        esUltimoPaso ? Icons.check : Icons.chevron_right,
                        color: AppColors.blanco,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tu progreso',
                        style: TextStyle(fontSize: 11, color: AppColors.grisOscuro),
                      ),
                      Text(
                        '${_indicePasoActual + 1}/$totalPasos',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primario,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progreso,
                      minHeight: 7,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primarioClaro),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.download_done, size: 15, color: AppColors.primario),
                SizedBox(width: 6),
                Text(
                  'Disponible sin conexión ',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grisOscuro,
                  ),
                ),
                Text(
                  'Este modelo vive en tu dispositivo.',
                  style: TextStyle(fontSize: 11, color: AppColors.grisClaro),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 6,
              width: double.infinity,
              color: AppColors.primarioClaro,
            ),
          ],
        ),
      ),
    );
  }
}