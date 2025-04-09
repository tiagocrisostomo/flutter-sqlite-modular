import 'package:db_sqlite/data/dao/finan_lancamento_dao.dart';
import 'package:db_sqlite/data/model/finan_lancamento.dart';

class LancamentoService {
  final FinanLancamentoDAO _dao = FinanLancamentoDAO();

  Future<void> salvarOuAtualizarFinanLancamento(
    FinanLancamento lancamento,
  ) async {
    if (lancamento.id == null) {
      await _dao.salvar(lancamento);
    } else {
      await _dao.atualizar(lancamento);
    }
  }

  Future<void> deletarLancamento(int id) => _dao.deletar(id);

  Future<List<FinanLancamento>> buscarTodos() => _dao.listarTodos();

  Future<double> totalApagar() => _dao.totalPorCategoria(1);
  Future<double> totalAreceber() => _dao.totalPorCategoria(2);

  Future<double> totalTipoGeral() => _dao.totalPorTipo(1, 1);
  Future<double> totalTipoPessoal() => _dao.totalPorTipo(2, 1);

  Future<List<FinanLancamento>> buscarPorUsuario(int usuarioId) =>
      _dao.buscarPorUsuario(usuarioId);
}
