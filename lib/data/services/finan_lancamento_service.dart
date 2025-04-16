import 'package:db_sqlite/data/dao/finan_lancamento_dao.dart';
import 'package:db_sqlite/data/model/finan_lancamento.dart';

class FinanLancamentoService {
  final FinanLancamentoDAO _dao = FinanLancamentoDAO();

  Future<void> salvarOuAtualizarLancamento(FinanLancamento lancamento) async {
    if (lancamento.id == null) {
      await _dao.salvar(lancamento);
    } else {
      await _dao.atualizar(lancamento);
    }
  }

  Future<List<FinanLancamento>> buscarLancamentos() async {
    return await _dao.listarTodos();
  }

  Future<FinanLancamento?> buscarLancamentoPorId(int id) async {
    return await _dao.buscarPorId(id);
  }

  Future<void> deletarLancamento(int id) async {
    await _dao.deletar(id);
  }

  Future<Map<String, double>> totalPorCategoria() async {
    final lancamentos = await _dao.totalPorCategoria();
    final Map<String, double> totalPorCategoria = {};

    for (var lancamento in lancamentos) {
      final categoria = lancamento['categoria'] as String;
      final total = lancamento['total'] as double;
      totalPorCategoria[categoria] = total;
    }
    if (totalPorCategoria.isNotEmpty) return totalPorCategoria;

    return {'Sem Categoria': 0.00};
  }
}
