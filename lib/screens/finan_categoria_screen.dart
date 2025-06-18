import 'package:db_sqlite/store/finan_categoria_store.dart';
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(store.mensagemErro!), backgroundColor: Colors.red));
        store.limparErro();
      });
    }

    Widget corpo;

    switch (store.estado) {
      case EstadoFinanCategoria.carregando:
        corpo = const Center(child: CircularProgressIndicator());
        break;
      case EstadoFinanCategoria.erro:
        corpo = const Center(child: Text('Erro inesperado'));
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
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => FormularioFinanCategoria(categoria: cat)));
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_forever_outlined, color: Colors.red, size: 18),
                      onPressed: () {
                        _confirmarExclusaoCategoria(context, cat.id!);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
        break;
      default:
        corpo = const Center(child: Text('DEU ERRO E TA SEM TRATAMENTO AQUI NESSA TELA.'));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Categoria de Finanças'),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.green, applyTextScaling: true, size: 35),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FormularioFinanCategoria()));
            },
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
              TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancelar')),
              TextButton(
                onPressed: () async {
                  await store.removerCategoria(id);

                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                },
                child: const Text('Excluir'),
              ),
            ],
          ),
    );
  }
}
