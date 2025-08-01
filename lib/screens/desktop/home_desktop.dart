import 'package:db_sqlite/screens/desktop/configuracao_screen_desktop.dart';
import 'package:db_sqlite/screens/desktop/finan_lancamento_screen_desktop.dart';
import 'package:db_sqlite/widgets/finan_painel.dart';
import 'package:flutter/material.dart';

class HomePageDesktop extends StatefulWidget {
  const HomePageDesktop({super.key});

  @override
  State<HomePageDesktop> createState() => _HomePageDesktopState();
}

class _HomePageDesktopState extends State<HomePageDesktop> {
  int paginaAtual = 0;

  final List<Widget> paginas = [
    const PainelFinanceiro(),
    const FinanLancamentoScreenDesktop(),
    const ConfigScreenDesktop(), // ou alguma outra tela
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[500],
        title: const Text('Controle Financeiro'),
        centerTitle: true,
        actions: [
          IconButton.filledTonal(
            onPressed: () {
              debugPrint('Botão de menu pressionado');
            },
            icon: Icon(Icons.person_2_outlined),
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            extended: true,
            selectedIndex: paginaAtual,
            onDestinationSelected: (index) => setState(() => paginaAtual = index),
            labelType: NavigationRailLabelType.none,
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.pie_chart, size: 30), label: Text('Dashboard', style: TextStyle(fontSize: 17))),
              NavigationRailDestination(icon: Icon(Icons.monetization_on_outlined, size: 30), label: Text('Lançamentos', style: TextStyle(fontSize: 17))),
              NavigationRailDestination(icon: Icon(Icons.settings, size: 30), label: Text('Configurações', style: TextStyle(fontSize: 17))),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: IndexedStack(index: paginaAtual, children: [...paginas])),
        ],
      ),
    );
  }
}
