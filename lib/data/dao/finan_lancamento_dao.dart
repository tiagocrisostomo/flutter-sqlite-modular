import 'package:db_sqlite/data/db/banco_de_dados.dart';
import 'package:db_sqlite/data/model/finan_lancamento.dart';

class FinanLancamentoDAO {
  Future<void> salvar(FinanLancamento lancamento) async {
    final db = await BancoDeDados.banco;
    await db.insert('finan_lancamentos', lancamento.toMap());
  }

  Future<void> atualizar(FinanLancamento lancamento) async {
    final db = await BancoDeDados.banco;
    await db.update(
      'finan_lancamentos',
      lancamento.toMap(),
      where: 'id = ?',
      whereArgs: [lancamento.id],
    );
  }

  Future<void> deletar(int id) async {
    final db = await BancoDeDados.banco;
    await db.delete('finan_lancamentos', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<FinanLancamento>> listarTodos() async {
    final db = await BancoDeDados.banco;
    final maps = await db.query('finan_lancamentos');
    return maps.map((map) => FinanLancamento.fromMap(map)).toList();
  }

  Future<double> totalPorCategoria(int categoriaId) async {
    final db = await BancoDeDados.banco;
    final result = await db.rawQuery(
      'SELECT SUM(valor) as total FROM finan_lancamentos WHERE categoriaId = ?',
      [categoriaId],
    );
    return result.first['total'] == null
        ? 0.0
        : (result.first['total'] as num).toDouble();
  }

  Future<double> totalPorTipo(int tipoId, int categoriaId) async {
    final db = await BancoDeDados.banco;
    final result = await db.rawQuery(
      '''SELECT SUM(valor) as total FROM finan_lancamentos 
      WHERE tipoId = ? AND categoriaId = ?''',

      [tipoId, categoriaId],
    );
    return result.first['total'] == null
        ? 0.0
        : (result.first['total'] as num).toDouble();
  }

  Future<List<FinanLancamento>> buscarPorUsuario(int usuarioId) async {
    final db = await BancoDeDados.banco;
    final maps = await db.query(
      'finan_lancamentos',
      where: 'usuarioId = ?',
      whereArgs: [usuarioId],
    );
    return maps.map((map) => FinanLancamento.fromMap(map)).toList();
  }
}
