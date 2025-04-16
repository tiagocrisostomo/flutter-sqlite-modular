import 'package:db_sqlite/data/db/banco_de_dados.dart';
import 'package:db_sqlite/data/model/usuario.dart';
import 'package:db_sqlite/utils/seguranca.dart';
import 'package:sqflite/sqflite.dart';

class UsuarioDao {
  Future<void> salvar(Usuario usuario) async {
    final db = await BancoDeDados.banco;
    final usuarioComSenhaHash = Usuario(
      id: usuario.id,
      nome: usuario.nome,
      senha: Seguranca.hashSenha(usuario.senha),
    );

    await db.insert(
      'usuario',
      usuarioComSenhaHash.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Usuario>> listarTodos() async {
    final db = await BancoDeDados.banco;
    final resultado = await db.query('usuario');
    return resultado.map((e) => Usuario.fromMap(e)).toList();
  }

  Future<int> atualizar(Usuario usuario) async {
    final db = await BancoDeDados.banco;
    return await db.update(
      'usuario',
      usuario.toMap(),
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
  }

  Future<int> deletar(int id) async {
    final db = await BancoDeDados.banco;
    return await db.delete('usuario', where: 'id = ?', whereArgs: [id]);
  }

  Future<Usuario?> buscarPorId(int id) async {
    final db = await BancoDeDados.banco;
    final resultado = await db.query(
      'usuario',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (resultado.isNotEmpty) {
      return Usuario.fromMap(resultado.first);
    }
    return null;
  }

  Future<Usuario?> buscarPorNomeSenha(String nome, String senha) async {
    final db = await BancoDeDados.banco;
    final senhaHash = Seguranca.hashSenha(senha);

    final maps = await db.query(
      'usuario',
      where: 'nome = ? AND senha = ?',
      whereArgs: [nome, senhaHash],
    );
    if (maps.isNotEmpty) {
      return Usuario.fromMap(maps.first);
    }
    return null;
  }

  Future<bool> verificarUso(int id) async {
    final db = await BancoDeDados.banco;
    final resultado = await db.rawQuery(
      'SELECT COUNT(*) FROM finan_lancamento WHERE usuarioId = ?',
      [id],
    );

    // debugPrint('Resultado  USO: $resultado');

    if (resultado.isNotEmpty) {
      final count = Sqflite.firstIntValue(resultado);
      return count != null && count > 0;
    }
    return false;
  }

  Future<bool> verificarPadrao(int? id) async {
    final db = await BancoDeDados.banco;

    final resultado = await db.query(
      'usuario',
      where: 'id = ? OR nome = ?',
      whereArgs: [1, 'admin'],
    );

    bool padrao = resultado.any((row) => row['id'] == id);
    // debugPrint('Resultado PADRAO: $padrao');

    return padrao;
  }
}
