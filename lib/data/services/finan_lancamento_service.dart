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

  Future<List<FinanLancamento>> buscarLancamentoMes() async {
    return await _dao.listarMes();
  }

  Future<FinanLancamento?> buscarLancamentoPorId(int id) async {
    return await _dao.buscarPorId(id);
  }

  Future<void> deletarLancamento(int id) async {
    await _dao.deletar(id);
  }
}
