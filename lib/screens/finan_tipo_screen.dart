import 'package:db_sqlite/store/finan_tipo_store.dart';
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
    Future.microtask(
      () =>
          // ignore: use_build_context_synchronously
          Provider.of<FinanTipoStore>(context, listen: false).carregarTipos(),
    );
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
          ),
        );
        store.limparErro();
      });
    }

    Widget corpo;

    switch (store.estado) {
      case EstadoFinanTipo.carregando:
        corpo = Center(child: CircularProgressIndicator());
        break;
      case EstadoFinanTipo.erro:
        corpo = Center(child: Text(store.mensagemErro ?? 'Erro inesperado'));
        break;
      case EstadoFinanTipo.carregado:
        corpo = ListView.builder(
          itemCount: store.finanTipos.length,
          itemBuilder: (_, index) {
            final tipo = store.finanTipos[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    tipo.cor != null
                        ? Color(int.parse(tipo.cor!.replaceAll("#", "0xFF")))
                        : Colors.grey,
                child:
                    tipo.id != null
                        ? Text(tipo.id.toString())
                        : Icon(Icons.playlist_add_check_circle_sharp),
              ),
              title: Text(tipo.descricao ?? ''),
              subtitle: Text(tipo.cor ?? ''),
              trailing: SizedBox(
                width: 96,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => FormularioFinanTipo(tipo: tipo),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_forever_outlined,
                        color: Colors.red,
                      ),
                      onPressed:
                          () => _confirmarExclusaoTipo(context, tipo.id!),
                    ),
                  ],
                ),
              ),
            );
          },
        );
        break;
      default:
        corpo = const Center(
          child: Text('DEU ERRO E TA SEM TRATAMNTO AQUI NESSA TELA.'),
        );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Tipos de Finanças'),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.green, applyTextScaling: true),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FormularioFinanTipo()),
              );
            },
          ),
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
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  await store.removerTipo(id);
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                },
                child: Text('Excluir'),
              ),
            ],
          ),
    );
  }
}
