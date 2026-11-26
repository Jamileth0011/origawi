import 'package:flutter/material.dart';
import '../models/colores.dart';
import '../viewmodels/origami_viewmodel.dart';
import 'tutorial_view.dart';

class FavoritosView extends StatefulWidget {
  final OrigamiViewModel viewModel;

  const FavoritosView({super.key, required this.viewModel});

  @override
  State<FavoritosView> createState() => _FavoritosViewState();
}

class _FavoritosViewState extends State<FavoritosView> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoritos = widget.viewModel.origamisFavoritos;

    return Scaffold(
      backgroundColor: AppColors.fondoApp,
      appBar: AppBar(
        backgroundColor: AppColors.blanco,
        title: const Text(
          'Mis Favoritos',
          style: TextStyle(color: Color(0xFF1A2E1A), fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1A2E1A)),
        elevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: Divider(color: AppColors.primarioClaro, thickness: 4, height: 4),
        ),
      ),
      body: favoritos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text(
                    'Aún no tienes favoritos',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.grisOscuro),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Explora y guarda tus origamis preferidos.',
                    style: TextStyle(color: AppColors.grisClaro),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoritos.length,
              itemBuilder: (context, index) {
                final origami = favoritos[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: origami.colorFondoTarjeta,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/logo_origami.png', // Ruta actualizada
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, color: Colors.grey),
                        ),
                      ),
                    ),
                    title: Text(
                      origami.nombre,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${origami.categoria} • ${origami.dificultad}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.bookmark, color: AppColors.favoritoActivo),
                      onPressed: () {
                        widget.viewModel.cambiarFavorito(origami);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TutorialView(
                            origami: origami,
                            viewModel: widget.viewModel,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}