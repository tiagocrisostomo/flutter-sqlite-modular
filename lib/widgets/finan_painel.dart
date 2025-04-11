import 'package:db_sqlite/store/finan_lancamento_store.dart';
import 'package:db_sqlite/widgets/grahos.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PainelFinanceiro extends StatefulWidget {
  const PainelFinanceiro({super.key});

  @override
  _PainelFinanceiroState createState() => _PainelFinanceiroState();
}

class _PainelFinanceiroState extends State<PainelFinanceiro> {
  @override
  void initState() {
    super.initState();

    // Aguarda o primeiro frame para chamar o carregarLancamentos de forma segura
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FinanLancamentoStore>(
        context,
        listen: false,
      ).carregarLancamentos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Painel Financeiro")),
      body: Consumer<FinanLancamentoStore>(
        builder: (context, lancStore, child) {
          double totalReceitas = 0;
          double totalDespesas = 0;
          String? categoriaMaisGasta;
          DateTime? ultimoLancamento;
          Map<String, double> gastosPorCategoria = {};

          for (var lanc in lancStore.lancamentos) {
            if (lanc.categoriaId == 2) {
              totalReceitas += lanc.valor ?? 0;
            } else if (lanc.categoriaId == 1) {
              totalDespesas += lanc.valor ?? 0;

              // Acumula gastos por categoria
              final categoria = lanc.categoriaId ?? 'Outros';
              gastosPorCategoria[categoria.toString()] =
                  (gastosPorCategoria[categoria] ?? 0) + (lanc.valor ?? 0);
            }

            // Atualiza último lançamento
            if (ultimoLancamento == null ||
                lanc.data!.isAfter(ultimoLancamento)) {
              ultimoLancamento = lanc.data;
            }
          }

          // Descobre a categoria com maior gasto
          categoriaMaisGasta =
              gastosPorCategoria.entries.isNotEmpty
                  ? gastosPorCategoria.entries
                      .reduce((a, b) => a.value > b.value ? a : b)
                      .key
                  : 'Nenhuma';

          double saldo = totalReceitas - totalDespesas;
          int qtdReceitas =
              lancStore.lancamentos.where((l) => l.categoriaId == 2).length;
          int qtdDespesas =
              lancStore.lancamentos.where((l) => l.categoriaId == 1).length;

          return SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 10, 49, 82),
                    Color.fromARGB(255, 50, 89, 118),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildInfoRow("Receitas", totalReceitas, Colors.green),
                  _buildInfoRow("Despesas", totalDespesas, Colors.red),
                  const Divider(),
                  _buildInfoRow(
                    "Saldo Atual",
                    saldo,
                    saldo >= 0 ? Colors.blue : Colors.orange,
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Text("📌"),
                      title: Text(
                        "Lançamentos: ${lancStore.lancamentos.length} ",
                      ),
                      subtitle: Text(
                        "(Receitas: $qtdReceitas | Despesas: $qtdDespesas)",
                      ),
                    ),
                  ),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Text("💰"),
                      title: Text("Categoria com maior gasto:"),
                      subtitle: Text(
                        "R\$ ${gastosPorCategoria[categoriaMaisGasta]?.toStringAsFixed(2) ?? '0.00'}",
                      ),
                    ),
                  ),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Text("📅"),
                      title: Text("Último lançamento: "),
                      subtitle: Text(
                        ultimoLancamento != null
                            ? DateFormat('dd/MM/yyyy').format(ultimoLancamento)
                            : 'Nenhum',
                      ),
                    ),
                  ),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: GraficoPizzaGastosPorTipo(
                        totalReceitas: totalReceitas,
                        totalDespesas: totalDespesas,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, double valor, Color cor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: cor,
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder:
              (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
          child: Text(
            "R\$ ${valor.toStringAsFixed(2)}",
            key: ValueKey<double>(valor),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: cor,
            ),
          ),
        ),
      ],
    );
  }
}
