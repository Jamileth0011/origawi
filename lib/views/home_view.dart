import 'package:flutter/material.dart';
import '../models/colores.dart';
import '../viewmodels/origami_viewmodel.dart';
import 'favoritos_view.dart';
import 'tutorial_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // Gato blanco (para fondos verdes) y gato gris (para las tarjetas claras)
  static const String _rutaLogo = 'assets/image/logo_gato_blanco.png';
  static const String _rutaLogoTarjeta = 'assets/image/logo_gato_blanco.png';
  
  final OrigamiViewModel _viewModel = OrigamiViewModel();
  String? _filtroAbierto; // 'Categoría', 'Dificultad', 'Tipo' o null

  @override
  void initState() {
    super.initState();
    _viewModel.cargarOrigamis();
    _viewModel.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void _abrirFavoritos() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoritosView(viewModel: _viewModel),
      ),
    );
  }

  void _alternarPanelFiltro(String nombreFiltro) {
    setState(() {
      _filtroAbierto = (_filtroAbierto == nombreFiltro) ? null : nombreFiltro;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoApp,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera blanca + línea verde brillante
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: AppColors.blanco,
                border: Border(
                  bottom: BorderSide(color: AppColors.primarioClaro, width: 4),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primarioClaro,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.asset(
                          _rutaLogo, 
                          width: 30,
                          height: 30,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Origawi',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A2E1A),
                            ),
                          ),
                          Text(
                            'Dobla • Crea • Aprende',
                            style: TextStyle(fontSize: 11, color: AppColors.grisOscuro),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Botón de favoritos en esquina superior derecha
                  GestureDetector(
                    onTap: _abrirFavoritos,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF0F0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.bookmark, color: Color(0xFFE50000), size: 18),
                          const SizedBox(width: 6),
                          Text(
                            '${_viewModel.totalFavoritos}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.favoritoActivo,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Buscador
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: TextField(
                onChanged: _viewModel.actualizarBusqueda,
                decoration: InputDecoration(
                  hintText: 'Busca un origami...',
                  hintStyle: const TextStyle(color: AppColors.grisOscuro, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: AppColors.grisOscuro),
                  filled: true,
                  fillColor: AppColors.blanco,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.primario, width: 1.5),
                  ),
                ),
              ),
            ),

            // Píldoras de filtro
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _construirPildoraFiltro(
                      etiqueta: 'Categoría',
                      valorActual: _viewModel.categoriaSeleccionada,
                      valorDefecto: 'Todas',
                      estaAbierto: _filtroAbierto == 'Categoría',
                      onTap: () => _alternarPanelFiltro('Categoría'),
                    ),
                    const SizedBox(width: 8),
                    _construirPildoraFiltro(
                      etiqueta: 'Dificultad',
                      valorActual: _viewModel.dificultadSeleccionada,
                      valorDefecto: 'Todas',
                      estaAbierto: _filtroAbierto == 'Dificultad',
                      onTap: () => _alternarPanelFiltro('Dificultad'),
                    ),
                    const SizedBox(width: 8),
                    _construirPildoraFiltro(
                      etiqueta: 'Tipo',
                      valorActual: _viewModel.tipoSeleccionado,
                      valorDefecto: 'Todos',
                      estaAbierto: _filtroAbierto == 'Tipo',
                      onTap: () => _alternarPanelFiltro('Tipo'),
                    ),
                  ],
                ),
              ),
            ),

            // Tarjeta desplegable de opciones
            if (_filtroAbierto != null) _construirPanelOpcionesFiltro(),

            // Título de sección
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Explora y crea',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A2E1A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_viewModel.origamisFiltrados.length} modelos disponibles sin conexión',
                    style: const TextStyle(fontSize: 12, color: AppColors.grisOscuro),
                  ),
                ],
              ),
            ),

            // Cuadrícula de figuras
            Expanded(
              child: _viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primario))
                  : _viewModel.origamisFiltrados.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off, size: 60, color: AppColors.grisClaro),
                              SizedBox(height: 12),
                              Text(
                                'No hay origamis con esos filtros',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.grisOscuro,
                                ),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                      physics: const BouncingScrollPhysics(), // Soluciona el aviso amarillo
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.78,
                      ),
                      itemCount: _viewModel.origamisFiltrados.length,
                      itemBuilder: (context, index) {
                        final origami = _viewModel.origamisFiltrados[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TutorialView(
                                  origami: origami,
                                  viewModel: _viewModel,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.blanco,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: origami.colorFondoTarjeta,
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(18),
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Image.asset(
                                            _rutaLogoTarjeta,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.contain,
                                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, color: Colors.grey, size: 50),
                                          ),
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: GestureDetector(
                                            onTap: () => _viewModel.cambiarFavorito(origami),
                                            child: Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                color: origami.esFavorito
                                                    ? const Color(0xFFFCE8E8)
                                                    : AppColors.blanco,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Icon(
                                                Icons.bookmark,
                                                color: origami.esFavorito
                                                    ? AppColors.favoritoActivo
                                                    : const Color(0xFFFF8A8A),
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 8,
                                          left: 8,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 9,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.blanco,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              origami.dificultad,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF1A2E1A),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(11),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              origami.nombre,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Color(0xFF1A2E1A),
                                              ),
                                            ),
                                            Text(
                                              origami.categoria,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: AppColors.grisOscuro,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 7,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEAF8EC),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          origami.tiempoEstimado,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: AppColors.primario,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Franja inferior verde del diseño
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

  Widget _construirPildoraFiltro({
    required String etiqueta,
    required String valorActual,
    required String valorDefecto,
    required bool estaAbierto,
    required VoidCallback onTap,
  }) {
    final bool tieneFiltroActivo = valorActual != valorDefecto;
    final bool resaltado = estaAbierto || tieneFiltroActivo;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: resaltado ? AppColors.primario : AppColors.blanco,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: resaltado ? AppColors.primario : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Text(
              tieneFiltroActivo ? valorActual : etiqueta,
              style: TextStyle(
                color: resaltado ? AppColors.blanco : AppColors.grisOscuro,
                fontSize: 13,
                fontWeight: resaltado ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              estaAbierto ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 18,
              color: resaltado ? AppColors.blanco : AppColors.grisOscuro,
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirPanelOpcionesFiltro() {
    List<String> opciones = [];
    String seleccionActual = '';
    ValueChanged<String?> onSelect = (_) {};

    if (_filtroAbierto == 'Categoría') {
      opciones = ['Todas', 'Animales', 'Flores', 'Transporte'];
      seleccionActual = _viewModel.categoriaSeleccionada;
      onSelect = _viewModel.cambiarCategoria;
    } else if (_filtroAbierto == 'Dificultad') {
      opciones = ['Todas', 'Fácil', 'Medio', 'Difícil'];
      seleccionActual = _viewModel.dificultadSeleccionada;
      onSelect = _viewModel.cambiarDificultad;
    } else if (_filtroAbierto == 'Tipo') {
      opciones = ['Todos', 'Tradicional', 'Acción', 'Modular'];
      seleccionActual = _viewModel.tipoSeleccionado;
      onSelect = _viewModel.cambiarTipo;
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.blanco,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'FILTRAR POR',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      color: AppColors.grisClaro,
                    ),
                  ),
                  Text(
                    _filtroAbierto!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A2E1A),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => setState(() => _filtroAbierto = null),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.fondoApp,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.close, size: 18, color: AppColors.grisOscuro),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Reemplazamos el GridView por un Wrap para que se vea como en Figma
          Wrap(
            spacing: 8, 
            runSpacing: 8, 
            children: opciones.map((opcion) {
              final bool seleccionada = opcion == seleccionActual;
              final double anchoBoton = (MediaQuery.of(context).size.width - 32 - 32 - 8) / 2;
              
              return GestureDetector(
                onTap: () {
                  onSelect(opcion);
                  setState(() => _filtroAbierto = null);
                },
                child: Container(
                  width: anchoBoton,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: seleccionada ? const Color(0xFFEAF9EC) : AppColors.fondoApp,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: seleccionada ? AppColors.primarioClaro : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        opcion,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: seleccionada ? FontWeight.bold : FontWeight.w500,
                          color: seleccionada ? AppColors.primario : AppColors.grisOscuro,
                        ),
                      ),
                      if (seleccionada)
                        const Icon(Icons.check, size: 16, color: AppColors.primario),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}