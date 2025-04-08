import 'package:db_sqlite/data/db/banco_de_dados.dart';
import 'package:db_sqlite/data/model/usuario.dart';

class UsuarioDao {
  Future<int> inserir(Usuario usuario) async {
    final db = await BancoDeDados.banco;
    return await db.insert('usuarios', usuario.toMap());
  }

  Future<List<Usuario>> listarTodos() async {
    final db = await BancoDeDados.banco;
    final resultado = await db.query('usuarios');
    return resultado.map((e) => Usuario.fromMap(e)).toList();
  }

  Future<int> atualizar(Usuario usuario) async {
    final db = await BancoDeDados.banco;
    return await db.update(
      'usuarios',
      usuario.toMap(),
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
  }

  Future<int> deletar(int id) async {
    final db = await BancoDeDados.banco;
    return await db.delete('usuarios', where: 'id = ?', whereArgs: [id]);
  }

  Future<Usuario?> buscarPorId(int id) async {
    final db = await BancoDeDados.banco;
    final resultado = await db.query(
      'usuarios',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (resultado.isNotEmpty) {
      return Usuario.fromMap(resultado.first);
    }
    return null;
  }
}
