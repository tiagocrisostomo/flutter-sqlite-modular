import 'package:db_sqlite/data/db/banco_de_dados.dart';
import 'package:db_sqlite/utils/seguranca.dart';
import 'package:flutter/foundation.dart';

Future<void> inicializarBancoComDadosPadrao() async {
  final db = await BancoDeDados.banco;

  final usuarios = await db.query('usuario');
  if (usuarios.isEmpty) {
    await db.insert('usuario', {'nome': 'tiago', 'email': 'tiagovcrisostomo@gmail.com', 'senha': Seguranca.hashSenha('1234')});
    debugPrint('✅ Usuário padrão criado: tiago / tiagovcrisostomo@gmail.com');
  }

  final tipos = await db.query('finan_tipo');
  if (tipos.isEmpty) {
    await db.insert('finan_tipo', {'descricao': 'Geral'});
    await db.insert('finan_tipo', {'descricao': 'Aluguel'});
    await db.insert('finan_tipo', {'descricao': 'Assinaturas'});
    await db.insert('finan_tipo', {'descricao': 'Combustível'});
    await db.insert('finan_tipo', {'descricao': 'Condomínio'});
    await db.insert('finan_tipo', {'descricao': 'Consórcios'});
    await db.insert('finan_tipo', {'descricao': 'Cuidados Pessoais'});
    await db.insert('finan_tipo', {'descricao': 'Delivery'});
    await db.insert('finan_tipo', {'descricao': 'Doações'});
    await db.insert('finan_tipo', {'descricao': 'Energia'});
    await db.insert('finan_tipo', {'descricao': 'Faxinas'});
    await db.insert('finan_tipo', {'descricao': 'Feira/Mercado'});
    await db.insert('finan_tipo', {'descricao': 'Financiamentos'});
    await db.insert('finan_tipo', {'descricao': 'Impostos'});
    await db.insert('finan_tipo', {'descricao': 'Investimentos'});
    await db.insert('finan_tipo', {'descricao': 'Livros/Cursos'});
    await db.insert('finan_tipo', {'descricao': 'Manutenção Apto/Casa'});
    await db.insert('finan_tipo', {'descricao': 'Manutenção Bancária'});
    await db.insert('finan_tipo', {'descricao': 'Manutenção Veícular'});
    await db.insert('finan_tipo', {'descricao': 'Padaria'});
    await db.insert('finan_tipo', {'descricao': 'Presentes'});
    await db.insert('finan_tipo', {'descricao': 'Salário'});
    await db.insert('finan_tipo', {'descricao': 'Saúde/Medicamentos'});
    await db.insert('finan_tipo', {'descricao': 'Seguros'});
    await db.insert('finan_tipo', {'descricao': 'Telefone/Internet'});
    await db.insert('finan_tipo', {'descricao': 'Uber/Apps'});
    await db.insert('finan_tipo', {'descricao': 'Viagens'});
    debugPrint(
      '✅ Tipos padrões criados: Geral, Energia, Aluguel, Salário, Telefone/Internet, Condomínio, Feira/Mercado, Delivery, Padaria, Assinaturas, Impostos ...',
    );
  }

  final categorias = await db.query('finan_categoria');
  if (categorias.isEmpty) {
    await db.insert('finan_categoria', {'descricao': 'A Pagar'});
    await db.insert('finan_categoria', {'descricao': 'A Receber'});
    debugPrint('✅ Categorias padrões criadas: A Pagar, A Receber');
  }

  // final
}
