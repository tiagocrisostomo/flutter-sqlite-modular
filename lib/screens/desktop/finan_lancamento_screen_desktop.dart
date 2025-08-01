import 'package:db_sqlite/screens/mobile/finan_lancamento_screen_todos.dart';
import 'package:db_sqlite/store/finan_lancamento_store.dart';
import 'package:db_sqlite/utils/routes_context_transations.dart';
import 'package:db_sqlite/widgets/finan_lancamento_form.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FinanLancamentoScreenDesktop extends StatefulWidget {
  const FinanLancamentoScreenDesktop({super.key});

  @override
  State<FinanLancamentoScreenDesktop> createState() => _FinanLancamentoScreenDesktopState();
}

class _FinanLancamentoScreenDesktopState extends State<FinanLancamentoScreenDesktop> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FinanLancamentoStore>(context, listen: false).carregarLancamentosMes();
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
            showCloseIcon: true,
            // width: Material, // Width of the SnackBar.
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0, // Inner padding for SnackBar content.
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            elevation: 10,
            dismissDirection: DismissDirection.horizontal,
            animation: CurvedAnimation(parent: const AlwaysStoppedAnimation(1.5), curve: Curves.easeIn),
          ),
        );
        store.limparErro();
      });
    }

    if (store.estado == EstadoLancamento.deletado) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deletado'),
            backgroundColor: Colors.green,
            showCloseIcon: true,
            // width: Material, // Width of the SnackBar.
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0, // Inner padding for SnackBar content.
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            elevation: 10,
            dismissDirection: DismissDirection.horizontal,
            animation: CurvedAnimation(parent: const AlwaysStoppedAnimation(1.5), curve: Curves.easeIn),
          ),
        );
        store.limparErro();
      });
    }

    if (store.estado == EstadoLancamento.incluido) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cadastrado.'),
            backgroundColor: Colors.green,
            showCloseIcon: true,
            // width: Material, // Width of the SnackBar.
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0, // Inner padding for SnackBar content.
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            elevation: 10,
            dismissDirection: DismissDirection.horizontal,
            animation: CurvedAnimation(parent: const AlwaysStoppedAnimation(1.5), curve: Curves.easeIn),
          ),
        );
        store.limparErro();
      });
    }

    if (store.estado == EstadoLancamento.alterado) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Alterado.'),
            backgroundColor: Colors.green,
            showCloseIcon: true,
            // width: Material, // Width of the SnackBar.
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0, // Inner padding for SnackBar content.
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            elevation: 10,
            dismissDirection: DismissDirection.horizontal,
            animation: CurvedAnimation(parent: const AlwaysStoppedAnimation(1.5), curve: Curves.easeIn),
          ),
        );
        store.limparErro();
      });
    }

    Widget corpo;

    switch (store.estado) {
      case EstadoLancamento.carregando:
        corpo = Center(child: CircularProgressIndicator(semanticsLabel: 'Carregando...'));
        break;
      case EstadoLancamento.deletando:
        corpo = Center(child: CircularProgressIndicator(semanticsLabel: 'Deletando...'));
        break;
      case EstadoLancamento.incluindo:
        corpo = Center(child: CircularProgressIndicator(semanticsLabel: 'Incluindo...'));
        break;
      case EstadoLancamento.alterando:
        corpo = Center(child: CircularProgressIndicator(semanticsLabel: 'Alterando...'));
        break;
      case EstadoLancamento.carregado:
        corpo = RefreshIndicator(
          onRefresh: () async {
            await store.carregarLancamentosMes();
          },
          child: ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: store.lancamentosMes.length,
            itemBuilder: (_, index) {
              final lanc = store.lancamentosMes[index];
              return Container(
                padding: const EdgeInsets.all(2.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.blueGrey, width: 0.5)),
                  isThreeLine: false,
                  dense: true,
                  leading: CircleAvatar(
                    backgroundColor: Colors.black,
                    maxRadius: MediaQuery.of(context).size.width * 0.07,
                    child: Text(
                      lanc.tipoDescricao.toString(),
                      softWrap: true,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis, color: Colors.white),
                    ),
                  ),
                  title: Text('R\$ ${lanc.valor.toStringAsFixed(2)}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    '${lanc.categoriaDescricao.toString()} - ${DateFormat('dd/MM/yyyy').format(lanc.data as DateTime)} \n'
                    '${lanc.descricao.toString()}',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  trailing: Container(
                    height: MediaQuery.of(context).size.height * 0.04,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_square, color: Colors.blue, size: 16),
                          onPressed: () => context.pushRtL(FinanLancamentoForm(lancamento: lanc)),
                        ),
                        VerticalDivider(),
                        IconButton(icon: const Icon(Icons.delete_forever, color: Colors.red, size: 16), onPressed: () => _confirmarExclusao(context, lanc.id!)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
        break;
      default:
        corpo = Center(child: CircularProgressIndicator(semanticsLabel: 'Padrão...'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lançamentos Financeiros do mês', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        actions: [
          TextButton.icon(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.black),
              foregroundColor: WidgetStatePropertyAll(Colors.white),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            ),
            label: Text("Adicionar Lançamento", style: TextStyle(fontSize: 16, color: Colors.white)),
            icon: const Icon(Icons.add_box_rounded, color: Colors.white, applyTextScaling: true, size: 35),
            onPressed: () => context.pushBtTModal(FinanLancamentoForm()),
          ),
        ],
      ),
      body: corpo,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.width * 1,
        child: FloatingActionButton.extended(
          label: Row(
            children: [
              Text('Ver todos os lançamentos       ', style: TextStyle(fontSize: 16, color: Colors.white)),
              Icon(Icons.keyboard_double_arrow_right_outlined, applyTextScaling: true, color: Colors.green, size: 35),
            ],
          ),
          onPressed: () => context.pushRtL(FinanLancamentoScreenTodos()),
          isExtended: true,
          backgroundColor: Colors.black,
          tooltip: 'Ver todos os lançamentos',
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
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
                onPressed: () => Navigator.of(context).pop(),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                  foregroundColor: WidgetStatePropertyAll(Colors.blue),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                ),
                child: Text('Cancelar'),
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.red),
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                ),
                onPressed: () async {
                  await store.removerLancamento(id);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pop();
                  });
                },
                child: const Text('Excluir'),
              ),
            ],
          ),
    );
  }
}
