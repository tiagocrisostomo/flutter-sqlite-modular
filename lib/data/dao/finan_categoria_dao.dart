import 'package:db_sqlite/data/db/banco_de_dados.dart';
import 'package:db_sqlite/data/model/finan_categoria.dart';
import 'package:sqflite/sqflite.dart';

class FinanCategoriaDao {
  static const _tableName = 'finan_categoria';

  Future<void> salvar(FinanCategoria finanCategoria) async {
    final db = await BancoDeDados.banco;
    await db.insert(_tableName, finanCategoria.toMap());
  }

  Future<List<FinanCategoria>> listarTodos() async {
    final db = await BancoDeDados.banco;
    final resultado = await db.query(_tableName);
    return resultado.map((e) => FinanCategoria.fromMap(e)).toList();
  }

  Future<int> atualizar(FinanCategoria finanCategoria) async {
    final db = await BancoDeDados.banco;
    return await db.update(_tableName, finanCategoria.toMap(), where: 'id = ?', whereArgs: [finanCategoria.id]);
  }

  Future<int> deletar(int id) async {
    final db = await BancoDeDados.banco;
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<FinanCategoria>> buscarPorId(int id) async {
    final db = await BancoDeDados.banco;
    final resultado = await db.query(_tableName, where: 'id = ?', whereArgs: [id]);
    if (resultado.isNotEmpty) {
      return resultado.map((e) => FinanCategoria.fromMap(e)).toList();
    }
    return [];
  }

  Future<bool> verificarUso(int id) async {
    final db = await BancoDeDados.banco;
    final resultado = await db.query('finan_lancamento', columns: ['COUNT(*)'], where: 'categoriaId = ?', whereArgs: [id]);

    // debugPrint('Resultado  USO: $resultado');

    if (resultado.isNotEmpty) {
      final count = Sqflite.firstIntValue(resultado);
      return count != null && count > 0;
    }
    return false;
  }

  Future<bool> verificarPadrao(int? id) async {
    final db = await BancoDeDados.banco;

    final resultado = await db.query(_tableName, where: 'id IN (?, ?) OR descricao IN (?, ?)', whereArgs: [1, 2, 'A Pagar', 'A Receber']);

    bool padrao = resultado.any((row) => row['id'] == id);

    return padrao;
  }
}
