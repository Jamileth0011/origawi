import 'package:flutter/material.dart';
import '../models/colores.dart';
import '../viewmodels/origami_viewmodel.dart';
import 'tutorial_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final OrigamiViewModel _viewModel = OrigamiViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.cargarOrigamis();
    _viewModel.addListener(() {
      if (mounted) setState(() {});
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
            // Barra superior estilo Figma
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: AppColors.blanco,
                border: Border(
                  bottom: BorderSide(color: AppColors.primarioClaro, width: 3),
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
                          color: AppColors.primario,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.asset('assets/images/logo_gato.png', width: 28, height: 28),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'origawi',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'dobla • crea • aprende',
                            style: TextStyle(fontSize: 11, color: AppColors.grisOscuro),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Contador de favoritos
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.bookmark, color: AppColors.favoritoActivo, size: 20),
                        const SizedBox(width: 4),
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
                ],
              ),
            ),

            // Buscador
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: TextField(
                onChanged: _viewModel.actualizarBusqueda,
                decoration: InputDecoration(
                  hintText: 'Busca un origami...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.grisOscuro),
                  filled: true,
                  fillColor: AppColors.blanco,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Los 3 Select (Filtros)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _construirFiltro(
                      etiqueta: 'Categoría',
                      valor: _viewModel.categoriaSeleccionada,
                      opciones: ['Todas', 'Animal', 'Flores', 'Transporte'],
                      onChanged: _viewModel.cambiarCategoria,
                    ),
                    const SizedBox(width: 8),
                    _construirFiltro(
                      etiqueta: 'Dificultad',
                      valor: _viewModel.dificultadSeleccionada,
                      opciones: ['Todas', 'Fácil', 'Medio', 'Difícil'],
                      onChanged: _viewModel.cambiarDificultad,
                    ),
                    const SizedBox(width: 8),
                    _construirFiltro(
                      etiqueta: 'Tipo',
                      valor: _viewModel.tipoSeleccionado,
                      opciones: ['Todos', 'Tradicional', 'Acción', 'Modular'],
                      onChanged: _viewModel.cambiarTipo,
                    ),
                  ],
                ),
              ),
            ),

            // Título de sección
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Explora y crea',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
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
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
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
                                builder: (context) => TutorialView(origami: origami),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.blanco,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 6,
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
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                    ),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Image.asset('assets/images/logo_gato.png', width: 70),
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: GestureDetector(
                                            onTap: () => _viewModel.cambiarFavorito(origami),
                                            child: CircleAvatar(
                                              radius: 16,
                                              backgroundColor: AppColors.blanco,
                                              child: Icon(
                                                origami.esFavorito ? Icons.bookmark : Icons.bookmark_border,
                                                color: origami.esFavorito
                                                    ? AppColors.favoritoActivo
                                                    : AppColors.grisClaro,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 8,
                                          left: 8,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: AppColors.blanco,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              origami.dificultad,
                                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            origami.nombre,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                          ),
                                          Text(
                                            origami.categoria,
                                            style: const TextStyle(fontSize: 11, color: AppColors.grisOscuro),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          borderRadius: BorderRadius.circular(6),
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
          ],
        ),
      ),
    );
  }

  Widget _construirFiltro({
    required String etiqueta,
    required String valor,
    required List<String> opciones,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.blanco,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: valor,
          icon: const Icon(Icons.keyboard_arrow_down, size: 18),
          style: const TextStyle(color: Colors.black87, fontSize: 13),
          items: opciones.map((op) {
            return DropdownMenuItem(
              value: op,
              child: Text(op == 'Todas' || op == 'Todos' ? etiqueta : op),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}