import 'package:db_sqlite/store/finan_tipo_store.dart';
import 'package:db_sqlite/utils/routes_context_transations.dart';
import 'package:db_sqlite/widgets/finan_tipo_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FinanTipoScreen extends StatefulWidget {
  const FinanTipoScreen({super.key});

  @override
  State<FinanTipoScreen> createState() => _FinanTipoScreenState();
}

class _FinanTipoScreenState extends State<FinanTipoScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FinanTipoStore>(context, listen: false).carregarTipos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FinanTipoStore>(context);

    // Exibe snackbar se houver erro
    if (store.estado == EstadoFinanTipo.erro && store.mensagemErro != null) {
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
          ),
        );
        store.limparErro();
      });
    }

    if (store.estado == EstadoFinanTipo.deletado) {
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
          ),
        );
        store.limparErro();
      });
    }

    if (store.estado == EstadoFinanTipo.incluido) {
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
          ),
        );
        store.limparErro();
      });
    }

    if (store.estado == EstadoFinanTipo.alterado) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Alterado.'),
            backgroundColor: Colors.green,
            // action: SnackBarAction(
            //   label: 'Action',
            //   onPressed: () {
            //     // Code to execute.
            //   },
            // ),
            showCloseIcon: true,
            // width: Material, // Width of the SnackBar.
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0, // Inner padding for SnackBar content.
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          ),
        );
        store.limparErro();
      });
    }

    Widget corpo;

    switch (store.estado) {
      case EstadoFinanTipo.carregando:
        corpo = Center(child: CircularProgressIndicator(semanticsLabel: 'Carregando...'));
        break;
      case EstadoFinanTipo.deletando:
        corpo = Center(child: CircularProgressIndicator(semanticsLabel: 'Deletando...'));
        break;
      case EstadoFinanTipo.incluindo:
        corpo = Center(child: CircularProgressIndicator(semanticsLabel: 'Incluindo...'));
        break;
      case EstadoFinanTipo.alterando:
        corpo = Center(child: CircularProgressIndicator(semanticsLabel: 'Alterando...'));
        break;
      case EstadoFinanTipo.carregado:
        corpo = ListView.builder(
          itemCount: store.finanTipos.length,
          itemBuilder: (_, index) {
            final tipo = store.finanTipos[index];
            return ListTile(
              dense: true,
              leading: CircleAvatar(
                backgroundColor: tipo.cor != null ? Color(int.parse(tipo.cor!.replaceAll("#", "0xFF"))) : Colors.grey,
                child: tipo.id != null ? Text(tipo.id.toString()) : Icon(Icons.playlist_add_check_circle_sharp),
              ),
              title: Text(tipo.descricao ?? ''),
              subtitle: Text(tipo.cor ?? ''),
              trailing: SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Row(
                  children: [
                    IconButton(icon: const Icon(Icons.edit, color: Colors.blue, size: 18), onPressed: () => context.pushRtL(FormularioFinanTipo(tipo: tipo))),
                    IconButton(
                      icon: Icon(Icons.delete_forever_outlined, color: Colors.red, size: 18),
                      onPressed: () => _confirmarExclusaoTipo(context, tipo.id!),
                    ),
                  ],
                ),
              ),
            );
          },
        );
        break;
      default:
        corpo = Center(child: CircularProgressIndicator(semanticsLabel: 'Padrão...'));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Tipos de Finanças'),
        actions: [
          IconButton(icon: Icon(Icons.add, color: Colors.green, applyTextScaling: false, size: 35), onPressed: () => context.pushRtL(FormularioFinanTipo())),
        ],
      ),
      body: corpo,
    );
  }

  void _confirmarExclusaoTipo(BuildContext context, int id) {
    final store = Provider.of<FinanTipoStore>(context, listen: false);

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Excluir Tipo'),
            content: Text('Deseja realmente excluir o Tipo?'),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancelar')),
              TextButton(
                onPressed: () async {
                  await store.removerTipo(id);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pop();
                  });
                },
                child: Text('Excluir'),
              ),
            ],
          ),
    );
  }
}
