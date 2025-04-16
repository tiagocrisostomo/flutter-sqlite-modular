import 'package:db_sqlite/data/db/banco_de_dados.dart';
import 'package:db_sqlite/data/model/finan_categoria.dart';
import 'package:sqflite/sqflite.dart';

class FinanCategoriaDao {
  Future<void> salvar(FinanCategoria finanCategoria) async {
    final db = await BancoDeDados.banco;
    await db.insert('finan_categoria', finanCategoria.toMap());
  }

  Future<List<FinanCategoria>> listarTodos() async {
    final db = await BancoDeDados.banco;
    final resultado = await db.query('finan_categoria');
    return resultado.map((e) => FinanCategoria.fromMap(e)).toList();
  }

  Future<int> atualizar(FinanCategoria finanCategoria) async {
    final db = await BancoDeDados.banco;
    return await db.update(
      'finan_categoria',
      finanCategoria.toMap(),
      where: 'id = ?',
      whereArgs: [finanCategoria.id],
    );
  }

  Future<int> deletar(int id) async {
    final db = await BancoDeDados.banco;
    return await db.delete('finan_categoria', where: 'id = ?', whereArgs: [id]);
  }

  Future<FinanCategoria?> buscarPorId(int id) async {
    final db = await BancoDeDados.banco;
    final resultado = await db.query(
      'finan_tipo',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (resultado.isNotEmpty) {
      return FinanCategoria.fromMap(resultado.first);
    }
    return null;
  }

  Future<bool> verificarUso(int id) async {
    final db = await BancoDeDados.banco;
    final resultado = await db.rawQuery(
      'SELECT COUNT(*) FROM finan_lancamento WHERE categoriaId = ?',
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
      'finan_categoria',
      where: 'id IN (?, ?) OR descricao IN (?, ?)',
      whereArgs: [1, 2, 'A Pagar', 'A Receber'],
    );

    bool padrao = resultado.any((row) => row['id'] == id);
    // debugPrint('Resultado PADRAO: $padrao');

    return padrao;
  }
}
