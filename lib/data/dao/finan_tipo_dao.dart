import 'package:db_sqlite/data/db/banco_de_dados.dart';
import 'package:db_sqlite/data/model/finan_tipo.dart';
import 'package:sqflite/sqflite.dart';

class FinanTipoDao {
  Future<void> salvar(FinanTipo finanTipo) async {
    final db = await BancoDeDados.banco;
    await db.insert('finan_tipos', finanTipo.toMap());
  }

  Future<List<FinanTipo>> listarTodos() async {
    final db = await BancoDeDados.banco;
    final resultado = await db.query('finan_tipos');
    return resultado.map((e) => FinanTipo.fromMap(e)).toList();
  }

  Future<int> atualizar(FinanTipo finanTipo) async {
    final db = await BancoDeDados.banco;
    return await db.update(
      'finan_tipos',
      finanTipo.toMap(),
      where: 'id = ?',
      whereArgs: [finanTipo.id],
    );
  }

  Future<int> deletar(int id) async {
    final db = await BancoDeDados.banco;
    return await db.delete('finan_tipos', where: 'id = ?', whereArgs: [id]);
  }

  Future<FinanTipo?> buscarPorId(int id) async {
    final db = await BancoDeDados.banco;
    final resultado = await db.query(
      'finan_tipos',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (resultado.isNotEmpty) {
      return FinanTipo.fromMap(resultado.first);
    }
    return null;
  }

  Future<bool> verificarUso(int id) async {
    final db = await BancoDeDados.banco;
    final resultado = await db.rawQuery(
      'SELECT COUNT(*) FROM finan_lancamentos WHERE tipoId = ?',
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
      'finan_tipos',
      where: 'id IN (?, ?) OR descricao IN (?, ?)',
      whereArgs: [1, 2, 'Geral', 'Pessoal'],
    );

    bool padrao = resultado.any((row) => row['id'] == id);
    // debugPrint('Resultado PADRAO: $padrao');

    return padrao;
  }
}
