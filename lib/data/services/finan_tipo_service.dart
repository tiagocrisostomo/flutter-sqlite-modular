import 'package:db_sqlite/data/dao/finan_tipo_dao.dart';
import 'package:db_sqlite/data/model/finan_tipo.dart';

class FinanTipoService {
  final FinanTipoDao _dao = FinanTipoDao();
  Future<void> salvarOuAtualizarTipo(FinanTipo finanTipo) async {
    if (finanTipo.id == null) {
      await _dao.salvar(finanTipo);
    } else {
      await _dao.atualizar(finanTipo);
    }
  }

  Future<FinanTipo?> buscarTipoPorId(int id) async {
    return await _dao.buscarPorId(id);
  }

  Future<List<FinanTipo>> buscarTipos() async {
    return await _dao.listarTodos();
  }

  Future<void> deletarTipo(int id) async {
    // Verifica se a categoria está em usome/ou é padrão
    final emUso = await _dao.verificarUso(id);
    final catPadrao = await _dao.verificarPadrao(id);

    if (catPadrao) {
      throw Exception('Categoria padrão não pode ser deletada.');
    }
    if (emUso) {
      throw Exception('Categoria em uso e não pode ser deletada.');
    }

    await _dao.deletar(id);
  }
}
