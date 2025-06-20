import 'package:db_sqlite/data/model/finan_categoria.dart';
import 'package:db_sqlite/data/services/finan_categoria_service.dart';
import 'package:flutter/material.dart';

enum EstadoFinanCategoria { inicial, carregando, carregado, erro, deletando, deletado, incluindo, incluido, alterando, alterado }

class FinanCategoriaStore extends ChangeNotifier {
  final FinanCategoriaService _service = FinanCategoriaService();

  List<FinanCategoria> _finanCategorias = [];
  List<FinanCategoria> get finanCategorias => _finanCategorias;

  List<FinanCategoria> _finanCategoria = [];
  List<FinanCategoria> get finanCategoria => _finanCategoria;

  EstadoFinanCategoria _estado = EstadoFinanCategoria.inicial;
  EstadoFinanCategoria get estado => _estado;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  Future<void> carregarCategorias() async {
    _estado = EstadoFinanCategoria.carregando;
    notifyListeners();

    try {
      _finanCategorias = await _service.buscarCategorias();
      _estado = EstadoFinanCategoria.carregado;
    } catch (e) {
      _estado = EstadoFinanCategoria.erro;
      _mensagemErro = "Erro ao carregar categorias: $e";
    }

    notifyListeners();
  }

  Future<void> adicionarCategoria(FinanCategoria finanCategoria) async {
    if (finanCategoria.id == null) {
      _estado = EstadoFinanCategoria.incluindo;
    } else {
      _estado = EstadoFinanCategoria.alterando;
    }
    notifyListeners();
    try {
      await _service.salvarOuAtualizarCategoria(finanCategoria);
      if (finanCategoria.id == null) {
        _estado = EstadoFinanCategoria.incluido;
      } else {
        _estado = EstadoFinanCategoria.alterado;
      }

      notifyListeners();
      // await carregarCategorias();
    } catch (e) {
      _estado = EstadoFinanCategoria.erro;
      _mensagemErro = "Erro ao adicionar categoria: $e";
      notifyListeners();
    }
  }

  Future<void> removerCategoria(int id) async {
    _estado = EstadoFinanCategoria.deletando;
    notifyListeners();
    try {
      await _service.deletarCategoria(id);
      _estado = EstadoFinanCategoria.deletado;
      notifyListeners();
      // await carregarCategorias();
    } catch (e) {
      _estado = EstadoFinanCategoria.erro;
      _mensagemErro = "Erro ao remover categoria: $e";
      notifyListeners();
    }
  }

  Future<void> buscarCategoriaId(int id) async {
    try {
      _finanCategoria = await _service.buscarCategoriaPorId(id);
      notifyListeners();
    } catch (e) {
      _estado = EstadoFinanCategoria.erro;
      _mensagemErro = "Erro ao consultar categoria: $e";
      notifyListeners();
    }
  }

  void limparErro() {
    _mensagemErro = null;
    _estado = EstadoFinanCategoria.inicial;
    notifyListeners();
    carregarCategorias();
  }
}
