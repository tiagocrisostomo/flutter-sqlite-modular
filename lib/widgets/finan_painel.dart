import 'package:db_sqlite/store/finan_lancamento_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PainelFinanceiro extends StatelessWidget {
  const PainelFinanceiro({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<LancamentoStore>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoTile(
            'Receitas',
            store.receitas,
            Colors.green,
            Icon(Icons.monetization_on, color: Colors.green),
          ),
          const SizedBox(height: 8),
          _infoTile(
            'Despesas',
            store.despesas,
            Colors.red,
            Icon(Icons.monetization_on, color: Colors.red),
          ),
          const SizedBox(height: 8),
          _infoTile(
            'Saldo',
            store.saldo,
            store.saldo >= 0 ? Colors.blue : Colors.orange,
            Icon(
              Icons.monetization_on,
              color: store.saldo >= 0 ? Colors.blue : Colors.orange,
            ),
          ),
          Divider(color: Colors.grey.shade300, thickness: 4, height: 32),
          _infoTile(
            'Tipo Geral',
            store.tipoGeral,
            Colors.purple,
            Icon(Icons.credit_card, color: Colors.purple),
          ),
          const SizedBox(height: 8),
          _infoTile(
            'Tipo Pessoal',
            store.tipoPessoal,
            Colors.teal,
            Icon(Icons.credit_card, color: Colors.teal),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _infoTile(String label, double valor, Color cor, Icon icone) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: icone,
        title: Text(label),
        trailing: Text(
          'R\$ ${valor.toStringAsFixed(2)}',
          style: TextStyle(
            color: cor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
