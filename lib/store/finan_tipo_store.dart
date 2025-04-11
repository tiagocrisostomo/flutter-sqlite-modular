import 'package:db_sqlite/data/model/finan_tipo.dart';
import 'package:db_sqlite/data/services/finan_tipo_service.dart';
import 'package:flutter/material.dart';

enum EstadoFinanTipo { inicial, carregando, carregado, erro }

class FinanTipoStore extends ChangeNotifier {
  final FinanTipoService _service = FinanTipoService();

  List<FinanTipo> _finanTipos = [];
  List<FinanTipo> get finanTipos => _finanTipos;

  EstadoFinanTipo _estado = EstadoFinanTipo.inicial;
  EstadoFinanTipo get estado => _estado;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  Future<void> carregarTipos() async {
    _estado = EstadoFinanTipo.carregando;
    notifyListeners();

    try {
      _finanTipos = await _service.buscarTipos();
      _estado = EstadoFinanTipo.carregado;
    } catch (e) {
      _estado = EstadoFinanTipo.erro;
      _mensagemErro = "Erro ao carregar tipos: $e";
    }

    notifyListeners();
  }

  Future<void> adicionarTipo(FinanTipo finanTipo) async {
    try {
      await _service.salvarOuAtualizarTipo(finanTipo);

      // Atualiza a lista de tipos após adicionar
      await carregarTipos();
    } catch (e) {
      _estado = EstadoFinanTipo.erro;
      _mensagemErro = "Erro ao adicionar tipo: $e";
      notifyListeners();
    }
  }

  Future<void> removerTipo(int id) async {
    try {
      await _service.deletarTipo(id);
      await carregarTipos();
    } catch (e) {
      _estado = EstadoFinanTipo.erro;
      _mensagemErro = "Erro ao remover tipo: $e";
      notifyListeners();
    }
  }

  void limparErro() {
    _mensagemErro = null;
    _estado = EstadoFinanTipo.inicial;
    notifyListeners();
    carregarTipos();
  }
}
