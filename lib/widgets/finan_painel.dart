import 'package:db_sqlite/store/finan_lancamento_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class PainelFinanceiro extends StatefulWidget {
  const PainelFinanceiro({super.key});

  @override
  State<PainelFinanceiro> createState() => _PainelFinanceiroState();
}

class _PainelFinanceiroState extends State<PainelFinanceiro>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Tab> _tabs = const [
    Tab(text: 'Por Tipo'),
    Tab(text: 'Por Categoria'),
    Tab(text: 'Por Titular'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FinanLancamentoStore>(
        context,
        listen: false,
      ).carregarLancamentos();

      Provider.of<FinanLancamentoStore>(
        context,
        listen: false,
      ).totaisPorCategoriaDescricao();
      
      Provider.of<FinanLancamentoStore>(
        context,
        listen: false,
      ).totaisPorTipoDescricao();

      Provider.of<FinanLancamentoStore>(context, listen: false);
    });
  }

  // Método para carregar os dados

  @override
  Widget build(BuildContext context) {
    final store = context.watch<FinanLancamentoStore>();

    return Scaffold(
      appBar: AppBar(title: Text("Painel")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCards('A Receber', store.totalAreceber),
            _buildCards('A Pagar', store.totalApagar),
            _buildCards('Saldo', store.saldoTotal),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TabBar(
                  controller: _tabController,
                  tabs: _tabs,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.black,
                  indicatorColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
            SizedBox(
              height: 300,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildGraficoPizzaPorTipo(store),
                  _buildGraficoBarraPorCategoria(store),
                  _buildGraficoPizzaPorTitular(store),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCards(String titulo, double valor) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              (titulo == 'A Receber')
                  ? Icons.monetization_on_rounded
                  : (titulo == 'A Pagar')
                  ? Icons.money_off_csred
                  : Icons.attach_money_outlined,
              size: 32,
              color:
                  (titulo == 'A Receber')
                      ? Colors.green
                      : (titulo == 'A Pagar')
                      ? Colors.red
                      : (valor > 0)
                      ? Colors.blue
                      : Colors.orange,
            ),
            const SizedBox(width: 12),
            Text(
              titulo,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const Spacer(),
            (valor > 0)
                ? Text(
                  'R\$ ${valor.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
                : Text(
                  'R\$ ${valor.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildGraficoPizzaPorTipo(FinanLancamentoStore store) {
    final data = store.totaisPorTipoDescricao();
    final total = data.values.fold(0.0, (a, b) => a + b);

    if (data.isEmpty) {
      return const Center(child: Text('Nenhum dado disponível'));
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: PieChart(
        PieChartData(
          sections:
              data.entries.map((entry) {
                final percent = (entry.value / total) * 100;
                return PieChartSectionData(
                  value: entry.value,
                  title: '${entry.key} \n ${percent.toStringAsFixed(1)}%',
                  color: _corAleatoria(entry.key),
                  radius: 60,
                  titleStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
          sectionsSpace: 4,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }

  Widget _buildGraficoBarraPorCategoria(FinanLancamentoStore store) {
    final data = store.totaisPorCategoriaDescricao();
    final keys = data.keys.toList();

    if (data.isEmpty) {
      return const Center(child: Text('Nenhum dado disponível'));
    }

    final max = data.values.reduce((a, b) => a > b ? a : b);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: max * 1.7,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(               
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < keys.length) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(keys[index], style: TextStyle(fontSize: 12)),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(keys.length, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: data[keys[i]]!,
                  color: _corAleatoria(keys[i]),
                  width: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildGraficoPizzaPorTitular(FinanLancamentoStore store) {    
    final data = store.totaisPorUsuarioNome();
    final total = data.values.fold(0.0, (a, b) => a + b);

    if (data.isEmpty) {
      return const Center(child: Text('Nenhum dado disponível'));
    }

    return AnimatedSwitcher(            
      duration: const Duration(milliseconds: 300),
      child: PieChart(                
        PieChartData(
          sections:
              data.entries.map((entry) {
                final percent = (entry.value / total) * 100;
                return PieChartSectionData(                                    
                  value: entry.value,
                  title: '${entry.key} \n ${percent.toStringAsFixed(2)}%',
                  color: _corAleatoria(entry.key),
                  radius: 60,
                  titleStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
          sectionsSpace: 4,
          centerSpaceRadius: 30,
        ),
      ),
    );
  
  }

  Color _corAleatoria(String chave) {
    final hash = chave.hashCode;
    return Color((0xFF000000 + (hash & 0x00FFFFFF))).withValues(alpha: 1.0);
  }
  
  
}
