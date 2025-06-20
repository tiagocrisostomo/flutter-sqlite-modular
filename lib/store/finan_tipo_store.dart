import 'package:db_sqlite/data/model/finan_tipo.dart';
import 'package:db_sqlite/data/services/finan_tipo_service.dart';
import 'package:flutter/material.dart';

enum EstadoFinanTipo { inicial, carregando, carregado, erro, deletando, deletado, incluindo, incluido, alterando, alterado }

class FinanTipoStore extends ChangeNotifier {
  final FinanTipoService _service = FinanTipoService();

  List<FinanTipo> _finanTipos = [];
  List<FinanTipo> get finanTipos => _finanTipos;

  List<FinanTipo> _finanTipo = [];
  List<FinanTipo> get finanTipo => _finanTipo;

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
    if (finanTipo.id == null) {
      _estado = EstadoFinanTipo.incluindo;
    } else {
      _estado = EstadoFinanTipo.alterando;
    }
    notifyListeners();
    try {
      await _service.salvarOuAtualizarTipo(finanTipo);
      if (finanTipo.id == null) {
        _estado = EstadoFinanTipo.incluido;
      } else {
        _estado = EstadoFinanTipo.alterado;
      }

      notifyListeners();
      // await carregarTipos();
    } catch (e) {
      _estado = EstadoFinanTipo.erro;
      _mensagemErro = "Erro ao adicionar tipo: $e";
      notifyListeners();
    }
  }

  Future<void> removerTipo(int id) async {
    _estado = EstadoFinanTipo.deletando;
    notifyListeners();
    try {
      await _service.deletarTipo(id);
      _estado = EstadoFinanTipo.deletado;
      notifyListeners();
      // await carregarTipos();
    } catch (e) {
      _estado = EstadoFinanTipo.erro;
      _mensagemErro = "Erro ao remover tipo: $e";
      notifyListeners();
    }
  }

  Future<void> buscarTipoId(int id) async {
    try {
      _finanTipo = await _service.buscarTipoPorId(id);
      notifyListeners();
    } catch (e) {
      _estado = EstadoFinanTipo.erro;
      _mensagemErro = "Erro ao consultar tipo: $e";
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
