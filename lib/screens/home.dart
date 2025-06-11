import 'package:db_sqlite/screens/configuracao_screen.dart';
import 'package:db_sqlite/screens/finan_lancamento_screen.dart';
import 'package:db_sqlite/widgets/finan_painel.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int paginaAtual = 0;

  final List<Widget> paginas = [
    const PainelFinanceiro(),
    const FinanLancamentoScreen(),
    const ConfigScreen(), // ou alguma outra tela
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(  
        leading: IconButton.filled(onPressed: (){}, icon: Icon(Icons.person_2_outlined),),      
        title: const Text('Controle Financeiro'),
        centerTitle: true,
      ),
      body: paginas[paginaAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        onTap: (index) => setState(() => paginaAtual = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Painel'),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on_outlined),
            label: 'Lançamentos',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Config'),
        ],
      ),
    );
  }
}
