import 'package:db_sqlite/data/dao/usuario_dao.dart';
import 'package:db_sqlite/data/model/usuario.dart';

class AuthService {
  final UsuarioDao _dao = UsuarioDao();

  Future<Usuario?> login(String nome, String senha) async {
    final usuario = await _dao.buscarPorNomeSenha(nome, senha);
    if (usuario != null) {
      return usuario;
    }
    return null;
  }
}
