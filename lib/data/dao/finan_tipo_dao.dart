import 'package:db_sqlite/data/db/banco_de_dados.dart';
import 'package:db_sqlite/data/model/finan_tipo.dart';
import 'package:sqflite/sqflite.dart';

class FinanTipoDao {
  static const _tableName = 'finan_tipo';

  Future<void> salvar(FinanTipo finanTipo) async {
    final db = await BancoDeDados.banco;
    await db.insert(_tableName, finanTipo.toMap());
  }

  Future<List<FinanTipo>> listarTodos() async {
    final db = await BancoDeDados.banco;
    final resultado = await db.query(_tableName);
    return resultado.map((e) => FinanTipo.fromMap(e)).toList();
  }

  Future<int> atualizar(FinanTipo finanTipo) async {
    final db = await BancoDeDados.banco;
    return await db.update(_tableName, finanTipo.toMap(), where: 'id = ?', whereArgs: [finanTipo.id]);
  }

  Future<int> deletar(int id) async {
    final db = await BancoDeDados.banco;
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<FinanTipo>> buscarPorId(int id) async {
    final db = await BancoDeDados.banco;
    final resultado = await db.query(_tableName, where: 'id = ?', whereArgs: [id]);
    if (resultado.isNotEmpty) {
      return resultado.map((e) => FinanTipo.fromMap(e)).toList();
    }
    return [];
  }

  Future<bool> verificarUso(int id) async {
    final db = await BancoDeDados.banco;

    final resultado = await db.query('finan_lancamento', columns: ['COUNT(*)'], where: 'tipoId = ?', whereArgs: [id]);

    if (resultado.isNotEmpty) {
      final count = Sqflite.firstIntValue(resultado);
      return count != null && count > 0;
    }
    return false;
  }

  Future<bool> verificarPadrao(int? id) async {
    final db = await BancoDeDados.banco;

    final resultado = await db.query(_tableName, where: 'id IN (?, ?) OR descricao IN (?, ?)', whereArgs: [1, 'Geral']);

    bool padrao = resultado.any((row) => row['id'] == id);

    return padrao;
  }

  Future<List<FinanTipo>> findBy({int limit = 14, int offset = 0}) async {
    final db = await BancoDeDados.banco;
    final res = await db.query(
    _tableName,
    limit: limit,
    offset: offset,
    orderBy: 'id ASC', // É uma boa prática ter uma ordem definida
   );
   return res.map((json) => FinanTipo.fromMap(json)).toList();
 }
}
