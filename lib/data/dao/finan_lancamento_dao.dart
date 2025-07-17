import 'package:db_sqlite/data/db/banco_de_dados.dart';
import 'package:db_sqlite/data/model/finan_lancamento.dart';

class FinanLancamentoDAO {
  static const _tableName = 'finan_lancamento';

  Future<void> salvar(FinanLancamento lancamento) async {
    final db = await BancoDeDados.banco;
    await db.insert(_tableName, lancamento.toMap());
  }

  Future<void> atualizar(FinanLancamento lancamento) async {
    final db = await BancoDeDados.banco;
    await db.update(_tableName, lancamento.toMap(), where: 'id = ?', whereArgs: [lancamento.id]);
  }

  Future<void> deletar(int id) async {
    final db = await BancoDeDados.banco;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<FinanLancamento>> listarTodos() async {
    String sql = '''SELECT
      fl.id,
      fl.descricao,
      fl.valor,
      fl.data,
      fl.categoriaId,
      fl.tipoId,
      fl.usuarioId,
      fc.descricao AS categoriaDescricao,
      ft.descricao AS tipoDescricao,
      u.nome AS usuarioNome  
     FROM finan_lancamento fl
     INNER JOIN finan_categoria fc ON fl.categoriaId = fc.id
     INNER JOIN finan_tipo ft ON fl.tipoId = ft.id
     INNER JOIN usuario u ON fl.usuarioId = u.id
     ORDER BY fl.data DESC
  ''';
    final db = await BancoDeDados.banco;
    final lancamentos = await db.rawQuery(sql);
    return lancamentos.map((lancamento) => FinanLancamento.fromMap(lancamento)).toList();
  }

    Future<List<FinanLancamento>> listarMes() async {
    String sql = '''SELECT
      fl.id,
      fl.descricao,
      fl.valor,
      fl.data,
      fl.categoriaId,
      fl.tipoId,
      fl.usuarioId,
      fc.descricao AS categoriaDescricao,
      ft.descricao AS tipoDescricao,
      u.nome AS usuarioNome  
     FROM finan_lancamento fl
     INNER JOIN finan_categoria fc ON fl.categoriaId = fc.id
     INNER JOIN finan_tipo ft ON fl.tipoId = ft.id
     INNER JOIN usuario u ON fl.usuarioId = u.id
     WHERE strftime('%Y-%m', fl.data) = strftime('%Y-%m', 'now')
     ORDER BY fl.data DESC
  ''';
    final db = await BancoDeDados.banco;
    final lancamentos = await db.rawQuery(sql);
    return lancamentos.map((lancamento) => FinanLancamento.fromMap(lancamento)).toList();
  }

  // Future<List<FinanLancamento>> listarTodos() async {
  //   final db = await BancoDeDados.banco;
  //   final lancamentos = await db.query(_tableName);
  //   return lancamentos.map((lancamento) => FinanLancamento.fromMap(lancamento)).toList();
  // }

  Future<FinanLancamento?> buscarPorId(int id) async {
    final db = await BancoDeDados.banco;
    final resultado = await db.query(_tableName, where: 'id = ?', whereArgs: [id]);
    if (resultado.isNotEmpty) {
      return FinanLancamento.fromMap(resultado.first);
    }
    return null;
  }

  Future<List<Map>> totalPorCategoria() async {
    final db = await BancoDeDados.banco;
    final result = await db.rawQuery('''SELECT fc.descricao as categoria, SUM(fl.valor) as total 
         FROM finan_lancamento fl
         INNER JOIN finan_categoria fc ON fl.categoriaId = fc.id
         GROUP BY fc.descricao
         ORDER BY fc.descricao''');

    if (result.isEmpty) return [];

    return result;
  }

  Future<List<FinanLancamento>> buscarPorUsuario(int usuarioId) async {
    final db = await BancoDeDados.banco;
    final maps = await db.query('finan_lancamento', where: 'usuarioId = ?', whereArgs: [usuarioId]);
    return maps.map((map) => FinanLancamento.fromMap(map)).toList();
  }
}
