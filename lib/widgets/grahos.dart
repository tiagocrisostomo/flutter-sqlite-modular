import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraficoPizzaGastosPorTipo extends StatelessWidget {
  final double totalReceitas;
  final double totalDespesas;

  const GraficoPizzaGastosPorTipo({
    super.key,
    required this.totalReceitas,
    required this.totalDespesas,
  });

  @override
  Widget build(BuildContext context) {
    final total = totalReceitas + totalDespesas;
    if (total == 0) {
      return const Center(child: Text('Sem dados para exibir o gráfico.'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "💹 Distribuição por Tipo",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: AspectRatio(
            aspectRatio: 1.2,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: totalReceitas,
                    color: Colors.green,
                    title:
                        '${(totalReceitas / total * 100).toStringAsFixed(1)}%',
                    radius: 60,
                    titleStyle: const TextStyle(color: Colors.white),
                  ),
                  PieChartSectionData(
                    value: totalDespesas,
                    color: Colors.red,
                    title:
                        '${(totalDespesas / total * 100).toStringAsFixed(1)}%',
                    radius: 60,
                    titleStyle: const TextStyle(color: Colors.white),
                  ),
                ],
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _LegendaCor(texto: 'Receitas', cor: Colors.green),
            _LegendaCor(texto: 'Despesas', cor: Colors.red),
          ],
        ),
      ],
    );
  }
}

class _LegendaCor extends StatelessWidget {
  final String texto;
  final Color cor;

  const _LegendaCor({required this.texto, required this.cor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 6, backgroundColor: cor),
        const SizedBox(width: 6),
        Text(texto),
      ],
    );
  }
}
