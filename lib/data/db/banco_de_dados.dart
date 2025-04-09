import 'package:flutter/material.dart';
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
    debugPrint('Caminho do banco de dados: $caminhoCompleto');

    return openDatabase(
      caminhoCompleto,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE usuarios (id INTEGER PRIMARY KEY, nome TEXT, senha TEXT)''',
        );
        await db.execute(
          '''CREATE TABLE finan_categorias (id INTEGER PRIMARY KEY, descricao TEXT, cor TEXT)''',
        );
        await db.execute(
          '''CREATE TABLE finan_tipos (id INTEGER PRIMARY KEY, descricao TEXT, cor TEXT)''',
        );
        await db.execute('''CREATE TABLE finan_lancamentos 
          (id INTEGER PRIMARY KEY, descricao TEXT, valor REAL, data TEXT, 
          tipoId INTEGER, categoriaId INTEGER, usuarioId INTEGER, 
          FOREIGN KEY(tipoId) REFERENCES finan_tipos(id), 
          FOREIGN KEY(categoriaId) REFERENCES finan_categorias(id), 
          FOREIGN KEY(usuarioId) REFERENCES usuarios(id))''');
      },
    );
  }
}
