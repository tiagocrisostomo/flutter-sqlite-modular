import 'package:db_sqlite/store/finan_lancamento_store.dart';
import 'package:db_sqlite/widgets/finan_lancamento_form.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FinanLancamentoScreen extends StatefulWidget {
  const FinanLancamentoScreen({super.key});

  @override
  State<FinanLancamentoScreen> createState() => _FinanLancamentoScreenState();
}

class _FinanLancamentoScreenState extends State<FinanLancamentoScreen> {
  @override
  void initState() {
    super.initState();
    // Future.microtask(() {
    //   Provider.of<FinanLancamentoStore>(
    //     // ignore: use_build_context_synchronously
    //     context,
    //     listen: false,
    //   ).carregarLancamentos();
    // });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FinanLancamentoStore>(
        context,
        listen: false,
      ).carregarLancamentos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FinanLancamentoStore>(context);

    // Mostra erro caso ocorra
    if (store.estado == EstadoLancamento.erro && store.mensagemErro != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(store.mensagemErro!),
            backgroundColor: Colors.red,
          ),
        );
        store.limparErro();
      });
    }

    Widget corpo;

    switch (store.estado) {
      case EstadoLancamento.carregando:
        corpo = const Center(child: CircularProgressIndicator());
        break;
      case EstadoLancamento.carregado:
        corpo = ListView.builder(
          itemCount: store.lancamentos.length,
          itemBuilder: (_, index) {
            final lanc = store.lancamentos[index];
            return ListTile(
              title: Text(lanc.descricao.toString()),
              subtitle: Text(
                'R\$ ${lanc.valor?.toStringAsFixed(2)} - ${DateFormat('dd/MM/yyyy').format(lanc.data as DateTime)}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FinanLancamentoForm(lancamento: lanc),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _confirmarExclusao(context, lanc.id!);
                    },
                  ),
                ],
              ),
            );
          },
        );
        break;
      default:
        corpo = const SizedBox();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lançamentos Financeiros'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.green),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FinanLancamentoForm()),
              );
            },
          ),
        ],
      ),
      body: corpo,
    );
  }

  void _confirmarExclusao(BuildContext context, int id) {
    final store = Provider.of<FinanLancamentoStore>(context, listen: false);
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Confirmar exclusão'),
            content: const Text('Deseja realmente excluir este lançamento?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  await store.removerLancamento(id);
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  if (store.estado != EstadoLancamento.erro) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Lançamento excluído com sucesso!'),
                      ),
                    );
                  }
                },
                child: const Text('Excluir'),
              ),
            ],
          ),
    );
  }
}
