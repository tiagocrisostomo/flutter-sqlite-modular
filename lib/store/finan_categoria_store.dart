import 'package:db_sqlite/data/model/finan_categoria.dart';
import 'package:db_sqlite/data/services/finan_categoria_service.dart';
import 'package:flutter/material.dart';

enum EstadoFinanCategoria { inicial, carregando, carregado, erro }

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
    try {
      await _service.salvarOuAtualizarCategoria(finanCategoria);

      // Atualiza a lista de categorias após adicionar
      await carregarCategorias();
    } catch (e) {
      _estado = EstadoFinanCategoria.erro;
      _mensagemErro = "Erro ao adicionar categoria: $e";
      notifyListeners();
    }
  }

  Future<void> removerCategoria(int id) async {
    try {
      await _service.deletarCategoria(id);
      await carregarCategorias();
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
