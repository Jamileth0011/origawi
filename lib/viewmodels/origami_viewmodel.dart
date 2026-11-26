import 'package:flutter/foundation.dart';
import '../models/origawi.dart';
import '../repositories/origami_repository.dart';

class OrigamiViewModel extends ChangeNotifier {
  final OrigamiRepository _repository = OrigamiRepository();

  List<Origami> _todosLosOrigamis = [];
  List<Origami> origamisFiltrados = [];
  bool isLoading = false;

  String textoBusqueda = '';
  String categoriaSeleccionada = 'Todas';
  String dificultadSeleccionada = 'Todas';
  String tipoSeleccionado = 'Todos';

  int get totalFavoritos => _todosLosOrigamis.where((o) => o.esFavorito).length;

  Future<void> cargarOrigamis() async {
    isLoading = true;
    notifyListeners();

    _todosLosOrigamis = await _repository.obtenerOrigamisLocales();
    aplicarFiltros();

    isLoading = false;
    notifyListeners();
  }

  void actualizarBusqueda(String texto) {
    textoBusqueda = texto;
    aplicarFiltros();
  }

  void cambiarCategoria(String? valor) {
    if (valor != null) {
      categoriaSeleccionada = valor;
      aplicarFiltros();
    }
  }

  void cambiarDificultad(String? valor) {
    if (valor != null) {
      dificultadSeleccionada = valor;
      aplicarFiltros();
    }
  }

  void cambiarTipo(String? valor) {
    if (valor != null) {
      tipoSeleccionado = valor;
      aplicarFiltros();
    }
  }

  void aplicarFiltros() {
    origamisFiltrados = _todosLosOrigamis.where((origami) {
      final coincideTexto = origami.nombre.toLowerCase().contains(textoBusqueda.toLowerCase());
      final coincideCat = categoriaSeleccionada == 'Todas' || origami.categoria == categoriaSeleccionada;
      final coincideDif = dificultadSeleccionada == 'Todas' || origami.dificultad == dificultadSeleccionada;
      final coincideTipo = tipoSeleccionado == 'Todos' || origami.tipo == tipoSeleccionado;

      return coincideTexto && coincideCat && coincideDif && coincideTipo;
    }).toList();
    notifyListeners();
  }

  void cambiarFavorito(Origami origami) {
    origami.esFavorito = !origami.esFavorito;
    notifyListeners();
  }
}