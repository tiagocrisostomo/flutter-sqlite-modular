import 'package:flutter/material.dart';

class PainelFinanceiro extends StatelessWidget {
  const PainelFinanceiro({super.key});

  @override
  Widget build(BuildContext context) {
    // Exemplo fixo, você pode trocar por store ou service depois
    final totalReceitas = 2500.0;
    final totalDespesas = 1800.0;
    final saldo = totalReceitas - totalDespesas;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoTile('Receitas', totalReceitas, Colors.green),
          const SizedBox(height: 8),
          _infoTile('Despesas', totalDespesas, Colors.red),
          const SizedBox(height: 8),
          _infoTile('Saldo', saldo, saldo >= 0 ? Colors.blue : Colors.orange),
        ],
      ),
    );
  }

  Widget _infoTile(String label, double valor, Color cor) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.monetization_on, color: cor),
        title: Text(label),
        trailing: Text(
          'R\$ ${valor.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            color: cor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
