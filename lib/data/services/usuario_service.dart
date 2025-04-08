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
  
  Future<Usuario?> buscarUsuarioPorId(int id) async {
    return await _dao.buscarPorId(id);
  }

  Future<List<Usuario>> buscarUsuarios() async {
    return await _dao.listarTodos();
  }

  Future<void> deletarUsuario(int id) async {
    await _dao.deletar(id);
  }
}
