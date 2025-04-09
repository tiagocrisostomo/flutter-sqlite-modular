import 'package:db_sqlite/data/db/banco_de_dados.dart';
import 'package:db_sqlite/utils/seguranca.dart';
import 'package:flutter/foundation.dart';

Future<void> inicializarBancoComDadosPadrao() async {
  final db = await BancoDeDados.banco;

  final usuarios = await db.query('usuarios');
  if (usuarios.isEmpty) {
    await db.insert('usuarios', {
      'nome': 'admin',
      'senha': Seguranca.hashSenha('1234'),
    });
    debugPrint('✅ Usuário padrão criado: admin / 1234');
  }

  final tipos = await db.query('finan_tipos');
  if (tipos.isEmpty) {
    await db.insert('finan_tipos', {'descricao': 'Geral', 'cor': '#0B07ED'});
    await db.insert('finan_tipos', {'descricao': 'Pessoal', 'cor': '#00FF00'});
    debugPrint('✅ Tipos padrão criados: Geral, Pessoal');
  }

  final categorias = await db.query('finan_categorias');
  if (categorias.isEmpty) {
    await db.insert('finan_categorias', {
      'descricao': 'A Pagar',
      'cor': '#FF0000',
    });
    await db.insert('finan_categorias', {
      'descricao': 'A Receber',
      'cor': '#058505',
    });
    debugPrint('✅ Categorias padrão criadas: A Pagar, A Receber');
  }
}
