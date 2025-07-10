import 'package:db_sqlite/store/finan_categoria_store.dart';
import 'package:db_sqlite/utils/routes_context_transations.dart';
import 'package:db_sqlite/widgets/finan_categoria_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FinanCategoriaScreen extends StatefulWidget {
  const FinanCategoriaScreen({super.key});

  @override
  State<FinanCategoriaScreen> createState() => _FinanCategoriaScreenState();
}

class _FinanCategoriaScreenState extends State<FinanCategoriaScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FinanCategoriaStore>(context, listen: false).carregarCategorias();
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FinanCategoriaStore>(context);

    // Exibe snackbar se houver erro
    if (store.estado == EstadoFinanCategoria.erro && store.mensagemErro != null) {
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

    if (store.estado == EstadoFinanCategoria.deletado) {
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

    if (store.estado == EstadoFinanCategoria.incluido) {
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

    if (store.estado == EstadoFinanCategoria.alterado) {
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
      case EstadoFinanCategoria.carregando:
        corpo = Center(child: CircularProgressIndicator(semanticsLabel: 'Carregando...'));
        break;
      case EstadoFinanCategoria.deletando:
        corpo = Center(child: CircularProgressIndicator(semanticsLabel: 'Deletando...'));
        break;
      case EstadoFinanCategoria.incluindo:
        corpo = Center(child: CircularProgressIndicator(semanticsLabel: 'Incluindo...'));
        break;
      case EstadoFinanCategoria.alterando:
        corpo = Center(child: CircularProgressIndicator(semanticsLabel: 'Alterando...'));
        break;
      case EstadoFinanCategoria.carregado:
        corpo = ListView.builder(
          itemCount: store.finanCategorias.length,
          itemBuilder: (_, index) {
            final cat = store.finanCategorias[index];
            return ListTile(
              dense: true,
              leading: CircleAvatar(
                backgroundColor: cat.cor != null ? Color(int.parse(cat.cor!.replaceAll("#", "0xFF"))) : Colors.grey,
                child: cat.id != null ? Text(cat.id.toString()) : Icon(Icons.playlist_add_check_circle_sharp),
              ),
              title: Text(cat.descricao ?? ''),
              subtitle: Text(cat.cor ?? ''),
              trailing: SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue, size: 18),
                      onPressed: () => context.pushRtL(FormularioFinanCategoria(categoria: cat)),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_forever_outlined, color: Colors.red, size: 18),
                      onPressed: () => _confirmarExclusaoCategoria(context, cat.id!),
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
        title: Text('Categoria de Finanças'),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.green, applyTextScaling: true, size: 35),
            onPressed: () => context.pushRtL(FormularioFinanCategoria()),
          ),
        ],
      ),
      body: corpo,
    );
  }

  void _confirmarExclusaoCategoria(BuildContext context, int id) {
    final store = Provider.of<FinanCategoriaStore>(context, listen: false);

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Excluir Categoria'),
            content: Text('Deseja realmente excluir a Categoria?'),
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
                onPressed: () async {
                  await store.removerCategoria(id);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pop();
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.red),
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                ),
                child: const Text('Excluir'),
              ),
            ],
          ),
    );
  }
}
