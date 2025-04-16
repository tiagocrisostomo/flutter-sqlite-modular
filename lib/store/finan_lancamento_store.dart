import 'package:db_sqlite/data/model/finan_categoria.dart';
import 'package:db_sqlite/data/model/finan_lancamento.dart';
import 'package:db_sqlite/data/model/finan_tipo.dart';
import 'package:db_sqlite/data/services/finan_categoria_service.dart';
import 'package:db_sqlite/data/services/finan_lancamento_service.dart';
import 'package:db_sqlite/data/services/finan_tipo_service.dart';
import 'package:flutter/material.dart';

enum EstadoLancamento { inicial, carregando, carregado, erro }

class FinanLancamentoStore extends ChangeNotifier {
  final FinanLancamentoService service = FinanLancamentoService();
  List<FinanTipo> _tipos = [];
  List<FinanCategoria> _categorias = [];

  List<FinanLancamento> _lancamentos = [];
  List<FinanLancamento> get lancamentos => _lancamentos;

  EstadoLancamento _estado = EstadoLancamento.inicial;
  EstadoLancamento get estado => _estado;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  double get totalApagar => _lancamentos
      .where((l) => l.categoriaId == 1)
      .fold(0.0, (total, l) => total + l.valor);

  double get totalAreceber => _lancamentos
      .where((l) => l.categoriaId == 2)
      .fold(0.0, (total, l) => total + l.valor);

  double get saldoTotal => totalAreceber - totalApagar;

  Future<void> carregarLancamentos() async {
    _estado = EstadoLancamento.carregando;
    notifyListeners();

    try {
      _lancamentos = await service.buscarLancamentos();
      _estado = EstadoLancamento.carregado;
    } catch (e) {
      _estado = EstadoLancamento.erro;
      _mensagemErro = "Erro ao carregar lançamentos: $e";
    }

    notifyListeners();
  }

  Future<void> adicionarOuEditarLancamento(FinanLancamento lancamento) async {
    try {
      await service.salvarOuAtualizarLancamento(lancamento);
      await carregarLancamentos();
    } catch (e) {
      _estado = EstadoLancamento.erro;
      _mensagemErro = "Erro ao salvar lançamento: $e";
      notifyListeners();
    }
  }

  Future<void> removerLancamento(int id) async {
    try {
      await service.deletarLancamento(id);
      await carregarLancamentos();
    } catch (e) {
      _estado = EstadoLancamento.erro;
      _mensagemErro = "Erro ao remover lançamento: $e";
      notifyListeners();
    }
  }

  Future<void> carregarTipos() async {
    _tipos = await FinanTipoService().buscarTipos();
  }

  Future<void> carregarCategorias() async {
    _categorias = await FinanCategoriaService().buscarCategorias();
  }

  Map<String, double> totaisPorTipoDescricao() {
    carregarTipos();
    final Map<String, double> totais = {};
    for (var t in _lancamentos) {
      final tipo = _tipos.firstWhere(
        (tipo) => tipo.id == t.tipoId,
        orElse:
            () =>
                FinanTipo(id: t.tipoId, descricao: 'Tipo ${t.tipoId}', cor: ''),
      );
      totais[tipo.descricao.toString()] =
          (totais[tipo.descricao] ?? 0) + t.valor;
    }
    // debugPrint(totais.toString());
    return totais;
  }

  Map<String, double> totaisPorCategoriaDescricao() {
    carregarCategorias();
    final Map<String, double> totais = {};
    for (var t in _lancamentos) {
      final categoria = _categorias.firstWhere(
        (c) => c.id == t.categoriaId,
        orElse:
            () => FinanCategoria(
              id: t.categoriaId,
              descricao: 'Categoria ${t.categoriaId}',
              cor: '',
            ),
      );
      totais[categoria.descricao.toString()] =
          (totais[categoria.descricao] ?? 0) + t.valor;
    }
    // debugPrint(totais.toString());
    return totais;
  }

  void limparErro() {
    _mensagemErro = null;
    _estado = EstadoLancamento.inicial;
    notifyListeners();
    carregarLancamentos();
  }
}
