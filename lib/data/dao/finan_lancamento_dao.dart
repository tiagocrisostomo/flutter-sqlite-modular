import 'package:db_sqlite/data/db/banco_de_dados.dart';
import 'package:db_sqlite/data/model/finan_lancamento.dart';

class FinanLancamentoDAO {
  Future<void> salvar(FinanLancamento lancamento) async {
    final db = await BancoDeDados.banco;
    await db.insert('finan_lancamento', lancamento.toMap());
  }

  Future<void> atualizar(FinanLancamento lancamento) async {
    final db = await BancoDeDados.banco;
    await db.update(
      'finan_lancamento',
      lancamento.toMap(),
      where: 'id = ?',
      whereArgs: [lancamento.id],
    );
  }

  Future<void> deletar(int id) async {
    final db = await BancoDeDados.banco;
    await db.delete('finan_lancamento', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<FinanLancamento>> listarTodos() async {
    final db = await BancoDeDados.banco;
    final maps = await db.query('finan_lancamento');
    return maps.map((map) => FinanLancamento.fromMap(map)).toList();
  }

  Future<FinanLancamento?> buscarPorId(int id) async {
    final db = await BancoDeDados.banco;
    final resultado = await db.query(
      'finan_lancamentos',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (resultado.isNotEmpty) {
      return FinanLancamento.fromMap(resultado.first);
    }
    return null;
  }

  Future<List<Map>> totalPorCategoria() async {
    final db = await BancoDeDados.banco;
    final result = await db.rawQuery(
      '''SELECT fc.descricao as categoria, SUM(fl.valor) as total 
         FROM finan_lancamento fl
         INNER JOIN finan_categoria fc ON fl.categoriaId = fc.id
         GROUP BY fc.descricao
         ORDER BY fc.descricao''',
    );

    if (result.isEmpty) return [];

    return result;
  }

  Future<List<FinanLancamento>> buscarPorUsuario(int usuarioId) async {
    final db = await BancoDeDados.banco;
    final maps = await db.query(
      'finan_lancamento',
      where: 'usuarioId = ?',
      whereArgs: [usuarioId],
    );
    return maps.map((map) => FinanLancamento.fromMap(map)).toList();
  }
}
