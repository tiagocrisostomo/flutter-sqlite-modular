import 'package:db_sqlite/data/model/finan_lancamento.dart';
import 'package:db_sqlite/data/services/finan_lancamento_service.dart';
import 'package:flutter/material.dart';

enum EstadoLancamento { inicial, carregando, carregado, erro }

class FinanLancamentoStore extends ChangeNotifier {
  final FinanLancamentoService _service = FinanLancamentoService();

  List<FinanLancamento> _lancamentos = [];
  List<FinanLancamento> get lancamentos => _lancamentos;

  EstadoLancamento _estado = EstadoLancamento.inicial;
  EstadoLancamento get estado => _estado;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  Future<void> carregarLancamentos() async {
    _estado = EstadoLancamento.carregando;
    notifyListeners();

    try {
      _lancamentos = await _service.buscarLancamentos();
      _estado = EstadoLancamento.carregado;
    } catch (e) {
      _estado = EstadoLancamento.erro;
      _mensagemErro = "Erro ao carregar lançamentos: $e";
    }

    notifyListeners();
  }

  Future<void> adicionarOuEditarLancamento(FinanLancamento lancamento) async {
    try {
      await _service.salvarOuAtualizarLancamento(lancamento);
      await carregarLancamentos();
    } catch (e) {
      _estado = EstadoLancamento.erro;
      _mensagemErro = "Erro ao salvar lançamento: $e";
      notifyListeners();
    }
  }

  Future<void> removerLancamento(int id) async {
    try {
      await _service.deletarLancamento(id);
      await carregarLancamentos();
    } catch (e) {
      _estado = EstadoLancamento.erro;
      _mensagemErro = "Erro ao remover lançamento: $e";
      notifyListeners();
    }
  }

  void limparErro() {
    _mensagemErro = null;
    _estado = EstadoLancamento.inicial;
    notifyListeners();
    carregarLancamentos();
  }
}
