import 'package:flutter/material.dart';

class PainelFinanceiro extends StatefulWidget {
  const PainelFinanceiro({super.key});

  @override
  State<PainelFinanceiro> createState() => _PainelFinanceiroState();
}

class _PainelFinanceiroState extends State<PainelFinanceiro> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Painel Financeiro")),
      body: Text('PANIEL VEM AQUI'),
    );
  }
}
