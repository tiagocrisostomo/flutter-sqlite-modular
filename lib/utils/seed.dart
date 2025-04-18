import 'package:db_sqlite/data/db/banco_de_dados.dart';
import 'package:db_sqlite/utils/seguranca.dart';
import 'package:flutter/foundation.dart';

Future<void> inicializarBancoComDadosPadrao() async {
  final db = await BancoDeDados.banco;

  final usuarios = await db.query('usuario');
  if (usuarios.isEmpty) {
    await db.insert('usuario', {
      'nome': 'admin',
      'email': 'tiagovcrisostomo@gmail.com',
      'senha': Seguranca.hashSenha('1234'),
    });
    debugPrint('✅ Usuário padrão criado: admin / 1234 / tiagovcrisostomo@gmail.com');
  }

  final tipos = await db.query('finan_tipo');
  if (tipos.isEmpty) {
    await db.insert('finan_tipo', {'descricao': 'Geral', 'cor': '#0B07ED'});
    await db.insert('finan_tipo', {'descricao': 'Pessoal', 'cor': '#00FF00'});
    debugPrint('✅ Tipos padrões criados: Geral, Pessoal');
  }

  final categorias = await db.query('finan_categoria');
  if (categorias.isEmpty) {
    await db.insert('finan_categoria', {
      'descricao': 'A Pagar',
      'cor': '#FF0000',
    });
    await db.insert('finan_categoria', {
      'descricao': 'A Receber',
      'cor': '#058505',
    });
    debugPrint('✅ Categorias padrões criadas: A Pagar, A Receber');
  }
}
