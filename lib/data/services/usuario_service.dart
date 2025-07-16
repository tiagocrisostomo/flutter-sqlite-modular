import 'package:db_sqlite/data/dao/usuario_dao.dart';
import 'package:db_sqlite/data/model/usuario.dart';

class UsuarioService {
  final UsuarioDao _dao = UsuarioDao();

  Future<void> salvarOuAtualizarUsuario(Usuario usuario) async {
    if (usuario.id == null) {
      await _dao.salvar(usuario);
    } else {
      await _dao.atualizar(usuario);
    }
  }

  Future<List<Usuario>> buscarUsuarioPorId(int id) async {
    return await _dao.buscarPorId(id);
  }

  Future<List<Usuario>> buscarUsuarios() async {
    return await _dao.listarTodos();
  }

  Future<void> deletarUsuario(int id) async {
    // Verifica se a categoria está em usome/ou é padrão
    final emUso = await _dao.verificarUso(id);
    final usuarioPadrao = await _dao.verificarPadrao(id);

    if (usuarioPadrao) {
      throw Exception('Usuário padrão não pode ser deletado.');
    }
    if (emUso) {
      throw Exception('Usuário em vinculado à lançamentos não pode ser deletado.');
    }
    await _dao.deletar(id);
  }
}
