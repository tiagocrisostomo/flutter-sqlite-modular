import 'package:db_sqlite/data/model/finan_tipo.dart';
import 'package:db_sqlite/data/services/finan_tipo_service.dart';
import 'package:flutter/material.dart';

enum EstadoFinanTipo { inicial, carregando, carregado, erro, deletando, deletado, incluindo, incluido, alterando, alterado, carregandoMais, 
  carregadoMais  }

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

  // Variáveis para o Lazy Loading
  final int _pageSize = 14;
  int _offset = 0;
  bool _hasMoreItems = true;
  bool get hasMoreItems => _hasMoreItems;

  Future<void> carregarTipos() async {
    // Evita carregamento duplo
    if (_estado == EstadoFinanTipo.carregando) return;

    _estado = EstadoFinanTipo.carregando;
    notifyListeners();

    _offset = 0; // Reseta o offset para carregar do início
    _hasMoreItems = true;
    
    try {
      final newTipos = await _service.getTipos(limit: _pageSize, offset: _offset);
      
      _finanTipos = newTipos;
      if (newTipos.length < _pageSize) {
        _hasMoreItems = false;
      } else {
        _offset += _pageSize;
      }
      
      _estado = EstadoFinanTipo.carregado;
    } catch (e) {
      _estado = EstadoFinanTipo.erro;
      _mensagemErro = "Erro ao carregar tipos: $e";
    }

    notifyListeners();
  }

  Future<void> carregarMaisTipos() async {
    // Evita carregamento duplo ou se não houver mais itens
    if (!_hasMoreItems || _estado == EstadoFinanTipo.carregandoMais) {
      return;
    }

    _estado = EstadoFinanTipo.carregandoMais;
    notifyListeners();

    try {
      final newTipos = await _service.getTipos(limit: _pageSize, offset: _offset);
      
      if (newTipos.isEmpty) {
        _hasMoreItems = false;
      } else {
        _finanTipos.addAll(newTipos);
        _offset += newTipos.length;
      }
      
      _estado = EstadoFinanTipo.carregadoMais;
    } catch (e) {
      _estado = EstadoFinanTipo.erro;
      _mensagemErro = "Erro ao carregar mais tipos: $e";
    }

    notifyListeners();
  }

  // Future<void> carregarTipos() async {
  //   _estado = EstadoFinanTipo.carregando;
  //   notifyListeners();
  //   try {
  //     _finanTipos = await _service.buscarTipos();
  //     _estado = EstadoFinanTipo.carregado;
  //   } catch (e) {
  //     _estado = EstadoFinanTipo.erro;
  //     _mensagemErro = "Erro ao carregar tipos: $e";
  //   }
  //   notifyListeners();
  // }

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
