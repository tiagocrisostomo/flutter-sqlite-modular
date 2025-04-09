import 'package:db_sqlite/data/db/banco_de_dados.dart';
import 'package:db_sqlite/utils/seguranca.dart';
import 'package:flutter/foundation.dart';

Future<void> inicializarBancoComUsuarioPadrao() async {
  final db = await BancoDeDados.banco;

  final usuarios = await db.query('usuarios');
  if (usuarios.isEmpty) {
    await db.insert('usuarios', {
      'nome': 'admin',
      'senha': Seguranca.hashSenha('1234'),
    });
    debugPrint('✅ Usuário padrão criado: admin / 1234');
  }
}
