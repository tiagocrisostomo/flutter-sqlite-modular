import 'package:db_sqlite/screens/usuario_screen.dart';
import 'package:db_sqlite/widgets/finan_lancamento_form.dart';
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
    const UsuarioScreen(), // ou alguma outra tela
    Center(child: Text('Configurações')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Financeiro'),
        centerTitle: true,
      ),
      body: paginas[paginaAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        onTap: (index) => setState(() => paginaAtual = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Painel'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Usuários'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Config'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormLancamento()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
