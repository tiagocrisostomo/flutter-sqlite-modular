import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BancoDeDados {
  static Database? _banco;

  static Future<Database> get banco async {
    if (_banco != null) return _banco!;
    _banco = await _iniciarBanco();
    return _banco!;
  }

  static Future<Database> _iniciarBanco() async {
    final caminho = await getDatabasesPath();
    final caminhoCompleto = join(caminho, 'app.db');

    return openDatabase(
      caminhoCompleto,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE usuarios (id INTEGER PRIMARY KEY, nome TEXT, idade INTEGER)''',
        );
      },
    );
  }
}
